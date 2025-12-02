unit comercial.controller.entity;

interface

uses
  comercial.controller.interfaces,
  comercial.model.DAO.interfaces,
  comercial.model.resource.interfaces,
  comercial.model.entity.cadFornecedor,
  comercial.model.entity.cadProduto,
  Data.DB;

type
  TControllerEntity = class(TInterfacedObject, iControllerEntity)
  private
    FcadFornecedorDAO: iModelDAOEntity<TModelEntityCadFornecedor>;
    FcadProdutoDAO: iModelDAOEntity<TModelEntityCadProduto>;
  public
    constructor create;
    destructor destroy; override;
    class function New: iControllerEntity;
    function cadFornecedor: iModelDAOEntity<TModelEntityCadFornecedor>;
    function cadProduto: iModelDAOEntity<TModelEntityCadProduto>;
end;

implementation

uses
  comercial.model.DAO.CadFornecedor,
  comercial.model.DAO.CadProduto, comercial.model.resource.impl.queryFD;

{ TControllerEntity }

constructor TControllerEntity.create;
begin

end;

destructor TControllerEntity.destroy;
begin

  inherited;
end;


function TControllerEntity.cadFornecedor: iModelDAOEntity<TModelEntityCadFornecedor>;
begin
  if not assigned(FcadFornecedorDAO) then
    FcadFornecedorDAO := TModelDAOCadFornecedor.New;
  result := FcadFornecedorDAO;
end;

function TControllerEntity.cadProduto: iModelDAOEntity<TModelEntityCadProduto>;
begin
  if not assigned(FcadProdutoDAO) then
    FcadProdutoDAO := TModelDAOCadProduto.New;
  result := FcadProdutoDAO;
end;

class function TControllerEntity.New: iControllerEntity;
begin
  result := self.create;
end;

end.
