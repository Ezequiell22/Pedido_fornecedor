object TfrmFornecedor: TfrmFornecedor
  Left = 0
  Top = 0
  Caption = 'Fornecedor'
  ClientHeight = 360
  ClientWidth = 520
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
    Left = 16
    Top = 16
    Width = 12
    Height = 13
    Caption = 'ID'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 73
    Height = 13
    Caption = 'Nome Fantasia'
  end
  object Label3: TLabel
    Left = 16
    Top = 104
    Width = 68
    Height = 13
    Caption = 'Raz'#227'o Social'
  end
  object Label4: TLabel
    Left = 16
    Top = 144
    Width = 27
    Height = 13
    Caption = 'CNPJ'
  end
  object Label5: TLabel
    Left = 16
    Top = 184
    Width = 49
    Height = 13
    Caption = 'Endere'#231'o'
  end
  object Label6: TLabel
    Left = 16
    Top = 224
    Width = 44
    Height = 13
    Caption = 'Telefone'
  end
  object edtId: TEdit
    Left = 120
    Top = 12
    Width = 120
    Height = 21
    TabOrder = 0
  end
  object edtFantasia: TEdit
    Left = 120
    Top = 60
    Width = 360
    Height = 21
    TabOrder = 1
  end
  object edtRazao: TEdit
    Left = 120
    Top = 100
    Width = 360
    Height = 21
    TabOrder = 2
  end
  object edtCnpj: TEdit
    Left = 120
    Top = 140
    Width = 200
    Height = 21
    TabOrder = 3
  end
  object edtEndereco: TEdit
    Left = 120
    Top = 180
    Width = 360
    Height = 21
    TabOrder = 4
  end
  object edtTelefone: TEdit
    Left = 120
    Top = 220
    Width = 200
    Height = 21
    TabOrder = 5
  end
  object btnSalvar: TButton
    Left = 120
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 6
    OnClick = BtnSalvarClick
  end
  object dts2: TDataSource
    Left = 400
    Top = 280
  end
end
