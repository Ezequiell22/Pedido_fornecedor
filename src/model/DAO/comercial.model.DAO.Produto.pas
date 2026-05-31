unit comercial.model.DAO.Produto;

interface

uses
  Data.DB,
  System.Generics.Collections,
  comercial.model.DAO.interfaces,
  comercial.model.entity.Produto,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD;

type
  TModelDAOProduto = class(TInterfacedObject, iModelDAOEntity<TModelEntityProduto>)
  private
    FQuery: iQuery;
    FDataSource: TDataSource;
    FEntity: TModelEntityProduto;
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

constructor TModelDAOProduto.Create;
begin
  FEntity := TModelEntityProduto.Create(Self);
  FQuery := TModelResourceQueryFD.New;
end;

destructor TModelDAOProduto.Destroy;
begin
  FEntity.Free;
  inherited;
end;

class function TModelDAOProduto.New: iModelDAOEntity<TModelEntityProduto>;
begin
  Result := Self.Create;
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
      .sqlAdd('DELETE FROM PRODUTO WHERE IDPRODUTO = :ID')
      .addParam('ID', FEntity.IDPRODUTO)
      .execSql;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TModelDAOProduto.Get: iModelDAOEntity<TModelEntityProduto>;
begin
  Result := Self;
  try
    FQuery.active(False)
      .sqlClear
      .sqlAdd('SELECT * FROM PRODUTO ORDER BY DESCRICAO')
      .Open;
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
      .sqlAdd('SELECT * FROM PRODUTO WHERE IDPRODUTO = :ID')
      .addParam('ID', AValue)
      .Open;
      
    if not FQuery.DataSet.IsEmpty then
    begin
       FEntity.IDPRODUTO(FQuery.DataSet.FieldByName('IDPRODUTO').AsInteger);
       FEntity.DESCRICAO(FQuery.DataSet.FieldByName('DESCRICAO').AsString);
       FEntity.MARCA(FQuery.DataSet.FieldByName('MARCA').AsString);
       FEntity.PRECO(FQuery.DataSet.FieldByName('PRECO').AsFloat);
       // Check if field exists to avoid errors if schema is different
       if FQuery.DataSet.FindField('ALIQUOTA_ESTADUAL') <> nil then
         FEntity.ALIQUOTA_ESTADUAL(FQuery.DataSet.FieldByName('ALIQUOTA_ESTADUAL').AsFloat)
       else
         FEntity.ALIQUOTA_ESTADUAL(0); // Default or raise error? User wants logic based on this.
    end;
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
      .sqlAdd('INSERT INTO PRODUTO (IDPRODUTO, DESCRICAO, MARCA, PRECO, ALIQUOTA_ESTADUAL)')
      .sqlAdd('VALUES ((SELECT COALESCE(MAX(IDPRODUTO),0)+1 FROM PRODUTO), :DESCRICAO, :MARCA, :PRECO, :ALIQUOTA)')
      .addParam('DESCRICAO', FEntity.DESCRICAO)
      .addParam('MARCA', FEntity.MARCA)
      .addParam('PRECO', FEntity.PRECO)
      .addParam('ALIQUOTA', FEntity.ALIQUOTA_ESTADUAL)
      .execSql;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
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
      .sqlAdd('UPDATE PRODUTO SET DESCRICAO = :DESCRICAO, MARCA = :MARCA, PRECO = :PRECO, ALIQUOTA_ESTADUAL = :ALIQUOTA')
      .sqlAdd('WHERE IDPRODUTO = :ID')
      .addParam('DESCRICAO', FEntity.DESCRICAO)
      .addParam('MARCA', FEntity.MARCA)
      .addParam('PRECO', FEntity.PRECO)
      .addParam('ALIQUOTA', FEntity.ALIQUOTA_ESTADUAL)
      .addParam('ID', FEntity.IDPRODUTO)
      .execSql;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

end.
