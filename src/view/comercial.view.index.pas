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
    ButtonPedidos: TButton;
    buttonPorProduto: TButton;
    ButtonPorFornecedor: TButton;
    procedure ButtonFornecedoresClick(Sender: TObject);
    procedure ButtonPedidosClick(Sender: TObject);
    procedure buttonPorProdutoClick(Sender: TObject);
    procedure ButtonPorFornecedorClick(Sender: TObject);

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
  comercial.view.Pedido,
  comercial.view.ListagemFornecedor,
  comercial.util.printhtml,
  comercial.view.ListagemPedido;

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
  with TfrmListagemPedido.Create(self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TfrmIndex.ButtonPorFornecedorClick(Sender: TObject);

begin
  Fcontroller := TController.new;

  Fcontroller.business
    .Relatorio
    .GerarPorFornecedor();

  showMessage('Relatório salvo em ' + GetCurrentDir);

end;

procedure TfrmIndex.buttonPorProdutoClick(Sender: TObject);
begin

  Fcontroller := TController.new;

  Fcontroller.business
    .Relatorio
    .GerarPorProduto();

  showMessage('Relatório salvo em ' + GetCurrentDir);

end;

end.
