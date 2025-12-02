unit comercial.view.ListagemFornecedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, comercial.controller.interfaces;

type
  TfrmListagemFornecedor = class(TForm)
    btnNovo: TButton;
    btnExcluir: TButton;
    btnEditar: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FController: iController;
  public
    { Public declarations }
  end;

var
  frmListagemFornecedor: TfrmListagemFornecedor;

implementation

{$R *.dfm}

uses comercial.view.Fornecedor, comercial.controller;

procedure TfrmListagemFornecedor.btnExcluirClick(Sender: TObject);
begin
  FController.business.Fornecedor.Excluir(DataSource1.DataSet.FieldByName('IDFORNECEDOR')
    .AsInteger).Get;

end;

procedure TfrmListagemFornecedor.btnNovoClick(Sender: TObject);
var frm : TfrmFornecedor;
begin
  frm := TfrmFornecedor.Create(self);

  try
    frm.Caption := 'Novo fornecedor';
    frm.edtid.text := '';
    frm.edtid.ReadOnly := true;
    frm.ShowModal;
  finally
    frm.Free;
  end;

  FController.business.Fornecedor.Get;
end;

procedure TfrmListagemFornecedor.btnEditarClick(Sender: TObject);
var frm : TfrmFornecedor;
begin
  frm := TfrmFornecedor.Create(self);

  try
    frm.Caption := 'Editar fornecedor';
    frm.edtid.text := datasource1.DataSet.FieldByName('IDFORNECEDOR').asString;
    frm.edtid.ReadOnly := true;
    frm.ShowModal;
  finally
    frm.Free;
  end;

  FController.business.Fornecedor.Get;
end;

procedure TfrmListagemFornecedor.FormShow(Sender: TObject);
begin
  FController := TController.New;
  dbgrid1.DataSource := datasource1;
  dbgrid1.Options := dbgrid1.Options - [dgediting];
  FController.business.Fornecedor.Bind(datasource1).Get;
end;

end.
