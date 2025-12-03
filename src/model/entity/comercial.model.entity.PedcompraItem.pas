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
    FCOD_EMPRESA: Integer;
    FSEQUENCIA: Integer;
    FCOD_Item: Integer;
    FCOD_unidadecompra: string;
    FQTD_PEDIDA: Double;
    FQTD_RECEBIDA: Double;
    FDESCRICAO: string;
    FPRECO_UNITARIO: Double;
    FPERC_DESCTO: Double;
    FVALOR_DESCTO: Double;
    FPERC_FINANC: Double;
    FVALOR_FINANC: Double;
    FVALOR_TOTAL: Double;
    FDT_INCLUSAO: TDateTime;
    FDT_SOLICITADA: TDateTime;
    FDT_RECEBIDA: TDateTime;
  public
    constructor Create(aParent: iModelDAOEntity<TModelEntityPedcompraItem>);
    destructor Destroy; override;
    function COD_PEDIDOCOMPRA(aValue: Integer)
      : TModelEntityPedcompraItem; overload;
    function COD_PEDIDOCOMPRA: Integer; overload;
    function COD_EMPRESA(aValue: Integer): TModelEntityPedcompraItem; overload;
    function COD_EMPRESA: Integer; overload;
    function SEQUENCIA(aValue: Integer): TModelEntityPedcompraItem; overload;
    function SEQUENCIA: Integer; overload;
    function COD_Item(aValue: Integer): TModelEntityPedcompraItem; overload;
    function COD_Item: Integer; overload;
    function COD_unidadecompra(aValue: string)
      : TModelEntityPedcompraItem; overload;
    function COD_unidadecompra: string; overload;
    function QTD_PEDIDA(aValue: Double): TModelEntityPedcompraItem; overload;
    function QTD_PEDIDA: Double; overload;
    function QTD_RECEBIDA(aValue: Double): TModelEntityPedcompraItem; overload;
    function QTD_RECEBIDA: Double; overload;
    function DESCRICAO(aValue: string): TModelEntityPedcompraItem; overload;
    function DESCRICAO: string; overload;
    function PRECO_UNITARIO(aValue: Double): TModelEntityPedcompraItem;
      overload;
    function PRECO_UNITARIO: Double; overload;
    function PERC_DESCTO(aValue: Double): TModelEntityPedcompraItem; overload;
    function PERC_DESCTO: Double; overload;
    function VALOR_DESCTO(aValue: Double): TModelEntityPedcompraItem; overload;
    function VALOR_DESCTO: Double; overload;
    function PERC_FINANC(aValue: Double): TModelEntityPedcompraItem; overload;
    function PERC_FINANC: Double; overload;
    function VALOR_FINANC(aValue: Double): TModelEntityPedcompraItem; overload;
    function VALOR_FINANC: Double; overload;
    function VALOR_TOTAL(aValue: Double): TModelEntityPedcompraItem; overload;
    function VALOR_TOTAL: Double; overload;
    function DT_INCLUSAO(aValue: TDateTime): TModelEntityPedcompraItem;
      overload;
    function DT_INCLUSAO: TDateTime; overload;
    function DT_SOLICITADA(aValue: TDateTime)
      : TModelEntityPedcompraItem; overload;
    function DT_SOLICITADA: TDateTime; overload;
    function DT_RECEBIDA(aValue: TDateTime): TModelEntityPedcompraItem;
      overload;
    function DT_RECEBIDA: TDateTime; overload;
    function &End: iModelDAOEntity<TModelEntityPedcompraItem>;
  end;

implementation

uses System.SysUtils;

constructor TModelEntityPedcompraItem.Create
  (aParent: iModelDAOEntity<TModelEntityPedcompraItem>);
begin
  FParent := aParent;
end;

destructor TModelEntityPedcompraItem.Destroy;
begin
  inherited;
end;

function TModelEntityPedcompraItem.&End
  : iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Result := FParent;
end;

function TModelEntityPedcompraItem.COD_PEDIDOCOMPRA(aValue: Integer)
  : TModelEntityPedcompraItem;
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

function TModelEntityPedcompraItem.COD_EMPRESA(aValue: Integer)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FCOD_EMPRESA := aValue;
end;

function TModelEntityPedcompraItem.COD_EMPRESA: Integer;
begin
  if FCOD_EMPRESA <= 0 then
    raise Exception.Create('id empresa inválido');

  Result := FCOD_EMPRESA;
end;

function TModelEntityPedcompraItem.SEQUENCIA(aValue: Integer)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FSEQUENCIA := aValue;
end;

function TModelEntityPedcompraItem.SEQUENCIA: Integer;
begin
  Result := FSEQUENCIA;
end;

function TModelEntityPedcompraItem.COD_Item(aValue: Integer)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FCOD_Item := aValue;
end;

function TModelEntityPedcompraItem.COD_Item: Integer;
begin
  Result := FCOD_Item;
end;

function TModelEntityPedcompraItem.COD_unidadecompra(aValue: string)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FCOD_unidadecompra := aValue;
end;

function TModelEntityPedcompraItem.COD_unidadecompra: string;
begin
  Result := FCOD_unidadecompra;
end;

function TModelEntityPedcompraItem.QTD_PEDIDA(aValue: Double)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FQTD_PEDIDA := aValue;
end;

function TModelEntityPedcompraItem.QTD_PEDIDA: Double;
begin
  Result := FQTD_PEDIDA;
end;

function TModelEntityPedcompraItem.QTD_RECEBIDA(aValue: Double)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FQTD_RECEBIDA := aValue;
end;

function TModelEntityPedcompraItem.QTD_RECEBIDA: Double;
begin
  Result := FQTD_RECEBIDA;
end;

function TModelEntityPedcompraItem.DESCRICAO(aValue: string)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FDESCRICAO := aValue;
end;

function TModelEntityPedcompraItem.DESCRICAO: string;
begin
  Result := FDESCRICAO;
end;

function TModelEntityPedcompraItem.PRECO_UNITARIO(aValue: Double)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FPRECO_UNITARIO := aValue;
end;

function TModelEntityPedcompraItem.PRECO_UNITARIO: Double;
begin
  Result := FPRECO_UNITARIO;
end;

function TModelEntityPedcompraItem.PERC_DESCTO(aValue: Double)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FPERC_DESCTO := aValue;
end;

function TModelEntityPedcompraItem.PERC_DESCTO: Double;
begin
  Result := FPERC_DESCTO;
end;

function TModelEntityPedcompraItem.VALOR_DESCTO(aValue: Double)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FVALOR_DESCTO := aValue;
end;

function TModelEntityPedcompraItem.VALOR_DESCTO: Double;
begin
  Result := FVALOR_DESCTO;
end;

function TModelEntityPedcompraItem.VALOR_FINANC: Double;
begin
  Result := FVALOR_FINANC
end;

function TModelEntityPedcompraItem.VALOR_FINANC(aValue: Double)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FVALOR_FINANC := aValue
end;

function TModelEntityPedcompraItem.PERC_FINANC(aValue: Double)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FPERC_FINANC := aValue;
end;

function TModelEntityPedcompraItem.PERC_FINANC: Double;
begin
  Result := FPERC_FINANC;
end;

function TModelEntityPedcompraItem.VALOR_TOTAL(aValue: Double)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FVALOR_TOTAL := aValue;
end;

function TModelEntityPedcompraItem.VALOR_TOTAL: Double;
begin
  Result := FVALOR_TOTAL;
end;

function TModelEntityPedcompraItem.DT_INCLUSAO(aValue: TDateTime)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FDT_INCLUSAO := aValue;
end;

function TModelEntityPedcompraItem.DT_INCLUSAO: TDateTime;
begin
  Result := FDT_INCLUSAO;
end;

function TModelEntityPedcompraItem.DT_SOLICITADA(aValue: TDateTime)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FDT_SOLICITADA := aValue;
end;

function TModelEntityPedcompraItem.DT_SOLICITADA: TDateTime;
begin
  Result := FDT_SOLICITADA;
end;

function TModelEntityPedcompraItem.DT_RECEBIDA(aValue: TDateTime)
  : TModelEntityPedcompraItem;
begin
  Result := Self;
  FDT_RECEBIDA := aValue;
end;

function TModelEntityPedcompraItem.DT_RECEBIDA: TDateTime;
begin
  Result := FDT_RECEBIDA;
end;

end.
