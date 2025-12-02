unit Comercial.Tests.Pedido;

interface

uses
  DUnitX.TestFramework,
  Data.DB,
  comercial.model.business.interfaces,
  comercial.model.business.Pedido,
  comercial.model.business.Fornecedor,
  comercial.model.business.Produto,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryIBX;

type
  [TestFixture]
  TTestPedido = class
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure CreatePedidoAddItemAndFinalizeTotal;
  end;

implementation

uses
  System.SysUtils;

procedure TTestPedido.Setup;
begin
end;

procedure TTestPedido.CreatePedidoAddItemAndFinalizeTotal;
var
  BFornecedor: iModelBusinessFornecedor;
  BProduto: iModelBusinessProduto;
  BPedido: iModelBusinessPedido;
  Q: iQuery;
  FornecedorId, ProdutoId, PedidoId: Integer;
  Desc: string;
begin
  BFornecedor := TModelBusinessFornecedor.New;
  BProduto := TModelBusinessProduto.New;

  BFornecedor.Salvar('Fornecedor UT', 'Razao UT', '12.345.678/0001-95', 'End', '999');
  Q := TModelResourceQueryIBX.New;
  Q.active(False).sqlClear.sqlAdd('select max(IDFORNECEDOR) as ID from FORNECEDOR').open;
  FornecedorId := Q.DataSet.FieldByName('ID').AsInteger;

  Desc := 'Produto UT ' + FormatDateTime('yyyymmdd_hhnnss', Now);
  BProduto.Salvar(Desc, 'Marca', 20.0);
  Q.active(False).sqlClear.sqlAdd('select max(IDPRODUTO) as ID from PRODUTO').open;
  ProdutoId := Q.DataSet.FieldByName('ID').AsInteger;

  BPedido := TModelBusinessPedido.New;
  BPedido.setIdFornecedor(FornecedorId).Novo;
  Q.active(False).sqlClear.sqlAdd('select max(IDPEDIDO) as ID from PEDIDO').open;
  PedidoId := Q.DataSet.FieldByName('ID').AsInteger;
  Assert.IsTrue(PedidoId > 0);

  BPedido.setIdproduto(ProdutoId).AdicionarItem(0, 2.0).Finalizar;

  Q.active(False).sqlClear.sqlAdd('select VALOR_TOTAL from PEDIDO where IDPEDIDO = :ID').addParam('ID', PedidoId).open;
  Assert.AreEqual(Double(40.0), Q.DataSet.FieldByName('VALOR_TOTAL').AsFloat);
end;

end.
