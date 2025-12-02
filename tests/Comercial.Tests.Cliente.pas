unit Comercial.Tests.Fornecedor;

interface

uses
  DUnitX.TestFramework,
  Data.DB,
  comercial.model.business.interfaces,
  comercial.model.business.Fornecedor,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryIBX;

type
  [TestFixture]
  TTestFornecedor = class
  private

  public
    [Setup]
    procedure Setup;
    [Test]
    procedure InsertUpdateDeleteFornecedor;
    [Test]
    procedure ShouldEnforceTelefoneTrigger;
  end;

implementation

uses
  System.SysUtils;

procedure TTestFornecedor.Setup;
begin

end;

procedure TTestFornecedor.InsertUpdateDeleteFornecedor;
var
  B: iModelBusinessFornecedor;
  id: Integer;
  Q: iQuery;
begin
  id := 0;

  Q := TModelResourceQueryIBX.New;
  B := TModelBusinessFornecedor.New;

  {}
  B.Salvar('Fantasia UT', 'Razao UT', '12.345.678/0001-95', 'End UT', '999');

  Q.active(False).sqlClear
  .sqlAdd('select max(IDFORNECEDOR) as ID from FORNECEDOR')
  .open;
  id := Q.DataSet.FieldByName('ID').AsInteger;

  Assert.IsTrue(id > 0);

  {}
  B.Editar(id, 'Fantasia UP', 'Razao UP', '12.345.678/0001-95', 'End UP', '888');
  Q.active(False).sqlClear
  .sqlAdd('select * from FORNECEDOR where IDFORNECEDOR = :ID')
  .addParam('ID', id).open;
  Assert.AreEqual('Fantasia UP', Q.DataSet.FieldByName('NM_FANTASIA').AsString);
  Assert.AreEqual('888', Q.DataSet.FieldByName('TELEFONE').AsString);

  {}
  B.Excluir(id);
  Q.active(False).sqlClear.sqlAdd('select 1 from FORNECEDOR where IDFORNECEDOR = :ID').addParam('ID', id).open;
  Assert.IsTrue(Q.DataSet.IsEmpty);
end;

procedure TTestFornecedor.ShouldEnforceTelefoneTrigger;
var
  Q: iQuery;
begin
  Q := TModelResourceQueryIBX.New;
  Assert.WillRaise(
    procedure
    begin
      Q.active(False).sqlClear
        .sqlAdd('insert into FORNECEDOR (IDFORNECEDOR, NM_FANTASIA, RAZAO_SOCIAL, CNPJ, ENDERECO, TELEFONE)')
        .sqlAdd('values ((select coalesce(max(IDFORNECEDOR),0)+1 from FORNECEDOR), ''X'', ''Y'', ''12.345.678/0001-95'', ''Z'', '''')')
        .execSql;
    end
  );
end;

end.
