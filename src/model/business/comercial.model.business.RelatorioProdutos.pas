unit comercial.model.business.RelatorioProdutos;

interface

uses Data.DB,
comercial.model.resource.interfaces,
comercial.model.resource.impl.queryFD,
comercial.model.business.interfaces;

type
  TModelBusinessRelatorio = class(TInterfacedObject, iModelBusinessRelatorio)
  private
    FQuery: iQuery;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelBusinessRelatorio;
    function GerarPorProduto: iModelBusinessRelatorio;
    function GerarPorFornecedor: iModelBusinessRelatorio;
    function LinkDataSource(aDataSource: TDataSource): iModelBusinessRelatorio;
  end;

implementation

uses System.SysUtils, comercial.util.printhtml;

constructor TModelBusinessRelatorio.Create;
begin
  FQuery := TModelResourceQueryFD.New;
end;

destructor TModelBusinessRelatorio.Destroy;
begin
  inherited;
end;


function TModelBusinessRelatorio.GerarPorProduto: iModelBusinessRelatorio;
begin
  Result := Self;
  TPrintHtmlPedido.GerarRelatorioPorProduto( getcurrentDir);
end;

function TModelBusinessRelatorio.GerarPorFornecedor: iModelBusinessRelatorio;
begin
  Result := Self;
  TPrintHtmlPedido.GerarRelatorioPorFornecedor( getcurrentDir);
end;

function TModelBusinessRelatorio.LinkDataSource(aDataSource: TDataSource): iModelBusinessRelatorio;
begin
  Result := Self;
  aDataSource.DataSet := FQuery.DataSet;
end;

class function TModelBusinessRelatorio.New: iModelBusinessRelatorio;
begin
  Result := Self.Create;
end;

end.
