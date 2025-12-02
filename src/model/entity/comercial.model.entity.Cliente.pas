unit comercial.model.entity.Fornecedor;

interface

uses
  comercial.model.DAO.interfaces,
  comercial.model.validation;

type
  TModelEntityFornecedor = class
  private
    [weak]
    FParent: iModelDAOEntity<TModelEntityFornecedor>;
    FCOD_CLIFOR: Integer;
    FRAZAO: string;
    FFANTASIA: string;
    FCOD_ESTADO: string;
    FCOD_PAIS: string;
    FFORNECEDOR: string;
    FFORNEC: string;
    FACTIVE : Boolean;
  public
    constructor Create(aParent: iModelDAOEntity<TModelEntityFornecedor>);
    destructor Destroy; override;
    function COD_CLIFOR(aValue: Integer): TModelEntityFornecedor; overload;
    function COD_CLIFOR: Integer; overload;
    function RAZAO(aValue: string): TModelEntityFornecedor; overload;
    function RAZAO: string; overload;
    function FANTASIA(aValue: string): TModelEntityFornecedor; overload;
    function FANTASIA: string; overload;
    function COD_ESTADO(aValue: string): TModelEntityFornecedor; overload;
    function COD_ESTADO: string; overload;
    function COD_PAIS(aValue: string): TModelEntityFornecedor; overload;
    function COD_PAIS: string; overload;
    function FORNECEDOR(aValue: string): TModelEntityFornecedor; overload;
    function FORNECEDOR: string; overload;
    function FORNEC(aValue: string): TModelEntityFornecedor; overload;
    function FORNEC: string; overload;
    function ACTIVE(aValue: Boolean): TModelEntityFornecedor; overload;
    function ACTIVE: Boolean; overload;
    function &End: iModelDAOEntity<TModelEntityFornecedor>;
  end;

implementation

uses System.SysUtils;

constructor TModelEntityFornecedor.Create(aParent: iModelDAOEntity<TModelEntityFornecedor>);
begin
  FParent := aParent;
end;

destructor TModelEntityFornecedor.Destroy;
begin
  inherited;
end;

function TModelEntityFornecedor.&End: iModelDAOEntity<TModelEntityFornecedor>;
begin
  Result := FParent;
end;

function TModelEntityFornecedor.COD_CLIFOR(aValue: Integer): TModelEntityFornecedor;
begin
  Result := Self;
  FCOD_CLIFOR := aValue;
end;

function TModelEntityFornecedor.COD_CLIFOR: Integer;
begin
  if FCOD_CLIFOR <= 0 then
    raise Exception.Create('id inválido');
  Result := FCOD_CLIFOR;
end;

function TModelEntityFornecedor.FANTASIA(aValue: string): TModelEntityFornecedor;
begin
  Result := Self;
  FFANTASIA := aValue;
end;

function TModelEntityFornecedor.FANTASIA: string;
begin
  Result := FFANTASIA;
end;

function TModelEntityFornecedor.RAZAO(aValue: string): TModelEntityFornecedor;
begin
  Result := Self;
  FRAZAO := aValue;
end;

function TModelEntityFornecedor.RAZAO: string;
begin
  Result := FRAZAO;
end;

function TModelEntityFornecedor.CNPJ(aValue: string): TModelEntityFornecedor;
begin

  Result := Self;

  if not IsValidCNPJ(aValue) then
     raise Exception.Create('CNPJ inválido!');

  FCNPJ := aValue;
end;

function TModelEntityFornecedor.ACTIVE: Boolean;
begin
  result := Factive
end;

function TModelEntityFornecedor.ACTIVE(aValue: Boolean): TModelEntityFornecedor;
begin
  result := Self;
  Factive := Avalue
end;

function TModelEntityFornecedor.CNPJ: string;
begin
  Result := FCNPJ;
end;

function TModelEntityFornecedor.ENDERECO(aValue: string): TModelEntityFornecedor;
begin
  Result := Self;
  FENDERECO := aValue;
end;

function TModelEntityFornecedor.ENDERECO: string;
begin
  Result := FENDERECO;
end;

function TModelEntityFornecedor.TELEFONE(aValue: string): TModelEntityFornecedor;
begin
  Result := Self;
  FTELEFONE := aValue;
end;

function TModelEntityFornecedor.COD_ESTADO(aValue: string): TModelEntityFornecedor;
begin
  Result := Self;
  FCOD_ESTADO := aValue;
end;

function TModelEntityFornecedor.COD_ESTADO: string;
begin
  Result := FCOD_ESTADO;
end;

function TModelEntityFornecedor.COD_PAIS(aValue: string): TModelEntityFornecedor;
begin
  Result := Self;
  FCOD_PAIS := aValue;
end;

function TModelEntityFornecedor.COD_PAIS: string;
begin
  Result := FCOD_PAIS;
end;

function TModelEntityFornecedor.FORNECEDOR(aValue: string): TModelEntityFornecedor;
begin
  Result := Self;
  FFORNECEDOR := aValue;
end;

function TModelEntityFornecedor.FORNECEDOR: string;
begin
  Result := FFORNECEDOR;
end;

function TModelEntityFornecedor.FORNEC(aValue: string): TModelEntityFornecedor;
begin
  Result := Self;
  FFORNEC := aValue;
end;

function TModelEntityFornecedor.FORNEC: string;
begin
  Result := FFORNEC;
end;

function TModelEntityFornecedor.TELEFONE: string;
begin
  if Trim(FTELEFONE) = '' then
    raise Exception.Create('telefone obrigatório');
  Result := FTELEFONE;
end;

end.
