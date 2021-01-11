unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, StdCtrls, ExtCtrls, VaClasses, VaComm, Mask, AdvSpin,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, SyncObjs,
  TeEngine, Series, TeeProcs, Chart, ComCtrls;

type
    THabitatThread = class(TThread)
  public
    procedure Execute; override;
end;

type
    TSSDVThread = class(TThread)
  public
    procedure Execute; override;
end;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    pnlCommStatus: TPanel;
    VaComm1: TVaComm;
    Label6: TLabel;
    pnlRSSI: TPanel;
    btnSet: TButton;
    Label14: TLabel;
    edtFrequency: TEdit;
    Label15: TLabel;
    Panel1: TPanel;
    lstCommands: TListBox;
    tmrCommands: TTimer;
    Label2: TLabel;
    cmbMode: TComboBox;
    Panel2: TPanel;
    Label3: TLabel;
    cmbCoding: TComboBox;
    Label4: TLabel;
    cmbSpreading: TComboBox;
    Label5: TLabel;
    cmbBandwidth: TComboBox;
    Label7: TLabel;
    cmbImplicit: TComboBox;
    Label8: TLabel;
    pblSentenceCount: TPanel;
    pnlFrequencyError: TPanel;
    Label9: TLabel;
    pnlPacketRSSI: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    pnlPacketSNR: TPanel;
    chkOnline: TCheckBox;
    IdHTTP1: TIdHTTP;
    Panel3: TPanel;
    Label12: TLabel;
    edtCallsign: TEdit;
    Label13: TLabel;
    pnlSSDVCount: TPanel;
    Label16: TLabel;
    pnlSSDVQueue: TPanel;
    tmrScreenUpdates: TTimer;
    IdHTTP2: TIdHTTP;
    Label17: TLabel;
    pnlAverageRSSI: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    lstPackets: TListBox;
    Button1: TButton;
    Label19: TLabel;
    pnlScanFrequency: TPanel;
    Chart1: TChart;
    Series4: TFastLineSeries;
    tmrSearch: TTimer;
    Button2: TButton;
    pnlSearchFrequency: TPanel;
    Panel4: TPanel;
    ProgressBar1: TProgressBar;
    chkAFC: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1CloseUp(Sender: TObject);
    procedure VaComm1RxChar(Sender: TObject; Count: Integer);
    procedure btnSetClick(Sender: TObject);
    procedure tmrCommandsTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrScreenUpdatesTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure tmrSearchTimer(Sender: TObject);
  private
    { Private declarations }
    Scanning, Searching: Boolean;
    SearchFrequencyError, SearchFrequency, MinSearchFrequency, MaxSearchFrequency, SearchFrequencyStep: Double;
    SearchPacketCount: Integer;
    procedure NextScan;
    procedure NextSearch(Test: Boolean);
    procedure StopSearch;
    procedure ProcessLine(Line: AnsiString);
    procedure ApplyAFC;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  CritSSDV, CritHabitat: TCriticalSection;
  SSDVPackets: TStringList;
  HabitatSentence: String;

implementation

{$R *.dfm}


procedure TForm1.btnSetClick(Sender: TObject);
begin
    lstCommands.Items.Clear;
    lstCommands.Items.Add('~F' + edtFrequency.Text);
    lstCommands.Items.Add('~M' + IntToStr(cmbMode.ItemIndex));
    if cmbCoding.ItemIndex > 0 then begin
        lstCommands.Items.Add('~E' + IntToStr(cmbCoding.ItemIndex+4));
    end;
    if cmbSpreading.ItemIndex > 0 then begin
        lstCommands.Items.Add('~S' + IntToStr(cmbSpreading.ItemIndex+5));
    end;
    if cmbBandwidth.ItemIndex > 0 then begin
        lstCommands.Items.Add('~B' + cmbBandwidth.Text);
    end;
    if cmbImplicit.ItemIndex > 0 then begin
        lstCommands.Items.Add('~I' + IntToStr(cmbImplicit.ItemIndex-1));
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    MinSearchFrequency := 434;
    MaxSearchFrequency := 434.7;
    SearchFrequencyStep := 0.0125;
    SearchFrequency := MinSearchFrequency - SearchFrequencyStep;
    Scanning := True;
    Chart1.Series[0].Clear;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    MinSearchFrequency := StrToFloat(edtFrequency.Text) - 0.010;
    MaxSearchFrequency := StrToFloat(edtFrequency.Text) + 0.010;
    SearchFrequencyStep := 0.002;
    SearchFrequency := MinSearchFrequency - SearchFrequencyStep;
    Searching := True;
    NextSearch(False);
end;

procedure TForm1.NextScan;
begin
    SearchFrequency := SearchFrequency + SearchFrequencyStep;

    if SearchFrequency > MaxSearchFrequency then begin
        pnlScanFrequency.Caption := '';
        Scanning := False;
        btnSetClick(nil);
    end else begin
        pnlScanFrequency.Caption := FormatFloat('.0000', SearchFrequency);
        lstCommands.Items.Add('~F' + pnlScanFrequency.Caption);
    end;
end;

procedure TForm1.NextSearch(Test: Boolean);
begin
    SearchFrequency := SearchFrequency + SearchFrequencyStep;

    if Test and (SearchFrequency > MaxSearchFrequency) then begin
        pnlSearchFrequency.Caption := '';
        ProgressBar1.Position := 0;
        Searching := False;
        btnSetClick(nil);
    end else begin
        pnlSearchFrequency.Caption := FormatFloat('.0000', SearchFrequency);
        ProgressBar1.Position := Round(((SearchFrequency + SearchFrequencyStep - MinSearchFrequency) / (MaxSearchFrequency + SearchFrequencyStep - MinSearchFrequency)) * 100);
        lstCommands.Items.Add('~F' + pnlSearchFrequency.Caption);
        SearchPacketCount := 0;
        tmrSearch.Enabled := True;
    end;
end;

procedure TForm1.StopSearch;
begin
    edtFrequency.Text := FormatFloat('0.0000', SearchFrequency + SearchFrequencyError / 1000);

    ProgressBar1.Position := 0;

    pnlSearchFrequency.Caption := '';

    Searching := False;

    btnSetClick(nil);
end;

procedure TForm1.ComboBox1CloseUp(Sender: TObject);
begin
    VaComm1.Close;
    if ComboBox1.ItemIndex >= 0 then begin
        try
            VaComm1.DeviceName := ComboBox1.Text;
            VaComm1.Open;
            pnlCommStatus.Caption := VaComm1.DeviceName + ' open';
        except
            pnlCommStatus.Caption := VaComm1.DeviceName + ' failed to open';
        end;
    end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    CritSSDV.Free;
    CritHabitat.Free;
    SSDVPackets.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  reg: TRegistry;
  st: Tstrings;
  i: Integer;
begin
    CritSSDV := TCriticalSection.Create;
    CritHabitat := TCriticalSection.Create;
    SSDVPackets := TStringList.Create;

    THabitatThread.Create(False);
    TSSDVThread.Create(False);

    ComboBox1.Items.Clear;

    reg := TRegistry.Create;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKeyReadOnly('hardware\devicemap\serialcomm');
        st := TstringList.Create;
        try
            reg.GetValueNames(st);
            for i := 0 to st.Count - 1 do begin
                ComboBox1.Items.Add(reg.Readstring(st.strings[i]));
            end;
        finally
            st.Free;
        end;
        reg.CloseKey;
    finally
        reg.Free;
    end;
end;

function GetString(var Line: AnsiString; Delimiter: String=','): AnsiString;
var
    Position: Integer;
begin
    Position := Pos(Delimiter, string(Line));
    if Position > 0 then begin
        Result := Copy(Line, 1, Position-1);
        Line := Copy(Line, Position+Length(Delimiter), Length(Line));
    end else begin
        Result := Line;
        Line := '';
    end;
end;

procedure UploadSentence(Telemetry: String);
var
    URL, FormAction, Callsign, Temp: String;
    Params: TStringList;
begin
    URL := 'http://habitat.habhub.org/transition';
    FormAction := 'payload_telemetry';
    Callsign := Form1.edtCallsign.Text;

    // Parameters
    Params := TStringList.Create;
    // Params.Add('Submit=' + FormAction);
    Params.Add('callsign=' + Callsign);
    Params.Add('string=' + Telemetry + #10);
    Params.Add('string_type=ascii');
    Params.Add('metadata={}');
    Params.Add('time_created=');

    // Post it
    Form1.IdHTTP1.Request.ContentType := 'application/x-www-form-urlencoded';
    Form1.IdHTTP1.Response.KeepAlive := False;
    Temp := Form1.IdHTTP1.Post(URL + '/' + FormAction, Params);

    Params.Free;
end;

procedure UploadSSDV(Packets: TStringList);
var
    URL, FormAction, Callsign, Temp, json: String;
    JsonToSend: TStringStream;
    i: Integer;
begin
    URL := 'http://ssdv.habhub.org/api/v0';
    FormAction := 'packets';
    Callsign := Form1.edtCallsign.Text;

    // Create json with the base64 data in hex, the tracker callsign and the current timestamp
    json :=
            '{' +
                '"type": "packets",' +
                '"packets":[';

    for i := 0 to Packets.Count-1 do begin
        if i > 0 then json := json + ',';
        
        json := json +
                     '{' +
                        '"type": "packet",' +
                        '"packet":' + '"55' + Packets[i] + '",' +
                        '"encoding": "hex",' +
                        '"received": "' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss"Z"', Now) + '",' +
                        '"receiver": "' + Callsign + '"' +
                     '}';
    end;

    json := json + ']}';

    // Need the JSON as a stream
    JsonToSend := TStringStream.Create(Json, TEncoding.UTF8);

    // Post it
    try
        Form1.IdHTTP2.Request.ContentType := 'application/json';
        Form1.IdHTTP2.Request.ContentEncoding := 'UTF-8';
        Form1.IdHTTP2.Response.KeepAlive := False;
        Temp := Form1.IdHTTP2.Post(URL + '/' + FormAction, JsonToSend);
    finally
        JsonToSend.Free;
    end;
    // Params.Free;
end;

procedure TForm1.ProcessLine(Line: AnsiString);
var
    Command: AnsiString;
begin
    Command := UpperCase(GetString(Line, '='));

    if Command = 'CURRENTRSSI' then begin
        pnlRSSI.Caption := string(Line + 'dBm');
        if pnlAverageRSSI.Caption = '' then begin
            pnlAverageRSSI.Caption := string(Line + 'dBm');
        end else begin
            pnlAverageRSSI.Caption := IntToStr(Round(StrToFloat(Copy(pnlAverageRSSI.Caption, 1, Length(pnlAverageRSSI.Caption)-3)) * 0.8 + StrToFloat(Line) * 0.2)) + 'dBm';
        end;

        if Scanning then begin
            if SearchFrequency > MinSearchFrequency then begin
                Chart1.Series[0].AddXY(SearchFrequency - 434.0, StrToFloat(Line));
            end;

            NextScan;
        end;
    end else if Command = 'MESSAGE' then begin
        lstPackets.Items.Add(Line);
        lstPackets.ItemIndex := lstPackets.Items.Count-1;
        Inc(SearchPacketCount);
        pblSentenceCount.Caption := IntToStr(StrToIntdef(pblSentenceCount.Caption, 0) + 1);
        if chkOnline.Checked then begin
            if Line[1] = '%' then begin
                Line[1] := '$';
            end;

            CritHabitat.Enter;
            try
                HabitatSentence := Line;
            finally
                CritHabitat.Leave;
            end;
        end;
        ApplyAFC;
    end else if Command = 'HEX' then begin
        if (Copy(Line,1,2) = '66') or (Copy(Line,1,2) = 'E6') then begin
            lstPackets.Items.Add(Line);
            lstPackets.ItemIndex := lstPackets.Items.Count-1;
            if Copy(Line,1,2) = 'E6' then begin
                Line[1] := '6';
            end;
            pnlSSDVCount.Caption := IntToStr(StrToIntdef(pnlSSDVCount.Caption, 0) + 1);
            if chkOnline.Checked then begin
                CritSSDV.Enter;
                try
                    SSDVPackets.Add(Line);
                finally
                    CritSSDV.Leave;
                end;
            end;
        end;
    end else if Command = 'FREQERR' then begin
        pnlFrequencyError.Caption := Line + ' kHz';
        SearchFrequencyError := StrToFloat(Line);
    end else if Command = 'PACKETRSSI' then begin
        pnlPacketRSSI.Caption := Line;
    end else if Command = 'PACKETSNR' then begin
        pnlPacketSNR.Caption := Line;
    end else begin
        // lstPackets.Items.Add('Unknown: ' + Line);
    end;
end;

procedure TForm1.ApplyAFC;
begin
    if chkAFC.Checked then begin
        if (not Scanning) and (not Searching) then begin
            if Abs(SearchFrequencyError) > 1 then begin
                edtFrequency.Text := FormatFloat('0.000', StrToFloat(edtFrequency.Text) + SearchFrequencyError / 1000);
                lstCommands.Items.Add('~F' + edtFrequency.Text);
            end;
        end;
    end;
end;

procedure TForm1.tmrCommandsTimer(Sender: TObject);
begin
    if lstCommands.Items.Count > 0 then begin
        VaComm1.WriteText(lstCommands.Items[0] + #13);
        lstCommands.Items.Delete(0);
    end;
end;

procedure TForm1.tmrScreenUpdatesTimer(Sender: TObject);
begin
    CritSSDV.Enter;
    try
        pnlSSDVQueue.Caption := IntToStr(SSDVPackets.Count);
    finally
        CritSSDV.Leave;
    end;
end;

procedure TForm1.tmrSearchTimer(Sender: TObject);
begin
    tmrSearch.Enabled := False;

    if SearchPacketCount > 1 then begin
        StopSearch;
    end else begin
        NextSearch(True);
    end;
end;

procedure TForm1.VaComm1RxChar(Sender: TObject; Count: Integer);
const
    Buffer: AnsiString = '';
var
    i: Integer;
    Character: AnsiChar;
begin
    for i := 1 to Count do begin
        VaComm1.ReadChar(Character);

        try
            if (Character = Chr(10)) or (Character = Chr(13)) then begin
                if Length(Buffer) > 0 then begin
                    ProcessLine(Buffer);
                    Buffer := '';
                end;
            end else begin
                if Length(Buffer) < 1000 then begin
                    Buffer := Buffer + Character;
                end;
            end;
        except
        end;
    end;
end;

procedure THabitatThread.Execute;
var
    Sentence: String;
begin
    while not Application.Terminated do begin
        Sentence := '';
        CritHabitat.Enter;
        try
            if HabitatSentence <> '' then begin
                Sentence := HabitatSentence;
            end;
        finally
            HabitatSentence := '';
            CritHabitat.Leave;
        end;
        if Sentence <> '' then begin
            UploadSentence(Sentence);
        end else begin
            sleep(100);
        end;
    end;
end;

procedure TSSDVThread.Execute;
var
    Packets: TStringList;
begin
    Packets := TStringList.Create;

    while not Application.Terminated do begin
        Packets.Clear;
        CritSSDV.Enter;
        try
            if SSDVPackets.Count > 0 then begin
                Packets.Assign(SSDVPackets);
                SSDVPackets.Clear;
            end;
        finally
            CritSSDV.Leave;
        end;
        if Packets.Count > 0 then begin
            UploadSSDV(Packets);
        end else begin
            sleep(100);
        end;
    end;

    Packets.Free;
end;

end.
