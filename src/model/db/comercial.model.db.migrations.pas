procedure TDbMigrations.Apply;
begin
  //
  // ===================== TABELA: FORNECEDORES =====================
  //
  if not MetadataExists(
    'select rdb$relation_name from rdb$relations where rdb$relation_name = ''FORNECEDORES''') then
    ExecDDL(
      'create table FORNECEDORES ' + #13#10 +
      '(' + #13#10 +
      '  COD_CLIFOR integer,' + #13#10 +
      '  RAZAO varchar(255),' + #13#10 +
      '  COD_ESTADO varchar(255),' + #13#10 +
      '  FANTASIA varchar(255),' + #13#10 +
      '  COD_PAIS varchar(255),' + #13#10 +
      '  CLIENTE varchar(255),' + #13#10 +
      '  FORNEC varchar(255)' + #13#10 +
      ')'
    );

  //
  // ===================== TABELA: PEDIDO_COMPRA =====================
  //
  if not MetadataExists(
    'select rdb$relation_name from rdb$relations where rdb$relation_name = ''PEDIDO_COMPRA''') then
    ExecDDL(
      'create table PEDIDO_COMPRA ' + #13#10 +
      '(' + #13#10 +
      '  COD_PEDIDOCOMPRA integer not null,' + #13#10 +
      '  COD_CLIFOR integer,' + #13#10 +
      '  COD_USUARIO integer,' + #13#10 +
      '  TOTAL numeric(18,4),' + #13#10 +
      '  COD_EMPRESA integer,' + #13#10 +
      '  COD_FILIAL integer,' + #13#10 +
      '  COD_DEPARTAMENTO integer,' + #13#10 +
      '  COD_CENTRO_CUSTO integer,' + #13#10 +
      '  DT_EMISSAO date,' + #13#10 +
      '  COD_CONDPAGTO integer,' + #13#10 +
      '  ORDEM_COMPRA varchar(255),' + #13#10 +
      '  VALOR_IMPOSTOS numeric(18,4),' + #13#10 +
      '  COD_COMPRADOR integer,' + #13#10 +
      '  PESO numeric(18,4),' + #13#10 +
      '  VOLUME numeric(18,4),' + #13#10 +
      '  COD_TIPOFRETE integer,' + #13#10 +
      '  DATA_PREVISTA_ENTREGA date,' + #13#10 +
      '  DT_ENTREGA date,' + #13#10 +
      '  TIPO_COMPRA varchar(255),' + #13#10 +
      '  constraint PK_PEDIDO_COMPRA primary key (COD_PEDIDOCOMPRA)' + #13#10 +
      ')'
    );

  //
  // FK PEDIDO_COMPRA → FORNECEDORES
  //
  if MetadataExists('select rdb$relation_name from rdb$relations where rdb$relation_name=''PEDIDO_COMPRA''') then
    ExecDDL(
      'alter table PEDIDO_COMPRA add constraint FK_PEDCOMPRA_FORNEC ' +
      'foreign key (COD_CLIFOR) references FORNECEDORES(COD_CLIFOR)'
    );

  //
  // ===================== TABELA: PEDCOMPRA_ITEM =====================
  //
  if not MetadataExists(
    'select rdb$relation_name from rdb$relations where rdb$relation_name = ''PEDCOMPRA_ITEM''') then
    ExecDDL(
      'create table PEDCOMPRA_ITEM ' + #13#10 +
      '(' + #13#10 +
      '  COD_PEDIDOCOMPRA integer not null,' + #13#10 +
      '  COD_PRODUTO integer,' + #13#10 +
      '  QUANTIDADE numeric(18,4),' + #13#10 +
      '  VL_UNITARIO numeric(18,4),' + #13#10 +
      '  VL_TOTAL numeric(18,4),' + #13#10 +
      '  COD_EMPRESA integer,' + #13#10 +
      '  COD_FILIAL integer,' + #13#10 +
      '  COD_DEPARTAMENTO integer,' + #13#10 +
      '  COD_CENTRO_CUSTO integer,' + #13#10 +
      '  DESCONTO numeric(18,4),' + #13#10 +
      '  ACRESCIMO numeric(18,4),' + #13#10 +
      '  IPI numeric(18,4),' + #13#10 +
      '  VALOR_IPI numeric(18,4),' + #13#10 +
      '  PESO numeric(18,4),' + #13#10 +
      '  VOLUME numeric(18,4),' + #13#10 +
      '  SEQUENCIA integer not null,' + #13#10 +
      '  DT_INCLUSAO date,' + #13#10 +
      '  DT_SOLICITADA date,' + #13#10 +
      '  DT_RECEBIDA date,' + #13#10 +
      '  constraint PK_PEDCOMPRA_ITEM primary key (COD_PEDIDOCOMPRA, SEQUENCIA)' + #13#10 +
      ')'
    );

  //
  // FKs PEDCOMPRA_ITEM
  //
  if MetadataExists('select rdb$relation_name from rdb$relations where rdb$relation_name=''PEDCOMPRA_ITEM''') then
  begin
    ExecDDL(
      'alter table PEDCOMPRA_ITEM add constraint FK_ITEM_PED ' +
      'foreign key (COD_PEDIDOCOMPRA) references PEDIDO_COMPRA(COD_PEDIDOCOMPRA)'
    );

    // Não existe tabela de produtos no Excel — se quiser crio uma.
    // ExecDDL('alter table PEDCOMPRA_ITEM add constraint FK_ITEM_PROD foreign key (COD_PRODUTO) references PRODUTO(COD_PRODUTO)');
  end;

  //
  // Índices recomendados
  //
  if not MetadataExists(
    'select rdb$index_name from rdb$indices where rdb$index_name = ''IDX_PEDIDO_COMPRA_CLIFOR''') then
    ExecDDL('create index IDX_PEDIDO_COMPRA_CLIFOR on PEDIDO_COMPRA (COD_CLIFOR)');

  if not MetadataExists(
    'select rdb$index_name from rdb$indices where rdb$index_name = ''IDX_PEDCOMPRA_ITEM_PED''') then
    ExecDDL('create index IDX_PEDCOMPRA_ITEM_PED on PEDCOMPRA_ITEM (COD_PEDIDOCOMPRA)');

end;
