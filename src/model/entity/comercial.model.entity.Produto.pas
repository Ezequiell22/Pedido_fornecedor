unit comercial.model.entity.Produto;

interface

uses comercial.model.DAO.interfaces;

type
  TModelEntityProduto = class
  private
    [weak]
    FParent: iModelDAOEntity<TModelEntityProduto>;
    FIDPRODUTO: Integer;
    FDESCRICAO: string;
    FMARCA: string;
    FPRECO: Double;
    FACTIVE: Boolean;
  public
    constructor Create(aParent: iModelDAOEntity<TModelEntityProduto>);
    destructor Destroy; override;
    function IDPRODUTO(aValue: Integer): TModelEntityProduto; overload;
    function IDPRODUTO: Integer; overload;
    function DESCRICAO(aValue: string): TModelEntityProduto; overload;
    function DESCRICAO: string; overload;
    function MARCA(aValue: string): TModelEntityProduto; overload;
    function MARCA: string; overload;
    function PRECO(aValue: Double): TModelEntityProduto; overload;
    function PRECO: Double; overload;
    function ACTIVE(aValue: Boolean): TModelEntityProduto; overload;
    function ACTIVE: Boolean; overload;
    function &End: iModelDAOEntity<TModelEntityProduto>;
  end;

implementation

uses System.SysUtils;

function TModelEntityProduto.ACTIVE: Boolean;
begin
  result := FACTIVE
end;

function TModelEntityProduto.ACTIVE(aValue: Boolean): TModelEntityProduto;
begin
  Result := Self;
  FACTIVE := Avalue;
end;

constructor TModelEntityProduto.Create
  (aParent: iModelDAOEntity<TModelEntityProduto>);
begin
  FParent := aParent;
end;

destructor TModelEntityProduto.Destroy;
begin
  inherited;
end;

function TModelEntityProduto.&End: iModelDAOEntity<TModelEntityProduto>;
begin
  Result := FParent;
end;

function TModelEntityProduto.IDPRODUTO(aValue: Integer): TModelEntityProduto;
begin
  Result := Self;
  FIDPRODUTO := aValue;
end;

function TModelEntityProduto.IDPRODUTO: Integer;
begin
  if FIDPRODUTO <= 0 then
    raise Exception.Create('id inválido');
  Result := FIDPRODUTO;
end;

function TModelEntityProduto.DESCRICAO(aValue: string): TModelEntityProduto;
begin
  Result := Self;
  FDESCRICAO := aValue;
end;

function TModelEntityProduto.DESCRICAO: string;
begin
  if Trim(FDESCRICAO) = '' then
    raise Exception.Create('descrição obrigatória');
  Result := FDESCRICAO;
end;

function TModelEntityProduto.MARCA(aValue: string): TModelEntityProduto;
begin
  Result := Self;
  FMARCA := aValue;
end;

function TModelEntityProduto.MARCA: string;
begin
  Result := FMARCA;
end;

function TModelEntityProduto.PRECO(aValue: Double): TModelEntityProduto;
begin
  Result := Self;
  FPRECO := aValue;
end;

function TModelEntityProduto.PRECO: Double;
begin
  if FPRECO < 0 then
    raise Exception.Create('preço inválido');
  Result := FPRECO;
end;

end.
