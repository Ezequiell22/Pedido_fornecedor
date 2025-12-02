unit comercial.model.business.Produto;

interface

uses
  Data.DB,
  comercial.model.business.interfaces,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryIBX,
  comercial.model.DAO.interfaces,
  comercial.model.entity.Produto;

type
  TModelBusinessProduto = class(TInterfacedObject, iModelBusinessProduto)
  private
    FDAOProduto: iModelDAOEntity<TModelEntityProduto>;
  public
    constructor Create;
    class function New: iModelBusinessProduto;
    function Bind(aDataSource: TDataSource): iModelBusinessProduto;
    function Get: iModelBusinessProduto;
    function GetById(aId: Integer): iModelBusinessProduto;
    function Salvar(aDescricao, aMarca: string; aPreco: Double): iModelBusinessProduto;
    function Editar(aId: Integer; aDescricao, aMarca: string; aPreco: Double): iModelBusinessProduto;
    function Excluir(aId: Integer): iModelBusinessProduto;
  end;

implementation

uses System.SysUtils, comercial.model.DAO.Produto;

constructor TModelBusinessProduto.Create;
begin
  FDAOProduto := TmodelDaoProduto.New;
end;

class function TModelBusinessProduto.New: iModelBusinessProduto;
begin
  Result := Self.Create();
end;

function TModelBusinessProduto.Bind(aDataSource: TDataSource): iModelBusinessProduto;
begin
  Result := Self;
  FDAOProduto.DataSet(aDataSource)
end;

function TModelBusinessProduto.Get: iModelBusinessProduto;
begin
  Result := Self;
  FDAOProduto.Get
end;

function TModelBusinessProduto.GetById(aId: Integer): iModelBusinessProduto;
begin
  Result := Self;
  FDAOProduto.GetbyId(aId)
end;

function TModelBusinessProduto.Salvar(aDescricao, aMarca: string; aPreco: Double): iModelBusinessProduto;
begin
  Result := Self;
  FDAOProduto
    .This
      .DESCRICAO(aDescricao)
      .MARCA(aMarca)
      .PRECO(aPreco)
      .&End
    .Insert
end;

function TModelBusinessProduto.Editar(aId: Integer; aDescricao, aMarca: string; aPreco: Double): iModelBusinessProduto;
begin
  Result := Self;
  FDAOProduto
      .This
        .IDPRODUTO(aId)
        .DESCRICAO(aDescricao)
        .MARCA(aMarca)
        .PRECO(aPreco)
        .&End
      .Update
end;

function TModelBusinessProduto.Excluir(aId: Integer): iModelBusinessProduto;
begin
  Result := Self;
   FDAOProduto
        .This
          .IDPRODUTO(aId)
          .&End
        .Delete

end;

end.
