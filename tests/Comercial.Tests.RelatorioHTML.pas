unit Comercial.Tests.RelatorioHTML;

interface

uses
  DUnitX.TestFramework,
  comercial.util.printhtml;

type
  [TestFixture]
  TTestRelatorioHTML = class
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure ShouldGenerateComprasPorProdutoHTML;
    [Test]
    procedure ShouldGenerateComprasPorFornecedorHTML;
  end;

implementation

uses
  System.SysUtils;

procedure TTestRelatorioHTML.Setup;
begin

end;

procedure TTestRelatorioHTML.ShouldGenerateComprasPorProdutoHTML;
var
  S: string;
begin
  S := TPrintHtmlPedido.GerarRelatorioPorProduto(Now - 30, Now, '');
  Assert.IsTrue(S <> '');
  Assert.IsTrue(Pos('<html', S) > 0);
  Assert.IsTrue(Pos('Compras por Produto', S) > 0);
end;

procedure TTestRelatorioHTML.ShouldGenerateComprasPorFornecedorHTML;
var
  S: string;
begin
  S := TPrintHtmlPedido.GerarRelatorioPorFornecedor(Now - 30, Now, '');
  Assert.IsTrue(S <> '');
  Assert.IsTrue(Pos('<html', S) > 0);
  Assert.IsTrue(Pos('Compras por Fornecedor', S) > 0);
end;

end.
