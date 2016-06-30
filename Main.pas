unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, StdCtrls, ExtCtrls, VaClasses, VaComm, Mask, AdvSpin,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

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
    lstPackets: TListBox;
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
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1CloseUp(Sender: TObject);
    procedure VaComm1RxChar(Sender: TObject; Count: Integer);
    procedure btnSetClick(Sender: TObject);
    procedure tmrCommandsTimer(Sender: TObject);
  private
    { Private declarations }
    procedure ProcessLine(Line: AnsiString);
    procedure UploadSentence(Telemetry: String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

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

procedure TForm1.FormCreate(Sender: TObject);
var
  reg: TRegistry;
  st: Tstrings;
  i: Integer;
begin
    ComboBox1.Items.Clear;

    reg := TRegistry.Create;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('hardware\devicemap\serialcomm', False);
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
    Position := Pos(Delimiter, Line);
    if Position > 0 then begin
        Result := Copy(Line, 1, Position-1);
        Line := Copy(Line, Position+Length(Delimiter), Length(Line));
    end else begin
        Result := Line;
        Line := '';
    end;
end;

procedure TForm1.UploadSentence(Telemetry: String);
var
    URL, FormAction, Callsign, Data, Temp: String;
    Params: TStringList;
    i: Integer;
begin
    URL := 'http://habitat.habhub.org/transition';
    FormAction := 'payload_telemetry';
    Callsign := edtCallsign.Text;

    // Parameters
    Params := TStringList.Create;
    // Params.Add('Submit=' + FormAction);
    Params.Add('callsign=' + Callsign);
    Params.Add('string=' + Telemetry + #10);
    Params.Add('string_type=ascii');
    Params.Add('metadata={}');
    Params.Add('time_created=');

    // Post it
    IdHTTP1.Request.ContentType := 'application/x-www-form-urlencoded';
    IdHTTP1.Response.KeepAlive := False;
    Temp := IdHTTP1.Post(URL + '/' + FormAction, Params);

    Params.Free;
end;

procedure TForm1.ProcessLine(Line: AnsiString);
var
    Command: String;
begin
//    lstPackets.Items.Add(Line);
//    lstPackets.ItemIndex := lstPackets.Items.Count-1;

    Command := UpperCase(GetString(Line, '='));

    if Command = 'CURRENTRSSI' then begin
        pnlRSSI.Caption := Line + 'dBm';
    end else if Command = 'MESSAGE' then begin
        lstPackets.Items.Add(Line);
        lstPackets.ItemIndex := lstPackets.Items.Count-1;
        pblSentenceCount.Caption := IntToStr(StrToIntdef(pblSentenceCount.Caption, 0) + 1);
        if chkOnline.Checked then begin
            UploadSentence(Line);
        end;
    end else if Command = 'FREQERR' then begin
        pnlFrequencyError.Caption := Line + ' kHz';
    end else if Command = 'PACKETRSSI' then begin
        pnlPacketRSSI.Caption := Line;
    end else if Command = 'PACKETSNR' then begin
        pnlPacketSNR.Caption := Line;
    end else begin
        // lstPackets.Items.Add('Unknown: ' + Line);
    end;
end;

procedure TForm1.tmrCommandsTimer(Sender: TObject);
begin
    if lstCommands.Items.Count > 0 then begin
        VaComm1.WriteText(lstCommands.Items[0] + #13);
        lstCommands.Items.Delete(0);
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
    end;
end;

end.
