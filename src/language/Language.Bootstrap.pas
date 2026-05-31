unit Language.Bootstrap;

interface

uses
  Language.Core.Interfaces;

type
  TLanguageBootstrap = class
  public
    class procedure Initialize; static;
    class procedure Reload; static;
  end;

function Translator: ITranslator;

implementation

uses
  Language.Core.Interfaces,
  Language.Runtime.Manager;

class procedure TLanguageBootstrap.Initialize;
begin
  LanguageManager.Initialize;
end;

class procedure TLanguageBootstrap.Reload;
begin
  LanguageManager.Reload;
end;

function Translator: ITranslator;
begin
  Result := LanguageManager.GetTranslator;
end;

end.
