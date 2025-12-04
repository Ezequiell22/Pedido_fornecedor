program comercial_dunitx_tests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  Comercial.Tests.Fornecedor in 'Comercial.Tests.Fornecedor.pas',
  Comercial.Tests.Pedido in 'Comercial.Tests.Pedido.pas',
  Comercial.Tests.RelatorioHTML in 'Comercial.Tests.RelatorioHTML.pas',
  comercial.model.resource.interfaces in '..\src\model\resource\comercial.model.resource.interfaces.pas',
  comercial.model.resource.impl.factory in '..\src\model\resource\impl\comercial.model.resource.impl.factory.pas',
  comercial.model.resource.impl.queryFD in '..\src\model\resource\impl\comercial.model.resource.impl.queryFD.pas',
  comercial.util.log in '..\src\utils\comercial.util.log.pas',
  comercial.util.printhtml in '..\src\utils\comercial.util.printhtml.pas',
  comercial.model.business.Fornecedor in '..\src\model\business\comercial.model.business.Fornecedor.pas',
  comercial.model.business.interfaces in '..\src\model\business\comercial.model.business.interfaces.pas',
  comercial.model.business.Pedido in '..\src\model\business\comercial.model.business.Pedido.pas',
  comercial.model.DAO.Fornecedor in '..\src\model\DAO\comercial.model.DAO.Fornecedor.pas',
  comercial.model.DAO.interfaces in '..\src\model\DAO\comercial.model.DAO.interfaces.pas',
  comercial.model.validation in '..\src\model\comercial.model.validation.pas',
  comercial.model.entity.Fornecedor in '..\src\model\entity\comercial.model.entity.Fornecedor.pas',
  comercial.model.entity.PedcompraItem in '..\src\model\entity\comercial.model.entity.PedcompraItem.pas',
  comercial.model.entity.PedidoCompra in '..\src\model\entity\comercial.model.entity.PedidoCompra.pas',
  comercial.model.resource.impl.conexaoFD in '..\src\model\resource\impl\comercial.model.resource.impl.conexaoFD.pas',
  comercial.model.DAO.PedcompraItem in '..\src\model\DAO\comercial.model.DAO.PedcompraItem.pas',
  comercial.model.DAO.PedidoCompra in '..\src\model\DAO\comercial.model.DAO.PedidoCompra.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;

begin
  ReportMemoryLeaksOnShutdown := True;

  TDUnitX.RegisterTestFixture(TTestFornecedor);
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
