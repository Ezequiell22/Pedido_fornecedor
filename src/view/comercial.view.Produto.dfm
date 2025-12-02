object frmProduto: TfrmProduto
  Left = 0
  Top = 0
  Caption = 'Produtos'
  ClientHeight = 71
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 13
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object Label2: TLabel
    Left = 96
    Top = 13
    Width = 46
    Height = 13
    Caption = 'Descri'#231#227'o'
  end
  object Label3: TLabel
    Left = 402
    Top = 13
    Width = 29
    Height = 13
    Caption = 'Marca'
  end
  object Label4: TLabel
    Left = 586
    Top = 13
    Width = 27
    Height = 13
    Caption = 'Pre'#231'o'
  end
  object edtId: TEdit
    Left = 8
    Top = 32
    Width = 80
    Height = 21
    TabOrder = 0
  end
  object edtDescricao: TEdit
    Left = 96
    Top = 32
    Width = 300
    Height = 21
    TabOrder = 1
  end
  object edtMarca: TEdit
    Left = 400
    Top = 32
    Width = 180
    Height = 21
    TabOrder = 2
  end
  object edtPreco: TEdit
    Left = 586
    Top = 32
    Width = 100
    Height = 21
    TabOrder = 3
  end
  object btnSalvar: TButton
    Left = 717
    Top = 30
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 4
    OnClick = BtnSalvarClick
  end
  object FDS: TDataSource
    Left = 512
    Top = 8
  end
end
