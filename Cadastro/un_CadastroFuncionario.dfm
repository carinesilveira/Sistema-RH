object FrmCadastroFuncionario: TFrmCadastroFuncionario
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object pnlFundo: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    Align = alClient
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object lblNome: TLabel
      Left = 40
      Top = 72
      Width = 47
      Height = 23
      Caption = 'NOME'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Sitka Text'
      Font.Style = []
      ParentFont = False
    end
    object lblEndereco: TLabel
      Left = 40
      Top = 152
      Width = 85
      Height = 23
      Caption = 'ENDERE'#199'O'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Sitka Text'
      Font.Style = []
      ParentFont = False
    end
    object pnlCadastro: TPanel
      Left = 1
      Top = 1
      Width = 622
      Height = 41
      Align = alTop
      BevelOuter = bvSpace
      Caption = 'Cadastro'
      Color = clTeal
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -24
      Font.Name = 'Sitka Small'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
    end
    object edtEndereco: TDBEdit
      Left = 40
      Top = 181
      Width = 521
      Height = 23
      CharCase = ecUpperCase
      DataField = 'ENDERECO'
      DataSource = DS_CADASTRO
      TabOrder = 2
    end
    object edtNome: TDBEdit
      Left = 40
      Top = 101
      Width = 521
      Height = 23
      CharCase = ecUpperCase
      DataField = 'NOME'
      DataSource = DS_CADASTRO
      TabOrder = 1
    end
    object pnlAdmissao: TPanel
      Left = 1
      Top = 248
      Width = 622
      Height = 192
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 3
      object lblAdmissao: TLabel
        Left = 48
        Top = 9
        Width = 80
        Height = 23
        Caption = 'ADMISS'#195'O'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Sitka Text'
        Font.Style = []
        ParentFont = False
      end
      object lblCargo: TLabel
        Left = 384
        Top = 9
        Width = 53
        Height = 23
        Caption = 'CARGO'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Sitka Text'
        Font.Style = []
        ParentFont = False
      end
      object lblSalario: TLabel
        Left = 48
        Top = 100
        Width = 66
        Height = 23
        Caption = 'SAL'#193'RIO'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Sitka Text'
        Font.Style = []
        ParentFont = False
      end
      object admissao: TDateTimePicker
        Left = 48
        Top = 38
        Width = 97
        Height = 23
        Date = 45376.000000000000000000
        Time = 0.893172048614360400
        TabOrder = 0
      end
      object cbCargo: TDBComboBox
        Left = 384
        Top = 38
        Width = 145
        Height = 23
        CharCase = ecUpperCase
        DataField = 'CAR_NOME'
        DataSource = DS_CARGO
        Items.Strings = (
          'DESENVOLVEDOR'
          'QA'
          'COMERCIAL'
          'SUPORTE'
          'MARKETING')
        TabOrder = 1
      end
      object edtSalario: TDBEdit
        Left = 48
        Top = 129
        Width = 145
        Height = 23
        DataField = 'SALARIO'
        DataSource = DS_CADASTRO
        TabOrder = 2
      end
      object btnCancelar: TButton
        Left = 536
        Top = 160
        Width = 75
        Height = 25
        Caption = 'Cancelar'
        TabOrder = 3
        OnClick = btnCancelarClick
      end
      object btnSalvar: TButton
        Left = 439
        Top = 160
        Width = 75
        Height = 25
        Caption = 'Salvar'
        TabOrder = 4
        OnClick = btnSalvarClick
      end
    end
  end
  object Conexao: TFDConnection
    Params.Strings = (
      'Database=RH'
      'User_Name=sa'
      'Password=aram98'
      'Server=localhost'
      'DriverID=MSSQL')
    Connected = True
    Left = 225
    Top = 384
  end
  object Q_CADASTRO: TFDQuery
    Connection = Conexao
    SQL.Strings = (
      'SELECT * FROM FUNCIONARIOS')
    Left = 297
    Top = 384
    object Q_CADASTROID_FUNC: TFDAutoIncField
      FieldName = 'ID_FUNC'
      Origin = 'ID_FUNC'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object Q_CADASTRONOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Required = True
      Size = 50
    end
    object Q_CADASTROENDERECO: TStringField
      FieldName = 'ENDERECO'
      Origin = 'ENDERECO'
      Size = 50
    end
    object Q_CADASTROADMISSAO: TSQLTimeStampField
      FieldName = 'ADMISSAO'
      Origin = 'ADMISSAO'
      Required = True
    end
    object Q_CADASTROSALARIO: TBCDField
      FieldName = 'SALARIO'
      Origin = 'SALARIO'
      Required = True
      Precision = 14
      Size = 2
    end
    object Q_CADASTROCARGO: TIntegerField
      FieldName = 'CARGO'
      Origin = 'CARGO'
    end
  end
  object DS_CADASTRO: TDataSource
    DataSet = Q_CADASTRO
    Left = 369
    Top = 384
  end
  object Q_CARGO: TFDQuery
    Connection = Conexao
    SQL.Strings = (
      'SELECT * FROM CARGOS')
    Left = 440
    Top = 40
  end
  object DS_CARGO: TDataSource
    DataSet = Q_CARGO
    Left = 504
    Top = 40
  end
end
