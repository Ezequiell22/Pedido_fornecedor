unit Language.Translations.Catalog;

interface

uses
  System.SysUtils;

type
  TTranslationEntry = record
    FormClass: string;
    ComponentName: string;
    PropertyName: string;
    TextPt: string;
    TextEn: string;
    TextEs: string;
  end;

  TTranslationCatalog = class
  public
    class function LanguageIndex(const LangCode: string): Integer; static;
    class function TextByIndex(const LangIndex: Integer;
      const Entry: TTranslationEntry): string; static;
    class function MessageText(const LangCode, TextId: string): string; static;
    class function MessageTextByIndex(const LangIndex: Integer;
      const TextId: string): string; static;
    class procedure GetFormEntries(const FormClass: string;
      out Entries: TArray<TTranslationEntry>); static;
    class function AllEntries: TArray<TTranslationEntry>; static;
  end;

implementation

const
  LANG_PT = 1;
  LANG_EN = 2;
  LANG_ES = 3;

function MsgEntry(const Id, Pt, En, Es: string): TTranslationEntry;
begin
  Result.FormClass := '';
  Result.ComponentName := Id;
  Result.PropertyName := 'Message';
  Result.TextPt := Pt;
  Result.TextEn := En;
  Result.TextEs := Es;
end;

function UiEntry(const FormClass, Component, Prop, Pt, En, Es: string): TTranslationEntry;
begin
  Result.FormClass := FormClass;
  Result.ComponentName := Component;
  Result.PropertyName := Prop;
  Result.TextPt := Pt;
  Result.TextEn := En;
  Result.TextEs := Es;
end;

function BuildCatalog: TArray<TTranslationEntry>;
begin
  SetLength(Result, 0);

  // Mensagens de codigo (Translator.Msg / FormatMsg)
  Result := Result + [MsgEntry('MSG_RELATORIO_SALVO',
    'Relatorio salvo em {0}', 'Report saved to {0}', 'Informe guardado en {0}')];
  Result := Result + [MsgEntry('MSG_FANTASIA_OBRIGATORIO',
    'Informe o nome fantasia.', 'Trade name is required.', 'Indique el nombre de fantasia.')];
  Result := Result + [MsgEntry('MSG_RAZAO_OBRIGATORIA',
    'Informe a razao social.', 'Legal name is required.', 'Indique la razon social.')];
  Result := Result + [MsgEntry('MSG_PEDIDO_ID_INVALIDO',
    'Informe um codigo de pedido valido.', 'Enter a valid purchase order id.',
    'Indique un codigo de pedido valido.')];
  Result := Result + [MsgEntry('MSG_FORNECEDOR_ID_INVALIDO',
    'Selecione um fornecedor valido.', 'Select a valid supplier.',
    'Seleccione un proveedor valido.')];
  Result := Result + [MsgEntry('MSG_VALOR_INVALIDO',
    'Informe um valor unitario valido.', 'Enter a valid unit price.',
    'Indique un precio unitario valido.')];
  Result := Result + [MsgEntry('MSG_QUANTIDADE_INVALIDA',
    'Informe uma quantidade valida.', 'Enter a valid quantity.',
    'Indique una cantidad valida.')];
  Result := Result + [MsgEntry('FRM_FORNECEDOR_NOVO',
    'Novo Fornecedor', 'New Supplier', 'Nuevo Proveedor')];
  Result := Result + [MsgEntry('FRM_FORNECEDOR_EDITAR',
    'Editar Fornecedor', 'Edit Supplier', 'Editar Proveedor')];

  // frmIndex
  Result := Result + [UiEntry('TfrmIndex', '', 'Caption',
    'Modulo Comercial', 'Commercial Module', 'Modulo Comercial')];
  Result := Result + [UiEntry('TfrmIndex', 'ButtonFornecedores', 'Caption',
    'Fornecedores', 'Suppliers', 'Proveedores')];
  Result := Result + [UiEntry('TfrmIndex', 'ButtonPedidos', 'Caption',
    'Pedido', 'Purchase Order', 'Pedido')];
  Result := Result + [UiEntry('TfrmIndex', 'buttonPorProduto', 'Caption',
    'Relatorio de Compras por Produto', 'Purchases by Product Report',
    'Informe de Compras por Producto')];
  Result := Result + [UiEntry('TfrmIndex', 'ButtonPorFornecedor', 'Caption',
    'Relatorio de Compras por Fornecedor', 'Purchases by Supplier Report',
    'Informe de Compras por Proveedor')];

  // TfrmFornecedor
  Result := Result + [UiEntry('TfrmFornecedor', '', 'Caption',
    'Fornecedor', 'Supplier', 'Proveedor')];
  Result := Result + [UiEntry('TfrmFornecedor', 'Label1', 'Caption',
    'Codigo', 'Code', 'Codigo')];
  Result := Result + [UiEntry('TfrmFornecedor', 'Label2', 'Caption',
    'Nome Fantasia', 'Trade Name', 'Nombre de Fantasia')];
  Result := Result + [UiEntry('TfrmFornecedor', 'Label3', 'Caption',
    'Razao Social', 'Legal Name', 'Razon Social')];
  Result := Result + [UiEntry('TfrmFornecedor', 'Label4', 'Caption',
    'Cod. Estado', 'State Code', 'Cod. Estado')];
  Result := Result + [UiEntry('TfrmFornecedor', 'Label5', 'Caption',
    'Cod. Pais', 'Country Code', 'Cod. Pais')];
  Result := Result + [UiEntry('TfrmFornecedor', 'btnSalvar', 'Caption',
    'Salvar', 'Save', 'Guardar')];
  Result := Result + [UiEntry('TfrmFornecedor', 'CheckBoxcliente', 'Caption',
    'Cliente', 'Customer', 'Cliente')];
  Result := Result + [UiEntry('TfrmFornecedor', 'CheckBoxFornec', 'Caption',
    'Fornecedor', 'Supplier', 'Proveedor')];

  // frmListagemFornecedor
  Result := Result + [UiEntry('TfrmListagemFornecedor', '', 'Caption',
    'Listagem de Fornecedores', 'Supplier List', 'Listado de Proveedores')];
  Result := Result + [UiEntry('TfrmListagemFornecedor', 'BtnNovo', 'Caption',
    'Novo', 'New', 'Nuevo')];
  Result := Result + [UiEntry('TfrmListagemFornecedor', 'BtnEditar', 'Caption',
    'Editar', 'Edit', 'Editar')];
  Result := Result + [UiEntry('TfrmListagemFornecedor', 'BtnExcluir', 'Caption',
    'Excluir', 'Delete', 'Eliminar')];

  // TfrmPedido
  Result := Result + [UiEntry('TfrmPedido', '', 'Caption',
    'Pedido de Compra', 'Purchase Order', 'Pedido de Compra')];
  Result := Result + [UiEntry('TfrmPedido', 'GroupBox2', 'Caption',
    'Produto', 'Product', 'Producto')];
  Result := Result + [UiEntry('TfrmPedido', 'Label4', 'Caption',
    'Codigo', 'Code', 'Codigo')];
  Result := Result + [UiEntry('TfrmPedido', 'Label5', 'Caption',
    'Valor unitario', 'Unit Price', 'Precio unitario')];
  Result := Result + [UiEntry('TfrmPedido', 'Label6', 'Caption',
    'Quantidade', 'Quantity', 'Cantidad')];
  Result := Result + [UiEntry('TfrmPedido', 'Label2', 'Caption',
    'Produto', 'Product', 'Producto')];
  Result := Result + [UiEntry('TfrmPedido', 'btnAddItem', 'Caption',
    'Adicionar Item', 'Add Item', 'Agregar Item')];
  Result := Result + [UiEntry('TfrmPedido', 'btnEditarItem', 'Caption',
    'Editar Item', 'Edit Item', 'Editar Item')];
  Result := Result + [UiEntry('TfrmPedido', 'btnRemoverItem', 'Caption',
    'Remover Item', 'Remove Item', 'Quitar Item')];
  Result := Result + [UiEntry('TfrmPedido', 'Label1', 'Caption',
    'Codigo pedido', 'Order Code', 'Codigo pedido')];
  Result := Result + [UiEntry('TfrmPedido', 'Label8', 'Caption',
    'Fornecedor', 'Supplier', 'Proveedor')];
  Result := Result + [UiEntry('TfrmPedido', 'btnCriarPedido', 'Caption',
    'Criar Pedido', 'Create Order', 'Crear Pedido')];

  // frmListagemPedido
  Result := Result + [UiEntry('TfrmListagemPedido', '', 'Caption',
    'Listagem de Pedidos', 'Order List', 'Listado de Pedidos')];
  Result := Result + [UiEntry('TfrmListagemPedido', 'LabelFornecedor', 'Caption',
    'Fornecedor', 'Supplier', 'Proveedor')];
  Result := Result + [UiEntry('TfrmListagemPedido', 'LabelPeriodo', 'Caption',
    'Periodo', 'Period', 'Periodo')];
  Result := Result + [UiEntry('TfrmListagemPedido', 'Label1', 'Caption',
    'Codigo pedido', 'Order Code', 'Codigo pedido')];
  Result := Result + [UiEntry('TfrmListagemPedido', 'BtnAplicarFiltros', 'Caption',
    'Aplicar Filtros', 'Apply Filters', 'Aplicar Filtros')];
  Result := Result + [UiEntry('TfrmListagemPedido', 'BtnNovo', 'Caption',
    'Novo', 'New', 'Nuevo')];
  Result := Result + [UiEntry('TfrmListagemPedido', 'BtnEditar', 'Caption',
    'Editar', 'Edit', 'Editar')];
  Result := Result + [UiEntry('TfrmListagemPedido', 'BtnExcluir', 'Caption',
    'Excluir', 'Delete', 'Eliminar')];
  Result := Result + [UiEntry('TfrmListagemPedido', 'ButtonLimparFiltros', 'Caption',
    'Limpar filtros', 'Clear Filters', 'Limpiar filtros')];
end;

class function TTranslationCatalog.LanguageIndex(const LangCode: string): Integer;
var
  Code: string;
begin
  Code := LowerCase(LangCode);
  if Pos('-', Code) > 0 then
    Code := Copy(Code, 1, Pos('-', Code) - 1);
  if Code = 'en' then
    Exit(LANG_EN);
  if Code = 'es' then
    Exit(LANG_ES);
  Result := LANG_PT;
end;

class function TTranslationCatalog.TextByIndex(const LangIndex: Integer;
  const Entry: TTranslationEntry): string;
begin
  case LangIndex of
    LANG_EN: Result := Entry.TextEn;
    LANG_ES: Result := Entry.TextEs;
  else
    Result := Entry.TextPt;
  end;
  if Result = '' then
    Result := Entry.TextPt;
end;

class function TTranslationCatalog.AllEntries: TArray<TTranslationEntry>;
begin
  Result := BuildCatalog;
end;

class function TTranslationCatalog.MessageText(const LangCode,
  TextId: string): string;
begin
  Result := MessageTextByIndex(LanguageIndex(LangCode), TextId);
end;

class function TTranslationCatalog.MessageTextByIndex(const LangIndex: Integer;
  const TextId: string): string;
var
  Entries: TArray<TTranslationEntry>;
  Entry: TTranslationEntry;
begin
  Result := TextId;
  Entries := BuildCatalog;
  for Entry in Entries do
    if (Entry.FormClass = '') and SameText(Entry.ComponentName, TextId) then
      Exit(TextByIndex(LangIndex, Entry));
end;

class procedure TTranslationCatalog.GetFormEntries(const FormClass: string;
  out Entries: TArray<TTranslationEntry>);
var
  All: TArray<TTranslationEntry>;
  Entry: TTranslationEntry;
  List: TArray<TTranslationEntry>;
begin
  SetLength(List, 0);
  All := BuildCatalog;
  for Entry in All do
    if (Entry.FormClass <> '') and SameText(Entry.FormClass, FormClass) then
    begin
      SetLength(List, Length(List) + 1);
      List[High(List)] := Entry;
    end;
  Entries := List;
end;

end.
