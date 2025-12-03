object frmFornecedor: TfrmFornecedor
  Left = 0
  Top = 0
  Caption = 'Fornecedor'
  ClientHeight = 205
  ClientWidth = 502
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
    Width = 17
    Height = 13
    Caption = 'cod'
  end
  object Label2: TLabel
    Left = 16
    Top = 70
    Width = 71
    Height = 13
    Caption = 'Nome Fantasia'
  end
  object Label3: TLabel
    Left = 16
    Top = 43
    Width = 60
    Height = 13
    Caption = 'Raz'#227'o Social'
  end
  object Label4: TLabel
    Left = 16
    Top = 97
    Width = 55
    Height = 13
    Caption = 'Cod Estado'
  end
  object Label5: TLabel
    Left = 16
    Top = 124
    Width = 41
    Height = 13
    Caption = 'Cod Pais'
  end
  object edtCod_clifor: TEdit
    Left = 120
    Top = 12
    Width = 120
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object edtFantasia: TEdit
    Left = 120
    Top = 66
    Width = 360
    Height = 21
    TabOrder = 1
  end
  object edtRazao: TEdit
    Left = 120
    Top = 39
    Width = 360
    Height = 21
    TabOrder = 2
  end
  object edtCodEstado: TEdit
    Left = 120
    Top = 93
    Width = 41
    Height = 21
    TabOrder = 3
  end
  object edtCodPais: TEdit
    Left = 120
    Top = 120
    Width = 41
    Height = 21
    TabOrder = 4
  end
  object btnSalvar: TButton
    Left = 240
    Top = 164
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 5
    OnClick = BtnSalvarClick
  end
  object CheckBoxcliente: TCheckBox
    Left = 16
    Top = 168
    Width = 97
    Height = 17
    Caption = 'Cliente'
    TabOrder = 6
  end
  object CheckBoxFornec: TCheckBox
    Left = 119
    Top = 168
    Width = 97
    Height = 17
    Caption = 'Fornec'
    TabOrder = 7
  end
  object dts2: TDataSource
    Left = 392
    Top = 120
  end
end
