object frmListagemPedido: TfrmListagemPedido
  Left = 0
  Top = 0
  Caption = 'Listagem de Pedidos'
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object LabelPeriodo: TLabel
    Left = 16
    Top = 12
    Width = 38
    Height = 13
    Caption = 'Per'#237'odo'
  end
  object LabelFornecedor: TLabel
    Left = 280
    Top = 12
    Width = 59
    Height = 13
    Caption = 'Fornecedor'
  end
  object DtIni: TDateTimePicker
    Left = 16
    Top = 32
    Width = 120
    Height = 21
    Date = 45452.000000000000000000
    Time = 0.000000000000000000
    TabOrder = 0
  end
  object DtFim: TDateTimePicker
    Left = 144
    Top = 32
    Width = 120
    Height = 21
    Date = 45482.000000000000000000
    Time = 0.000000000000000000
    TabOrder = 1
  end
  object CbFornecedor: TComboBox
    Left = 280
    Top = 32
    Width = 400
    Height = 21
    Style = csDropDownList
    TabOrder = 2
  end
  object BtnAplicarFiltros: TButton
    Left = 696
    Top = 30
    Width = 100
    Height = 25
    Caption = 'Aplicar Filtros'
    TabOrder = 3
    OnClick = BtnAplicarFiltrosClick
  end
  object GridPedidos: TDBGrid
    Left = 0
    Top = 64
    Width = 900
    Height = 256
    Align = alTop
    DataSource = DSPedidos
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object GridItens: TDBGrid
    Left = 0
    Top = 320
    Width = 900
    Height = 216
    Align = alTop
    DataSource = DSItens
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object BtnNovo: TButton
    Left = 16
    Top = 552
    Width = 75
    Height = 25
    Caption = 'Novo'
    TabOrder = 6
    OnClick = BtnNovoClick
  end
  object BtnEditar: TButton
    Left = 96
    Top = 552
    Width = 75
    Height = 25
    Caption = 'Editar'
    TabOrder = 7
    OnClick = BtnEditarClick
  end
  object BtnExcluir: TButton
    Left = 176
    Top = 552
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 8
    OnClick = BtnExcluirClick
  end
  object DSPedidos: TDataSource
    Left = 256
    Top = 560
  end
  object DSItens: TDataSource
    Left = 336
    Top = 560
  end
end
