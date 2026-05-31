unit comercial.view.Pedido;

interface

uses System.SysUtils,
System.Classes,
System.Generics.Collections,
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
    edtPrecoUnitario: TEdit;
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
    GridItens: TDBGrid;
    Label8: TLabel;
    ComboBoxFornecedor: TComboBox;
    btnCriarPedido: TButton;
    edtCodItem: TEdit;
    btnEditarItem: TButton;
    btnRemoverItem: TButton;
    EdtDescricao: TEdit;
    Label2: TLabel;
    procedure BtnAddItemClick(Sender: TObject);
    procedure ComboBoxFornecedorSelect(Sender: TObject);

    procedure edtIdPedidoExit(Sender: TObject);
    procedure btnCriarPedidoClick(Sender: TObject);
    procedure btnRemoverItemClick(Sender: TObject);
    procedure btnEditarItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DSItensDataChange(Sender: TField);
  private
    FController: iController;
    function ValidatePedidoItem: Boolean;
    function ValidatePedidoCab: Boolean;
    procedure LoadComboboxFornecedor;
    FFornecedorIds: TList<Integer>;
  public
    FIDEMPRESA : INTEGER;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  Vcl.Dialogs,
  Language.Bootstrap;

{$R *.dfm}

constructor TfrmPedido.Create(AOwner: TComponent);
begin
  inherited;
  FController := TController.New;
  FFornecedorIds := TList<Integer>.Create;

  FController.business
    .Pedido
    .LinkDataSourcePedido(DSPedido)
    .LinkDataSourceItens(DSItens);

  LoadComboboxFornecedor;

  gridItens.Options := gridItens.Options - [dgediting];
end;

destructor TfrmPedido.Destroy;
begin
  FFornecedorIds.Free;
  inherited;
end;

procedure TfrmPedido.DSItensDataChange(Sender: TObject; Field: TField);
begin
  edtCodItem.Text := dsItens.DataSet.FieldByName('cod_item').AsString;
  edtPrecoUnitario.Text := dsItens.DataSet.FieldByName('preco_unitario').AsString;
  edtQuantidade.Text := dsItens.DataSet.FieldByName('qtd_pedida').AsString;
  EdtDescricao.Text := dsItens.DataSet.FieldByName('descricao').AsString;

end;

procedure TfrmPedido.edtIdPedidoExit(Sender: TObject);
begin

  if strTointDef(edtIdPedido.Text, 0) > 0 then
    FController
      .business
      .Pedido
      .setIdPedido(strTointDef(edtIdPedido.Text, 0))
      .Abrir(ComboBoxFornecedor)
      .GetItems;

end;

procedure TfrmPedido.FormShow(Sender: TObject);
begin
     FController.business
    .Pedido
    .setIdEmpresa(FIDEMPRESA);

    edtIdPedidoExit(nil);
end;

procedure TfrmPedido.LoadComboboxFornecedor;
begin
  FController.business.Fornecedor.Bind(DSFornecedores).Get;
  ComboBoxFornecedor.Items.Clear;
  FFornecedorIds.Clear;
  if Assigned(DSFornecedores.DataSet) then
  begin
    DSFornecedores.DataSet.First;
    while not DSFornecedores.DataSet.Eof do
    begin
      ComboBoxFornecedor.Items.Add(DSFornecedores.DataSet.FieldByName('FANTASIA')
        .AsString);
      FFornecedorIds.Add(DSFornecedores.DataSet.FieldByName('COD_CLIFOR').AsInteger);
      DSFornecedores.DataSet.Next;
    end;
  end;
end;

function TfrmPedido.ValidatePedidoCab: Boolean;
begin
  Result := False;
  if StrToIntDef(edtIdPedido.Text, 0) <= 0 then
  begin
    ShowMessage(Translator.Msg('MSG_PEDIDO_ID_INVALIDO'));
    Exit;
  end;
  if Trim(ComboBoxFornecedor.Text) = EmptyStr then
  begin
    ShowMessage(Translator.Msg('MSG_FORNECEDOR_ID_INVALIDO'));
    Exit;
  end;
  Result := True;
end;

function TfrmPedido.ValidatePedidoItem: Boolean;
var
  V, Q: Double;
begin
  Result := False;

  V := StrToFloatDef(edtPrecoUnitario.Text, -1);
  if V < 0 then
  begin
    ShowMessage(Translator.Msg('MSG_VALOR_INVALIDO'));
    Exit;
  end;
  Q := StrToFloatDef(edtQuantidade.Text, -1);
  if Q <= 0 then
  begin
    ShowMessage(Translator.Msg('MSG_QUANTIDADE_INVALIDA'));
    Exit;
  end;
  Result := True;
end;

procedure TfrmPedido.BtnAddItemClick(Sender: TObject);
begin
  if not ValidatePedidoItem then
    Exit;

  if DSPedido.DataSet.IsEmpty then
    raise Exception.Create('Antes de adicionar um item � necesss�rio criar o pedido');

  FController.business
    .Pedido
    .setIdPedido(DSPedido.DataSet.FieldByName('COD_PEDIDOCOMPRA').AsInteger)
    .setIdEmpresa(DSPedido.DataSet.FieldByName('COD_EMPRESA').AsInteger)
    .AdicionarItem(
                  strTointDef(edtCodItem.Text, 0),
                  StrToFloatDef(edtPrecoUnitario.Text, 0),
                  StrToFloatDef(edtQuantidade.Text, 0),
                  edtDescricao.text)
    .GetItems;
end;

procedure TfrmPedido.btnCriarPedidoClick(Sender: TObject);
begin
   FController
    .business
    .Pedido
    .novo;

    edtIdPedido.Text := DSPedido.DataSet.FieldByName('COD_PEDIDOCOMPRA').AsString;
    edtIdPedidoExit(nil);
end;

procedure TfrmPedido.btnRemoverItemClick(Sender: TObject);
var
  seq: Integer;
begin
  if Assigned(DSItens.DataSet) and not DSItens.DataSet.IsEmpty then
  begin
    seq := DSItens.DataSet.FieldByName('SEQUENCIA').AsInteger;
    FController.business.Pedido
    .setIdPedido(DSPedido.DataSet.FieldByName('COD_PEDIDOCOMPRA').AsInteger)
    .setIdEmpresa(DSPedido.DataSet.FieldByName('COD_EMPRESA').AsInteger)
    .RemoverItem(seq)
    .GetItems;
  end;
end;

procedure TfrmPedido.btnEditarItemClick(Sender: TObject);
var
  seq: Integer;
  valor, quantidade : Double;
begin
  if Assigned(DSItens.DataSet) and not DSItens.DataSet.IsEmpty then
  begin
    seq := DSItens.DataSet.FieldByName('SEQUENCIA').AsInteger;
    valor := StrToFloatDef(edtPrecoUnitario.Text, 0);
    quantidade := StrToFloatDef(edtQuantidade.Text, 1);
    FController.business
    .Pedido
    .setIdPedido(DSPedido.DataSet.FieldByName('COD_PEDIDOCOMPRA').AsInteger)
    .setIdEmpresa(DSPedido.DataSet.FieldByName('COD_EMPRESA').AsInteger)
    .EditarItem(seq, valor, quantidade, edtDescricao.text)
    .GetItems;
  end;
end;

procedure TfrmPedido.ComboBoxFornecedorSelect(Sender: TObject);
begin
  if (ComboBoxFornecedor.ItemIndex >= 0)
    and (ComboBoxFornecedor.ItemIndex < FFornecedorIds.Count) then
  begin
    FController
      .business
      .Pedido
      .setIdFornecedor(FFornecedorIds[ComboBoxFornecedor.ItemIndex]);
  end;
end;

end.
