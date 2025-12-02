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
    procedure ShouldCreateTriggerAndException;
    [Test]
    procedure ShouldCreateUniqueIndexProdutoDescricao;
    [Test]
    procedure ProcedureTopProdutosExists;
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
  Assert.IsTrue(Exists('select rdb$relation_name from rdb$relations where rdb$relation_name = ''FORNECEDOR'''));
  Assert.IsTrue(Exists('select rdb$relation_name from rdb$relations where rdb$relation_name = ''PRODUTO'''));
  Assert.IsTrue(Exists('select rdb$relation_name from rdb$relations where rdb$relation_name = ''PEDIDO'''));
  Assert.IsTrue(Exists('select rdb$relation_name from rdb$relations where rdb$relation_name = ''PEDIDO_ITENS'''));
end;

procedure TTestMigrations.ShouldCreateTriggerAndException;
begin
  Assert.IsTrue(Exists('select rdb$exception_name from rdb$exceptions where rdb$exception_name = ''EX_TELEFONE_OBRIGATORIO'''));
  Assert.IsTrue(Exists('select rdb$trigger_name from rdb$triggers where rdb$trigger_name = ''TRG_FORNECEDOR_TELEFONE'''));
end;

procedure TTestMigrations.ShouldCreateUniqueIndexProdutoDescricao;
begin
  Assert.IsTrue(Exists('select rdb$index_name from rdb$indices where rdb$index_name = ''IDX_PRODUTO_DESCRICAO_UNICO'''));
end;

procedure TTestMigrations.ProcedureTopProdutosExists;
begin
  Assert.IsTrue(Exists('select rdb$procedure_name from rdb$procedures where rdb$procedure_name = ''SP_TOP_PRODUTOS_VENDIDOS'''));
end;

end.
