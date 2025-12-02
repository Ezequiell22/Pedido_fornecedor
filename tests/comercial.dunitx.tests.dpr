program comercial_dunitx_tests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  Comercial.Tests.Migrations in 'Comercial.Tests.Migrations.pas',
  Comercial.Tests.Fornecedor in 'Comercial.Tests.Cliente.pas',
  Comercial.Tests.Produto in 'Comercial.Tests.Produto.pas',
  Comercial.Tests.Pedido in 'Comercial.Tests.Pedido.pas',
  Comercial.Tests.RelatorioHTML in 'Comercial.Tests.RelatorioHTML.pas',
  comercial.model.db.migrations in '..\src\model\db\comercial.model.db.migrations.pas',
  comercial.model.resource.interfaces in '..\src\model\resource\comercial.model.resource.interfaces.pas',
  comercial.model.resource.impl.conexaoIBX in '..\src\model\resource\impl\comercial.model.resource.impl.conexaoIBX.pas',
  comercial.model.resource.impl.factory in '..\src\model\resource\impl\comercial.model.resource.impl.factory.pas',
  comercial.model.resource.impl.queryFD in '..\src\model\resource\impl\comercial.model.resource.impl.queryFD.pas',
  comercial.util.log in '..\src\utils\comercial.util.log.pas',
  comercial.util.printhtml in '..\src\utils\comercial.util.printhtml.pas',
  comercial.model.business.Fornecedor in '..\src\model\business\comercial.model.business.Fornecedor.pas',
  comercial.model.business.interfaces in '..\src\model\business\comercial.model.business.interfaces.pas',
  comercial.model.business.Pedido in '..\src\model\business\comercial.model.business.Pedido.pas',
  comercial.model.business.Produto in '..\src\model\business\comercial.model.business.Produto.pas',
  comercial.model.business.RelatorioProdutos in '..\src\model\business\comercial.model.business.RelatorioProdutos.pas',
  comercial.model.DAO.Fornecedor in '..\src\model\DAO\comercial.model.DAO.Fornecedor.pas',
  comercial.model.DAO.interfaces in '..\src\model\DAO\comercial.model.DAO.interfaces.pas',
  comercial.model.DAO.Produto in '..\src\model\DAO\comercial.model.DAO.Produto.pas',
  comercial.model.entity.Fornecedor in '..\src\model\entity\comercial.model.entity.Fornecedor.pas',
  comercial.model.entity.Produto in '..\src\model\entity\comercial.model.entity.Produto.pas',
  comercial.model.validation in '..\src\model\comercial.model.validation.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;

begin
  ReportMemoryLeaksOnShutdown := True;

  TDUnitX.RegisterTestFixture(TTestMigrations);
  TDUnitX.RegisterTestFixture(TTestFornecedor);
  TDUnitX.RegisterTestFixture(TTestProduto);
  TDUnitX.RegisterTestFixture(TTestPedido);
  TDUnitX.RegisterTestFixture(TTestRelatorioHTML);

  Runner := TDUnitX.CreateRunner;
  Runner.AddLogger(TDUnitXConsoleLogger.Create(True));
  Runner.UseRTTI := True;
  Results := Runner.Execute;

  if Results.AllPassed then
    System.ExitCode := 0
  else
    System.ExitCode := 1;

  Writeln('--- Testes finalizados. Pressione ENTER para sair ---');
  Readln;
end.
