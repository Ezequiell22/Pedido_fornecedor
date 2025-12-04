unit comercial.model.resource.impl.conexaoFD;

interface

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Pool,
  FireDAC.Phys,
  FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  System.IniFiles,
  system.StrUtils,
  comercial.model.resource.interfaces;

type
  TModelResourceConexaoFD = class(TInterfacedObject, iConexao)
  private
    FConn: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iConexao;
    function Connect: TCustomConnection;
  end;

implementation

function TModelResourceConexaoFD.Connect: TCustomConnection;
begin
  if FConn.Connected then
    Exit(FConn);

  var iniPath := ExtractFilePath(ParamStr(0)) + 'comercial.ini';
  var ini := TIniFile.Create(iniPath);
  try
    var server := ini.ReadString('Database', 'Server', '172.20.10.6,1433');
    var database := ini.ReadString('Database', 'Database', '');
    var dbUser := ini.ReadString('Database', 'User', 'sa');
    var dbPass := ini.ReadString('Database', 'Password', '');

    FConn.Params.Clear;
    FConn.Params.Values['DriverID'] := 'MSSQL';
    FConn.Params.Values['Server'] := server;
    FConn.Params.Values['Database'] := database;
    FConn.Params.Values['User_Name'] := dbUser;
    FConn.Params.Values['Password'] := dbPass;
    FConn.Params.Values['OSAuthent'] := IfThen((dbUser = '') and (dbPass = ''), 'Yes', 'No');
    FConn.FormatOptions.MapRules.Add(dtMemo, dtAnsiString);
    FConn.FormatOptions.MapRules.Add(dtWideMemo, dtWideString);
    FConn.FormatOptions.MaxStringSize := 32767;
    FConn.LoginPrompt := False;
  finally
    ini.Free;
  end;

  FConn.Connected := True;
  Result := FConn;
end;

constructor TModelResourceConexaoFD.Create;
begin
  FConn := TFDConnection.Create(nil);
end;

destructor TModelResourceConexaoFD.Destroy;
begin
  FConn.Free;
  inherited;
end;

class function TModelResourceConexaoFD.New: iConexao;
begin
  Result := Self.Create;
end;

end.
