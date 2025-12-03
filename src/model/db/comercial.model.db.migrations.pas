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
    .sqlAdd('select top 1 1 from PEDIDO_COMPRA pc where pc.COD_CLIFOR is not null and not exists (select 1 from FORNECEDORES f where f.COD_CLIFOR = pc.COD_CLIFOR)')
    .open;
  Result := not Q.DataSet.IsEmpty;
end;

function TDbMigrations.HasOrphansItem: Boolean;
var
  Q: iQuery;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False).sqlClear
    .sqlAdd('select top 1 1 from PEDCOMPRA_ITEM i where not exists (select 1 from PEDIDO_COMPRA p where p.COD_PEDIDOCOMPRA = i.COD_PEDIDOCOMPRA)')
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
    .sqlAdd('select top 1 1 from FORNECEDORES where COD_CLIFOR is null')
    .open;
  HasNulls := not Q.DataSet.IsEmpty;

  Q.active(False).sqlClear
    .sqlAdd('select top 1 COD_CLIFOR from FORNECEDORES group by COD_CLIFOR having count(*) > 1')
    .open;
  HasDuplicates := not Q.DataSet.IsEmpty;

  Result := (not HasNulls) and (not HasDuplicates);
end;

procedure TDbMigrations.SanitizeData;
begin
  if TableExists('FORNECEDORES') then
  begin
    ExecDDL('delete from FORNECEDORES where COD_CLIFOR is null');
    ExecDDL('with d as (select COD_CLIFOR, row_number() over (partition by COD_CLIFOR order by COD_CLIFOR) rn from FORNECEDORES) delete from d where rn > 1');
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
    .sqlAdd('select IS_NULLABLE from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = ''FORNECEDORES'' and COLUMN_NAME = ''COD_CLIFOR''')
    .open;
  Result := (not Q.DataSet.IsEmpty) and (UpperCase(Q.DataSet.FieldByName('IS_NULLABLE').AsString) = 'NO');
end;

function TDbMigrations.TableExists(const AName: string): Boolean;
begin
  Result := MetadataExists('select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = ''' + AName + '''');
end;

procedure TDbMigrations.Apply;
begin
  if not TableExists('FORNECEDORES') then
    ExecDDL('create table FORNECEDORES ' + #13#10 +
            '(' + #13#10 +
            '  COD_CLIFOR integer,' + #13#10 +
            '  RAZAO varchar(255),' + #13#10 +
            '  COD_ESTADO varchar(5),' + #13#10 +
            '  FANTASIA varchar(255),' + #13#10 +
            '  COD_PAIS varchar(7),' + #13#10 +
            '  CLIENTE varchar(1),' + #13#10 +
            '  FORNEC varchar(1),' + #13#10 +
            '  ACTIVE integer' + #13#10 +
            ')');

  SanitizeData;

  if not IsNotNullFornecedores then
    ExecDDL('alter table FORNECEDORES alter column COD_CLIFOR int not null');

  if not MetadataExists('select CONSTRAINT_NAME from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = ''FORNECEDORES'' and CONSTRAINT_TYPE = ''PRIMARY KEY''') then
    if CanAddPKFornecedores then
      ExecDDL('alter table FORNECEDORES add constraint PK_FORNECEDORES primary key (COD_CLIFOR)');

  if not TableExists('PEDIDO_COMPRA') then
    ExecDDL('create table PEDIDO_COMPRA ' + #13#10 +
            '(' + #13#10 +
            '  COD_PEDIDOCOMPRA integer not null,' + #13#10 +
            '  COD_EMPRESA integer,' + #13#10 +
            '  COD_CLIFOR integer,' + #13#10 +
            '  COD_MOEDA varchar(20),' + #13#10 +
            '  DT_EMISSAO date,' + #13#10 +
            '  DT_PREVISAOENTREGA date,' + #13#10 +
            '  DT_ENTREGA date,' + #13#10 +
            '  TIPO_COMPRA varchar(255),' + #13#10 +
            '  constraint PK_PEDIDO_COMPRA primary key (COD_PEDIDOCOMPRA, COD_EMPRESA)' + #13#10 +
            ')');

  if TableExists('PEDIDO_COMPRA') then
    if not MetadataExists('select name from sys.foreign_keys where name = ''FK_PEDCOMPRA_FORNEC''') then
      if not HasOrphansPedidoCompra then
        ExecDDL('alter table PEDIDO_COMPRA add constraint FK_PEDCOMPRA_FORNEC foreign key (COD_CLIFOR) references FORNECEDORES(COD_CLIFOR)');

  if not TableExists('PEDCOMPRA_ITEM') then
    ExecDDL('create table PEDCOMPRA_ITEM ' + #13#10 +
            '(' + #13#10 +
            '  COD_PEDIDOCOMPRA integer not null,' + #13#10 +
             '  COD_EMPRESA integer,' + #13#10 +
             '  SEQUENCIA integer not null,' + #13#10 +
             '  COD_Item integer,' + #13#10 +
             '  COD_unidadecompra varchar(20),' + #13#10 +
             '  QTD_PEDIDA numeric(18,4),' + #13#10 +
             '  QTD_RECEBIDA numeric(18,4),' + #13#10 +
             '  DESCRICAO VARCHAR(255),' + #13#10 +
             '  PRECO_UNITARIO numeric(18,4),' + #13#10 +
             '  PERC_DESCTO numeric(18,4),' + #13#10 +
             '  VALOR_DESCTO numeric(18,4),' + #13#10 +
             '  PERC_FINANC numeric(18,4),' + #13#10 +
             '  VALOR_FINANC numeric(18,4),' + #13#10 +
             '  VALOR_TOTAL numeric(18,4),' + #13#10 +
             '  DT_INCLUSAO DATE,' + #13#10 +
             '  DT_SOLICITADA DATE,' + #13#10 +
             '  DT_RECEBIDA DATE,' + #13#10 +
            '  constraint PK_PEDCOMPRA_ITEM primary key (COD_PEDIDOCOMPRA, COD_EMPRESA, SEQUENCIA)' + #13#10 +
            ')');

  SanitizeData;

  if not MetadataExists('select name from sys.indexes where name = ''IDX_PEDIDO_COMPRA_CLIFOR''') then
    ExecDDL('create index IDX_PEDIDO_COMPRA_CLIFOR on PEDIDO_COMPRA (COD_CLIFOR)');

  if not MetadataExists('select name from sys.indexes where name = ''IDX_PEDCOMPRA_ITEM_PED''') then
    ExecDDL('create index IDX_PEDCOMPRA_ITEM_PED on PEDCOMPRA_ITEM (COD_PEDIDOCOMPRA)');
end;

end.
