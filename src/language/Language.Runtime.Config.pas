unit Language.Runtime.Config;

interface

uses
  System.SysUtils;

type
  TLanguageConfig = record
    Current: string;
    Fallback: string;
    HotReload: Boolean;
    AuditMode: Boolean;
    DiscoveryMode: Boolean;
    BasePath: string;
    LanguagesPath: string;
    LogsPath: string;
  end;

  TLanguageConfigReader = class
  public
    class function Load(const BasePath: string): TLanguageConfig; static;
    class function ConfigFilePath(const BasePath: string): string; static;
  end;

implementation

uses
  System.IniFiles,
  System.IOUtils;

class function TLanguageConfigReader.ConfigFilePath(const BasePath: string): string;
begin
  Result := IncludeTrailingPathDelimiter(BasePath) + 'Config.ini';
end;

class function TLanguageConfigReader.Load(const BasePath: string): TLanguageConfig;
var
  Ini: TIniFile;
  Path: string;
begin
  Result.BasePath := IncludeTrailingPathDelimiter(BasePath);
  Result.LanguagesPath := Result.BasePath + 'Languages' + PathDelim;
  Result.LogsPath := Result.BasePath + 'Logs' + PathDelim;
  Result.Current := 'pt';
  Result.Fallback := 'en';
  Result.HotReload := True;
  Result.AuditMode := False;
  Result.DiscoveryMode := False;

  Path := ConfigFilePath(BasePath);
  if not FileExists(Path) then
    Exit;

  Ini := TIniFile.Create(Path);
  try
    Result.Current := Ini.ReadString('Language', 'Current', Result.Current);
    Result.Fallback := Ini.ReadString('Language', 'Fallback', Result.Fallback);
    Result.HotReload := Ini.ReadBool('Language', 'HotReload', Result.HotReload);
    Result.AuditMode := Ini.ReadBool('Language', 'AuditMode', Result.AuditMode);
    Result.DiscoveryMode := Ini.ReadBool('Language', 'DiscoveryMode', Result.DiscoveryMode);
  finally
    Ini.Free;
  end;
end;

end.
