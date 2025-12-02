unit comercial.view.Produto;

interface

uses System.SysUtils, System.Classes, Vcl.Forms, Vcl.StdCtrls, Vcl.DBGrids,
  Data.DB,
  comercial.controller,
  comercial.controller.interfaces, Vcl.Controls, Vcl.Grids;

type
  TfrmProduto = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    FDS: TDataSource;
    procedure FormShow(Sender: TObject);
  published
    FController: iController;
    edtId: TEdit;
    edtDescricao: TEdit;
    edtMarca: TEdit;
    edtPreco: TEdit;
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

constructor TfrmProduto.Create(AOwner: TComponent);
begin
  inherited;
  FController := TController.New;
  FController.business.Produto.Bind(FDS);
end;

destructor TfrmProduto.Destroy;
begin
  inherited;
end;

procedure TfrmProduto.FormShow(Sender: TObject);
begin
  FController.business.Produto.GetById(strTointdef(edtId.Text, 0));
  LoadData;
  edtDescricao.SetFocus;
end;

procedure TfrmProduto.LoadData;
begin
  if not FDS.DataSet.Active then
    exit;

  edtId.Text := FDS.DataSet.FieldByName('IDProduto').AsString;
  edtDescricao.Text := FDS.DataSet.FieldByName('DESCRICAO').AsString;
  edtMarca.Text := FDS.DataSet.FieldByName('MARCA').AsString;
  edtPreco.Text := FDS.DataSet.FieldByName('PRECO').AsString;

end;

function ValidateProdutoInputs(AOwner: TfrmProduto): Boolean;
var
  P: Double;
begin
  Result := False;
  if Trim(AOwner.edtDescricao.Text) = '' then
  begin
    ShowMessage('Descricao obrigatoria');
    exit;
  end;
  P := StrToFloatDef(AOwner.edtPreco.Text, -1);
  if P < 0 then
  begin
    ShowMessage('Preco deve ser numero maior ou igual a zero');
    exit;
  end;
  Result := True;
end;

procedure TfrmProduto.BtnSalvarClick(Sender: TObject);
begin
  if not ValidateProdutoInputs(Self) then
    exit;

  if Trim(edtId.Text) = EmptyStr then
  begin
    FController.business.Produto.Salvar(edtDescricao.Text, edtMarca.Text,
      StrToFloatDef(edtPreco.Text, 0));

  end
  else
    FController.business.Produto.Editar(FDS.DataSet.FieldByName('IDPRODUTO')
      .AsInteger, edtDescricao.Text, edtMarca.Text,
      StrToFloatDef(edtPreco.Text, 0));
  Self.close;
end;

end.
