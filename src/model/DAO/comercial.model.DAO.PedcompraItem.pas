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
              'COD_PEDIDOCOMPRA, COD_PRODUTO, QUANTIDADE, VL_UNITARIO, VL_TOTAL, COD_EMPRESA, COD_FILIAL, COD_DEPARTAMENTO, ' +
              'COD_CENTRO_CUSTO, DESCONTO, ACRESCIMO, IPI, VALOR_IPI, PESO, VOLUME, SEQUENCIA, DT_INCLUSAO, DT_SOLICITADA, DT_RECEBIDA)')
      .sqlAdd('values (:COD_PEDIDOCOMPRA, :COD_PRODUTO, :QUANTIDADE, :VL_UNITARIO, :VL_TOTAL, :COD_EMPRESA, :COD_FILIAL, :COD_DEPARTAMENTO, ' +
              ':COD_CENTRO_CUSTO, :DESCONTO, :ACRESCIMO, :IPI, :VALOR_IPI, :PESO, :VOLUME, ' +
              '(select coalesce(max(SEQUENCIA),0)+1 from PEDCOMPRA_ITEM where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA), ' +
              ':DT_INCLUSAO, :DT_SOLICITADA, :DT_RECEBIDA)')
      .addParam('COD_PEDIDOCOMPRA', FEntity.COD_PEDIDOCOMPRA)
      .addParam('COD_PRODUTO', FEntity.COD_PRODUTO)
      .addParam('QUANTIDADE', FEntity.QUANTIDADE)
      .addParam('VL_UNITARIO', FEntity.VL_UNITARIO)
      .addParam('VL_TOTAL', FEntity.VL_TOTAL)
      .addParam('COD_EMPRESA', FEntity.COD_EMPRESA)
      .addParam('COD_FILIAL', FEntity.COD_FILIAL)
      .addParam('COD_DEPARTAMENTO', FEntity.COD_DEPARTAMENTO)
      .addParam('COD_CENTRO_CUSTO', FEntity.COD_CENTRO_CUSTO)
      .addParam('DESCONTO', FEntity.DESCONTO)
      .addParam('ACRESCIMO', FEntity.ACRESCIMO)
      .addParam('IPI', FEntity.IPI)
      .addParam('VALOR_IPI', FEntity.VALOR_IPI)
      .addParam('PESO', FEntity.PESO)
      .addParam('VOLUME', FEntity.VOLUME)
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
              'COD_PRODUTO = :COD_PRODUTO, QUANTIDADE = :QUANTIDADE, VL_UNITARIO = :VL_UNITARIO, VL_TOTAL = :VL_TOTAL, ' +
              'COD_EMPRESA = :COD_EMPRESA, COD_FILIAL = :COD_FILIAL, COD_DEPARTAMENTO = :COD_DEPARTAMENTO, ' +
              'COD_CENTRO_CUSTO = :COD_CENTRO_CUSTO, DESCONTO = :DESCONTO, ACRESCIMO = :ACRESCIMO, IPI = :IPI, VALOR_IPI = :VALOR_IPI, ' +
              'PESO = :PESO, VOLUME = :VOLUME, DT_INCLUSAO = :DT_INCLUSAO, DT_SOLICITADA = :DT_SOLICITADA, DT_RECEBIDA = :DT_RECEBIDA')
      .sqlAdd(' where COD_PEDIDOCOMPRA = :COD_PEDIDOCOMPRA and SEQUENCIA = :SEQUENCIA')
      .addParam('COD_PEDIDOCOMPRA', FEntity.COD_PEDIDOCOMPRA)
      .addParam('SEQUENCIA', FEntity.SEQUENCIA)
      .addParam('COD_PRODUTO', FEntity.COD_PRODUTO)
      .addParam('QUANTIDADE', FEntity.QUANTIDADE)
      .addParam('VL_UNITARIO', FEntity.VL_UNITARIO)
      .addParam('VL_TOTAL', FEntity.VL_TOTAL)
      .addParam('COD_EMPRESA', FEntity.COD_EMPRESA)
      .addParam('COD_FILIAL', FEntity.COD_FILIAL)
      .addParam('COD_DEPARTAMENTO', FEntity.COD_DEPARTAMENTO)
      .addParam('COD_CENTRO_CUSTO', FEntity.COD_CENTRO_CUSTO)
      .addParam('DESCONTO', FEntity.DESCONTO)
      .addParam('ACRESCIMO', FEntity.ACRESCIMO)
      .addParam('IPI', FEntity.IPI)
      .addParam('VALOR_IPI', FEntity.VALOR_IPI)
      .addParam('PESO', FEntity.PESO)
      .addParam('VOLUME', FEntity.VOLUME)
      .addParam('DT_INCLUSAO', FEntity.DT_INCLUSAO)
      .addParam('DT_SOLICITADA', FEntity.DT_SOLICITADA)
      .addParam('DT_RECEBIDA', FEntity.DT_RECEBIDA)
      .execSql;
end;

end.
