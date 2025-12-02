unit comercial.view.index;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.WinXCtrls,
  Vcl.Menus,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  comercial.controller.interfaces;

type
  TfrmIndex = class(Tform)
    ButtonFornecedores: TButton;
    ButtonProdutos: TButton;
    ButtonPedidos: TButton;
    ButtonRelatorioTopDois: TButton;
    procedure ButtonProdutosClick(Sender: TObject);
    procedure ButtonFornecedoresClick(Sender: TObject);
    procedure ButtonPedidosClick(Sender: TObject);
    procedure ButtonRelatorioTopDoisClick(Sender: TObject);

  private
    Fcontroller: iController;
  public
  end;

var
  frmIndex: TfrmIndex;

implementation

{$R *.dfm}

uses
  System.UITypes,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  comercial.controller,
  comercial.view.Fornecedor,
  comercial.view.Produto,
  comercial.view.Pedido,
  comercial.view.ListagemFornecedor,
  comercial.view.ListagemProduto,
  comercial.util.printhtml;

procedure TfrmIndex.ButtonFornecedoresClick(Sender: TObject);
begin
  with TfrmListagemFornecedor.Create(self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TfrmIndex.ButtonPedidosClick(Sender: TObject);
begin
  with TfrmPedido.Create(self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TfrmIndex.ButtonProdutosClick(Sender: TObject);
begin
  with TfrmListagemProduto.Create(self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TfrmIndex.ButtonRelatorioTopDoisClick(Sender: TObject);
var
  dtini, dtfim: TdateTime;
begin
  dtini := StrToDateTime('25/11/2025 00:00:00');
  dtfim := StrToDateTime('29/11/2025 23:59:59.999');

  Fcontroller := TController.new;

  Fcontroller.business.RelatorioProdutos.Gerar(dtini,
                      dtfim);

  showMessage('Relatório salvo em ' + GetCurrentDir);
end;

end.
