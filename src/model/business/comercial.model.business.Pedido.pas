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
    function buildStrComboBox(id : integer; description : string) : string;
    function getIndexByCode(aCombo : TComboBox; Acode :integer ) : integer;
    function getCodeSelectedCombo(aValue : string ) : integer;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelBusinessPedido;
    function Novo : iModelBusinessPedido;
    function Get: iModelBusinessPedido;

    function AdicionarItem(aCodItem : integer;
    aValor: Double; aQuantidade: Double; aDescricaoProduto : string): iModelBusinessPedido;
    function RemoverItem(aSequencia: Integer): iModelBusinessPedido;
    function EditarItem(aCodItem, aSequencia: Integer;
     aValor: Double; aQuantidade: Double; aDescricaoProduto : string): iModelBusinessPedido;
    function ExcluirPedido : iModelBusinessPedido;
    function LinkDataSourcePedido(aDataSource: TDataSource): iModelBusinessPedido;
    function LinkDataSourceItens(aDataSource: TDataSource): iModelBusinessPedido;
    function GetItems : iModelBusinessPedido;
    function setIdPedido(aValue : integer) : iModelBusinessPedido;
    function setIdEmpresa(aValue : integer) : iModelBusinessPedido;
    function setIdFornecedor(aValue : integer) : iModelBusinessPedido;
     function loadPedidos(AFieldsWhere: TDictionary<string, Variant>) : iModelBusinessPedido;
    function Abrir(
    AcomboBoxFornecedor : TComboBox): iModelBusinessPedido;
    procedure LoadComboboxFornecedor(
         aComboBox : TComboBox  );
    function getSelectedCodCombo(aCombo : TComboBox ) : integer;
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

procedure TModelBusinessPedido.LoadComboboxFornecedor(
  aComboBox : TComboBox
);
begin
  FDAOFornecedor := TModelDAOFornecedor.New;
  FDAOFornecedor.Get;
  aComboBox.Items.Clear;

  if not(FDAOFornecedor.GetDataSet.IsEmpty) then
  begin
    FDAOFornecedor.GetDataSet.First;
    while not FDAOFornecedor.GetDataSet.Eof do
    begin
      var str :=
        buildStrComboBox(
            FDAOFornecedor.GetDataSet.FieldByName('COD_CLIFOR')
                  .asInteger,
                FDAOFornecedor.GetDataSet.FieldByName('FANTASIA')
              .AsString );

      aComboBox.Items.Add(str);

      FDAOFornecedor.GetDataSet.Next;
    end;
  end;
end;

function TModelBusinessPedido.Abrir(
  AcomboBoxFornecedor : TComboBox): iModelBusinessPedido;
var idFornecedor : integer;
begin
  Result := Self;

  try
    FDAOPedido.GetbyId(FDAOPedido.this.COD_PEDIDOCOMPRA);

    setIdFornecedor(
        FDAOPedido.GetDataSet.FieldByName('COD_CLIFOR').AsInteger);

    AcomboBoxFornecedor.ItemIndex := getIndexByCode(
        AcomboBoxFornecedor,FDAOPedido.GetDataSet.FieldByName('COD_CLIFOR').AsInteger );

    AcomboBoxFornecedor.Enabled := false;
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

function TModelBusinessPedido.getSelectedCodCombo(aCombo: TComboBox): integer;
begin
   result := getCodeSelectedCombo(aCombo.Text)
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
  VUnit, VTotalItem: Double;
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
        .VALOR_TOTAL(VTotalItem)
        .VALOR_DESCTO(0)
        .VALOR_FINANC(0)
        .COD_unidadecompra('UN')
        .DT_INCLUSAO(now)
        .DT_SOLICITADA(now)
        .DT_RECEBIDA(now)
        .&End
      .Insert;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TModelBusinessPedido.buildStrComboBox(id: integer;
  description: string): string;
  var separetor : string;
begin
  separetor := ' - ';

  result := id.ToString + separetor + description;

end;

function TModelBusinessPedido.getCodeSelectedCombo(aValue : string): integer;
begin

  try
    result := strTointdef(avalue.Split(['-'])[0].Trim, 0)
  except
    result := 0;
  end;

end;

function TModelBusinessPedido.getIndexByCode(aCombo : TComboBox; Acode :integer): integer;
 var i , code : integer;
begin
  result := -1;

  for I := 0 to aCombo.Items.Count - 1 do
  begin
    try
       code := getCodeSelectedCombo(aCombo.Items[i]);

       if code = aCode then
       begin
          result := i;
          break;
       end;
    except
      code := 0;
    end;

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

function TModelBusinessPedido.EditarItem(aCodItem, aSequencia: Integer;
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
    .COD_Item(aCodItem)
    .SEQUENCIA(aSequencia)
    .DESCRICAO(aDescricaoProduto)
    .PRECO_UNITARIO(VUnit)
    .VALOR_TOTAL(VTotalItem)
    .QTD_PEDIDA(aQuantidade)
    .QTD_RECEBIDA(aQuantidade)
    .VALOR_DESCTO(0)
    .VALOR_FINANC(0)
    .COD_unidadecompra('UN')
    .DT_INCLUSAO(now)
    .DT_SOLICITADA(now)
    .DT_RECEBIDA(now)
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
