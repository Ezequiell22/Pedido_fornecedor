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
var
  hasWhere: Boolean;
begin
  Result := Self;
  hasWhere := False;
  FQuery
    .active(False)
    .sqlClear
      .sqlAdd('select * from PEDIDO_COMPRA');

  if Assigned(AFieldsWhere) then
  begin
    if AFieldsWhere.ContainsKey('DT_EMISSAO_INI') and AFieldsWhere.ContainsKey('DT_EMISSAO_FIM') then
    begin
      FQuery.sqlAdd(' where DT_EMISSAO between :DTINI and :DTFIM');
      FQuery.addParam('DTINI', AFieldsWhere['DT_EMISSAO_INI']);
      FQuery.addParam('DTFIM', AFieldsWhere['DT_EMISSAO_FIM']);
      hasWhere := True;
    end;

    if AFieldsWhere.ContainsKey('COD_CLIFOR') then
    begin
      if hasWhere then
        FQuery.sqlAdd(' and COD_CLIFOR = :COD_CLIFOR')
      else
        FQuery.sqlAdd(' where COD_CLIFOR = :COD_CLIFOR');
      FQuery.addParam('COD_CLIFOR', AFieldsWhere['COD_CLIFOR']);
      hasWhere := True;
    end;
  end;

  FQuery.open;
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
              'COD_PEDIDOCOMPRA, COD_EMPRESA, COD_CLIFOR, COD_MOEDA, DT_EMISSAO, DT_PREVISAOENTREGA, DT_ENTREGA, TIPO_COMPRA)')
      .sqlAdd('values (' +
              'case when :COD_PEDIDOCOMPRA > 0 then :COD_PEDIDOCOMPRA else (select coalesce(max(COD_PEDIDOCOMPRA),0)+1 from PEDIDO_COMPRA) end, ' +
              ':COD_EMPRESA, :COD_CLIFOR, :COD_MOEDA, :DT_EMISSAO, :DT_PREVISAOENTREGA, :DT_ENTREGA, :TIPO_COMPRA)')
      .addParam('COD_PEDIDOCOMPRA', FEntity.COD_PEDIDOCOMPRA)
      .addParam('COD_EMPRESA', FEntity.COD_EMPRESA)
      .addParam('COD_CLIFOR', FEntity.COD_CLIFOR)
      .addParam('COD_MOEDA', FEntity.COD_MOEDA)
      .addParam('DT_EMISSAO', FEntity.DT_EMISSAO)
      .addParam('DT_PREVISAOENTREGA', FEntity.DT_PREVISAOENTREGA)
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
              'COD_EMPRESA = :COD_EMPRESA, COD_CLIFOR = :COD_CLIFOR, COD_MOEDA = :COD_MOEDA, ' +
              'DT_EMISSAO = :DT_EMISSAO, DT_PREVISAOENTREGA = :DT_PREVISAOENTREGA, DT_ENTREGA = :DT_ENTREGA, ' +
              'TIPO_COMPRA = :TIPO_COMPRA')
      .sqlAdd(' where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA')
      .addParam('COD_PEDIDOCOMPRA', FEntity.COD_PEDIDOCOMPRA)
      .addParam('COD_EMPRESA', FEntity.COD_EMPRESA)
      .addParam('COD_CLIFOR', FEntity.COD_CLIFOR)
      .addParam('COD_MOEDA', FEntity.COD_MOEDA)
      .addParam('DT_EMISSAO', FEntity.DT_EMISSAO)
      .addParam('DT_PREVISAOENTREGA', FEntity.DT_PREVISAOENTREGA)
      .addParam('DT_ENTREGA', FEntity.DT_ENTREGA)
      .addParam('TIPO_COMPRA', FEntity.TIPO_COMPRA)
      .execSql;
end;

end.
