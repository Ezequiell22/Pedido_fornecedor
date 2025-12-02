unit comercial.model.business.Pedido;

interface

uses
  Data.DB, Vcl.StdCtrls,
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
    FQuery: iQuery;
    FQueryItens: iQuery;
    FQueryLookup : iQuery;
    FIdPedido: Integer;
    FIdFornecedor: Integer;
    FTotal: Double;
    FIdProduto : integer;
    FDAOFornecedor: iModelDAOEntity<TModelEntityFornecedor>;
    FDAOPedido: iModelDAOEntity<TModelEntityPedidoCompra>;
    FDAOItem: iModelDAOEntity<TModelEntityPedcompraItem>;
    // Header defaults
    FCOD_USUARIO: Integer;
    FCOD_EMPRESA: Integer;
    FCOD_FILIAL: Integer;
    FCOD_DEPARTAMENTO: Integer;
    FCOD_CENTRO_CUSTO: Integer;
    FDT_EMISSAO: TDateTime;
    FCOD_CONDPAGTO: Integer;
    FORDEM_COMPRA: string;
    FVALOR_IMPOSTOS: Double;
    FCOD_COMPRADOR: Integer;
    FPESO_CAB: Double;
    FVOLUME_CAB: Double;
    FCOD_TIPOFRETE: Integer;
    FDATA_PREVISTA_ENTREGA: TDateTime;
    FDT_ENTREGA: TDateTime;
    FTIPO_COMPRA: string;
    // Item defaults
    FIT_COD_EMPRESA: Integer;
    FIT_COD_FILIAL: Integer;
    FIT_COD_DEPARTAMENTO: Integer;
    FIT_COD_CENTRO_CUSTO: Integer;
    FIT_DESCONTO: Double;
    FIT_ACRESCIMO: Double;
    FIT_IPI: Double;
    FIT_VALOR_IPI: Double;
    FIT_PESO: Double;
    FIT_VOLUME: Double;
    FIT_DT_INCLUSAO: TDateTime;
    FIT_DT_SOLICITADA: TDateTime;
    FIT_DT_RECEBIDA: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelBusinessPedido;
    function Novo : iModelBusinessPedido;
    function Get: iModelBusinessPedido;
    function Abrir(aIdPedido: Integer;
    AcomboBoxFornecedor : TComboBox): iModelBusinessPedido;
    function AdicionarItem(aValor: Double; aQuantidade: Double): iModelBusinessPedido;
    function RemoverItem(aSequencia: Integer): iModelBusinessPedido;
    function EditarItem(aSequencia: Integer; aValor: Double; aQuantidade: Double): iModelBusinessPedido;
    function Finalizar: iModelBusinessPedido;
    function ExcluirPedido: iModelBusinessPedido;
    function LinkDataSourcePedido(aDataSource: TDataSource): iModelBusinessPedido;
    function LinkDataSourceItens(aDataSource: TDataSource): iModelBusinessPedido;
    function setIdproduto(aValue : integer) : iModelBusinessPedido;
    function setIdFornecedor(aValue : integer) : iModelBusinessPedido;
    function DAOPedido: iModelDAOEntity<TModelEntityPedidoCompra>;
    function DAOItens: iModelDAOEntity<TModelEntityPedcompraItem>;
  end;

implementation

uses System.SysUtils, comercial.model.DAO.Fornecedor;

constructor TModelBusinessPedido.Create;
begin
  FQueryLookup := TModelResourceQueryFD.New();
  FDAOPedido := TModelDAOPedidoCompra.New;
  FDAOItem := TModelDAOPedcompraItem.New;
  // sensible defaults
  FCOD_USUARIO := 0;
  FCOD_EMPRESA := 0;
  FCOD_FILIAL := 0;
  FCOD_DEPARTAMENTO := 0;
  FCOD_CENTRO_CUSTO := 0;
  FDT_EMISSAO := Now;
  FCOD_CONDPAGTO := 0;
  FORDEM_COMPRA := '';
  FVALOR_IMPOSTOS := 0;
  FCOD_COMPRADOR := 0;
  FPESO_CAB := 0;
  FVOLUME_CAB := 0;
  FCOD_TIPOFRETE := 0;
  FDATA_PREVISTA_ENTREGA := Now;
  FDT_ENTREGA := 0;
  FTIPO_COMPRA := '';
  FIT_COD_EMPRESA := 0;
  FIT_COD_FILIAL := 0;
  FIT_COD_DEPARTAMENTO := 0;
  FIT_COD_CENTRO_CUSTO := 0;
  FIT_DESCONTO := 0;
  FIT_ACRESCIMO := 0;
  FIT_IPI := 0;
  FIT_VALOR_IPI := 0;
  FIT_PESO := 0;
  FIT_VOLUME := 0;
  FIT_DT_INCLUSAO := Now;
  FIT_DT_SOLICITADA := Now;
  FIT_DT_RECEBIDA := 0;
end;

function TModelBusinessPedido.Abrir(aIdPedido: Integer;
  AcomboBoxFornecedor : TComboBox): iModelBusinessPedido;
begin
  Result := Self;
  FIdPedido := aIdPedido;
  try
    FDAOPedido.GetbyId(FIdPedido);
    FDAOItem.GetbyId(FIdPedido);

    FIdFornecedor := FDAOPedido.GetDataSet.FieldByName('COD_CLIFOR').AsInteger;

    FDAOFornecedor:= TModelDAOFornecedor.New;
    FDAOFornecedor.GetbyId(FIdFornecedor);

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

function TModelBusinessPedido.Finalizar: iModelBusinessPedido;
begin
  Result := Self;
  try
    FQueryLookup.active(False)
      .sqlClear
      .sqlAdd('select SUM(VL_TOTAL) vl from PEDCOMPRA_ITEM')
      .sqlAdd('where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA')
      .addParam('COD_PEDIDOCOMPRA', FIdPedido)
      .open;

    FTotal := FQueryLookup.DataSet.FieldByName('vl').AsFloat;

    FQueryLookup.active(False)
      .sqlClear
      .sqlAdd('update PEDIDO_COMPRA set TOTAL = :TOTAL where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA')
      .addParam('TOTAL', FTotal)
      .addParam('COD_PEDIDOCOMPRA', FIdPedido)
      .execSql;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TModelBusinessPedido.Get: iModelBusinessPedido;
begin
  Result := Self;
  FDAOPedido.Get;
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

class function TModelBusinessPedido.New: iModelBusinessPedido;
begin
  Result := Self.Create;
end;

function TModelBusinessPedido.Novo: iModelBusinessPedido;
begin
  Result := Self;
  if (FIdFornecedor <= 0)then
      raise Exception.Create('Selecione um fornecedor');

  FTotal := 0;
  try
    FDAOPedido
      .This
        .COD_CLIFOR(FIdFornecedor)
        .COD_USUARIO(FCOD_USUARIO)
        .TOTAL(FTotal)
        .COD_EMPRESA(FCOD_EMPRESA)
        .COD_FILIAL(FCOD_FILIAL)
        .COD_DEPARTAMENTO(FCOD_DEPARTAMENTO)
        .COD_CENTRO_CUSTO(FCOD_CENTRO_CUSTO)
        .DT_EMISSAO(FDT_EMISSAO)
        .COD_CONDPAGTO(FCOD_CONDPAGTO)
        .ORDEM_COMPRA(FORDEM_COMPRA)
        .VALOR_IMPOSTOS(FVALOR_IMPOSTOS)
        .COD_COMPRADOR(FCOD_COMPRADOR)
        .PESO(FPESO_CAB)
        .VOLUME(FVOLUME_CAB)
        .COD_TIPOFRETE(FCOD_TIPOFRETE)
        .DATA_PREVISTA_ENTREGA(FDATA_PREVISTA_ENTREGA)
        .DT_ENTREGA(FDT_ENTREGA)
        .TIPO_COMPRA(FTIPO_COMPRA)
        .&End
      .Insert;

    FQueryLookup.active(False)
      .sqlClear
      .sqlAdd('select (coalesce(max(COD_PEDIDOCOMPRA),0)) idn from PEDIDO_COMPRA')
      .open;

    FIdPedido := FQueryLookup.DataSet.FieldByName('idn').AsInteger;

    FDAOPedido.GetbyId(FIdPedido);

    FDAOItem.GetbyId(FIdPedido);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TModelBusinessPedido.setIdFornecedor(
  aValue: integer): iModelBusinessPedido;
begin
  result := Self;
  FIdFornecedor := aValue
end;

function TModelBusinessPedido.setIdproduto(
  aValue: integer): iModelBusinessPedido;
begin
 result := Self;
 FIdProduto := aValue;
end;

function TModelBusinessPedido.AdicionarItem(
    aValor: Double; aQuantidade: Double): iModelBusinessPedido;
var
  VUnit: Double;
  VTotalItem: Double;
begin
  Result := Self;
  try
    VUnit := aValor;
    if VUnit <= 0 then
    begin
      FQueryLookup.active(False)
        .sqlClear
        .sqlAdd('select PRECO from PRODUTO where IDPRODUTO = :IDPRODUTO')
        .addParam('IDPRODUTO', FIdProduto)
        .Open;
      if not FQueryLookup.DataSet.IsEmpty then
        VUnit := FQueryLookup.DataSet.FieldByName('PRECO').AsFloat;
    end;

    VTotalItem := VUnit * aQuantidade;
    FTotal := FTotal + VTotalItem;
    FDAOItem
      .This
        .COD_PEDIDOCOMPRA(FIdPedido)
        .COD_PRODUTO(FIdProduto)
        .QUANTIDADE(aQuantidade)
        .VL_UNITARIO(VUnit)
        .VL_TOTAL(VTotalItem)
        .COD_EMPRESA(FIT_COD_EMPRESA)
        .COD_FILIAL(FIT_COD_FILIAL)
        .COD_DEPARTAMENTO(FIT_COD_DEPARTAMENTO)
        .COD_CENTRO_CUSTO(FIT_COD_CENTRO_CUSTO)
        .DESCONTO(FIT_DESCONTO)
        .ACRESCIMO(FIT_ACRESCIMO)
        .IPI(FIT_IPI)
        .VALOR_IPI(FIT_VALOR_IPI)
        .PESO(FIT_PESO)
        .VOLUME(FIT_VOLUME)
        .DT_INCLUSAO(FIT_DT_INCLUSAO)
        .DT_SOLICITADA(FIT_DT_SOLICITADA)
        .DT_RECEBIDA(FIT_DT_RECEBIDA)
        .&End
      .Insert;

    FDAOItem.GetbyId(FIdPedido);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TModelBusinessPedido.RemoverItem(aSequencia: Integer): iModelBusinessPedido;
begin
  Result := Self;
  FQueryItens.active(False)
    .sqlClear
    .sqlAdd('delete from PEDCOMPRA_ITEM where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA and SEQUENCIA = :SEQUENCIA')
    .addParam('COD_PEDIDOCOMPRA', FIdPedido)
    .addParam('SEQUENCIA', aSequencia)
    .execSql;

  FQueryItens.active(False)
    .sqlClear
    .sqlAdd('select * from PEDCOMPRA_ITEM where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA order by SEQUENCIA')
    .addParam('COD_PEDIDOCOMPRA', FIdPedido)
    .Open;
end;

function TModelBusinessPedido.EditarItem(aSequencia: Integer; aValor: Double; aQuantidade: Double): iModelBusinessPedido;
var
  VUnit, VTotalItem: Double;
begin
  Result := Self;
  VUnit := aValor;
  if VUnit < 0 then VUnit := 0;
  if aQuantidade <= 0 then aQuantidade := 1;
  VTotalItem := VUnit * aQuantidade;

  FQueryItens.active(False)
    .sqlClear
    .sqlAdd('update PEDCOMPRA_ITEM set QUANTIDADE = :QUANTIDADE, VL_UNITARIO = :VL_UNITARIO, VL_TOTAL = :VL_TOTAL')
    .sqlAdd(' where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA and SEQUENCIA = :SEQUENCIA')
    .addParam('COD_PEDIDOCOMPRA', FIdPedido)
    .addParam('SEQUENCIA', aSequencia)
    .addParam('QUANTIDADE', aQuantidade)
    .addParam('VL_UNITARIO', VUnit)
    .addParam('VL_TOTAL', VTotalItem)
    .execSql;

  FQueryItens.active(False)
    .sqlClear
    .sqlAdd('select * from PEDCOMPRA_ITEM where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA order by SEQUENCIA')
    .addParam('COD_PEDIDOCOMPRA', FIdPedido)
    .Open;
end;

function TModelBusinessPedido.ExcluirPedido: iModelBusinessPedido;
begin
  Result := Self;
  FQueryItens.active(False)
    .sqlClear
    .sqlAdd('delete from PEDCOMPRA_ITEM where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA')
    .addParam('COD_PEDIDOCOMPRA', FIdPedido)
    .execSql;

  FQuery.active(False)
    .sqlClear
    .sqlAdd('delete from PEDIDO_COMPRA where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA')
    .addParam('COD_PEDIDOCOMPRA', FIdPedido)
    .execSql;
end;

function TModelBusinessPedido.DAOPedido: iModelDAOEntity<TModelEntityPedidoCompra>;
begin
  Result := FDAOPedido;
end;

function TModelBusinessPedido.DAOItens: iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Result := FDAOItem;
end;

end.
