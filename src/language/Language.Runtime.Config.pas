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
    TranslationFile: string;
  end;

  TLanguageConfigReader = class
  public
    class function Load(const BasePath: string): TLanguageConfig; static;
    class function LanguageIndex(const Config: TLanguageConfig;
      const LangCode: string): Integer; static;
  end;

implementation

uses
  System.IniFiles,
  System.IOUtils;

class function TLanguageConfigReader.Load(const BasePath: string): TLanguageConfig;
var
  Ini: TIniFile;
  Path: string;
begin
  Result.BasePath := IncludeTrailingPathDelimiter(BasePath);
  Result.LanguagesPath := Result.BasePath + 'Languages' + PathDelim;
  Result.LogsPath := Result.BasePath + 'Logs' + PathDelim;
  Result.TranslationFile := Result.LanguagesPath + 'comercial.sil';
  Result.Current := 'pt';
  Result.Fallback := 'en';
  Result.HotReload := True;
  Result.AuditMode := False;
  Result.DiscoveryMode := False;

  Path := Result.BasePath + 'Config.ini';
  if not FileExists(Path) then
    Exit;

  Ini := TIniFile.Create(Path);
  try
    Result.Current := Ini.ReadString('Language', 'Current', Result.Current);
    Result.Fallback := Ini.ReadString('Language', 'Fallback', Result.Fallback);
    Result.HotReload := Ini.ReadBool('Language', 'HotReload', Result.HotReload);
    Result.AuditMode := Ini.ReadBool('Language', 'AuditMode', Result.AuditMode);
    Result.DiscoveryMode := Ini.ReadBool('Language', 'DiscoveryMode', Result.DiscoveryMode);
    Result.TranslationFile := Ini.ReadString('Language', 'TranslationFile',
      Result.TranslationFile);
    if not TPath.IsPathRooted(Result.TranslationFile) then
      Result.TranslationFile := Result.BasePath + Result.TranslationFile;
  finally
    Ini.Free;
  end;
end;

class function TLanguageConfigReader.LanguageIndex(const Config: TLanguageConfig;
  const LangCode: string): Integer;
var
  Code: string;
begin
  Code := LowerCase(LangCode);
  if Pos('-', Code) > 0 then
    Code := Copy(Code, 1, Pos('-', Code) - 1);

  if Code = 'pt' then
    Exit(1);
  if Code = 'en' then
    Exit(2);
  if Code = 'es' then
    Exit(3);

  Result := 1;
end;

end.
