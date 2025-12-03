unit comercial.model.entity.PedidoCompra;

interface

uses
  Data.DB,
  comercial.model.DAO.interfaces;

type
  TModelEntityPedidoCompra = class
  private
    [weak]
    FParent: iModelDAOEntity<TModelEntityPedidoCompra>;
    FCOD_PEDIDOCOMPRA: Integer;
    FCOD_EMPRESA: Integer;
    FCOD_CLIFOR: Integer;
    FCOD_MOEDA: string;
    FDT_EMISSAO: TDateTime;
    FDT_PREVISTAENTREGA: TDateTime;
    FDT_ENTREGA: TDateTime;
    FTIPO_COMPRA: string;
  public
    constructor Create(aParent: iModelDAOEntity<TModelEntityPedidoCompra>);
    destructor Destroy; override;
    function COD_PEDIDOCOMPRA(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_PEDIDOCOMPRA: Integer; overload;
    function COD_EMPRESA(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_EMPRESA: Integer; overload;
    function COD_CLIFOR(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_CLIFOR: Integer; overload;
    function COD_MOEDA(aValue: string): TModelEntityPedidoCompra; overload;
    function COD_MOEDA: string; overload;
    function DT_EMISSAO(aValue: TDateTime): TModelEntityPedidoCompra; overload;
    function DT_EMISSAO: TDateTime; overload;
    function DT_PREVISTAENTREGA(aValue: TDateTime): TModelEntityPedidoCompra; overload;
    function DT_PREVISTAENTREGA: TDateTime; overload;
    function DT_ENTREGA(aValue: TDateTime): TModelEntityPedidoCompra; overload;
    function DT_ENTREGA: TDateTime; overload;
    function TIPO_COMPRA(aValue: string): TModelEntityPedidoCompra; overload;
    function TIPO_COMPRA: string; overload;
    function &End: iModelDAOEntity<TModelEntityPedidoCompra>;
  end;

implementation

uses System.SysUtils;

constructor TModelEntityPedidoCompra.Create(aParent: iModelDAOEntity<TModelEntityPedidoCompra>);
begin
  FParent := aParent;
end;

destructor TModelEntityPedidoCompra.Destroy;
begin
  inherited;
end;

function TModelEntityPedidoCompra.&End: iModelDAOEntity<TModelEntityPedidoCompra>;
begin
  Result := FParent;
end;

function TModelEntityPedidoCompra.COD_PEDIDOCOMPRA(aValue: Integer): TModelEntityPedidoCompra;
begin
  Result := Self;
  FCOD_PEDIDOCOMPRA := aValue;
end;

function TModelEntityPedidoCompra.COD_PEDIDOCOMPRA: Integer;
begin
  if FCOD_PEDIDOCOMPRA <= 0 then
    raise Exception.Create('id inválido');
  Result := FCOD_PEDIDOCOMPRA;
end;

function TModelEntityPedidoCompra.COD_CLIFOR(aValue: Integer): TModelEntityPedidoCompra;
begin
  Result := Self;
  FCOD_CLIFOR := aValue;
end;

function TModelEntityPedidoCompra.COD_CLIFOR: Integer;
begin
  Result := FCOD_CLIFOR;
end;

function TModelEntityPedidoCompra.COD_EMPRESA(aValue: Integer): TModelEntityPedidoCompra;
begin
  Result := Self;
  FCOD_EMPRESA := aValue;
end;

function TModelEntityPedidoCompra.COD_EMPRESA: Integer;
begin
  Result := FCOD_EMPRESA;
end;

function TModelEntityPedidoCompra.COD_MOEDA(aValue: string): TModelEntityPedidoCompra;
begin
  Result := Self;
  FCOD_MOEDA := aValue;
end;

function TModelEntityPedidoCompra.COD_MOEDA: string;
begin
  Result := FCOD_MOEDA;
end;

function TModelEntityPedidoCompra.DT_EMISSAO(aValue: TDateTime): TModelEntityPedidoCompra;
begin
  Result := Self;
  FDT_EMISSAO := aValue;
end;

function TModelEntityPedidoCompra.DT_EMISSAO: TDateTime;
begin
  Result := FDT_EMISSAO;
end;

function TModelEntityPedidoCompra.DT_PREVISTAENTREGA(aValue: TDateTime): TModelEntityPedidoCompra;
begin
  Result := Self;
  FDT_PREVISTAENTREGA := aValue;
end;

function TModelEntityPedidoCompra.DT_PREVISTAENTREGA: TDateTime;
begin
  Result := FDT_PREVISTAENTREGA;
end;

function TModelEntityPedidoCompra.DT_ENTREGA(aValue: TDateTime): TModelEntityPedidoCompra;
begin
  Result := Self;
  FDT_ENTREGA := aValue;
end;

function TModelEntityPedidoCompra.DT_ENTREGA: TDateTime;
begin
  Result := FDT_ENTREGA;
end;

function TModelEntityPedidoCompra.TIPO_COMPRA(aValue: string): TModelEntityPedidoCompra;
begin
  Result := Self;
  FTIPO_COMPRA := aValue;
end;

function TModelEntityPedidoCompra.TIPO_COMPRA: string;
begin
  Result := FTIPO_COMPRA;
end;

end.
