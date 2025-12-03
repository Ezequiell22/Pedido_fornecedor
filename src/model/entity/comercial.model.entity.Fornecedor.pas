{ copied from Cliente.pas with same unit name }
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
    FCLIENTE: string;
    FFORNEC: string;
    FACTIVE: Integer;
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
    function CLIENTE(aValue: string): TModelEntityFornecedor; overload;
    function CLIENTE: string; overload;
    function FORNEC(aValue: string): TModelEntityFornecedor; overload;
    function FORNEC: string; overload;
    function ACTIVE(aValue: Integer): TModelEntityFornecedor; overload;
    function ACTIVE: Integer; overload;
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

function TModelEntityFornecedor.ACTIVE: Integer;
begin
  Result := FACTIVE;
end;

function TModelEntityFornecedor.ACTIVE(aValue: Integer): TModelEntityFornecedor;
begin
  Result := Self;
  FACTIVE := aValue;
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

function TModelEntityFornecedor.CLIENTE(aValue: string): TModelEntityFornecedor;
begin
  Result := Self;
  FCLIENTE := aValue;
end;

function TModelEntityFornecedor.CLIENTE: string;
begin
  Result := FCLIENTE;
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

end.
