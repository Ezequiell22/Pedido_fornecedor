unit comercial.model.entity.PedcompraItem;

interface

uses
  Data.DB,
  comercial.model.DAO.interfaces;

type
  TModelEntityPedcompraItem = class
  private
    [weak]
    FParent: iModelDAOEntity<TModelEntityPedcompraItem>;
    FCOD_PEDIDOCOMPRA: Integer;
    FCOD_PRODUTO: Integer;
    FQUANTIDADE: Double;
    FVL_UNITARIO: Double;
    FVL_TOTAL: Double;
    FCOD_EMPRESA: Integer;
    FCOD_FILIAL: Integer;
    FCOD_DEPARTAMENTO: Integer;
    FCOD_CENTRO_CUSTO: Integer;
    FDESCONTO: Double;
    FACRESCIMO: Double;
    FIPI: Double;
    FVALOR_IPI: Double;
    FPESO: Double;
    FVOLUME: Double;
    FSEQUENCIA: Integer;
    FDT_INCLUSAO: TDateTime;
    FDT_SOLICITADA: TDateTime;
    FDT_RECEBIDA: TDateTime;
  public
    constructor Create(aParent: iModelDAOEntity<TModelEntityPedcompraItem>);
    destructor Destroy; override;
    function COD_PEDIDOCOMPRA(aValue: Integer): TModelEntityPedcompraItem; overload;
    function COD_PEDIDOCOMPRA: Integer; overload;
    function COD_PRODUTO(aValue: Integer): TModelEntityPedcompraItem; overload;
    function COD_PRODUTO: Integer; overload;
    function QUANTIDADE(aValue: Double): TModelEntityPedcompraItem; overload;
    function QUANTIDADE: Double; overload;
    function VL_UNITARIO(aValue: Double): TModelEntityPedcompraItem; overload;
    function VL_UNITARIO: Double; overload;
    function VL_TOTAL(aValue: Double): TModelEntityPedcompraItem; overload;
    function VL_TOTAL: Double; overload;
    function COD_EMPRESA(aValue: Integer): TModelEntityPedcompraItem; overload;
    function COD_EMPRESA: Integer; overload;
    function COD_FILIAL(aValue: Integer): TModelEntityPedcompraItem; overload;
    function COD_FILIAL: Integer; overload;
    function COD_DEPARTAMENTO(aValue: Integer): TModelEntityPedcompraItem; overload;
    function COD_DEPARTAMENTO: Integer; overload;
    function COD_CENTRO_CUSTO(aValue: Integer): TModelEntityPedcompraItem; overload;
    function COD_CENTRO_CUSTO: Integer; overload;
    function DESCONTO(aValue: Double): TModelEntityPedcompraItem; overload;
    function DESCONTO: Double; overload;
    function ACRESCIMO(aValue: Double): TModelEntityPedcompraItem; overload;
    function ACRESCIMO: Double; overload;
    function IPI(aValue: Double): TModelEntityPedcompraItem; overload;
    function IPI: Double; overload;
    function VALOR_IPI(aValue: Double): TModelEntityPedcompraItem; overload;
    function VALOR_IPI: Double; overload;
    function PESO(aValue: Double): TModelEntityPedcompraItem; overload;
    function PESO: Double; overload;
    function VOLUME(aValue: Double): TModelEntityPedcompraItem; overload;
    function VOLUME: Double; overload;
    function SEQUENCIA(aValue: Integer): TModelEntityPedcompraItem; overload;
    function SEQUENCIA: Integer; overload;
    function DT_INCLUSAO(aValue: TDateTime): TModelEntityPedcompraItem; overload;
    function DT_INCLUSAO: TDateTime; overload;
    function DT_SOLICITADA(aValue: TDateTime): TModelEntityPedcompraItem; overload;
    function DT_SOLICITADA: TDateTime; overload;
    function DT_RECEBIDA(aValue: TDateTime): TModelEntityPedcompraItem; overload;
    function DT_RECEBIDA: TDateTime; overload;
    function &End: iModelDAOEntity<TModelEntityPedcompraItem>;
  end;

implementation

uses System.SysUtils;

constructor TModelEntityPedcompraItem.Create(aParent: iModelDAOEntity<TModelEntityPedcompraItem>);
begin
  FParent := aParent;
end;

destructor TModelEntityPedcompraItem.Destroy;
begin
  inherited;
end;

function TModelEntityPedcompraItem.&End: iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Result := FParent;
end;

function TModelEntityPedcompraItem.COD_PEDIDOCOMPRA(aValue: Integer): TModelEntityPedcompraItem;
begin
  Result := Self;
  FCOD_PEDIDOCOMPRA := aValue;
end;

function TModelEntityPedcompraItem.COD_PEDIDOCOMPRA: Integer;
begin
  if FCOD_PEDIDOCOMPRA <= 0 then
    raise Exception.Create('id inválido');
  Result := FCOD_PEDIDOCOMPRA;
end;

function TModelEntityPedcompraItem.COD_PRODUTO(aValue: Integer): TModelEntityPedcompraItem;
begin
  Result := Self;
  FCOD_PRODUTO := aValue;
end;

function TModelEntityPedcompraItem.COD_PRODUTO: Integer;
begin
  Result := FCOD_PRODUTO;
end;

function TModelEntityPedcompraItem.QUANTIDADE(aValue: Double): TModelEntityPedcompraItem;
begin
  Result := Self;
  FQUANTIDADE := aValue;
end;

function TModelEntityPedcompraItem.QUANTIDADE: Double;
begin
  Result := FQUANTIDADE;
end;

function TModelEntityPedcompraItem.VL_UNITARIO(aValue: Double): TModelEntityPedcompraItem;
begin
  Result := Self;
  FVL_UNITARIO := aValue;
end;

function TModelEntityPedcompraItem.VL_UNITARIO: Double;
begin
  Result := FVL_UNITARIO;
end;

function TModelEntityPedcompraItem.VL_TOTAL(aValue: Double): TModelEntityPedcompraItem;
begin
  Result := Self;
  FVL_TOTAL := aValue;
end;

function TModelEntityPedcompraItem.VL_TOTAL: Double;
begin
  Result := FVL_TOTAL;
end;

function TModelEntityPedcompraItem.COD_EMPRESA(aValue: Integer): TModelEntityPedcompraItem;
begin
  Result := Self;
  FCOD_EMPRESA := aValue;
end;

function TModelEntityPedcompraItem.COD_EMPRESA: Integer;
begin
  Result := FCOD_EMPRESA;
end;

function TModelEntityPedcompraItem.COD_FILIAL(aValue: Integer): TModelEntityPedcompraItem;
begin
  Result := Self;
  FCOD_FILIAL := aValue;
end;

function TModelEntityPedcompraItem.COD_FILIAL: Integer;
begin
  Result := FCOD_FILIAL;
end;

function TModelEntityPedcompraItem.COD_DEPARTAMENTO(aValue: Integer): TModelEntityPedcompraItem;
begin
  Result := Self;
  FCOD_DEPARTAMENTO := aValue;
end;

function TModelEntityPedcompraItem.COD_DEPARTAMENTO: Integer;
begin
  Result := FCOD_DEPARTAMENTO;
end;

function TModelEntityPedcompraItem.COD_CENTRO_CUSTO(aValue: Integer): TModelEntityPedcompraItem;
begin
  Result := Self;
  FCOD_CENTRO_CUSTO := aValue;
end;

function TModelEntityPedcompraItem.COD_CENTRO_CUSTO: Integer;
begin
  Result := FCOD_CENTRO_CUSTO;
end;

function TModelEntityPedcompraItem.DESCONTO(aValue: Double): TModelEntityPedcompraItem;
begin
  Result := Self;
  FDESCONTO := aValue;
end;

function TModelEntityPedcompraItem.DESCONTO: Double;
begin
  Result := FDESCONTO;
end;

function TModelEntityPedcompraItem.ACRESCIMO(aValue: Double): TModelEntityPedcompraItem;
begin
  Result := Self;
  FACRESCIMO := aValue;
end;

function TModelEntityPedcompraItem.ACRESCIMO: Double;
begin
  Result := FACRESCIMO;
end;

function TModelEntityPedcompraItem.IPI(aValue: Double): TModelEntityPedcompraItem;
begin
  Result := Self;
  FIPI := aValue;
end;

function TModelEntityPedcompraItem.IPI: Double;
begin
  Result := FIPI;
end;

function TModelEntityPedcompraItem.VALOR_IPI(aValue: Double): TModelEntityPedcompraItem;
begin
  Result := Self;
  FVALOR_IPI := aValue;
end;

function TModelEntityPedcompraItem.VALOR_IPI: Double;
begin
  Result := FVALOR_IPI;
end;

function TModelEntityPedcompraItem.PESO(aValue: Double): TModelEntityPedcompraItem;
begin
  Result := Self;
  FPESO := aValue;
end;

function TModelEntityPedcompraItem.PESO: Double;
begin
  Result := FPESO;
end;

function TModelEntityPedcompraItem.VOLUME(aValue: Double): TModelEntityPedcompraItem;
begin
  Result := Self;
  FVOLUME := aValue;
end;

function TModelEntityPedcompraItem.VOLUME: Double;
begin
  Result := FVOLUME;
end;

function TModelEntityPedcompraItem.SEQUENCIA(aValue: Integer): TModelEntityPedcompraItem;
begin
  Result := Self;
  FSEQUENCIA := aValue;
end;

function TModelEntityPedcompraItem.SEQUENCIA: Integer;
begin
  Result := FSEQUENCIA;
end;

function TModelEntityPedcompraItem.DT_INCLUSAO(aValue: TDateTime): TModelEntityPedcompraItem;
begin
  Result := Self;
  FDT_INCLUSAO := aValue;
end;

function TModelEntityPedcompraItem.DT_INCLUSAO: TDateTime;
begin
  Result := FDT_INCLUSAO;
end;

function TModelEntityPedcompraItem.DT_SOLICITADA(aValue: TDateTime): TModelEntityPedcompraItem;
begin
  Result := Self;
  FDT_SOLICITADA := aValue;
end;

function TModelEntityPedcompraItem.DT_SOLICITADA: TDateTime;
begin
  Result := FDT_SOLICITADA;
end;

function TModelEntityPedcompraItem.DT_RECEBIDA(aValue: TDateTime): TModelEntityPedcompraItem;
begin
  Result := Self;
  FDT_RECEBIDA := aValue;
end;

function TModelEntityPedcompraItem.DT_RECEBIDA: TDateTime;
begin
  Result := FDT_RECEBIDA;
end;

end.
