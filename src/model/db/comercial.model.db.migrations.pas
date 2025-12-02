unit comercial.model.db.migrations;

interface

type
  TDbMigrations = class
  private
    function MetadataExists(const SQL: string): Boolean;
    procedure ExecDDL(const SQL: string);
    function HasOrphansPedidoCompra: Boolean;
    function HasOrphansItem: Boolean;
    function CanAddPKFornecedores: Boolean;
    procedure SanitizeData;
    function IsNotNullFornecedores: Boolean;
    function TableExists(const AName: string): Boolean;
  public
    procedure Apply;
  end;

implementation

uses
  Data.DB,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD;

function TDbMigrations.MetadataExists(const SQL: string): Boolean;
var
  Q: iQuery;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False).sqlClear.sqlAdd(SQL).open;
  Result := not Q.DataSet.IsEmpty;
end;

procedure TDbMigrations.ExecDDL(const SQL: string);
var
  Q: iQuery;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False).sqlClear.sqlAdd(SQL).execSql;
end;

function TDbMigrations.HasOrphansPedidoCompra: Boolean;
var
  Q: iQuery;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False).sqlClear
    .sqlAdd('select first 1 1 from PEDIDO_COMPRA pc where pc.COD_CLIFOR is not null and not exists (select 1 from FORNECEDORES f where f.COD_CLIFOR = pc.COD_CLIFOR)')
    .open;
  Result := not Q.DataSet.IsEmpty;
end;

function TDbMigrations.HasOrphansItem: Boolean;
var
  Q: iQuery;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False).sqlClear
    .sqlAdd('select first 1 1 from PEDCOMPRA_ITEM i where not exists (select 1 from PEDIDO_COMPRA p where p.COD_PEDIDOCOMPRA = i.COD_PEDIDOCOMPRA)')
    .open;
  Result := not Q.DataSet.IsEmpty;
end;

function TDbMigrations.CanAddPKFornecedores: Boolean;
var
  Q: iQuery;
  HasNulls, HasDuplicates: Boolean;
begin
  HasNulls := False;
  HasDuplicates := False;
  Q := TModelResourceQueryFD.New;
  Q.active(False).sqlClear
    .sqlAdd('select first 1 1 from FORNECEDORES where COD_CLIFOR is null')
    .open;
  HasNulls := not Q.DataSet.IsEmpty;

  Q.active(False).sqlClear
    .sqlAdd('select first 1 COD_CLIFOR from FORNECEDORES group by COD_CLIFOR having count(*) > 1')
    .open;
  HasDuplicates := not Q.DataSet.IsEmpty;

  Result := (not HasNulls) and (not HasDuplicates);
end;

procedure TDbMigrations.SanitizeData;
begin
  if TableExists('FORNECEDORES') then
  begin
    ExecDDL('delete from FORNECEDORES where COD_CLIFOR is null');
    ExecDDL('delete from FORNECEDORES f where exists (select 1 from FORNECEDORES d where d.COD_CLIFOR = f.COD_CLIFOR and d.RDB$DB_KEY < f.RDB$DB_KEY)');
  end;

  if TableExists('PEDIDO_COMPRA') and TableExists('FORNECEDORES') then
    ExecDDL('update PEDIDO_COMPRA pc set COD_CLIFOR = null where COD_CLIFOR is not null and not exists (select 1 from FORNECEDORES f where f.COD_CLIFOR = pc.COD_CLIFOR)');

  if TableExists('PEDCOMPRA_ITEM') and TableExists('PEDIDO_COMPRA') then
    ExecDDL('delete from PEDCOMPRA_ITEM i where not exists (select 1 from PEDIDO_COMPRA p where p.COD_PEDIDOCOMPRA = i.COD_PEDIDOCOMPRA)');
end;

function TDbMigrations.IsNotNullFornecedores: Boolean;
var
  Q: iQuery;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False).sqlClear
    .sqlAdd('select rf.rdb$null_flag from rdb$relation_fields rf where rf.rdb$relation_name = ''FORNECEDORES'' and rf.rdb$field_name = ''COD_CLIFOR''')
    .open;
  Result := (not Q.DataSet.IsEmpty) and (Q.DataSet.FieldByName('rdb$null_flag').AsInteger = 1);
end;

function TDbMigrations.TableExists(const AName: string): Boolean;
begin
  Result := MetadataExists('select rdb$relation_name from rdb$relations where rdb$relation_name = ''' + AName + '''');
end;

procedure TDbMigrations.Apply;
begin
  if not MetadataExists('select rdb$relation_name from rdb$relations where rdb$relation_name = ''FORNECEDORES''') then
    ExecDDL('create table FORNECEDORES ' + #13#10 +
            '(' + #13#10 +
            '  COD_CLIFOR integer,' + #13#10 +
            '  RAZAO varchar(255),' + #13#10 +
            '  COD_ESTADO varchar(255),' + #13#10 +
            '  FANTASIA varchar(255),' + #13#10 +
            '  COD_PAIS varchar(255),' + #13#10 +
            '  CLIENTE varchar(255),' + #13#10 +
            '  FORNEC varchar(255)' + #13#10 +
            ')');

  SanitizeData;

  if not IsNotNullFornecedores then
    ExecDDL('alter table FORNECEDORES alter COD_CLIFOR set not null');

  if not MetadataExists('select rc.rdb$constraint_name from rdb$relation_constraints rc where rc.rdb$relation_name = ''FORNECEDORES'' and rc.rdb$constraint_type = ''PRIMARY KEY''') then
    if CanAddPKFornecedores then
      ExecDDL('alter table FORNECEDORES add constraint PK_FORNECEDORES primary key (COD_CLIFOR)');

  if not MetadataExists('select rdb$relation_name from rdb$relations where rdb$relation_name = ''PEDIDO_COMPRA''') then
    ExecDDL('create table PEDIDO_COMPRA ' + #13#10 +
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
            ')');

  if MetadataExists('select rdb$relation_name from rdb$relations where rdb$relation_name=''PEDIDO_COMPRA''') then
    if not MetadataExists('select rc.rdb$constraint_name from rdb$relation_constraints rc where rc.rdb$constraint_name = ''FK_PEDCOMPRA_FORNEC''') then
      if not HasOrphansPedidoCompra then
        ExecDDL('alter table PEDIDO_COMPRA add constraint FK_PEDCOMPRA_FORNEC foreign key (COD_CLIFOR) references FORNECEDORES(COD_CLIFOR)');

  if not MetadataExists('select rdb$relation_name from rdb$relations where rdb$relation_name = ''PEDCOMPRA_ITEM''') then
    ExecDDL('create table PEDCOMPRA_ITEM ' + #13#10 +
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
            ')');

  SanitizeData;

  if MetadataExists('select rdb$relation_name from rdb$relations where rdb$relation_name=''PEDCOMPRA_ITEM''') then
    if not MetadataExists('select rc.rdb$constraint_name from rdb$relation_constraints rc where rc.rdb$constraint_name = ''FK_ITEM_PED''') then
      if not HasOrphansItem then
        ExecDDL('alter table PEDCOMPRA_ITEM add constraint FK_ITEM_PED foreign key (COD_PEDIDOCOMPRA) references PEDIDO_COMPRA(COD_PEDIDOCOMPRA)');

  if not MetadataExists('select rdb$index_name from rdb$indices where rdb$index_name = ''IDX_PEDIDO_COMPRA_CLIFOR''') then
    ExecDDL('create index IDX_PEDIDO_COMPRA_CLIFOR on PEDIDO_COMPRA (COD_CLIFOR)');

  if not MetadataExists('select rdb$index_name from rdb$indices where rdb$index_name = ''IDX_PEDCOMPRA_ITEM_PED''') then
    ExecDDL('create index IDX_PEDCOMPRA_ITEM_PED on PEDCOMPRA_ITEM (COD_PEDIDOCOMPRA)');
end;

end.

