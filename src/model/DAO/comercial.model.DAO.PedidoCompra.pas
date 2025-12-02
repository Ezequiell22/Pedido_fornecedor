unit comercial.model.DAO.PedidoCompra;

interface

uses
  System.Generics.Collections,
  System.Variants,
  Data.DB,
  comercial.model.DAO.interfaces,
  comercial.model.entity.PedidoCompra,
  comercial.model.resource.interfaces;

type
  TModelDAOPedidoCompra = class(TInterfacedObject, iModelDAOEntity<TModelEntityPedidoCompra>)
  private
    FQuery: iQuery;
    FDataSource: TDataSource;
    FEntity: TModelEntityPedidoCompra;
    procedure AfterScroll(DataSet: TDataSet);
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelDAOEntity<TModelEntityPedidoCompra>;
    function Delete: iModelDAOEntity<TModelEntityPedidoCompra>;
    function DataSet(AValue: TDataSource): iModelDAOEntity<TModelEntityPedidoCompra>;
    function Get: iModelDAOEntity<TModelEntityPedidoCompra>; overload;
    function Insert: iModelDAOEntity<TModelEntityPedidoCompra>;
    function This: TModelEntityPedidoCompra;
    function Update: iModelDAOEntity<TModelEntityPedidoCompra>;
    function GetbyId(AValue: integer): iModelDAOEntity<TModelEntityPedidoCompra>;
    function GetDataSet: TDataSet;
    function Get(AFieldsWhere: TDictionary<string, Variant>): iModelDAOEntity<TModelEntityPedidoCompra>; overload;
  end;

implementation

uses comercial.model.resource.impl.queryFD;

procedure TModelDAOPedidoCompra.AfterScroll(DataSet: TDataSet);
begin
end;

constructor TModelDAOPedidoCompra.Create;
begin
  FQuery := TModelResourceQueryFD.New;
  FDataSource := TDataSource.Create(nil);
  FDataSource.DataSet := FQuery.DataSet;
  FEntity := TModelEntityPedidoCompra.Create(Self);
end;

destructor TModelDAOPedidoCompra.Destroy;
begin
  FDataSource.Free;
  inherited;
end;

function TModelDAOPedidoCompra.DataSet(AValue: TDataSource): iModelDAOEntity<TModelEntityPedidoCompra>;
begin
  Result := Self;
  FDataSource := AValue;
  FDataSource.DataSet := FQuery.DataSet;
  FQuery.DataSet.AfterScroll := AfterScroll;
end;

function TModelDAOPedidoCompra.Delete: iModelDAOEntity<TModelEntityPedidoCompra>;
begin
  Result := Self;
  FQuery
    .active(False)
    .sqlClear
      .sqlAdd('delete from PEDIDO_COMPRA where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA')
      .addParam('COD_PEDIDOCOMPRA', FEntity.COD_PEDIDOCOMPRA)
      .execSql;
end;

function TModelDAOPedidoCompra.Get: iModelDAOEntity<TModelEntityPedidoCompra>;
begin
  Result := Self;
  FQuery
    .active(False)
    .sqlClear
      .sqlAdd('select * from PEDIDO_COMPRA')
      .open;
  FDataSource.DataSet := FQuery.DataSet;
end;

function TModelDAOPedidoCompra.Get(AFieldsWhere: TDictionary<string, Variant>): iModelDAOEntity<TModelEntityPedidoCompra>;
begin
  Result := Get;
end;

function TModelDAOPedidoCompra.GetbyId(AValue: integer): iModelDAOEntity<TModelEntityPedidoCompra>;
begin
  Result := Self;
  FQuery
    .active(False)
    .sqlClear
      .sqlAdd('select * from PEDIDO_COMPRA where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA')
      .addParam('COD_PEDIDOCOMPRA', AValue)
      .open;
  FDataSource.DataSet := FQuery.DataSet;
end;

function TModelDAOPedidoCompra.GetDataSet: TDataSet;
begin
  Result := FQuery.DataSet;
end;

function TModelDAOPedidoCompra.Insert: iModelDAOEntity<TModelEntityPedidoCompra>;
begin
  Result := Self;
  FQuery
    .active(False)
    .sqlClear
      .sqlAdd('insert into PEDIDO_COMPRA (' +
              'COD_PEDIDOCOMPRA, COD_CLIFOR, COD_USUARIO, TOTAL, COD_EMPRESA, COD_FILIAL, COD_DEPARTAMENTO, COD_CENTRO_CUSTO, ' +
              'DT_EMISSAO, COD_CONDPAGTO, ORDEM_COMPRA, VALOR_IMPOSTOS, COD_COMPRADOR, PESO, VOLUME, COD_TIPOFRETE, ' +
              'DATA_PREVISTA_ENTREGA, DT_ENTREGA, TIPO_COMPRA)')
      .sqlAdd('values ((select coalesce(max(COD_PEDIDOCOMPRA),0)+1 from PEDIDO_COMPRA), ' +
              ':COD_CLIFOR, :COD_USUARIO, :TOTAL, :COD_EMPRESA, :COD_FILIAL, :COD_DEPARTAMENTO, :COD_CENTRO_CUSTO, ' +
              ':DT_EMISSAO, :COD_CONDPAGTO, :ORDEM_COMPRA, :VALOR_IMPOSTOS, :COD_COMPRADOR, :PESO, :VOLUME, :COD_TIPOFRETE, ' +
              ':DATA_PREVISTA_ENTREGA, :DT_ENTREGA, :TIPO_COMPRA)')
      .addParam('COD_CLIFOR', FEntity.COD_CLIFOR)
      .addParam('COD_USUARIO', FEntity.COD_USUARIO)
      .addParam('TOTAL', FEntity.TOTAL)
      .addParam('COD_EMPRESA', FEntity.COD_EMPRESA)
      .addParam('COD_FILIAL', FEntity.COD_FILIAL)
      .addParam('COD_DEPARTAMENTO', FEntity.COD_DEPARTAMENTO)
      .addParam('COD_CENTRO_CUSTO', FEntity.COD_CENTRO_CUSTO)
      .addParam('DT_EMISSAO', FEntity.DT_EMISSAO)
      .addParam('COD_CONDPAGTO', FEntity.COD_CONDPAGTO)
      .addParam('ORDEM_COMPRA', FEntity.ORDEM_COMPRA)
      .addParam('VALOR_IMPOSTOS', FEntity.VALOR_IMPOSTOS)
      .addParam('COD_COMPRADOR', FEntity.COD_COMPRADOR)
      .addParam('PESO', FEntity.PESO)
      .addParam('VOLUME', FEntity.VOLUME)
      .addParam('COD_TIPOFRETE', FEntity.COD_TIPOFRETE)
      .addParam('DATA_PREVISTA_ENTREGA', FEntity.DATA_PREVISTA_ENTREGA)
      .addParam('DT_ENTREGA', FEntity.DT_ENTREGA)
      .addParam('TIPO_COMPRA', FEntity.TIPO_COMPRA)
      .execSql;
end;

class function TModelDAOPedidoCompra.New: iModelDAOEntity<TModelEntityPedidoCompra>;
begin
  Result := Self.Create;
end;

function TModelDAOPedidoCompra.This: TModelEntityPedidoCompra;
begin
  Result := FEntity;
end;

function TModelDAOPedidoCompra.Update: iModelDAOEntity<TModelEntityPedidoCompra>;
begin
  Result := Self;
  FQuery
    .active(False)
    .sqlClear
      .sqlAdd('update PEDIDO_COMPRA set ' +
              'COD_CLIFOR = :COD_CLIFOR, COD_USUARIO = :COD_USUARIO, TOTAL = :TOTAL, COD_EMPRESA = :COD_EMPRESA, ' +
              'COD_FILIAL = :COD_FILIAL, COD_DEPARTAMENTO = :COD_DEPARTAMENTO, COD_CENTRO_CUSTO = :COD_CENTRO_CUSTO, ' +
              'DT_EMISSAO = :DT_EMISSAO, COD_CONDPAGTO = :COD_CONDPAGTO, ORDEM_COMPRA = :ORDEM_COMPRA, ' +
              'VALOR_IMPOSTOS = :VALOR_IMPOSTOS, COD_COMPRADOR = :COD_COMPRADOR, PESO = :PESO, VOLUME = :VOLUME, ' +
              'COD_TIPOFRETE = :COD_TIPOFRETE, DATA_PREVISTA_ENTREGA = :DATA_PREVISTA_ENTREGA, DT_ENTREGA = :DT_ENTREGA, ' +
              'TIPO_COMPRA = :TIPO_COMPRA')
      .sqlAdd(' where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA')
      .addParam('COD_PEDIDOCOMPRA', FEntity.COD_PEDIDOCOMPRA)
      .addParam('COD_CLIFOR', FEntity.COD_CLIFOR)
      .addParam('COD_USUARIO', FEntity.COD_USUARIO)
      .addParam('TOTAL', FEntity.TOTAL)
      .addParam('COD_EMPRESA', FEntity.COD_EMPRESA)
      .addParam('COD_FILIAL', FEntity.COD_FILIAL)
      .addParam('COD_DEPARTAMENTO', FEntity.COD_DEPARTAMENTO)
      .addParam('COD_CENTRO_CUSTO', FEntity.COD_CENTRO_CUSTO)
      .addParam('DT_EMISSAO', FEntity.DT_EMISSAO)
      .addParam('COD_CONDPAGTO', FEntity.COD_CONDPAGTO)
      .addParam('ORDEM_COMPRA', FEntity.ORDEM_COMPRA)
      .addParam('VALOR_IMPOSTOS', FEntity.VALOR_IMPOSTOS)
      .addParam('COD_COMPRADOR', FEntity.COD_COMPRADOR)
      .addParam('PESO', FEntity.PESO)
      .addParam('VOLUME', FEntity.VOLUME)
      .addParam('COD_TIPOFRETE', FEntity.COD_TIPOFRETE)
      .addParam('DATA_PREVISTA_ENTREGA', FEntity.DATA_PREVISTA_ENTREGA)
      .addParam('DT_ENTREGA', FEntity.DT_ENTREGA)
      .addParam('TIPO_COMPRA', FEntity.TIPO_COMPRA)
      .execSql;
end;

end.
