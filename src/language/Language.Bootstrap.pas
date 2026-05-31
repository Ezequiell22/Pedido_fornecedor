unit Language.Bootstrap;

interface

uses
  Language.TsiLang.Service;

type
  TLanguageBootstrap = class
  public
    class procedure Initialize(const BasePath: string = ''); static;
    class procedure Reload; static;
  end;

function Translator: ITsiLangTranslator;

implementation

class procedure TLanguageBootstrap.Initialize(const BasePath: string);
begin
  TTsiLangLanguageService.Initialize(BasePath);
end;

class procedure TLanguageBootstrap.Reload;
begin
  TTsiLangLanguageService.Reload;
end;

function Translator: ITsiLangTranslator;
begin
  Result := TTsiLangLanguageService.Translator;
end;

end.
