object frmListagemProduto: TfrmListagemProduto
  Left = 0
  Top = 0
  Caption = 'Listagem de produto'
  ClientHeight = 289
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object DBGrid1: TDBGrid
    Left = 0
    Top = 56
    Width = 624
    Height = 233
    Align = alBottom
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object btnNovo: TButton
    Left = 379
    Top = 18
    Width = 75
    Height = 25
    Caption = 'Novo'
    TabOrder = 1
    OnClick = btnNovoClick
  end
  object btnEditar: TButton
    Left = 460
    Top = 17
    Width = 75
    Height = 25
    Caption = 'Editar'
    TabOrder = 2
    OnClick = btnEditarClick
  end
  object btnExcluir: TButton
    Left = 541
    Top = 17
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 3
    OnClick = btnExcluirClick
  end
  object DataSource1: TDataSource
    Left = 360
    Top = 128
  end
end
