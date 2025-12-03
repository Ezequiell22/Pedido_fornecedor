program comercial;

uses
  Vcl.Forms,
  System.IniFiles,
  System.SysUtils,
  comercial.view.index in 'src\view\comercial.view.index.pas' {frmIndex},
  comercial.controller.interfaces in 'src\controller\comercial.controller.interfaces.pas',
  comercial.controller in 'src\controller\comercial.controller.pas',
  comercial.controller.business in 'src\controller\comercial.controller.business.pas',
  comercial.model.business.interfaces in 'src\model\business\comercial.model.business.interfaces.pas',
  comercial.model.resource.interfaces in 'src\model\resource\comercial.model.resource.interfaces.pas',
  comercial.model.db.migrations in 'src\model\db\comercial.model.db.migrations.pas',
  comercial.model.entity.Fornecedor in 'src\model\entity\comercial.model.entity.Fornecedor.pas',
  comercial.model.entity.PedidoCompra in 'src\model\entity\comercial.model.entity.PedidoCompra.pas',
  comercial.model.entity.PedcompraItem in 'src\model\entity\comercial.model.entity.PedcompraItem.pas',
  comercial.model.DAO.Fornecedor in 'src\model\DAO\comercial.model.DAO.Fornecedor.pas',
  comercial.model.DAO.PedidoCompra in 'src\model\DAO\comercial.model.DAO.PedidoCompra.pas',
  comercial.model.DAO.PedcompraItem in 'src\model\DAO\comercial.model.DAO.PedcompraItem.pas',
  comercial.model.business.Pedido in 'src\model\business\comercial.model.business.Pedido.pas',
  comercial.model.business.RelatorioProdutos in 'src\model\business\comercial.model.business.RelatorioProdutos.pas',
  comercial.view.Fornecedor in 'src\view\comercial.view.Fornecedor.pas' {TfrmFornecedor},
  comercial.view.Pedido in 'src\view\comercial.view.Pedido.pas' {TfrmPedido},
  comercial.model.DAO.interfaces in 'src\model\DAO\comercial.model.DAO.interfaces.pas',
  comercial.model.validation in 'src\model\comercial.model.validation.pas',
  comercial.view.ListagemFornecedor in 'src\view\comercial.view.ListagemFornecedor.pas' {frmListagemFornecedor},
  comercial.model.business.Fornecedor in 'src\model\business\comercial.model.business.Fornecedor.pas',
  comercial.model.resource.impl.conexaoFD in 'src\model\resource\impl\comercial.model.resource.impl.conexaoFD.pas',
  comercial.model.resource.impl.factory in 'src\model\resource\impl\comercial.model.resource.impl.factory.pas',
  comercial.model.resource.impl.queryFD in 'src\model\resource\impl\comercial.model.resource.impl.queryFD.pas',
  comercial.util.log in 'src\utils\comercial.util.log.pas',
  comercial.util.printhtml in 'src\utils\comercial.util.printhtml.pas',
  comercial.model.db.migrations.seed in 'src\model\db\comercial.model.db.migrations.seed.pas',
  comercial.view.ListagemPedido in 'src\view\comercial.view.ListagemPedido.pas' {frmListagemPedido};

{$R *.res}

type
  TAppExceptionLogger = class
  public
    procedure Handle(Sender: TObject; E: Exception);
  end;

procedure TAppExceptionLogger.Handle(Sender: TObject; E: Exception);
begin
  try
    TLog.Error('Unhandled: ' + E.ClassName + ' | ' + E.Message);
  except
  end;
end;

var
  AppExceptionLogger: TAppExceptionLogger;
begin
  { COD EMPRESA 204}

  AppExceptionLogger := TAppExceptionLogger.Create;
  Application.OnException := AppExceptionLogger.Handle;
//  var
//  Mig := TDbMigrations.Create;
//  try
//    Mig.Apply;
//  finally
//    Mig.Free;
//  end;
//
//  Var MigData := TDbMigrationsSeed.Create;
//  try
//    MigData.Apply('C:\Pedido_fornecedor\Base_Teste_Vaga_Delphi.xlsx');
//  finally
//    MigData.Free;
//  end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmIndex, frmIndex);
  Application.CreateForm(TfrmListagemPedido, frmListagemPedido);
  Application.Run;

end.
