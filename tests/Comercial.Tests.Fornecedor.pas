unit Comercial.Tests.Fornecedor;

interface

uses
  DUnitX.TestFramework,
  Data.DB,
  comercial.model.business.interfaces,
  comercial.model.business.Fornecedor,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD;

type
  [TestFixture]
  TTestFornecedor = class
  private

  public
    [Setup]
    procedure Setup;
    [Test]
    procedure InsertUpdateSoftDeleteFornecedor;
  end;

implementation

uses
  System.SysUtils;

procedure TTestFornecedor.Setup;
begin

end;

procedure TTestFornecedor.InsertUpdateSoftDeleteFornecedor;
var
  B: iModelBusinessFornecedor;
  id: Integer;
  Q: iQuery;
begin
  id := 0;

  Q := TModelResourceQueryFD.New;
  B := TModelBusinessFornecedor.New;

  // insert
  B.Salvar(0, 'Razao UT', 'SP', 'Fantasia UT', 'BR', True, False);

  Q.active(False).sqlClear
  .sqlAdd('select max(COD_CLIFOR) as ID from FORNECEDORES where ACTIVE = 1')
  .open;
  id := Q.DataSet.FieldByName('ID').AsInteger;

  Assert.IsTrue(id > 0);

  // update via Salvar
  B.Salvar(id, 'Razao UP', 'RJ', 'Fantasia UP', 'BR', False, True);
  Q.active(False).sqlClear
  .sqlAdd('select * from FORNECEDORES where COD_CLIFOR = :ID')
  .addParam('ID', id).open;
  Assert.AreEqual('Fantasia UP', Q.DataSet.FieldByName('FANTASIA').AsString);
  Assert.AreEqual('S', Q.DataSet.FieldByName('FORNEC').AsString);
  Assert.AreEqual('N', Q.DataSet.FieldByName('CLIENTE').AsString);

  // soft delete sets ACTIVE = 0
  B.Excluir(id);
  Q.active(False).sqlClear
    .sqlAdd('select ACTIVE from FORNECEDORES where COD_CLIFOR = :ID')
    .addParam('ID', id).open;
  Assert.AreEqual(0, Q.DataSet.FieldByName('ACTIVE').AsInteger);
end;

end.
