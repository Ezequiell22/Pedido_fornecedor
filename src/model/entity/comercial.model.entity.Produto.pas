unit comercial.model.entity.Produto;

interface

uses
  Data.DB,
  comercial.model.DAO.interfaces;

type
  TModelEntityProduto = class
  private
    [weak]
    FParent: iModelDAOEntity<TModelEntityProduto>;
    FIDPRODUTO: Integer;
    FDESCRICAO: string;
    FMARCA: string;
    FPRECO: Double;
    FALIQUOTA_ESTADUAL: Double;
  public
    constructor Create(aParent: iModelDAOEntity<TModelEntityProduto>);
    destructor Destroy; override;
    function &End: iModelDAOEntity<TModelEntityProduto>;

    function IDPRODUTO(aValue: Integer): TModelEntityProduto; overload;
    function IDPRODUTO: Integer; overload;

    function DESCRICAO(aValue: string): TModelEntityProduto; overload;
    function DESCRICAO: string; overload;

    function MARCA(aValue: string): TModelEntityProduto; overload;
    function MARCA: string; overload;

    function PRECO(aValue: Double): TModelEntityProduto; overload;
    function PRECO: Double; overload;

    function ALIQUOTA_ESTADUAL(aValue: Double): TModelEntityProduto; overload;
    function ALIQUOTA_ESTADUAL: Double; overload;
  end;

implementation

constructor TModelEntityProduto.Create(aParent: iModelDAOEntity<TModelEntityProduto>);
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
  Result := FIDPRODUTO;
end;

function TModelEntityProduto.DESCRICAO(aValue: string): TModelEntityProduto;
begin
  Result := Self;
  FDESCRICAO := aValue;
end;

function TModelEntityProduto.DESCRICAO: string;
begin
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
  Result := FPRECO;
end;

function TModelEntityProduto.ALIQUOTA_ESTADUAL(aValue: Double): TModelEntityProduto;
begin
  Result := Self;
  FALIQUOTA_ESTADUAL := aValue;
end;

function TModelEntityProduto.ALIQUOTA_ESTADUAL: Double;
begin
  Result := FALIQUOTA_ESTADUAL;
end;

end.
