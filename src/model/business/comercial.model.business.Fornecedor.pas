unit comercial.model.business.Fornecedor;

interface

uses
  Data.DB,
  comercial.model.business.interfaces,
  comercial.model.resource.interfaces,
  comercial.model.DAO.interfaces,
  comercial.model.entity.Fornecedor;

type
  TModelBusinessFornecedor = class(TInterfacedObject, iModelBusinessFornecedor)
  private
    FDAOFornecedor: iModelDAOEntity<TModelEntityFornecedor>;
  public
    constructor Create;
    class function New: iModelBusinessFornecedor;
    function Bind(aDataSource: TDataSource): iModelBusinessFornecedor;
    function Get: iModelBusinessFornecedor;
    function GetById(aId: Integer): iModelBusinessFornecedor;
    function Salvar(aCOD_CLIFOR: Integer; aRAZAO,
     aCOD_ESTADO, aFANTASIA,
      aCOD_PAIS : string; aCLIENTE, aFORNEC: boolean): iModelBusinessFornecedor;
    function Excluir(aId: Integer): iModelBusinessFornecedor;
  end;

implementation

uses System.SysUtils,
      system.StrUtils,
      comercial.model.DAO.Fornecedor;

constructor TModelBusinessFornecedor.Create;
begin
  FDAOFornecedor := TModelDAOFornecedor.New;
end;

class function TModelBusinessFornecedor.New: iModelBusinessFornecedor;
begin
  Result := Self.Create;
end;

function TModelBusinessFornecedor.Bind(aDataSource: TDataSource): iModelBusinessFornecedor;
begin
  Result := Self;
  FDAOFornecedor.DataSet(aDataSource)
end;

function TModelBusinessFornecedor.Get: iModelBusinessFornecedor;
begin
  Result := Self;
  FDAOFornecedor.Get
end;

function TModelBusinessFornecedor.GetById(aId: Integer): iModelBusinessFornecedor;
begin
  Result := Self;
  FDAOFornecedor.GetbyId(aId)
end;

function TModelBusinessFornecedor.Salvar(aCOD_CLIFOR: Integer; aRAZAO,
     aCOD_ESTADO, aFANTASIA,
      aCOD_PAIS : string; aCLIENTE, aFORNEC: boolean): iModelBusinessFornecedor;
  var scliente, sFornec : string;
begin
  Result := Self;

  scliente := IfThen(aCliente, 'S', 'N');
  sFornec := IfThen(aFornec, 'S', 'N');

  FDAOFornecedor.GetbyId(aCOD_CLIFOR);

  if FDAOFornecedor.GetDataSet.IsEmpty then
  begin
    FDAOFornecedor.This
      .FANTASIA(aFantasia)
      .COD_ESTADO(aCOD_ESTADO)
      .RAZAO(aRazao)
      .COD_PAIS(aCOD_PAIS)
      .CLIENTE(scliente)
      .FORNEC(sFornec)
      .&End
      .Insert;
  end
  else
  begin
    FDAOFornecedor.This
      .COD_CLIFOR(aCOD_CLIFOR)
      .FANTASIA(aFantasia)
      .COD_ESTADO(aCOD_ESTADO)
      .RAZAO(aRazao)
      .COD_PAIS(aCOD_PAIS)
      .CLIENTE(scliente)
      .FORNEC(sFornec)
      .&End
      .Update;
  end;

end;

function TModelBusinessFornecedor.Excluir(aId: Integer): iModelBusinessFornecedor;
begin
  Result := Self;
  FDAOFornecedor.This
    .COD_CLIFOR(aId)
    .&End
    .Delete
end;

end.
