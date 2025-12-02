unit comercial.view.ListagemProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, comercial.controller.interfaces;

type
  TfrmListagemProduto = class(TForm)
    DBGrid1: TDBGrid;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    DataSource1: TDataSource;
    procedure btnExcluirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FController: iController;
  public
    { Public declarations }
  end;

var
  frmListagemProduto: TfrmListagemProduto;

implementation

uses
  comercial.view.Produto, comercial.controller;

{$R *.dfm}

procedure TfrmListagemProduto.btnEditarClick(Sender: TObject);
var
  frm: TfrmProduto;
begin
  frm := TfrmProduto.Create(self);

  try
    frm.Caption := 'Editar Produto';
    frm.edtid.text := DataSource1.DataSet.FieldByName('idproduto').asString;
    frm.edtid.ReadOnly := true;
    frm.ShowModal;
  finally
    frm.Free;
  end;

  FController.business.Produto.Get;

end;

procedure TfrmListagemProduto.btnExcluirClick(Sender: TObject);
begin
  FController.business.Produto.Excluir
    (DataSource1.DataSet.FieldByName('IDPRODUTO').AsInteger).Get;

end;

procedure TfrmListagemProduto.btnNovoClick(Sender: TObject);
var
  frm: TfrmProduto;
begin
  frm := TfrmProduto.Create(self);

  try
    frm.Caption := 'Novo Produto';
    frm.edtid.text := EmptyStr;
    frm.edtid.ReadOnly := true;
    frm.ShowModal;
  finally
    frm.Free;
  end;

  FController.business.Produto.Get;

end;

procedure TfrmListagemProduto.FormShow(Sender: TObject);
begin
  FController := TController.New;
  DBGrid1.DataSource := DataSource1;
  dbgrid1.Options := dbgrid1.Options - [dgediting];
  FController.business.Produto.Bind(DataSource1).Get;
end;

end.
