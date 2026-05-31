program comercial_dunitx_tests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Vcl.Forms,
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
  Language.Bootstrap in '..\src\language\Language.Bootstrap.pas',
  Language.Core.Interfaces in '..\src\language\Language.Core.Interfaces.pas',
  Language.Runtime.Config in '..\src\language\Language.Runtime.Config.pas',
  Language.Runtime.Logger in '..\src\language\Language.Runtime.Logger.pas',
  Language.Runtime.Cache in '..\src\language\Language.Runtime.Cache.pas',
  Language.JsonProvider in '..\src\language\Language.JsonProvider.pas',
  Language.Runtime.Translator in '..\src\language\Language.Runtime.Translator.pas',
  Language.Runtime.Manager in '..\src\language\Language.Runtime.Manager.pas',
  Language.VCL.Keys in '..\src\language\Language.VCL.Keys.pas',
  Language.VCL.ComponentWalker in '..\src\language\Language.VCL.ComponentWalker.pas',
  Language.VCL.Hook in '..\src\language\Language.VCL.Hook.pas',
  Language.Tools.Validator in '..\src\language\Language.Tools.Validator.pas',
  Language.Tests.Helpers in 'Language.Tests.Helpers.pas',
  Language.Tests.Config in 'Language.Tests.Config.pas',
  Language.Tests.Cache in 'Language.Tests.Cache.pas',
  Language.Tests.JsonProvider in 'Language.Tests.JsonProvider.pas',
  Language.Tests.Translator in 'Language.Tests.Translator.pas',
  Language.Tests.Manager in 'Language.Tests.Manager.pas',
  Language.Tests.Validator in 'Language.Tests.Validator.pas',
  Language.Tests.Keys in 'Language.Tests.Keys.pas',
  Language.Tests.VCL in 'Language.Tests.VCL.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;

  TDUnitX.RegisterTestFixture(TTestFornecedor);
  TDUnitX.RegisterTestFixture(TTestPedido);
  TDUnitX.RegisterTestFixture(TTestRelatorioHTML);
  TDUnitX.RegisterTestFixture(TTestLanguageConfig);
  TDUnitX.RegisterTestFixture(TTestLanguageCache);
  TDUnitX.RegisterTestFixture(TTestLanguageJsonProvider);
  TDUnitX.RegisterTestFixture(TTestLanguageTranslator);
  TDUnitX.RegisterTestFixture(TTestLanguageManager);
  TDUnitX.RegisterTestFixture(TTestLanguageValidator);
  TDUnitX.RegisterTestFixture(TTestLanguageKeys);
  TDUnitX.RegisterTestFixture(TTestLanguageVCL);

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
