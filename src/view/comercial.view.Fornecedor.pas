unit comercial.view.Fornecedor;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.StdCtrls,
  Data.DB,
  Vcl.Controls, Vcl.Grids,
  comercial.controller,
  comercial.controller.interfaces;

type
  TfrmFornecedor = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtCod_clifor: TEdit;
    edtFantasia: TEdit;
    edtRazao: TEdit;
    edtCodEstado: TEdit;
    edtCodPais: TEdit;
    dts2: TDataSource;
    CheckBoxcliente: TCheckBox;
    CheckBoxFornec: TCheckBox;
    procedure FormShow(Sender: TObject);
  published
    FController: iController;
    btnSalvar: TButton;
    procedure BtnSalvarClick(Sender: TObject);
  private
    procedure LoadData;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  system.StrUtils,
  Vcl.Dialogs;

{$R *.dfm}

constructor TfrmFornecedor.Create(AOwner: TComponent);
begin
  inherited;
  FController := TController.New;
  FController.business.Fornecedor.Bind(dts2);
end;

destructor TfrmFornecedor.Destroy;
begin
  inherited;
end;

procedure TfrmFornecedor.FormShow(Sender: TObject);
begin
  FController.business.Fornecedor
  .GetById(strTointdef(edtCod_clifor.Text, 0));
  LoadData;
  edtFantasia.SetFocus;
end;

procedure TfrmFornecedor.LoadData;
begin
  if not dts2.DataSet.Active then
    Exit;
  edtCod_clifor.Text := dts2.DataSet.FieldByName('COD_CLIFOR').AsString;
  edtRazao.Text := dts2.DataSet.FieldByName('RAZAO').AsString;
  edtCodEstado.Text := dts2.DataSet.FieldByName('COD_ESTADO').AsString;
  edtFantasia.Text := dts2.DataSet.FieldByName('FANTASIA').AsString;
  edtCodPais.Text := dts2.DataSet.FieldByName('COD_PAIS').AsString;
  CheckBoxcliente.Checked := dts2.DataSet.FieldByName('CLIENTE').AsString = 'S';
  CheckBoxFornec.Checked := dts2.DataSet.FieldByName('FORNEC').AsString = 'S';
end;

function ValidateFornecedorInputs(AOwner: TfrmFornecedor): Boolean;
begin
  Result := False;
  if Trim(AOwner.edtFantasia.Text) = '' then
  begin
    ShowMessage('Nome fantasia obrigatorio');
    Exit;
  end;
  if Trim(AOwner.edtRazao.Text) = '' then
  begin
    ShowMessage('Razao social obrigatoria');
    Exit;
  end;

  Result := True;
end;

procedure TfrmFornecedor.BtnSalvarClick(Sender: TObject);
begin
  if not ValidateFornecedorInputs(Self) then
    Exit;

    FController.business
    .Fornecedor
      .Salvar(
        strTointDef(edtCod_clifor.Text, 0),
        edtRazao.Text,
        edtCodEstado.Text,
        edtFantasia.Text,
        edtCodPais.Text,
        CheckBoxcliente.Checked,
        CheckBoxFornec.Checked);


  Close;
end;

end.
