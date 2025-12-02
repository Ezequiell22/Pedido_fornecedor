unit comercial.model.DAO.Fornecedor;

interface

uses
    Data.DB,
    System.Generics.Collections,
  comercial.model.DAO.interfaces,
  comercial.model.entity.Fornecedor,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD;

type
  TModelDAOFornecedor = class(TInterfacedObject, iModelDAOEntity<TModelEntityFornecedor>)
  private
    FQuery: iQuery;
    FDataSource: TDataSource;
    FEntity: TModelEntityFornecedor;
    procedure AfterScroll(DataSet: TDataSet);
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelDAOEntity<TModelEntityFornecedor>;
    function Delete: iModelDAOEntity<TModelEntityFornecedor>;
    function DataSet(AValue: TDataSource): iModelDAOEntity<TModelEntityFornecedor>;
    function Get: iModelDAOEntity<TModelEntityFornecedor>; overload;
    function Insert: iModelDAOEntity<TModelEntityFornecedor>;
    function This: TModelEntityFornecedor;
    function Update: iModelDAOEntity<TModelEntityFornecedor>;
    function GetbyId(AValue: integer): iModelDAOEntity<TModelEntityFornecedor>;
    function GetDataSet: TDataSet;
    function Get(AFieldsWhere: TDictionary<string, Variant>): iModelDAOEntity<TModelEntityFornecedor>; overload;
  end;

implementation

uses System.SysUtils;

procedure TModelDAOFornecedor.AfterScroll(DataSet: TDataSet);
begin

end;

constructor TModelDAOFornecedor.Create;
begin
  FEntity := TModelEntityFornecedor.Create(Self);
  FQuery := TModelResourceQueryFD.New;
  FQuery.DataSet.AfterScroll := AfterScroll;
end;

function TModelDAOFornecedor.DataSet(AValue: TDataSource): iModelDAOEntity<TModelEntityFornecedor>;
begin
  Result := Self;
  FDataSource := AValue;
  FDataSource.DataSet := FQuery.DataSet;
end;

function TModelDAOFornecedor.Delete: iModelDAOEntity<TModelEntityFornecedor>;
begin
  Result := Self;
 try
    FQuery.active(False)
      .sqlClear
      .sqlAdd('delete from FORNECEDORES where COD_CLIFOR = :COD_CLIFOR')
      .addParam('COD_CLIFOR', FEntity.COD_CLIFOR)
      .execSql;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

destructor TModelDAOFornecedor.Destroy;
begin
  FEntity.Free;
  inherited;
end;

function TModelDAOFornecedor.Get: iModelDAOEntity<TModelEntityFornecedor>;
begin
  Result := Self;
  try
    FQuery.active(False)
      .sqlClear
      .sqlAdd('select * from FORNECEDORES')
      .Open;
    FQuery.DataSet.First;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TModelDAOFornecedor.Get(AFieldsWhere: TDictionary<string, Variant>): iModelDAOEntity<TModelEntityFornecedor>;
begin
  Result := Self;
end;

function TModelDAOFornecedor.GetbyId(AValue: integer): iModelDAOEntity<TModelEntityFornecedor>;
begin
  Result := Self;
  try
    FQuery.active(False)
      .sqlClear
      .sqlAdd('select * from FORNECEDORES where COD_CLIFOR = :COD_CLIFOR')
      .addParam('COD_CLIFOR', AValue)
      .Open;
    FQuery.DataSet.First;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TModelDAOFornecedor.GetDataSet: TDataSet;
begin
  Result := FQuery.DataSet;
end;

function TModelDAOFornecedor.Insert: iModelDAOEntity<TModelEntityFornecedor>;
begin
  Result := Self;
  try
    FQuery.active(False)
      .sqlClear
      .sqlAdd('insert into FORNECEDORES (COD_CLIFOR, RAZAO, COD_ESTADO, FANTASIA, COD_PAIS, CLIENTE, FORNEC)')
      .sqlAdd('values ((select coalesce(max(COD_CLIFOR),0)+1 from FORNECEDORES),')
      .sqlAdd(':RAZAO, :COD_ESTADO, :FANTASIA, :COD_PAIS, :FORNECEDOR, :FORNEC)')
      .addParam('RAZAO', FEntity.RAZAO)
      .addParam('COD_ESTADO', FEntity.COD_ESTADO)
      .addParam('FANTASIA', FEntity.FANTASIA)
      .addParam('COD_PAIS', FEntity.COD_PAIS)
      .addParam('CLIENTE', FEntity.FORNECEDOR)
      .addParam('FORNEC', FEntity.FORNEC)
      .execSql;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;

end;

class function TModelDAOFornecedor.New: iModelDAOEntity<TModelEntityFornecedor>;
begin
  Result := Self.Create;
end;

function TModelDAOFornecedor.This: TModelEntityFornecedor;
begin
  Result := FEntity;
end;

function TModelDAOFornecedor.Update: iModelDAOEntity<TModelEntityFornecedor>;
begin
  Result := Self;
  try
    FQuery.active(False)
      .sqlClear
      .sqlAdd('update FORNECEDORES set RAZAO = :RAZAO, COD_ESTADO = :COD_ESTADO,')
      .sqlAdd(' FANTASIA = :FANTASIA, COD_PAIS = :COD_PAIS, CLIENTE = :CLIENTE, FORNEC = :FORNEC')
      .sqlAdd(' where COD_CLIFOR = :COD_CLIFOR')
      .addParam('COD_CLIFOR', FEntity.COD_CLIFOR)
      .addParam('RAZAO', FEntity.RAZAO)
      .addParam('COD_ESTADO', FEntity.COD_ESTADO)
      .addParam('FANTASIA', FEntity.FANTASIA)
      .addParam('COD_PAIS', FEntity.COD_PAIS)
      .addParam('CLIENTE', FEntity.FORNECEDOR)
      .addParam('FORNEC', FEntity.FORNEC)
      .execSql;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

end.
