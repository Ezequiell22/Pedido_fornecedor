unit comercial.model.business.interfaces;

interface

uses System.Generics.Collections,
  Data.DB,
  System.Classes,
  Vcl.CheckLst,
  Vcl.StdCtrls,
  Vcl.DBGrids,
  comercial.model.DAO.interfaces,
  comercial.model.entity.PedidoCompra,
  comercial.model.entity.PedcompraItem;

type

  iModelBusinessPedido = interface
    ['{6E2D3C1A-8E5A-4A6F-8B71-2E6C8146E1C2}']
    function Novo: iModelBusinessPedido;
    function Get: iModelBusinessPedido;
    function Abrir(AcomboBoxFornecedor: TComboBox): iModelBusinessPedido;
    function AdicionarItem(aCodItem: Integer; aValor: Double;
      aQuantidade: Double): iModelBusinessPedido;

    function LinkDataSourcePedido(aDataSource: TDataSource)
      : iModelBusinessPedido;
    function LinkDataSourceItens(aDataSource: TDataSource)
      : iModelBusinessPedido;
    function setIdPedido(aValue: Integer): iModelBusinessPedido;
    function setIdEmpresa(aValue: Integer): iModelBusinessPedido;
    function setIdFornecedor(aValue: Integer): iModelBusinessPedido;
    function RemoverItem(aSequencia: Integer): iModelBusinessPedido;
    function EditarItem(aSequencia: Integer; aValor: Double;
      aQuantidade: Double): iModelBusinessPedido;
    function ExcluirPedido: iModelBusinessPedido;
    function GetItems: iModelBusinessPedido;
    function loadPedidos(AFieldsWhere: TDictionary<string, Variant>)
      : iModelBusinessPedido;
  end;

  iModelBusinessRelatorio = interface
    ['{BFD1E2A4-1F1C-4C76-AE2B-8D6B6A1B1D3C}']
    function GerarPorProduto: iModelBusinessRelatorio;
    function GerarPorFornecedor: iModelBusinessRelatorio;
    function LinkDataSource(aDataSource: TDataSource): iModelBusinessRelatorio;
  end;

  iModelBusinessFornecedor = interface
    ['{1C7D9A4A-6B23-4B3B-9E2A-8A63B6D4F5A1}']
    function Bind(aDataSource: TDataSource): iModelBusinessFornecedor;
    function Get: iModelBusinessFornecedor;
    function GetById(aId: Integer): iModelBusinessFornecedor;
    function Salvar(aCOD_CLIFOR: Integer; aRAZAO, aCOD_ESTADO, aFANTASIA,
      aCOD_PAIS: string; aCLIENTE, aFORNEC: boolean): iModelBusinessFornecedor;
    function Excluir(aId: Integer): iModelBusinessFornecedor;
  end;

  iModelBusinessProduto = interface
    ['{5B29E6D1-37B9-4C8C-8F0C-9D27E3A5B812}']
    function Bind(aDataSource: TDataSource): iModelBusinessProduto;
    function Get: iModelBusinessProduto;
    function GetById(aId: Integer): iModelBusinessProduto;
    function Salvar(aDescricao, aMarca: string; aPreco: Double)
      : iModelBusinessProduto;
    function Editar(aId: Integer; aDescricao, aMarca: string; aPreco: Double)
      : iModelBusinessProduto;
    function Excluir(aId: Integer): iModelBusinessProduto;
  end;

implementation

end.
