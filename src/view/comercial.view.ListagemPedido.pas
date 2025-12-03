unit comercial.view.ListagemPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Generics.Collections, comercial.controller.interfaces, Vcl.ExtCtrls;

type
  TfrmListagemPedido = class(TForm)
    GridPedidos: TDBGrid;
    GridItens: TDBGrid;
    DSPedidos: TDataSource;
    DSItens: TDataSource;
    Panel1: TPanel;
    DtIni: TDateTimePicker;
    DtFim: TDateTimePicker;
    CbFornecedor: TComboBox;
    BtnAplicarFiltros: TButton;
    LabelFornecedor: TLabel;
    LabelPeriodo: TLabel;
    BtnNovo: TButton;
    BtnEditar: TButton;
    BtnExcluir: TButton;
    procedure FormShow(Sender: TObject);
    procedure BtnAplicarFiltrosClick(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnEditarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure DSPedidosDataChange(Sender: TObject; Field: TField);
    procedure CbFornecedorSelect(Sender: TObject);
  private
    FController: iController;
    FFornecedorIds: TList<Integer>;
    FIDEMPRESA : Integer;
    procedure LoadFornecedores;
    function SelectedFornecedorId: Integer;
  public
    destructor Destroy; override;
  end;

var
  frmListagemPedido: TfrmListagemPedido;

implementation

{$R *.dfm}

uses
  comercial.controller, comercial.view.Pedido;

procedure TfrmListagemPedido.FormShow(Sender: TObject);
begin
  FIDEMPRESA := 200;
  FController := TController.New;
  FController.business.Pedido.LinkDataSourcePedido(DSPedidos);
  FController.business.Pedido.LinkDataSourceItens(DSItens);

  FFornecedorIds := TList<Integer>.Create;

  GridPedidos.DataSource := DSPedidos;
  GridItens.DataSource := DSItens;


  DtIni.Date := Now - 30;
  DtFim.Date := Now;

  FController
    .business
    .Pedido
    .setIdEmpresa(FIDEMPRESA);

  LoadFornecedores;
end;

procedure TfrmListagemPedido.LoadFornecedores;
var
  ds: TDataSource;
begin
  ds := TDataSource.Create(nil);
  try
    FController.business.Fornecedor.Bind(ds).Get;
    CbFornecedor.Items.Clear;
    FFornecedorIds.Clear;
    ds.DataSet.First;
    while not ds.DataSet.Eof do
    begin
      CbFornecedor.Items.Add(
        ds.DataSet.FieldByName('FANTASIA').AsString
      );
      FFornecedorIds.Add(ds.DataSet.FieldByName('COD_CLIFOR').AsInteger);
      ds.DataSet.Next;
    end;
  finally
    ds.Free;
  end;
end;

function TfrmListagemPedido.SelectedFornecedorId: Integer;
begin
  Result := 0;
  if (CbFornecedor.ItemIndex >= 0)
    and (CbFornecedor.ItemIndex < FFornecedorIds.Count) then
    Result := FFornecedorIds[CbFornecedor.ItemIndex];
end;

procedure TfrmListagemPedido.BtnAplicarFiltrosClick(Sender: TObject);
var
  filters: TDictionary<string, Variant>;
begin
  filters := TDictionary<string, Variant>.Create;
  try
    filters.Add('DT_EMISSAO_INI', DtIni.DateTime);
    filters.Add('DT_EMISSAO_FIM', DtFim.DateTime);
    if SelectedFornecedorId > 0 then
      filters.Add('COD_CLIFOR', SelectedFornecedorId);

    FController
    .business
    .Pedido
    .loadPedidos(filters);

  finally
    filters.Free;
  end;
end;

procedure TfrmListagemPedido.BtnNovoClick(Sender: TObject);
var frm : TfrmPedido;
begin
  frm:= TfrmPedido.Create(self);
  try
    frm.Caption := 'Novo Pedido';
    frm.FIDEMPRESA := FidEmpresa;
    frm.ShowModal;
  finally
    frm.Free;
  end;

  BtnAplicarFiltrosClick(nil);
end;

procedure TfrmListagemPedido.CbFornecedorSelect(Sender: TObject);
begin
   Fcontroller
    .business
      .Pedido
        .setIdFornecedor(SelectedFornecedorId);
end;

procedure TfrmListagemPedido.BtnEditarClick(Sender: TObject);
var frm : TfrmPedido;
begin
  frm := TfrmPedido.Create(self);

  try
    frm.Caption := 'Editar Pedido';
    frm.edtIdPedido.Text := DSPedidos.DataSet.FieldByName('COD_PEDIDOCOMPRA').AsString;
    frm.FIDEMPRESA := DSPedidos.DataSet.FieldByName('COD_EMPRESA').AsInteger;
    frm.edtIdPedidoExit(nil);
    frm.ShowModal;
  finally
    frm.Free;
  end;
  BtnAplicarFiltrosClick(nil);
end;

procedure TfrmListagemPedido.BtnExcluirClick(Sender: TObject);
begin
  FController
    .business
      .Pedido
      .ExcluirPedido;

  BtnAplicarFiltrosClick(nil);
end;

destructor TfrmListagemPedido.Destroy;
begin
  FFornecedorIds.Free;
  inherited;
end;

procedure TfrmListagemPedido.DSPedidosDataChange(Sender: TObject;
  Field: TField);
  var  COD_PEDIDOCOMPRA, COD_EMPRESA : integer;
begin
  COD_PEDIDOCOMPRA := DSPedidos.DataSet.FieldByName('COD_PEDIDOCOMPRA').AsInteger;
  COD_EMPRESA := DSPedidos.DataSet.FieldByName('COD_EMPRESA').AsInteger;

  FController
    .business
    .Pedido
    .setIdPedido(COD_PEDIDOCOMPRA)
    .setIdEmpresa(COD_EMPRESA)
    .GetItems;

end;

end.
