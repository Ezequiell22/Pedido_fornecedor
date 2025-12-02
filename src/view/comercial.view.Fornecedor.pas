{ copied from comercial.view.Cliente.pas }
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
    Label6: TLabel;
    edtId: TEdit;
    edtFantasia: TEdit;
    edtRazao: TEdit;
    edtCnpj: TEdit;
    edtEndereco: TEdit;
    edtTelefone: TEdit;
    dts2: TDataSource;
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
  FController.business.Fornecedor.GetById(strTointdef(edtId.Text, 0));
  LoadData;
  edtFantasia.SetFocus;
end;

procedure TfrmFornecedor.LoadData;
begin
  if not dts2.DataSet.Active then
    Exit;
  edtId.Text := dts2.DataSet.FieldByName('IDFORNECEDOR').AsString;
  edtFantasia.Text := dts2.DataSet.FieldByName('NM_FANTASIA').AsString;
  edtRazao.Text := dts2.DataSet.FieldByName('RAZAO_SOCIAL').AsString;
  edtCnpj.Text := dts2.DataSet.FieldByName('CNPJ').AsString;
  edtEndereco.Text := dts2.DataSet.FieldByName('ENDERECO').AsString;
  edtTelefone.Text := dts2.DataSet.FieldByName('TELEFONE').AsString;
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
  if Trim(AOwner.edtTelefone.Text) = '' then
  begin
    ShowMessage('Telefone obrigatorio');
    Exit;
  end;
  Result := True;
end;

procedure TfrmFornecedor.BtnSalvarClick(Sender: TObject);
begin
  if not ValidateFornecedorInputs(Self) then
    Exit;

  if Trim(edtId.Text) = EmptyStr then
  begin
    FController.business.Fornecedor.Salvar( edtFantasia.Text, edtRazao.Text,
      edtCnpj.Text, edtEndereco.Text, edtTelefone.Text);
  end
  else
    FController.business.Fornecedor.Editar(dts2.DataSet.FieldByName('IDFORNECEDOR')
      .AsInteger, edtFantasia.Text, edtRazao.Text, edtCnpj.Text,
      edtEndereco.Text, edtTelefone.Text);

  Close;
end;

end.
