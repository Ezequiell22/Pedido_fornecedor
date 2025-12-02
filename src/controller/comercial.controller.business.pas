unit comercial.controller.business;

interface

uses
  comercial.controller.interfaces,
  comercial.model.business.interfaces,
  comercial.model.resource.interfaces,
  comercial.model.DAO.interfaces,
  comercial.model.business.Pedido,
  comercial.model.business.RelatorioProdutos,
  comercial.model.business.Fornecedor,
  comercial.model.business.Produto;

type
  TControllerBusiness = class(TInterfacedObject, iControllerBusiness)
  private
    FPedido: iModelBusinessPedido;
    FRelatorio: iModelBusinessRelatorioProdutos;
    FFornecedor: iModelBusinessFornecedor;
    FProduto: iModelBusinessProduto;
  public
    constructor create;
    destructor destroy; override;
    class function New: iControllerBusiness;
    function Pedido: iModelBusinessPedido;
    function RelatorioProdutos: iModelBusinessRelatorioProdutos;
    function Fornecedor: iModelBusinessFornecedor;
    function Produto: iModelBusinessProduto;
  end;

implementation


{ TControllerBusiness }

constructor TControllerBusiness.create;
begin
end;

destructor TControllerBusiness.destroy;
begin

  inherited;
end;

function TControllerBusiness.Pedido: iModelBusinessPedido;
begin
  if not assigned(FPedido) then
    FPedido := TModelBusinessPedido.New;
  result := FPedido;
end;

function TControllerBusiness.RelatorioProdutos: iModelBusinessRelatorioProdutos;
begin
  if not assigned(FRelatorio) then
    FRelatorio := TModelBusinessRelatorioProdutos.New;
  result := FRelatorio;
end;

function TControllerBusiness.Fornecedor: iModelBusinessFornecedor;
begin
  if not assigned(FFornecedor) then
    FFornecedor := TModelBusinessFornecedor.New;
  result := FFornecedor;
end;

function TControllerBusiness.Produto: iModelBusinessProduto;
begin
  if not assigned(FProduto) then
    FProduto := TModelBusinessProduto.New;
  result := FProduto;
end;

class function TControllerBusiness.New: iControllerBusiness;
begin
  result := Self.create;
end;


end.
