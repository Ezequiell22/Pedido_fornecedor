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
  comercial.model.entity.Fornecedor in 'src\model\entity\comercial.model.entity.Fornecedor.pas',
  comercial.model.entity.PedidoCompra in 'src\model\entity\comercial.model.entity.PedidoCompra.pas',
  comercial.model.entity.PedcompraItem in 'src\model\entity\comercial.model.entity.PedcompraItem.pas',
  comercial.model.entity.Produto in 'src\model\entity\comercial.model.entity.Produto.pas',
  comercial.model.DAO.Fornecedor in 'src\model\DAO\comercial.model.DAO.Fornecedor.pas',
  comercial.model.DAO.PedidoCompra in 'src\model\DAO\comercial.model.DAO.PedidoCompra.pas',
  comercial.model.DAO.PedcompraItem in 'src\model\DAO\comercial.model.DAO.PedcompraItem.pas',
  comercial.model.DAO.Produto in 'src\model\DAO\comercial.model.DAO.Produto.pas',
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
  comercial.view.ListagemPedido in 'src\view\comercial.view.ListagemPedido.pas' {frmListagemPedido},
  Language.Bootstrap in 'src\language\Language.Bootstrap.pas',
  Language.Core.Interfaces in 'src\language\Language.Core.Interfaces.pas',
  Language.Runtime.Config in 'src\language\Language.Runtime.Config.pas',
  Language.Runtime.Logger in 'src\language\Language.Runtime.Logger.pas',
  Language.Runtime.Cache in 'src\language\Language.Runtime.Cache.pas',
  Language.JsonProvider in 'src\language\Language.JsonProvider.pas',
  Language.Runtime.Translator in 'src\language\Language.Runtime.Translator.pas',
  Language.Runtime.Manager in 'src\language\Language.Runtime.Manager.pas',
  Language.VCL.Keys in 'src\language\Language.VCL.Keys.pas',
  Language.VCL.ComponentWalker in 'src\language\Language.VCL.ComponentWalker.pas',
  Language.VCL.Hook in 'src\language\Language.VCL.Hook.pas';

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

  Application.Initialize;
  TLanguageBootstrap.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmIndex, frmIndex);
  Application.CreateForm(TfrmListagemPedido, frmListagemPedido);
  Translator.TranslateForm(frmIndex);
  Translator.TranslateForm(frmListagemPedido);
  Application.Run;

end.
