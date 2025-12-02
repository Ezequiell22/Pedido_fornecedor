unit Comercial.Tests.Produto;

interface

uses
  DUnitX.TestFramework,
  Data.DB,
  comercial.model.business.interfaces,
  comercial.model.business.Produto,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD;

type
  [TestFixture]
  TTestProduto = class
  private
    function NextId: Integer;
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure InsertUpdateDeleteProduto;
    [Test]
    procedure ShouldEnforceDescricaoUnique;
  end;

implementation

uses
  System.SysUtils;

procedure TTestProduto.Setup;
begin
end;

function TTestProduto.NextId: Integer;
var
  Q: iQuery;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False).sqlClear.sqlAdd('select coalesce(max(IDPRODUTO),0)+1 idN from PRODUTO').open;
  Result := Q.DataSet.FieldByName('idN').AsInteger;
end;

procedure TTestProduto.InsertUpdateDeleteProduto;
var
  B: iModelBusinessProduto;
  id: Integer;
  Q: iQuery;
  Desc: string;
begin
  B := TModelBusinessProduto.New;
  Desc := 'Desc UT ' + FormatDateTime('yyyymmdd_hhnnss', Now);
  B.Salvar(Desc, 'Marca UT', 10.0);
  Q := TModelResourceQueryFD.New;
  Q.active(False).sqlClear.sqlAdd('select max(IDPRODUTO) as ID from PRODUTO').open;
  id := Q.DataSet.FieldByName('ID').AsInteger;
  Assert.IsTrue(id > 0);
  B.Editar(id, Desc + ' UP', 'Marca UP', 12.5);
  Q.active(False).sqlClear.sqlAdd('select * from PRODUTO where IDPRODUTO = :ID').addParam('ID', id).open;
  Assert.AreEqual('Marca UP', Q.DataSet.FieldByName('MARCA').AsString);
  Assert.AreEqual(Double(12.5), Q.DataSet.FieldByName('PRECO').AsFloat);
  B.Excluir(id);
  Q.active(False).sqlClear.sqlAdd('select 1 from PRODUTO where IDPRODUTO = :ID').addParam('ID', id).open;
  Assert.IsTrue(Q.DataSet.IsEmpty);
end;

procedure TTestProduto.ShouldEnforceDescricaoUnique;
var
  B: iModelBusinessProduto;
  Desc: string;
begin
  B := TModelBusinessProduto.New;
  Desc := 'UNIQ DUNITX ' + FormatDateTime('yyyymmdd_hhnnss', Now);
  B.Salvar(Desc, 'M', 1.0);
  Assert.WillRaise(
    procedure
    begin
      TModelBusinessProduto.New.Salvar(Desc, 'M', 1.0);
    end
  );
end;

end.
