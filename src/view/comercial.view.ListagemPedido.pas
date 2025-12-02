unit comercial.view.ListagemPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Generics.Collections, comercial.controller.interfaces;

type
  TfrmListagemPedido = class(TForm)
    GridPedidos: TDBGrid;
    GridItens: TDBGrid;
    DSPedidos: TDataSource;
    DSItens: TDataSource;
    LabelPeriodo: TLabel;
    DtIni: TDateTimePicker;
    DtFim: TDateTimePicker;
    LabelFornecedor: TLabel;
    CbFornecedor: TComboBox;
    BtnAplicarFiltros: TButton;
    BtnNovo: TButton;
    BtnEditar: TButton;
    BtnExcluir: TButton;
    procedure FormShow(Sender: TObject);
    procedure BtnAplicarFiltrosClick(Sender: TObject);
    procedure DSPedidosDataChange(Sender: TObject; Field: TField);
    procedure BtnNovoClick(Sender: TObject);
    procedure BtnEditarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
  private
    FController: iController;
    FFornecedorIds: TList<Integer>;
    procedure LoadFornecedores;
    function SelectedFornecedorId: Integer;
  public
  end;

var
  frmListagemPedido: TfrmListagemPedido;

implementation

{$R *.dfm}

uses
  comercial.controller, comercial.view.Pedido;

procedure TfrmListagemPedido.FormShow(Sender: TObject);
begin
  FController := TController.New;
  FFornecedorIds := TList<Integer>.Create;
  GridPedidos.DataSource := DSPedidos;
  GridItens.DataSource := DSItens;
  DSPedidos.OnDataChange := DSPedidosDataChange;
  DtIni.Date := Now - 30;
  DtFim.Date := Now;
  LoadFornecedores;
  BtnAplicarFiltrosClick(nil);
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
  if (CbFornecedor.ItemIndex >= 0) and (CbFornecedor.ItemIndex < FFornecedorIds.Count) then
    Result := FFornecedorIds[CbFornecedor.ItemIndex];
end;

procedure TfrmListagemPedido.BtnAplicarFiltrosClick(Sender: TObject);
var
  filters: TDictionary<string, Variant>;
begin
  filters := TDictionary<string, Variant>.Create;
  try
    filters.Add('DT_EMISSAO_INI', DtIni.Date);
    filters.Add('DT_EMISSAO_FIM', DtFim.Date);
    if SelectedFornecedorId > 0 then
      filters.Add('COD_CLIFOR', SelectedFornecedorId);

    FController.business.Pedido.DAOPedido.Get(filters);
    DSPedidos.DataSet := FController.business.Pedido.DAOPedido.GetDataSet;
    DSPedidosDataChange(nil, nil);
  finally
    filters.Free;
  end;
end;

procedure TfrmListagemPedido.DSPedidosDataChange(Sender: TObject; Field: TField);
var
  id: Integer;
begin
  if Assigned(DSPedidos.DataSet) and not DSPedidos.DataSet.IsEmpty then
  begin
    id := DSPedidos.DataSet.FieldByName('COD_PEDIDOCOMPRA').AsInteger;
    FController.business.Pedido.DAOItens.GetbyId(id);
    DSItens.DataSet := FController.business.Pedido.DAOItens.GetDataSet;
  end
  else
    DSItens.DataSet := nil;
end;

procedure TfrmListagemPedido.BtnNovoClick(Sender: TObject);
begin
  with TfrmPedido.Create(self) do
    try
      Caption := 'Novo Pedido';
      ShowModal;
    finally
      Free;
    end;
  BtnAplicarFiltrosClick(nil);
end;

procedure TfrmListagemPedido.BtnEditarClick(Sender: TObject);
begin
  with TfrmPedido.Create(self) do
    try
      Caption := 'Editar Pedido';
      edtIdPedido.Text := DSPedidos.DataSet.FieldByName('COD_PEDIDOCOMPRA').AsString;
      edtIdPedidoExit(nil);
      ShowModal;
    finally
      Free;
    end;
  BtnAplicarFiltrosClick(nil);
end;

procedure TfrmListagemPedido.BtnExcluirClick(Sender: TObject);
begin
  FController.business.Pedido
    .Abrir(DSPedidos.DataSet.FieldByName('COD_PEDIDOCOMPRA').AsInteger, CbFornecedor)
    .ExcluirPedido;
  BtnAplicarFiltrosClick(nil);
end;

destructor TfrmListagemPedido.Destroy;
begin
  FFornecedorIds.Free;
  inherited;
end;

end.
