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
  comercial.model.entity.Fornecedor in 'src\model\entity\comercial.model.entity.Cliente.pas',
  comercial.model.entity.PedidoCompra in 'src\model\entity\comercial.model.entity.PedidoCompra.pas',
  comercial.model.entity.PedcompraItem in 'src\model\entity\comercial.model.entity.PedcompraItem.pas',
  comercial.model.entity.Produto in 'src\model\entity\comercial.model.entity.Produto.pas',
  comercial.model.DAO.Fornecedor in 'src\model\DAO\comercial.model.DAO.Cliente.pas',
  comercial.model.DAO.PedidoCompra in 'src\model\DAO\comercial.model.DAO.PedidoCompra.pas',
  comercial.model.DAO.PedcompraItem in 'src\model\DAO\comercial.model.DAO.PedcompraItem.pas',
  comercial.model.DAO.Produto in 'src\model\DAO\comercial.model.DAO.Produto.pas',
  comercial.model.business.Pedido in 'src\model\business\comercial.model.business.Pedido.pas',
  comercial.model.business.RelatorioProdutos in 'src\model\business\comercial.model.business.RelatorioProdutos.pas',
  comercial.view.Fornecedor in 'src\view\comercial.view.Cliente.pas' {TfrmFornecedor},
  comercial.view.Produto in 'src\view\comercial.view.Produto.pas' {TfrmProduto},
  comercial.view.Pedido in 'src\view\comercial.view.Pedido.pas' {TfrmPedido},
  comercial.model.DAO.interfaces in 'src\model\DAO\comercial.model.DAO.interfaces.pas',
  comercial.model.validation in 'src\model\comercial.model.validation.pas',
  comercial.view.ListagemFornecedor in 'src\view\comercial.view.ListagemCliente.pas' {frmListagemFornecedor},
  comercial.model.business.Fornecedor in 'src\model\business\comercial.model.business.Cliente.pas',
  comercial.model.business.Produto in 'src\model\business\comercial.model.business.Produto.pas',
  comercial.model.resource.impl.conexaoIBX in 'src\model\resource\impl\comercial.model.resource.impl.conexaoIBX.pas',
  comercial.model.resource.impl.factory in 'src\model\resource\impl\comercial.model.resource.impl.factory.pas',
  comercial.model.resource.impl.queryIBX in 'src\model\resource\impl\comercial.model.resource.impl.queryIBX.pas',
  comercial.view.ListagemProduto in 'src\view\comercial.view.ListagemProduto.pas' {frmListagemProduto},
  comercial.util.log in 'src\utils\comercial.util.log.pas',
  comercial.util.printhtml in 'src\utils\comercial.util.printhtml.pas';

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
  AppExceptionLogger := TAppExceptionLogger.Create;
  Application.OnException := AppExceptionLogger.Handle;
  var
  Mig := TDbMigrations.Create;
  try
    Mig.Apply;
  finally
    Mig.Free;
  end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmIndex, frmIndex);
  Application.Run;

end.
