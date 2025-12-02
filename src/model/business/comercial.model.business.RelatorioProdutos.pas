unit comercial.model.business.RelatorioProdutos;

interface

uses Data.DB,
comercial.model.resource.interfaces,
comercial.model.resource.impl.queryIBX,
comercial.model.business.interfaces;

type
  TModelBusinessRelatorioProdutos = class(TInterfacedObject, iModelBusinessRelatorioProdutos)
  private
    FQuery: iQuery;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelBusinessRelatorioProdutos;
    function GerarPorProduto(aDtIni, aDtFim: TDateTime): iModelBusinessRelatorioProdutos;
    function GerarPorFornecedor(aDtIni, aDtFim: TDateTime): iModelBusinessRelatorioProdutos;
    function LinkDataSource(aDataSource: TDataSource): iModelBusinessRelatorioProdutos;
  end;

implementation

uses System.SysUtils, comercial.util.printhtml;

constructor TModelBusinessRelatorioProdutos.Create;
begin
  FQuery := TModelResourceQueryIBX.New;
end;

destructor TModelBusinessRelatorioProdutos.Destroy;
begin
  inherited;
end;


function TModelBusinessRelatorioProdutos.GerarPorProduto(aDtIni, aDtFim: TDateTime): iModelBusinessRelatorioProdutos;
begin
  Result := Self;
  TPrintHtmlPedido.GerarRelatorioPorProduto(adtini, adtfim, getcurrentDir);
end;

function TModelBusinessRelatorioProdutos.GerarPorFornecedor(aDtIni, aDtFim: TDateTime): iModelBusinessRelatorioProdutos;
begin
  Result := Self;
  TPrintHtmlPedido.GerarRelatorioPorFornecedor(adtini, adtfim, getcurrentDir);
end;

function TModelBusinessRelatorioProdutos.LinkDataSource(aDataSource: TDataSource): iModelBusinessRelatorioProdutos;
begin
  Result := Self;
  aDataSource.DataSet := FQuery.DataSet;
end;

class function TModelBusinessRelatorioProdutos.New: iModelBusinessRelatorioProdutos;
begin
  Result := Self.Create;
end;

end.
