unit comercial.model.resource.impl.conexaoIBX;

interface

uses
  System.SysUtils,
  IBX.IBDatabase,
  comercial.model.resource.interfaces,
  Data.DB,
  System.inifiles;

type
  TmodelResourceConexaoIBX = class(TInterfacedObject, iConexao)
  private
    FConn: TIBDatabase;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iConexao;
    function Connect: TCustomConnection;
  end;

implementation


function TmodelResourceConexaoIBX.Connect: TCustomConnection;
begin
  try
    if FConn.Connected then
    begin
      Result := FConn;
      Exit;
    end;

    FConn.Params.Clear;

      var iniPath := ExtractFilePath(ParamStr(0)) + 'comercial.ini';
      var ini := TIniFile.Create(iniPath);
      try
        var dbPath := ini.ReadString('Database', 'Path', 'C:\testeEmpresa\DADOS.FDB');
        var dbUser := ini.ReadString('Database', 'User', 'SYSDBA');
        var dbPass := ini.ReadString('Database', 'Password', 'masterkey');

        FConn.DatabaseName := dbPath;
        FConn.Params.Values['user_name'] := dbUser;
        FConn.Params.Values['password'] := dbPass;
        FConn.loginprompt := false;
      finally
        ini.Free;
      end;
    FConn.Connected := True;
    Result := FConn;
  except
    on e: exception do
      raise exception.Create('Não foi possivel realizar a conex�o ' +
        e.message);
  end;
end;

constructor TmodelResourceConexaoIBX.Create;
begin
  FConn := TIBDatabase.Create(nil)
end;

destructor TmodelResourceConexaoIBX.Destroy;
begin
  FConn.Free;
  inherited;
end;

class function TmodelResourceConexaoIBX.New
  : iConexao;
begin
  Result := Self.Create;
end;

end.
