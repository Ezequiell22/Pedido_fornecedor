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
    FCOD_CLIFOR: Integer;
    FCOD_USUARIO: Integer;
    FTOTAL: Double;
    FCOD_EMPRESA: Integer;
    FCOD_FILIAL: Integer;
    FCOD_DEPARTAMENTO: Integer;
    FCOD_CENTRO_CUSTO: Integer;
    FDT_EMISSAO: TDateTime;
    FCOD_CONDPAGTO: Integer;
    FORDEM_COMPRA: string;
    FVALOR_IMPOSTOS: Double;
    FCOD_COMPRADOR: Integer;
    FPESO: Double;
    FVOLUME: Double;
    FCOD_TIPOFRETE: Integer;
    FDATA_PREVISTA_ENTREGA: TDateTime;
    FDT_ENTREGA: TDateTime;
    FTIPO_COMPRA: string;
  public
    constructor Create(aParent: iModelDAOEntity<TModelEntityPedidoCompra>);
    destructor Destroy; override;
    function COD_PEDIDOCOMPRA(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_PEDIDOCOMPRA: Integer; overload;
    function COD_CLIFOR(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_CLIFOR: Integer; overload;
    function COD_USUARIO(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_USUARIO: Integer; overload;
    function TOTAL(aValue: Double): TModelEntityPedidoCompra; overload;
    function TOTAL: Double; overload;
    function COD_EMPRESA(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_EMPRESA: Integer; overload;
    function COD_FILIAL(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_FILIAL: Integer; overload;
    function COD_DEPARTAMENTO(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_DEPARTAMENTO: Integer; overload;
    function COD_CENTRO_CUSTO(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_CENTRO_CUSTO: Integer; overload;
    function DT_EMISSAO(aValue: TDateTime): TModelEntityPedidoCompra; overload;
    function DT_EMISSAO: TDateTime; overload;
    function COD_CONDPAGTO(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_CONDPAGTO: Integer; overload;
    function ORDEM_COMPRA(aValue: string): TModelEntityPedidoCompra; overload;
    function ORDEM_COMPRA: string; overload;
    function VALOR_IMPOSTOS(aValue: Double): TModelEntityPedidoCompra; overload;
    function VALOR_IMPOSTOS: Double; overload;
    function COD_COMPRADOR(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_COMPRADOR: Integer; overload;
    function PESO(aValue: Double): TModelEntityPedidoCompra; overload;
    function PESO: Double; overload;
    function VOLUME(aValue: Double): TModelEntityPedidoCompra; overload;
    function VOLUME: Double; overload;
    function COD_TIPOFRETE(aValue: Integer): TModelEntityPedidoCompra; overload;
    function COD_TIPOFRETE: Integer; overload;
    function DATA_PREVISTA_ENTREGA(aValue: TDateTime): TModelEntityPedidoCompra; overload;
    function DATA_PREVISTA_ENTREGA: TDateTime; overload;
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

function TModelEntityPedidoCompra.COD_USUARIO(aValue: Integer): TModelEntityPedidoCompra;
begin
  Result := Self;
  FCOD_USUARIO := aValue;
end;

function TModelEntityPedidoCompra.COD_USUARIO: Integer;
begin
  Result := FCOD_USUARIO;
end;

function TModelEntityPedidoCompra.TOTAL(aValue: Double): TModelEntityPedidoCompra;
begin
  Result := Self;
  FTOTAL := aValue;
end;

function TModelEntityPedidoCompra.TOTAL: Double;
begin
  Result := FTOTAL;
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

function TModelEntityPedidoCompra.COD_FILIAL(aValue: Integer): TModelEntityPedidoCompra;
begin
  Result := Self;
  FCOD_FILIAL := aValue;
end;

function TModelEntityPedidoCompra.COD_FILIAL: Integer;
begin
  Result := FCOD_FILIAL;
end;

function TModelEntityPedidoCompra.COD_DEPARTAMENTO(aValue: Integer): TModelEntityPedidoCompra;
begin
  Result := Self;
  FCOD_DEPARTAMENTO := aValue;
end;

function TModelEntityPedidoCompra.COD_DEPARTAMENTO: Integer;
begin
  Result := FCOD_DEPARTAMENTO;
end;

function TModelEntityPedidoCompra.COD_CENTRO_CUSTO(aValue: Integer): TModelEntityPedidoCompra;
begin
  Result := Self;
  FCOD_CENTRO_CUSTO := aValue;
end;

function TModelEntityPedidoCompra.COD_CENTRO_CUSTO: Integer;
begin
  Result := FCOD_CENTRO_CUSTO;
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

function TModelEntityPedidoCompra.COD_CONDPAGTO(aValue: Integer): TModelEntityPedidoCompra;
begin
  Result := Self;
  FCOD_CONDPAGTO := aValue;
end;

function TModelEntityPedidoCompra.COD_CONDPAGTO: Integer;
begin
  Result := FCOD_CONDPAGTO;
end;

function TModelEntityPedidoCompra.ORDEM_COMPRA(aValue: string): TModelEntityPedidoCompra;
begin
  Result := Self;
  FORDEM_COMPRA := aValue;
end;

function TModelEntityPedidoCompra.ORDEM_COMPRA: string;
begin
  Result := FORDEM_COMPRA;
end;

function TModelEntityPedidoCompra.VALOR_IMPOSTOS(aValue: Double): TModelEntityPedidoCompra;
begin
  Result := Self;
  FVALOR_IMPOSTOS := aValue;
end;

function TModelEntityPedidoCompra.VALOR_IMPOSTOS: Double;
begin
  Result := FVALOR_IMPOSTOS;
end;

function TModelEntityPedidoCompra.COD_COMPRADOR(aValue: Integer): TModelEntityPedidoCompra;
begin
  Result := Self;
  FCOD_COMPRADOR := aValue;
end;

function TModelEntityPedidoCompra.COD_COMPRADOR: Integer;
begin
  Result := FCOD_COMPRADOR;
end;

function TModelEntityPedidoCompra.PESO(aValue: Double): TModelEntityPedidoCompra;
begin
  Result := Self;
  FPESO := aValue;
end;

function TModelEntityPedidoCompra.PESO: Double;
begin
  Result := FPESO;
end;

function TModelEntityPedidoCompra.VOLUME(aValue: Double): TModelEntityPedidoCompra;
begin
  Result := Self;
  FVOLUME := aValue;
end;

function TModelEntityPedidoCompra.VOLUME: Double;
begin
  Result := FVOLUME;
end;

function TModelEntityPedidoCompra.COD_TIPOFRETE(aValue: Integer): TModelEntityPedidoCompra;
begin
  Result := Self;
  FCOD_TIPOFRETE := aValue;
end;

function TModelEntityPedidoCompra.COD_TIPOFRETE: Integer;
begin
  Result := FCOD_TIPOFRETE;
end;

function TModelEntityPedidoCompra.DATA_PREVISTA_ENTREGA(aValue: TDateTime): TModelEntityPedidoCompra;
begin
  Result := Self;
  FDATA_PREVISTA_ENTREGA := aValue;
end;

function TModelEntityPedidoCompra.DATA_PREVISTA_ENTREGA: TDateTime;
begin
  Result := FDATA_PREVISTA_ENTREGA;
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
