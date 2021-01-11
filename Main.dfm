object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'LoRa Serial/Bluetooth Gateway V1.7'
  ClientHeight = 691
  ClientWidth = 606
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    606
    691)
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 79
    Height = 19
    Alignment = taRightJustify
    Caption = 'Serial Port:'
  end
  object Label6: TLabel
    Left = 8
    Top = 120
    Width = 98
    Height = 19
    Alignment = taRightJustify
    Caption = 'Current RSSI:'
  end
  object Label14: TLabel
    Left = 25
    Top = 176
    Width = 78
    Height = 19
    Alignment = taRightJustify
    Caption = 'Frequency:'
  end
  object Label15: TLabel
    Left = 211
    Top = 176
    Width = 30
    Height = 19
    Caption = 'MHz'
  end
  object Label2: TLabel
    Left = 282
    Top = 176
    Width = 44
    Height = 19
    Alignment = taRightJustify
    Caption = 'Mode:'
  end
  object Label3: TLabel
    Left = 270
    Top = 209
    Width = 56
    Height = 19
    Alignment = taRightJustify
    Caption = 'Coding:'
  end
  object Label4: TLabel
    Left = 249
    Top = 242
    Width = 77
    Height = 19
    Alignment = taRightJustify
    Caption = 'Spreading:'
  end
  object Label5: TLabel
    Left = 23
    Top = 209
    Width = 80
    Height = 19
    Alignment = taRightJustify
    Caption = 'Bandwidth:'
  end
  object Label7: TLabel
    Left = 47
    Top = 242
    Width = 56
    Height = 19
    Alignment = taRightJustify
    Caption = 'Header:'
  end
  object Label8: TLabel
    Left = 27
    Top = 295
    Width = 76
    Height = 19
    Alignment = taRightJustify
    Caption = 'Sentences:'
  end
  object Label9: TLabel
    Left = 20
    Top = 328
    Width = 83
    Height = 19
    Alignment = taRightJustify
    Caption = 'Freq. Error:'
  end
  object Label10: TLabel
    Left = 221
    Top = 328
    Width = 90
    Height = 19
    Alignment = taRightJustify
    Caption = 'Packet RSSI:'
  end
  object Label11: TLabel
    Left = 451
    Top = 328
    Width = 36
    Height = 19
    Alignment = taRightJustify
    Caption = 'SNR:'
  end
  object Label12: TLabel
    Left = 42
    Top = 64
    Width = 61
    Height = 19
    Alignment = taRightJustify
    Caption = 'Callsign:'
  end
  object Label13: TLabel
    Left = 266
    Top = 295
    Width = 45
    Height = 19
    Alignment = taRightJustify
    Caption = 'SSDV:'
  end
  object Label16: TLabel
    Left = 425
    Top = 295
    Width = 62
    Height = 19
    Alignment = taRightJustify
    Caption = 'SSDV Q:'
  end
  object Label17: TLabel
    Left = 215
    Top = 120
    Width = 103
    Height = 19
    Alignment = taRightJustify
    Caption = 'Average RSSI:'
  end
  object lstCommands: TListBox
    Left = 476
    Top = 209
    Width = 121
    Height = 57
    ItemHeight = 19
    TabOrder = 6
    Visible = False
  end
  object ComboBox1: TComboBox
    Left = 120
    Top = 21
    Width = 181
    Height = 27
    Style = csDropDownList
    ItemHeight = 19
    Sorted = True
    TabOrder = 0
    OnCloseUp = ComboBox1CloseUp
  end
  object pnlCommStatus: TPanel
    Left = 332
    Top = 20
    Width = 265
    Height = 27
    BevelOuter = bvLowered
    Caption = 'Please choose serial port'
    TabOrder = 1
  end
  object pnlRSSI: TPanel
    Left = 120
    Top = 116
    Width = 89
    Height = 27
    BevelOuter = bvLowered
    TabOrder = 2
  end
  object btnSet: TButton
    Left = 468
    Top = 174
    Width = 130
    Height = 92
    Caption = 'Set'
    TabOrder = 3
    OnClick = btnSetClick
  end
  object edtFrequency: TEdit
    Left = 120
    Top = 173
    Width = 85
    Height = 27
    TabOrder = 4
    Text = '434.425'
  end
  object Panel1: TPanel
    Left = 13
    Top = 155
    Width = 585
    Height = 5
    BevelOuter = bvLowered
    TabOrder = 5
  end
  object cmbMode: TComboBox
    Left = 332
    Top = 173
    Width = 112
    Height = 27
    ItemHeight = 19
    ItemIndex = 1
    TabOrder = 7
    Text = '1 - Fast'
    Items.Strings = (
      '0 - Slow'
      '1 - Fast'
      '2 - Repeater'
      '3 - Turbo'
      '4 - TurboX'
      '5 - Calling'
      '6 - Uplink'
      '7 - Telnet')
  end
  object Panel2: TPanel
    Left = 8
    Top = 280
    Width = 585
    Height = 5
    BevelOuter = bvLowered
    TabOrder = 8
  end
  object cmbCoding: TComboBox
    Left = 332
    Top = 206
    Width = 85
    Height = 27
    ItemHeight = 19
    ItemIndex = 0
    TabOrder = 9
    Text = '(default)'
    Items.Strings = (
      '(default)'
      '5'
      '6'
      '7'
      '8')
  end
  object cmbSpreading: TComboBox
    Left = 332
    Top = 239
    Width = 85
    Height = 27
    ItemHeight = 19
    ItemIndex = 0
    TabOrder = 10
    Text = '(default)'
    Items.Strings = (
      '(default)'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12')
  end
  object cmbBandwidth: TComboBox
    Left = 120
    Top = 206
    Width = 85
    Height = 27
    ItemHeight = 19
    TabOrder = 11
    Text = '(default)'
    Items.Strings = (
      '(default)'
      '7K8'
      '10K4'
      '15K6'
      '20K8'
      '31K25'
      '42K7'
      '62K5'
      '125K'
      '250K'
      '500K')
  end
  object cmbImplicit: TComboBox
    Left = 120
    Top = 239
    Width = 85
    Height = 27
    ItemHeight = 19
    TabOrder = 12
    Text = '(default)'
    Items.Strings = (
      '(default)'
      'Explicit'
      'Implicit')
  end
  object pblSentenceCount: TPanel
    Left = 120
    Top = 291
    Width = 89
    Height = 27
    BevelOuter = bvLowered
    TabOrder = 13
  end
  object pnlFrequencyError: TPanel
    Left = 120
    Top = 324
    Width = 89
    Height = 27
    BevelOuter = bvLowered
    TabOrder = 14
  end
  object pnlPacketRSSI: TPanel
    Left = 328
    Top = 324
    Width = 89
    Height = 27
    BevelOuter = bvLowered
    TabOrder = 15
  end
  object pnlPacketSNR: TPanel
    Left = 504
    Top = 324
    Width = 89
    Height = 27
    BevelOuter = bvLowered
    TabOrder = 16
  end
  object chkOnline: TCheckBox
    Left = 332
    Top = 66
    Width = 225
    Height = 17
    Caption = 'Upload to Habitat'
    TabOrder = 17
  end
  object Panel3: TPanel
    Left = 13
    Top = 105
    Width = 585
    Height = 5
    BevelOuter = bvLowered
    TabOrder = 18
  end
  object edtCallsign: TEdit
    Left = 120
    Top = 61
    Width = 181
    Height = 27
    TabOrder = 19
    Text = 'M0RPI'
  end
  object pnlSSDVCount: TPanel
    Left = 328
    Top = 291
    Width = 89
    Height = 27
    BevelOuter = bvLowered
    TabOrder = 20
  end
  object pnlSSDVQueue: TPanel
    Left = 504
    Top = 291
    Width = 89
    Height = 27
    BevelOuter = bvLowered
    TabOrder = 21
  end
  object pnlAverageRSSI: TPanel
    Left = 332
    Top = 116
    Width = 89
    Height = 27
    BevelOuter = bvLowered
    TabOrder = 22
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 408
    Width = 590
    Height = 275
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 23
    object TabSheet1: TTabSheet
      Caption = 'Comms'
      ExplicitHeight = 208
      object lstPackets: TListBox
        Left = 0
        Top = 0
        Width = 582
        Height = 241
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 18
        ParentFont = False
        TabOrder = 0
        ExplicitLeft = -8
        ExplicitTop = -29
        ExplicitWidth = 590
        ExplicitHeight = 237
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Band Scan'
      ImageIndex = 1
      ExplicitHeight = 208
      DesignSize = (
        582
        241)
      object Label19: TLabel
        Left = 372
        Top = 7
        Width = 78
        Height = 19
        Alignment = taRightJustify
        Caption = 'Frequency:'
      end
      object Button1: TButton
        Left = 3
        Top = 3
        Width = 190
        Height = 30
        Caption = 'Scan Band For Signal'
        TabOrder = 0
        OnClick = Button1Click
      end
      object pnlScanFrequency: TPanel
        Left = 456
        Top = 3
        Width = 117
        Height = 27
        BevelOuter = bvLowered
        TabOrder = 1
      end
      object Chart1: TChart
        Left = 3
        Top = 39
        Width = 576
        Height = 199
        Legend.Visible = False
        Title.Text.Strings = (
          'TChart')
        Title.Visible = False
        View3D = False
        TabOrder = 2
        Anchors = [akLeft, akTop, akRight, akBottom]
        ExplicitHeight = 243
        object Series4: TFastLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Title = 'RSSI'
          LinePen.Color = clBlue
          LinePen.Width = 2
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
    end
  end
  object Button2: TButton
    Left = 436
    Top = 368
    Width = 157
    Height = 30
    Caption = 'Search +/- 10kHz'
    TabOrder = 24
    OnClick = Button2Click
  end
  object pnlSearchFrequency: TPanel
    Left = 327
    Top = 368
    Width = 90
    Height = 27
    BevelOuter = bvLowered
    TabOrder = 25
  end
  object Panel4: TPanel
    Left = 13
    Top = 357
    Width = 585
    Height = 5
    BevelOuter = bvLowered
    TabOrder = 26
  end
  object ProgressBar1: TProgressBar
    Left = 13
    Top = 368
    Width = 305
    Height = 27
    BarColor = clNavy
    TabOrder = 27
  end
  object chkAFC: TCheckBox
    Left = 468
    Top = 122
    Width = 97
    Height = 21
    Caption = 'AFC'
    TabOrder = 28
  end
  object VaComm1: TVaComm
    Baudrate = br57600
    FlowControl.OutCtsFlow = False
    FlowControl.OutDsrFlow = False
    FlowControl.ControlDtr = dtrEnabled
    FlowControl.ControlRts = rtsEnabled
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    FlowControl.DsrSensitivity = False
    FlowControl.TxContinueOnXoff = False
    DeviceName = 'COM%d'
    SettingsStore.RegRoot = rrCURRENTUSER
    SettingsStore.Location = slINIFile
    OnRxChar = VaComm1RxChar
    Version = '2.1.0.1'
    Left = 316
    Top = 48
  end
  object tmrCommands: TTimer
    Interval = 100
    OnTimer = tmrCommandsTimer
    Left = 500
    Top = 60
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 556
    Top = 84
  end
  object tmrScreenUpdates: TTimer
    OnTimer = tmrScreenUpdatesTimer
    Left = 384
    Top = 52
  end
  object IdHTTP2: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 556
    Top = 140
  end
  object tmrSearch: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmrSearchTimer
    Left = 320
    Top = 392
  end
end
