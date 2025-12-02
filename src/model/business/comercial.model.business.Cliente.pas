unit comercial.model.business.Fornecedor;

interface

uses
  Data.DB,
  comercial.model.business.interfaces,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryIBX,
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
    function Salvar(aFantasia, aRazao, aCnpj, aEndereco, aTelefone: string): iModelBusinessFornecedor;
    function Editar(aId: Integer; aFantasia, aRazao, aCnpj, aEndereco, aTelefone: string): iModelBusinessFornecedor;
    function Excluir(aId: Integer): iModelBusinessFornecedor;
  end;

implementation

uses System.SysUtils,
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
  FDAOFornecedor
    .GetbyId(aId)
end;

function TModelBusinessFornecedor.Salvar( aFantasia, aRazao, aCnpj, aEndereco, aTelefone: string): iModelBusinessFornecedor;
begin
  Result := Self;

  FDAOFornecedor
    .This
      .FANTASIA(aFantasia)
      .RAZAO(aRazao)
      .&End
    .Insert

end;

function TModelBusinessFornecedor.Editar(aId: Integer; aFantasia, aRazao, aCnpj, aEndereco, aTelefone: string): iModelBusinessFornecedor;
begin
  Result := Self;
  FDAOFornecedor
    .This
      .COD_CLIFOR(Aid)
      .FANTASIA(aFantasia)
      .RAZAO(aRazao)
      .&End
    .Update
end;

function TModelBusinessFornecedor.Excluir(aId: Integer): iModelBusinessFornecedor;
begin
  Result := Self;

  FDAOFornecedor
    .This
      .COD_CLIFOR(Aid)
      .&End
    .Delete

end;

end.
