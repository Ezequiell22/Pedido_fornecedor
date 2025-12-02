object frmListagemFornecedor: TfrmListagemFornecedor
  Left = 0
  Top = 0
  Caption = 'Listagem de fornecedores'
  ClientHeight = 249
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object btnNovo: TButton
    Left = 379
    Top = 18
    Width = 75
    Height = 25
    Caption = 'Novo'
    TabOrder = 0
    OnClick = btnNovoClick
  end
  object btnExcluir: TButton
    Left = 541
    Top = 17
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 1
    OnClick = btnExcluirClick
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
  object DBGrid1: TDBGrid
    Left = 0
    Top = 49
    Width = 624
    Height = 200
    Align = alBottom
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    Left = 96
    Top = 144
  end
end
