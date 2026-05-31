unit Language.Tests.Helpers;

interface

uses
  System.SysUtils;

type
  TLanguageTestHelper = class
  public
    class function ResolveProjectBase: string;
    class function CreateTempDir: string;
    class procedure CleanupTempDir(const Path: string);
  end;

implementation

uses
  System.IOUtils;

class function TLanguageTestHelper.ResolveProjectBase: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  if not FileExists(Result + 'Config.ini') then
    Result := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))) + '..' + PathDelim;
end;

class function TLanguageTestHelper.CreateTempDir: string;
begin
  Result := IncludeTrailingPathDelimiter(TPath.GetTempPath) +
    'lang_test_' + FormatDateTime('yyyymmddhhnnsszzz', Now);
  ForceDirectories(Result);
end;

class procedure TLanguageTestHelper.CleanupTempDir(const Path: string);
begin
  if (Path <> '') and TDirectory.Exists(Path) then
    TDirectory.Delete(Path, True);
end;

end.
