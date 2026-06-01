unit Language.Bootstrap;

interface

uses
  Vcl.Forms,
  Language.TsiLang.Service;

type
  TLanguageBootstrap = class
  public
    class procedure Initialize(const BasePath: string = ''); static;
    class procedure Reload; static;
    class procedure ApplyFormTranslations(AForm: TForm;
      const ApplyFormCaption: Boolean = True); static;
  end;

function Translator: ITsiLangTranslator;

implementation

uses
  Language.Translations.Apply;

class procedure TLanguageBootstrap.Initialize(const BasePath: string);
begin
  TTsiLangLanguageService.Initialize(BasePath);
end;

class procedure TLanguageBootstrap.Reload;
begin
  TTsiLangLanguageService.Reload;
end;

class procedure TLanguageBootstrap.ApplyFormTranslations(AForm: TForm;
  const ApplyFormCaption: Boolean);
begin
  TTranslationApply.ApplyForm(AForm, TTsiLangLanguageService.CurrentLanguageCode,
    ApplyFormCaption);
end;

function Translator: ITsiLangTranslator;
begin
  Result := TTsiLangLanguageService.Translator;
end;

end.
