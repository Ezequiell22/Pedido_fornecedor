unit comercial.model.DAO.Produto;

interface

uses
  comercial.model.DAO.interfaces,
  comercial.model.entity.Produto,
  Data.DB,
  comercial.model.resource.impl.queryFD,
  System.Generics.Collections,
  comercial.model.resource.interfaces;

type
  TModelDAOProduto = class(TInterfacedObject, iModelDAOEntity<TModelEntityProduto>)
  private
    FQuery: iQuery;
    FDataSource: TDataSource;
    FEntity: TModelEntityProduto;
    procedure AfterScroll(DataSet: TDataSet);
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelDAOEntity<TModelEntityProduto>;
    function Delete: iModelDAOEntity<TModelEntityProduto>;
    function DataSet(AValue: TDataSource): iModelDAOEntity<TModelEntityProduto>;
    function Get: iModelDAOEntity<TModelEntityProduto>; overload;
    function Insert: iModelDAOEntity<TModelEntityProduto>;
    function This: TModelEntityProduto;
    function Update: iModelDAOEntity<TModelEntityProduto>;
    function GetbyId(AValue: integer): iModelDAOEntity<TModelEntityProduto>;
    function GetDataSet: TDataSet;
    function Get(AFieldsWhere: TDictionary<string, Variant>): iModelDAOEntity<TModelEntityProduto>; overload;
  end;

implementation

uses System.SysUtils;

procedure TModelDAOProduto.AfterScroll(DataSet: TDataSet);
begin
end;

constructor TModelDAOProduto.Create;
begin
  FEntity := TModelEntityProduto.Create(Self);
  FQuery := TModelResourceQueryFD.New;
  FQuery.DataSet.AfterScroll := AfterScroll;
end;

function TModelDAOProduto.DataSet(AValue: TDataSource): iModelDAOEntity<TModelEntityProduto>;
begin
  Result := Self;
  FDataSource := AValue;
  FDataSource.DataSet := FQuery.DataSet;
end;

function TModelDAOProduto.Delete: iModelDAOEntity<TModelEntityProduto>;
begin
  Result := Self;
 try
    FQuery.active(False)
      .sqlClear
      .sqlAdd('update PRODUTO set ACTIVE = :ACTIVE ')
      .sqlAdd('where IDPRODUTO = :IDPRODUTO')
      .addParam('IDPRODUTO', FEntity.IDPRODUTO)
      .addParam('ACTIVE', 0)
      .execSql;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

destructor TModelDAOProduto.Destroy;
begin
  FEntity.Free;
  inherited;
end;

function TModelDAOProduto.Get: iModelDAOEntity<TModelEntityProduto>;
begin
  Result := Self;
  try
    FQuery.active(False)
      .sqlClear
      .sqlAdd('select * from PRODUTO WHERE ACTIVE = 1')
      .Open;
    FQuery.DataSet.First;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TModelDAOProduto.Get(AFieldsWhere: TDictionary<string, Variant>): iModelDAOEntity<TModelEntityProduto>;
begin
  Result := Self;
end;

function TModelDAOProduto.GetbyId(AValue: integer): iModelDAOEntity<TModelEntityProduto>;
begin
  Result := Self;
  try
    FQuery.active(False)
      .sqlClear
      .sqlAdd('select * from PRODUTO where IDPRODUTO = :IDPRODUTO')
      .addParam('IDPRODUTO', AValue)
      .Open;
    FQuery.DataSet.First;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TModelDAOProduto.GetDataSet: TDataSet;
begin
  Result := FQuery.DataSet;
end;

function TModelDAOProduto.Insert: iModelDAOEntity<TModelEntityProduto>;
begin
  Result := Self;
  try
    FQuery.active(False)
      .sqlClear
      .sqlAdd('insert into PRODUTO (IDPRODUTO, DESCRICAO, MARCA, PRECO, ACTIVE)')
      .sqlAdd('values ((select coalesce(max(IDPRODUTO),0)+1 from PRODUTO),')
      .sqlAdd(':DESCRICAO, :MARCA, :PRECO, :ACTIVE)')
      .addParam('DESCRICAO', FEntity.DESCRICAO)
      .addParam('MARCA', FEntity.MARCA)
      .addParam('PRECO', FEntity.PRECO)
      .addParam('ACTIVE', 1)
      .execSql;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

class function TModelDAOProduto.New: iModelDAOEntity<TModelEntityProduto>;
begin
  Result := Self.Create;
end;

function TModelDAOProduto.This: TModelEntityProduto;
begin
  Result := FEntity;
end;

function TModelDAOProduto.Update: iModelDAOEntity<TModelEntityProduto>;
begin
  Result := Self;
  try
    FQuery.active(False)
      .sqlClear
      .sqlAdd('update PRODUTO set DESCRICAO = :DESCRICAO,')
      .sqlAdd('MARCA = :MARCA, PRECO = :PRECO, ACTIVE = :ACTIVE')
      .sqlAdd('where IDPRODUTO = :IDPRODUTO')
      .addParam('IDPRODUTO', FEntity.IDPRODUTO)
      .addParam('DESCRICAO', FEntity.DESCRICAO)
      .addParam('MARCA', FEntity.MARCA)
      .addParam('PRECO', FEntity.PRECO)
      .addParam('ACTIVE', 1)
      .execSql;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

end.
