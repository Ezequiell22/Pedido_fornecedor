unit comercial.model.resource.impl.factory;

interface

uses
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.conexaoFD;

type
  TResource = class(TInterfacedObject, iResource)
    private
      FConexao: iConexao;
    public
      constructor Create;
      destructor Destroy; override;
      class function New  : iResource;
      function Conexao: iConexao;
  end;

implementation

function TResource.Conexao: iConexao;
begin
  Result := FConexao;
end;

constructor TResource.Create;
begin
  FConexao := TModelResourceConexaoFD.New;
end;

destructor TResource.Destroy;
begin

  inherited;
end;

class function TResource.New  : iResource;
begin
  Result := Self.Create;
end;

end.

