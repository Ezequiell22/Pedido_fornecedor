unit Language.TsiLang.Service;

interface

uses
  System.SysUtils,
  Language.Runtime.Config;

type
  ITsiLangTranslator = interface
    ['{A8F3C2D1-4E5B-6A7C-8D9E-0F1A2B3C4D5E}']
    function Msg(const TextId: string): string;
    function FormatMsg(const TextId: string; const Args: array of const): string;
  end;

  TTsiLangLanguageService = class
  public
    class procedure Initialize(const BasePath: string); static;
    class procedure Reload; static;
    class procedure ApplyActiveLanguage; static;
    class function GetConfig: TLanguageConfig; static;
    class function Translator: ITsiLangTranslator; static;
  end;

implementation

uses
  System.Classes,
  System.IOUtils,
  System.Variants,
  Vcl.Forms,
  siComp,
  comercial.view.index;

type
  TTsiLangTranslatorImpl = class(TInterfacedObject, ITsiLangTranslator)
  public
    function Msg(const TextId: string): string;
    function FormatMsg(const TextId: string; const Args: array of const): string;
  end;

var
  GConfig: TLanguageConfig;
  GTranslator: ITsiLangTranslator;
  GInitialized: Boolean;

function ApplyPlaceholders(const Template: string;
  const Args: array of const): string;
var
  I: Integer;
  Placeholder: string;
begin
  Result := Template;
  for I := 0 to High(Args) do
  begin
    Placeholder := '{' + IntToStr(I) + '}';
    Result := StringReplace(Result, Placeholder, VarToStr(Args[I]), [rfReplaceAll]);
  end;
end;

function ResolveText(const TextId: string): string;
begin
  if not Assigned(frmIndex) or not Assigned(frmIndex.siLang1) then
    Exit(TextId);

  Result := frmIndex.siLang1.GetTextOrDefault(TextId);
  if (Result = '') and GConfig.AuditMode then
    Result := '[MISSING] ' + TextId;
end;

function TTsiLangTranslatorImpl.Msg(const TextId: string): string;
begin
  Result := ResolveText(TextId);
end;

function TTsiLangTranslatorImpl.FormatMsg(const TextId: string;
  const Args: array of const): string;
begin
  Result := ApplyPlaceholders(ResolveText(TextId), Args);
end;

class procedure TTsiLangLanguageService.Initialize(const BasePath: string);
var
  Path: string;
  Dir: string;
begin
  if BasePath <> '' then
    Path := BasePath
  else
    Path := ExtractFilePath(ParamStr(0));

  GConfig := TLanguageConfigReader.Load(Path);
  Dir := ExtractFilePath(GConfig.TranslationFile);
  if (Dir <> '') and not TDirectory.Exists(Dir) then
    TDirectory.CreateDirectory(Dir);

  if not Assigned(frmIndex) then
    raise Exception.Create('TsiLang: frmIndex must be created before Language.Initialize');

  frmIndex.siLangDispatcher1.DefaultLanguage :=
    TLanguageConfigReader.LanguageIndex(GConfig, GConfig.Fallback);

  if FileExists(GConfig.TranslationFile) then
  begin
    frmIndex.siLangDispatcher1.FileName := GConfig.TranslationFile;
    frmIndex.siLangDispatcher1.LoadAllFromFile(GConfig.TranslationFile, True);
  end;

  ApplyActiveLanguage;
  GTranslator := TTsiLangTranslatorImpl.Create;
  GInitialized := True;
end;

class procedure TTsiLangLanguageService.ApplyActiveLanguage;
begin
  if not Assigned(frmIndex) then
    Exit;
  frmIndex.siLangDispatcher1.ActiveLanguage :=
    TLanguageConfigReader.LanguageIndex(GConfig, GConfig.Current);
end;

class procedure TTsiLangLanguageService.Reload;
begin
  if not GInitialized then
    Exit;

  GConfig := TLanguageConfigReader.Load(GConfig.BasePath);

  if FileExists(GConfig.TranslationFile) then
  begin
    frmIndex.siLangDispatcher1.FileName := GConfig.TranslationFile;
    frmIndex.siLangDispatcher1.LoadAllFromFile(GConfig.TranslationFile, True);
  end;

  ApplyActiveLanguage;
end;

class function TTsiLangLanguageService.GetConfig: TLanguageConfig;
begin
  Result := GConfig;
end;

class function TTsiLangLanguageService.Translator: ITsiLangTranslator;
begin
  if GTranslator = nil then
    GTranslator := TTsiLangTranslatorImpl.Create;
  Result := GTranslator;
end;

end.
