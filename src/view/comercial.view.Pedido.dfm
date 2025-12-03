object frmPedido: TfrmPedido
  Left = 0
  Top = 0
  Caption = 'Pedido de Venda'
  ClientHeight = 395
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
  object GridItens: TDBGrid
    Left = 0
    Top = 146
    Width = 900
    Height = 248
    Align = alTop
    DataSource = DSItens
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 73
    Width = 900
    Height = 73
    Align = alTop
    Caption = 'Produto'
    TabOrder = 1
    object Label4: TLabel
      Left = 21
      Top = 17
      Width = 33
      Height = 13
      Caption = 'C'#243'digo'
    end
    object Label5: TLabel
      Left = 107
      Top = 17
      Width = 24
      Height = 13
      Caption = 'Valor'
    end
    object Label6: TLabel
      Left = 193
      Top = 17
      Width = 56
      Height = 13
      Caption = 'Quantidade'
    end
    object edtValor: TEdit
      Left = 107
      Top = 36
      Width = 80
      Height = 21
      TabOrder = 0
    end
    object edtQuantidade: TEdit
      Left = 193
      Top = 36
      Width = 80
      Height = 21
      TabOrder = 1
    end
    object btnAddItem: TButton
      Left = 295
      Top = 32
      Width = 100
      Height = 25
      Caption = 'Adicionar Item'
      TabOrder = 2
      OnClick = BtnAddItemClick
    end
    object edtCodItem: TEdit
      Left = 21
      Top = 36
      Width = 80
      Height = 21
      TabOrder = 3
    end
    object btnEditarItem: TButton
      Left = 408
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Editar Item'
      TabOrder = 4
      OnClick = btnEditarItemClick
    end
    object btnRemoverItem: TButton
      Left = 496
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Remover Item'
      TabOrder = 5
      OnClick = btnRemoverItemClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 73
    Align = alTop
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 68
      Height = 13
      Caption = 'C'#243'digo pedido'
    end
    object Label8: TLabel
      Left = 102
      Top = 8
      Width = 55
      Height = 13
      Caption = 'Fornecedor'
    end
    object edtIdPedido: TEdit
      Left = 16
      Top = 27
      Width = 80
      Height = 21
      TabOrder = 0
      OnExit = edtIdPedidoExit
    end
    object ComboBoxFornecedor: TComboBox
      Left = 102
      Top = 27
      Width = 643
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnSelect = ComboBoxFornecedorSelect
    end
    object btnCriarPedido: TButton
      Left = 764
      Top = 25
      Width = 75
      Height = 25
      Caption = 'Criar Pedido'
      TabOrder = 2
      OnClick = btnCriarPedidoClick
    end
  end
  object DSPedido: TDataSource
    Left = 248
    Top = 336
  end
  object DSItens: TDataSource
    Left = 328
    Top = 336
  end
  object DSFornecedores: TDataSource
    Left = 408
    Top = 336
  end
end
