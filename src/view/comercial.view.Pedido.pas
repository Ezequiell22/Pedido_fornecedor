unit comercial.view.Pedido;

interface

uses System.SysUtils,
System.Classes,
Vcl.Forms,
Vcl.StdCtrls,
Vcl.Controls,
vcl.DBGrids,
Vcl.ExtCtrls,
Vcl.Grids,
Data.DB,
System.UITypes,
comercial.controller,
comercial.controller.interfaces,
comercial.util.printhtml;

type
  TfrmPedido = class(TForm)
    GroupBox2: TGroupBox;
    Label4: TLabel;
    edtValor: TEdit;
    edtQuantidade: TEdit;
    btnAddItem: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    edtIdPedido: TEdit;
    Label1: TLabel;

    DSPedido: TDataSource;
    DSItens: TDataSource;
    DSFornecedores: TDataSource;
    btnFinalizar: TButton;
    GridItens: TDBGrid;
    Label8: TLabel;
    ComboBoxFornecedor: TComboBox;
    btnNovo: TButton;
    btnExcluirPedido: TButton;
    btnRemoverItem: TButton;
    btnEditarItem: TButton;
    Edit1: TEdit;
    procedure BtnAddItemClick(Sender: TObject);
    procedure BtnFinalizarClick(Sender: TObject);
    procedure ComboBoxFornecedorSelect(Sender: TObject);

    procedure edtIdPedidoExit(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnExcluirPedidoClick(Sender: TObject);
    procedure btnRemoverItemClick(Sender: TObject);
    procedure btnEditarItemClick(Sender: TObject);
  private
    FController: iController;
    function ValidatePedidoItem: Boolean;
    function ValidatePedidoCab: Boolean;
    procedure LoadComboboxFornecedor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  Vcl.Dialogs;

{$R *.dfm}

constructor TfrmPedido.Create(AOwner: TComponent);
begin
  inherited;
  FController := TController.New;

  FController.business.Pedido
    .LinkDataSourcePedido(DSPedido)
    .LinkDataSourceItens(DSItens);

  LoadComboboxFornecedor;

  gridItens.Options := gridItens.Options - [dgediting];
end;

destructor TfrmPedido.Destroy;
begin
  inherited;
end;

procedure TfrmPedido.edtIdPedidoExit(Sender: TObject);
begin

  FController.business.Pedido.Abrir(strTointDef(edtIdPedido.Text, 0),
    ComboBoxFornecedor)

end;

procedure TfrmPedido.LoadComboboxFornecedor;
begin
  FController.business.Fornecedor.Bind(DSFornecedores).Get;
  ComboBoxFornecedor.Items.Clear;
  if Assigned(DSFornecedores.DataSet) then
  begin
    DSFornecedores.DataSet.First;
    while not DSFornecedores.DataSet.Eof do
    begin
      ComboBoxFornecedor.Items.Add(DSFornecedores.DataSet.FieldByName('FANTASIA')
        .AsString);
      DSFornecedores.DataSet.Next;
    end;
  end;
end;

function TfrmPedido.ValidatePedidoCab: Boolean;
begin
  Result := False;
  if StrToIntDef(edtIdPedido.Text, 0) <= 0 then
  begin
    ShowMessage('ID Pedido invalido');
    Exit;
  end;
  if Trim(ComboBoxFornecedor.Text) = EmptyStr then
  begin
    ShowMessage('ID Fornecedor invalido');
    Exit;
  end;
  Result := True;
end;

function TfrmPedido.ValidatePedidoItem: Boolean;
var
  V, Q: Double;
begin
  Result := False;

  V := StrToFloatDef(edtValor.Text, -1);
  if V < 0 then
  begin
    ShowMessage('Valor deve ser numero maior ou igual a zero');
    Exit;
  end;
  Q := StrToFloatDef(edtQuantidade.Text, -1);
  if Q <= 0 then
  begin
    ShowMessage('Quantidade deve ser maior que zero');
    Exit;
  end;
  Result := True;
end;

procedure TfrmPedido.BtnAddItemClick(Sender: TObject);
begin
  if not ValidatePedidoItem then
    Exit;
  FController.business.Pedido
    .AdicionarItem(
          StrToFloatDef(edtValor.Text, 0),
          StrToFloatDef(edtQuantidade.Text, 0));
end;

procedure TfrmPedido.BtnFinalizarClick(Sender: TObject);
begin
  if not ValidatePedidoCab then
    Exit;
  FController.business.Pedido.Finalizar;

  if MessageDlg('Deseja imprimir o pedido?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin

    TPrintHtmlPedido.GerarHtmlPedido(StrToIntDef(edtIdPedido.Text, 0),
                                        GetCurrentDir());
    showMessage('Perido salvo em '+GetCurrentDir());
  end
end;

procedure TfrmPedido.btnNovoClick(Sender: TObject);
begin
   FController.business
    .Pedido.novo;
end;

procedure TfrmPedido.btnExcluirPedidoClick(Sender: TObject);
begin
  FController.business.Pedido.ExcluirPedido;
  DSPedido.DataSet := FController.business.Pedido.DAOPedido.GetDataSet;
  DSItens.DataSet := FController.business.Pedido.DAOItens.GetDataSet;
end;

procedure TfrmPedido.btnRemoverItemClick(Sender: TObject);
var
  seq: Integer;
begin
  if Assigned(DSItens.DataSet) and not DSItens.DataSet.IsEmpty then
  begin
    seq := DSItens.DataSet.FieldByName('SEQUENCIA').AsInteger;
    FController.business.Pedido.RemoverItem(seq);
    DSItens.DataSet := FController.business.Pedido.DAOItens.GetDataSet;
  end;
end;

procedure TfrmPedido.btnEditarItemClick(Sender: TObject);
var
  seq: Integer;
  v, q: Double;
begin
  if Assigned(DSItens.DataSet) and not DSItens.DataSet.IsEmpty then
  begin
    seq := DSItens.DataSet.FieldByName('SEQUENCIA').AsInteger;
    v := StrToFloatDef(edtValor.Text, 0);
    q := StrToFloatDef(edtQuantidade.Text, 1);
    FController.business.Pedido.EditarItem(seq, v, q);
    DSItens.DataSet := FController.business.Pedido.DAOItens.GetDataSet;
  end;
end;

procedure TfrmPedido.ComboBoxFornecedorSelect(Sender: TObject);
begin
  if Assigned(DSFornecedores.DataSet) then
  begin
    FController.business.Pedido.
      setIdFornecedor(
        DSFornecedores.DataSet.FieldByName('COD_CLIFOR').AsInteger);
  end;
end;

end.
