unit comercial.model.DAO.PedcompraItem;

interface

uses
  System.Generics.Collections,
  System.Variants,
  Data.DB,
  comercial.model.DAO.interfaces,
  comercial.model.entity.PedcompraItem,
  comercial.model.resource.interfaces;

type
  TModelDAOPedcompraItem = class(TInterfacedObject, iModelDAOEntity<TModelEntityPedcompraItem>)
  private
    FQuery: iQuery;
    FDataSource: TDataSource;
    FEntity: TModelEntityPedcompraItem;
    procedure AfterScroll(DataSet: TDataSet);
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelDAOEntity<TModelEntityPedcompraItem>;
    function Delete: iModelDAOEntity<TModelEntityPedcompraItem>;
    function DataSet(AValue: TDataSource): iModelDAOEntity<TModelEntityPedcompraItem>;
    function Get: iModelDAOEntity<TModelEntityPedcompraItem>; overload;
    function Insert: iModelDAOEntity<TModelEntityPedcompraItem>;
    function This: TModelEntityPedcompraItem;
    function Update: iModelDAOEntity<TModelEntityPedcompraItem>;
    function GetbyId(AValue: integer): iModelDAOEntity<TModelEntityPedcompraItem>;
    function GetDataSet: TDataSet;
    function Get(AFieldsWhere: TDictionary<string, Variant>): iModelDAOEntity<TModelEntityPedcompraItem>; overload;
  end;

implementation

uses comercial.model.resource.impl.queryFD;

procedure TModelDAOPedcompraItem.AfterScroll(DataSet: TDataSet);
begin
end;

constructor TModelDAOPedcompraItem.Create;
begin
  FQuery := TModelResourceQueryFD.New;
  FDataSource := TDataSource.Create(nil);
  FDataSource.DataSet := FQuery.DataSet;
  FEntity := TModelEntityPedcompraItem.Create(Self);
end;

destructor TModelDAOPedcompraItem.Destroy;
begin
  FDataSource.Free;
  inherited;
end;

function TModelDAOPedcompraItem.DataSet(AValue: TDataSource): iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Result := Self;
  FDataSource := AValue;
  FDataSource.DataSet := FQuery.DataSet;
  FQuery.DataSet.AfterScroll := AfterScroll;
end;

function TModelDAOPedcompraItem.Delete: iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Result := Self;
  FQuery
    .active(False)
    .sqlClear
      .sqlAdd('delete from PEDCOMPRA_ITEM where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA and SEQUENCIA = :SEQUENCIA')
      .addParam('COD_PEDIDOCOMPRA', FEntity.COD_PEDIDOCOMPRA)
      .addParam('SEQUENCIA', FEntity.SEQUENCIA)
      .execSql;
end;

function TModelDAOPedcompraItem.Get: iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Result := Self;
  FQuery
    .active(False)
    .sqlClear
      .sqlAdd('select * from PEDCOMPRA_ITEM')
      .open;
  FDataSource.DataSet := FQuery.DataSet;
end;

function TModelDAOPedcompraItem.Get(AFieldsWhere: TDictionary<string, Variant>): iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Result := Get;
end;

function TModelDAOPedcompraItem.GetbyId(AValue: integer): iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Result := Self;
  FQuery
    .active(False)
    .sqlClear
      .sqlAdd('select * from PEDCOMPRA_ITEM where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA')
      .addParam('COD_PEDIDOCOMPRA', AValue)
      .open;
  FDataSource.DataSet := FQuery.DataSet;
end;

function TModelDAOPedcompraItem.GetDataSet: TDataSet;
begin
  Result := FQuery.DataSet;
end;

function TModelDAOPedcompraItem.Insert: iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Result := Self;
  FQuery
    .active(False)
    .sqlClear
      .sqlAdd('insert into PEDCOMPRA_ITEM (' +
              'COD_PEDIDOCOMPRA, COD_EMPRESA, SEQUENCIA, COD_Item, COD_unidadecompra, ' +
              'QTD_PEDIDA, QTD_RECEBIDA, DESCRICAO, PRECO_UNITARIO, PERC_DESCTO, ' +
              'VALOR_DESCTO, PERC_FINANC, VALOR_FINANC, '+
              ' VALOR_TOTAL, DT_INCLUSAO,'+
              'DT_SOLICITADA, DT_RECEBIDA)')
      .sqlAdd('values (:COD_PEDIDOCOMPRA, :COD_EMPRESA, ' +
              'case when :SEQUENCIA > 0 then :SEQUENCIA else (select coalesce(max(SEQUENCIA),0)+1 from PEDCOMPRA_ITEM where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA) end, ' +
              ':COD_Item, :COD_unidadecompra, :QTD_PEDIDA, :QTD_RECEBIDA, :DESCRICAO, :PRECO_UNITARIO, :PERC_DESCTO, ' +
              ':VALOR_DESCTO, :PERC_FINANC, :VALOR_FINANC,'+
              ':VALOR_TOTAL, :DT_INCLUSAO, :DT_SOLICITADA, :DT_RECEBIDA)')
      .addParam('COD_PEDIDOCOMPRA', FEntity.COD_PEDIDOCOMPRA)
      .addParam('COD_EMPRESA', FEntity.COD_EMPRESA)
      .addParam('SEQUENCIA', FEntity.SEQUENCIA)
      .addParam('COD_Item', FEntity.COD_Item)
      .addParam('COD_unidadecompra', FEntity.COD_unidadecompra)
      .addParam('QTD_PEDIDA', FEntity.QTD_PEDIDA)
      .addParam('QTD_RECEBIDA', FEntity.QTD_RECEBIDA)
      .addParam('DESCRICAO', FEntity.DESCRICAO)
      .addParam('PRECO_UNITARIO', FEntity.PRECO_UNITARIO)
      .addParam('PERC_DESCTO', FEntity.PERC_DESCTO)
      .addParam('VALOR_DESCTO', FEntity.VALOR_DESCTO)
      .addParam('PERC_FINANC', FEntity.PERC_FINANC)
      .addParam('VALOR_FINANC', FEntity.VALOR_FINANC)
      .addParam('VALOR_TOTAL', FEntity.VALOR_TOTAL)
      .addParam('DT_INCLUSAO', FEntity.DT_INCLUSAO)
      .addParam('DT_SOLICITADA', FEntity.DT_SOLICITADA)
      .addParam('DT_RECEBIDA', FEntity.DT_RECEBIDA)
      .execSql;
end;

class function TModelDAOPedcompraItem.New: iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Result := Self.Create;
end;

function TModelDAOPedcompraItem.This: TModelEntityPedcompraItem;
begin
  Result := FEntity;
end;

function TModelDAOPedcompraItem.Update: iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Result := Self;
  FQuery
    .active(False)
    .sqlClear
      .sqlAdd('update PEDCOMPRA_ITEM set ' +
              'COD_EMPRESA = :COD_EMPRESA, COD_Item = :COD_Item, COD_unidadecompra = :COD_unidadecompra, ' +
              'QTDE_PEDIDA = :QTDE_PEDIDA, QTDE_RECEBIDA = :QTDE_RECEBIDA, DESCRICAO = :DESCRICAO, ' +
              'PRECO_UNITARIO = :PRECO_UNITARIO, PERC_DESCTO = :PERC_DESCTO, VALOR_DESCTO = :VALOR_DESCTO, ' +
              'PERC_FINANC = :PERC_FINANC, '+
              'VALOR_FINANC = :VALOR_FINANC, '+
              'VALOR_TOTAL = :VALOR_TOTAL, '+
              'DT_INCLUSAO = :DT_INCLUSAO, ' +
              'DT_SOLICITADA = :DT_SOLICITADA, DT_RECEBIDA = :DT_RECEBIDA')
      .sqlAdd(' where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA and SEQUENCIA = :SEQUENCIA')
      .addParam('COD_PEDIDOCOMPRA', FEntity.COD_PEDIDOCOMPRA)
      .addParam('SEQUENCIA', FEntity.SEQUENCIA)
      .addParam('COD_EMPRESA', FEntity.COD_EMPRESA)
      .addParam('COD_Item', FEntity.COD_Item)
      .addParam('COD_unidadecompra', FEntity.COD_unidadecompra)
      .addParam('QTD_PEDIDA', FEntity.QTD_PEDIDA)
      .addParam('QTD_RECEBIDA', FEntity.QTD_RECEBIDA)
      .addParam('DESCRICAO', FEntity.DESCRICAO)
      .addParam('PRECO_UNITARIO', FEntity.PRECO_UNITARIO)
      .addParam('PERC_DESCTO', FEntity.PERC_DESCTO)
      .addParam('VALOR_DESCTO', FEntity.VALOR_DESCTO)
      .addParam('PERC_FINANC', FEntity.PERC_FINANC)
      .addParam('VALOR_FINANC', FEntity.VALOR_FINANC)
      .addParam('VALOR_TOTAL', FEntity.VALOR_TOTAL)
      .addParam('DT_INCLUSAO', FEntity.DT_INCLUSAO)
      .addParam('DT_SOLICITADA', FEntity.DT_SOLICITADA)
      .addParam('DT_RECEBIDA', FEntity.DT_RECEBIDA)
      .execSql;
end;

end.
