unit comercial.view.ListagemFornecedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  comercial.controller.interfaces, comercial.controller;

type
  TfrmListagemFornecedor = class(TForm)
    Grid: TDBGrid;
    DS: TDataSource;
    BtnNovo: TButton;
    BtnEditar: TButton;
    BtnExcluir: TButton;
    procedure FormShow(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnEditarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
  private
    FController: iController;
  public
  end;

var
  frmListagemFornecedor: TfrmListagemFornecedor;

implementation

{$R *.dfm}

uses comercial.view.Fornecedor;

procedure TfrmListagemFornecedor.FormShow(Sender: TObject);
begin
  FController := TController.New;
  FController.business.Fornecedor.Bind(DS).Get;
end;

procedure TfrmListagemFornecedor.BtnNovoClick(Sender: TObject);
begin
  with TfrmFornecedor.Create(self) do
    try
      Caption := 'Novo Fornecedor';
      ShowModal;
    finally
      Free;
    end;
  FController.business.Fornecedor.Get;
end;

procedure TfrmListagemFornecedor.BtnEditarClick(Sender: TObject);
begin
  with TfrmFornecedor.Create(self) do
    try
      Caption := 'Editar Fornecedor';
      edtId.Text := DS.DataSet.FieldByName('COD_CLIFOR').AsString;
      ShowModal;
    finally
      Free;
    end;
  FController.business.Fornecedor.Get;
end;

procedure TfrmListagemFornecedor.BtnExcluirClick(Sender: TObject);
begin
  FController.business.Fornecedor
    .GetById(DS.DataSet.FieldByName('COD_CLIFOR').AsInteger)
    .Excluir;
  FController.business.Fornecedor.Get;
end;

end.
