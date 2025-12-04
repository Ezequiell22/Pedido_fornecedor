unit comercial.model.business.Pedido;

interface

uses
  Data.DB, Vcl.StdCtrls,
  Generics.Collections,
  comercial.model.business.interfaces,
  comercial.model.resource.Interfaces,
  comercial.model.resource.impl.queryFD,
  comercial.model.DAO.interfaces,
  comercial.model.entity.Fornecedor,
  comercial.model.entity.PedidoCompra,
  comercial.model.entity.PedcompraItem,
  comercial.model.DAO.PedidoCompra,
  comercial.model.DAO.PedcompraItem;

type
  TModelBusinessPedido = class(TInterfacedObject, iModelBusinessPedido)
  private
    FQueryLookup : iQuery;
    FQuery: iQuery;
    FQueryItens: iQuery;
    FDAOFornecedor: iModelDAOEntity<TModelEntityFornecedor>;
    FDAOPedido: iModelDAOEntity<TModelEntityPedidoCompra>;
    FDAOItem: iModelDAOEntity<TModelEntityPedcompraItem>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelBusinessPedido;
    function Novo : iModelBusinessPedido;
    function Get: iModelBusinessPedido;
    function Abrir(
    AcomboBoxFornecedor : TComboBox): iModelBusinessPedido;
    function AdicionarItem(aCodItem : integer;
    aValor: Double; aQuantidade: Double; aDescricaoProduto : string): iModelBusinessPedido;
    function RemoverItem(aSequencia: Integer): iModelBusinessPedido;
    function EditarItem(aSequencia: Integer;
     aValor: Double; aQuantidade: Double; aDescricaoProduto : string): iModelBusinessPedido;
    function ExcluirPedido : iModelBusinessPedido;
    function LinkDataSourcePedido(aDataSource: TDataSource): iModelBusinessPedido;
    function LinkDataSourceItens(aDataSource: TDataSource): iModelBusinessPedido;
    function GetItems : iModelBusinessPedido;
    function setIdPedido(aValue : integer) : iModelBusinessPedido;
    function setIdEmpresa(aValue : integer) : iModelBusinessPedido;
    function setIdFornecedor(aValue : integer) : iModelBusinessPedido;
    function loadPedidos(AFieldsWhere: TDictionary<string, Variant>) : iModelBusinessPedido;
  end;

implementation

uses System.SysUtils, comercial.model.DAO.Fornecedor;

constructor TModelBusinessPedido.Create;
begin
  FQueryLookup := TModelResourceQueryFD.New();
  FQuery := TModelResourceQueryFD.New();
  FQueryItens := TModelResourceQueryFD.New();
  FDAOPedido := TModelDAOPedidoCompra.New;
  FDAOItem := TModelDAOPedcompraItem.New;
end;

function TModelBusinessPedido.Abrir(
  AcomboBoxFornecedor : TComboBox): iModelBusinessPedido;
var idFornecedor : integer;
begin
  Result := Self;

  try
    FDAOPedido.GetbyId(FDAOPedido.this.COD_PEDIDOCOMPRA);

    idFornecedor := FDAOPedido.GetDataSet.FieldByName('COD_CLIFOR').AsInteger;

    FDAOFornecedor:= TModelDAOFornecedor.New;
    FDAOFornecedor.GetbyId(idFornecedor);

    AcomboBoxFornecedor.Items.Clear;
    AcomboBoxFornecedor.Items.Add(FDAOFornecedor.GetDataSet
      .FieldByName('FANTASIA').AsString);

    AcomboBoxFornecedor.ItemIndex := 0;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

destructor TModelBusinessPedido.Destroy;
begin
  inherited;
end;

function TModelBusinessPedido.Get: iModelBusinessPedido;
begin
  Result := Self;
  FDAOPedido.Get;
end;

function TModelBusinessPedido.GetItems: iModelBusinessPedido;
var idPedido : integer;
begin
  result := Self;

  if FdaoPEdido.GetDataSet.IsEmpty then
    idPedido := -1
  else
    idPedido := FdaoPEdido.this.COD_PEDIDOCOMPRA;

  FDAOItem
    .GetbyId(idPedido);
end;

function TModelBusinessPedido.LinkDataSourceItens(aDataSource: TDataSource): iModelBusinessPedido;
begin
  Result := Self;
  aDataSource.DataSet := FDAOItem.GetDataSet;
end;

function TModelBusinessPedido.LinkDataSourcePedido(aDataSource: TDataSource): iModelBusinessPedido;
begin
  Result := Self;
  aDataSource.DataSet := FDAOPedido.GetDataSet;
end;

function TModelBusinessPedido.loadPedidos(
  AFieldsWhere: TDictionary<string, Variant>): iModelBusinessPedido;
begin
  result := Self;
  FDAOPedido
    .Get(AFieldsWhere);

end;

class function TModelBusinessPedido.New: iModelBusinessPedido;
begin
  Result := Self.Create;
end;

function TModelBusinessPedido.Novo: iModelBusinessPedido;
var idPedido : integer;
begin
  Result := Self;
  try

    FQueryLookup.active(False)
      .sqlClear
      .sqlAdd('select (coalesce(max(COD_PEDIDOCOMPRA),0)) + 1 idn from PEDIDO_COMPRA')
      .open;

    idPedido := FQueryLookup.DataSet.FieldByName('idn').AsInteger;

    fDAOPedido
      .This
        .COD_PEDIDOCOMPRA(idPedido)
        .DT_EMISSAO(now)
        .DT_PREVISAOENTREGA(now + 1)
        .&end
      .insert;


    FDAOPedido.GetbyId(idPedido);
    FDAOItem.GetbyId(idPedido);

  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TModelBusinessPedido.setIdEmpresa(
  aValue: integer): iModelBusinessPedido;
begin
  result := Self;

  FDAOPedido
    .This
    .COD_EMPRESA(Avalue);

  FDAOItem
    .This
    .COD_EMPRESA(aValue);
end;

function TModelBusinessPedido.setIdFornecedor(
  aValue: integer): iModelBusinessPedido;
begin
  result := Self;

  FDAOPedido
    .This
    .COD_CLIFOR(Avalue);

end;

function TModelBusinessPedido.setIdPedido(
  aValue: integer): iModelBusinessPedido;
begin
  result := Self;

  FDAOPedido
    .This
    .COD_PEDIDOCOMPRA(Avalue);

  FDAOItem
    .This
    .COD_PEDIDOCOMPRA(aValue);
end;

function TModelBusinessPedido.AdicionarItem( aCodItem : integer;
    aValor: Double; aQuantidade: Double; aDescricaoProduto : string): iModelBusinessPedido;
var
  VUnit, VTotalItem, FTotal: Double;
begin
  Result := Self;

  try

    VUnit := aValor;
    if VUnit < 0 then VUnit := 0;
    if aQuantidade <= 0 then aQuantidade := 1;
    VTotalItem := VUnit * aQuantidade;
    FDAOItem
      .This
        .DESCRICAO(aDescricaoProduto)
        .PRECO_UNITARIO(VUnit)
        .COD_ITEM(aCodItem)
        .QTD_PEDIDA(aQuantidade)
        .QTD_RECEBIDA(aQuantidade)
        .VALOR_TOTAL(FTotal)
        .&End
      .Insert;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TModelBusinessPedido.RemoverItem(aSequencia: Integer): iModelBusinessPedido;
begin
  Result := Self;

  if aSequencia <= 0 then
    raise Exception.Create('Id sequencia inválido');

  FDAOItem
    .This
    .SEQUENCIA(aSequencia)
    .&end
    .delete;

end;

function TModelBusinessPedido.EditarItem(aSequencia: Integer;
 aValor: Double; aQuantidade: Double; aDescricaoProduto : string): iModelBusinessPedido;
var
  VUnit, VTotalItem: Double;
begin
  Result := Self;

  if aSequencia <= 0 then
    raise Exception.Create('Id sequencia inválido');

  VUnit := aValor;
  if VUnit < 0 then VUnit := 0;
  if aQuantidade <= 0 then aQuantidade := 1;
  VTotalItem := VUnit * aQuantidade;

  Fdaoitem
    .this
    .SEQUENCIA(aSequencia)
    .DESCRICAO(aDescricaoProduto)
    .PRECO_UNITARIO(VUnit)
    .VALOR_TOTAL(VTotalItem)
    .QTD_PEDIDA(aQuantidade)
    .QTD_RECEBIDA(aQuantidade)
    .&end
  .update;
end;

function TModelBusinessPedido.ExcluirPedido : iModelBusinessPedido;
begin
  Result := Self;

  Fdaoitem
    .Delete;

  FDAOPedido
    .Delete;
end;

end.
