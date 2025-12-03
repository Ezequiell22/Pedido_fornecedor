unit Comercial.Tests.Migrations;

interface

uses
  DUnitX.TestFramework,
  comercial.model.db.migrations,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD;

type
  [TestFixture]
  TTestMigrations = class
  private
    function Exists(const SQL: string): Boolean;
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure ShouldCreateTables;
    [Test]
    procedure ShouldCreateIndexes;
  end;

implementation

uses
  Data.DB;

procedure TTestMigrations.Setup;
begin
  TDbMigrations.Create.Apply;
end;

function TTestMigrations.Exists(const SQL: string): Boolean;
var
  Q: iQuery;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False).sqlClear.sqlAdd(SQL).open;
  Result := not Q.DataSet.IsEmpty;
end;

procedure TTestMigrations.ShouldCreateTables;
begin
  Assert.IsTrue(Exists('select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = ''FORNECEDORES'''));
  Assert.IsTrue(Exists('select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = ''PEDIDO_COMPRA'''));
  Assert.IsTrue(Exists('select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = ''PEDCOMPRA_ITEM'''));
end;

procedure TTestMigrations.ShouldCreateIndexes;
begin
  Assert.IsTrue(Exists('select name from sys.indexes where name = ''IDX_PEDIDO_COMPRA_CLIFOR'''));
  Assert.IsTrue(Exists('select name from sys.indexes where name = ''IDX_PEDCOMPRA_ITEM_PED'''));
end;

// removed legacy tests for triggers/procedure/unique index from previous project

end.
