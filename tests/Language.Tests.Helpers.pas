unit Language.Tests.Helpers;

interface

uses
  System.SysUtils;

type
  TLanguageTestHelper = class
  public
    class function ResolveProjectBase: string;
    class function LanguagesPath: string;
    class function CreateTempDir: string;
    class procedure WriteTextFile(const FileName, Content: string);
    class procedure WriteConfig(const BasePath, Current, Fallback: string;
      HotReload, AuditMode, DiscoveryMode: Boolean);
    class procedure WriteLanguageJson(const BasePath, LangCode, Content: string);
    class procedure CleanupTempDir(const Path: string);
  end;

implementation

uses
  System.IOUtils,
  System.Classes;

class function TLanguageTestHelper.ResolveProjectBase: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  if not FileExists(Result + 'Config.ini') then
    Result := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))) + '..' + PathDelim;
end;

class function TLanguageTestHelper.LanguagesPath: string;
begin
  Result := ResolveProjectBase + 'Languages' + PathDelim;
end;

class function TLanguageTestHelper.CreateTempDir: string;
begin
  Result := IncludeTrailingPathDelimiter(TPath.GetTempPath) +
    'lang_test_' + FormatDateTime('yyyymmddhhnnsszzz', Now);
  ForceDirectories(Result + 'Languages');
  ForceDirectories(Result + 'Logs');
end;

class procedure TLanguageTestHelper.WriteTextFile(const FileName, Content: string);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Text := Content;
    SL.SaveToFile(FileName, TEncoding.UTF8);
  finally
    SL.Free;
  end;
end;

class procedure TLanguageTestHelper.WriteConfig(const BasePath, Current,
  Fallback: string; HotReload, AuditMode, DiscoveryMode: Boolean);
var
  Content: string;
begin
  Content :=
    '[Language]' + sLineBreak +
    'Current=' + Current + sLineBreak +
    'Fallback=' + Fallback + sLineBreak +
    'HotReload=' + IntToStr(Ord(HotReload)) + sLineBreak +
    'AuditMode=' + IntToStr(Ord(AuditMode)) + sLineBreak +
    'DiscoveryMode=' + IntToStr(Ord(DiscoveryMode)) + sLineBreak;
  WriteTextFile(IncludeTrailingPathDelimiter(BasePath) + 'Config.ini', Content);
end;

class procedure TLanguageTestHelper.WriteLanguageJson(const BasePath, LangCode,
  Content: string);
begin
  WriteTextFile(
    IncludeTrailingPathDelimiter(BasePath) + 'Languages' + PathDelim +
    LowerCase(LangCode) + '.json',
    Content);
end;

class procedure TLanguageTestHelper.CleanupTempDir(const Path: string);
begin
  if (Path <> '') and TDirectory.Exists(Path) then
    TDirectory.Delete(Path, True);
end;

end.
