program LanguageValidator;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Language.Tools.Validator in '..\src\language\Language.Tools.Validator.pas',
  Language.Runtime.Translator in '..\src\language\Language.Runtime.Translator.pas',
  Language.VCL.Keys in '..\src\language\Language.VCL.Keys.pas',
  Language.VCL.ComponentWalker in '..\src\language\Language.VCL.ComponentWalker.pas',
  Language.Runtime.Logger in '..\src\language\Language.Runtime.Logger.pas',
  Language.Runtime.Config in '..\src\language\Language.Runtime.Config.pas',
  Language.Runtime.Cache in '..\src\language\Language.Runtime.Cache.pas';

var
  Result: TLanguageValidationResult;
  BasePath: string;
begin
  BasePath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  if not DirectoryExists(BasePath + 'Languages') then
    BasePath := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))) + '..' + PathDelim;

  Result := TLanguageValidator.Validate(BasePath + 'Languages' + PathDelim, 'pt');
  try
    Writeln(Result.Summary);
    if Result.Details.Count > 0 then
    begin
      Writeln;
      Writeln('Details:');
      Writeln(Result.Details.Text);
    end;
  finally
    Result.Details.Free;
  end;
end.
