object frmIndex: TfrmIndex
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'M'#243'dulo Comercial'
  ClientHeight = 157
  ClientWidth = 402
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Position = poScreenCenter
  TextHeight = 13
  object ButtonFornecedores: TButton
    Left = 120
    Top = 24
    Width = 201
    Height = 25
    Caption = 'Fornecedores'
    TabOrder = 0
    OnClick = ButtonFornecedoresClick
  end
  object ButtonPedidos: TButton
    Left = 120
    Top = 55
    Width = 201
    Height = 25
    Caption = 'Pedido'
    TabOrder = 1
    OnClick = ButtonPedidosClick
  end
  object buttonPorProduto: TButton
    Left = 120
    Top = 117
    Width = 201
    Height = 25
    Caption = 'Relat'#243'rio de Compras por Produto'
    TabOrder = 2
    OnClick = buttonPorProdutoClick
  end
  object ButtonPorFornecedor: TButton
    Left = 120
    Top = 86
    Width = 201
    Height = 25
    Caption = 'Relat'#243'rio de Compras por Fornecedor'
    TabOrder = 3
  end
end
