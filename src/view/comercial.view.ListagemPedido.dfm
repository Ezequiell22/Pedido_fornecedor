object frmListagemPedido: TfrmListagemPedido
  Left = 0
  Top = 0
  Caption = 'Listagem de Pedidos EMPRESA 200'
  ClientHeight = 520
  ClientWidth = 775
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object GridPedidos: TDBGrid
    Left = 0
    Top = 177
    Width = 775
    Height = 145
    Align = alTop
    DataSource = DSPedidos
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object GridItens: TDBGrid
    Left = 0
    Top = 322
    Width = 775
    Height = 192
    Align = alTop
    DataSource = DSItens
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 775
    Height = 177
    Align = alTop
    TabOrder = 2
    object LabelFornecedor: TLabel
      Left = 280
      Top = 12
      Width = 55
      Height = 13
      Caption = 'Fornecedor'
    end
    object LabelPeriodo: TLabel
      Left = 16
      Top = 12
      Width = 36
      Height = 13
      Caption = 'Per'#237'odo'
    end
    object Label1: TLabel
      Left = 16
      Top = 59
      Width = 68
      Height = 13
      Caption = 'C'#243'digo pedido'
    end
    object DtIni: TDateTimePicker
      Left = 16
      Top = 32
      Width = 120
      Height = 21
      Date = 45452.000000000000000000
      Time = 45452.000000000000000000
      TabOrder = 0
    end
    object DtFim: TDateTimePicker
      Left = 144
      Top = 32
      Width = 120
      Height = 21
      Date = 45481.000000000000000000
      Time = 45481.000000000000000000
      TabOrder = 1
    end
    object CbFornecedor: TComboBox
      Left = 280
      Top = 32
      Width = 400
      Height = 21
      Style = csDropDownList
      TabOrder = 2
      OnSelect = CbFornecedorSelect
    end
    object BtnAplicarFiltros: TButton
      Left = 280
      Top = 76
      Width = 75
      Height = 25
      Caption = 'Aplicar Filtros'
      TabOrder = 3
      OnClick = BtnAplicarFiltrosClick
    end
    object BtnNovo: TButton
      Left = 16
      Top = 130
      Width = 75
      Height = 25
      Caption = 'Novo'
      TabOrder = 4
      OnClick = BtnNovoClick
    end
    object BtnEditar: TButton
      Left = 96
      Top = 130
      Width = 75
      Height = 25
      Caption = 'Editar'
      TabOrder = 5
      OnClick = BtnEditarClick
    end
    object BtnExcluir: TButton
      Left = 176
      Top = 130
      Width = 75
      Height = 25
      Caption = 'Excluir'
      TabOrder = 6
      OnClick = BtnExcluirClick
    end
    object edtCodigo: TEdit
      Left = 16
      Top = 78
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 7
    end
    object ButtonLimparFiltros: TButton
      Left = 361
      Top = 76
      Width = 75
      Height = 25
      Caption = 'Limpar filtros'
      TabOrder = 8
      OnClick = ButtonLimparFiltrosClick
    end
  end
  object DSPedidos: TDataSource
    OnDataChange = DSPedidosDataChange
    Left = 352
    Top = 272
  end
  object DSItens: TDataSource
    Left = 432
    Top = 272
  end
end
