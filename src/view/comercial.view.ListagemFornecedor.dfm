object frmListagemFornecedor: TfrmListagemFornecedor
  Left = 0
  Top = 0
  Caption = 'Listagem de Fornecedores'
  ClientHeight = 480
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object Grid: TDBGrid
    Left = 0
    Top = 0
    Width = 720
    Height = 400
    Align = alTop
    DataSource = DS
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object BtnNovo: TButton
    Left = 16
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Novo'
    TabOrder = 1
    OnClick = BtnNovoClick
  end
  object BtnEditar: TButton
    Left = 96
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Editar'
    TabOrder = 2
    OnClick = BtnEditarClick
  end
  object BtnExcluir: TButton
    Left = 176
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 3
    OnClick = BtnExcluirClick
  end
  object DS: TDataSource
    Left = 264
    Top = 424
  end
end
