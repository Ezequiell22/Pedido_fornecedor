unit Comercial.Tests.Pedido;

interface

uses
  DUnitX.TestFramework,
  Data.DB,
  comercial.model.business.interfaces,
  comercial.model.business.Pedido,
  comercial.model.business.Fornecedor,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD;

type
  [TestFixture]
  TTestPedido = class
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure CreatePedidoAddItem;
  end;

implementation

uses
  System.SysUtils;

procedure TTestPedido.Setup;
begin
end;

procedure TTestPedido.CreatePedidoAddItem;
var
  BFornecedor: iModelBusinessFornecedor;
  BPedido: iModelBusinessPedido;
  Q: iQuery;
  FornecedorId, PedidoId: Integer;
begin
  BFornecedor := TModelBusinessFornecedor.New;

  BFornecedor.Salvar(0, 'Razao UT', 'SP', 'Fantasia UT', 'BR', True, True);
  Q := TModelResourceQueryFD.New;
  Q.active(False).sqlClear.sqlAdd('select max(COD_CLIFOR) as ID from FORNECEDORES where ACTIVE = 1').open;
  FornecedorId := Q.DataSet.FieldByName('ID').AsInteger;

  BPedido := TModelBusinessPedido.New;
  BPedido.setIdEmpresa(1);
  BPedido.Novo;
  Q.active(False).sqlClear.sqlAdd('select max(COD_PEDIDOCOMPRA) as ID from PEDIDO_COMPRA').open;
  PedidoId := Q.DataSet.FieldByName('ID').AsInteger;
  Assert.IsTrue(PedidoId > 0);
  BPedido.setIdPedido(PedidoId).setIdEmpresa(1).setIdFornecedor(FornecedorId);
  BPedido.AdicionarItem(123, 10.0, 2.0, 'Produto 1');

  Q.active(False).sqlClear
    .sqlAdd('select top 1 COD_Item, QTD_PEDIDA from PEDCOMPRA_ITEM where COD_PEDIDOCOMPRA = :ID and COD_EMPRESA = :EMP')
    .addParam('ID', PedidoId)
    .addParam('EMP', 1)
    .open;
  Assert.AreEqual(123, Q.DataSet.FieldByName('COD_Item').AsInteger);
  Assert.AreEqual(Double(2.0), Q.DataSet.FieldByName('QTD_PEDIDA').AsFloat);
end;

end.
