unit Language.Core.Interfaces;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls;

type
  ITranslationCache = interface
    ['{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}']
    function TryGetValue(const Key: string; out Value: string): Boolean;
    function Count: Integer;
    function TryGetPlural(const Key, Form: string; out Value: string): Boolean;
  end;

  ILanguageProvider = interface
    ['{B2C3D4E5-F6A7-8901-BCDE-F12345678901}']
    procedure LoadLanguage(const LanguageCode: string;
      out Translations: TStrings; out Plurals: TStrings);
    function GetAvailableLanguages: TStringList;
    function LanguagesPath: string;
  end;

  IMessageTranslator = interface
    ['{C3D4E5F6-A7B8-9012-CDEF-123456789012}']
    function Msg(const Key: string): string;
    function FormatMsg(const Key: string; const Args: array of const): string;
    function Plural(const Key: string; Count: Integer): string;
  end;

  IFormTranslator = interface
    ['{D4E5F6A7-B8C9-0123-DEF0-234567890123}']
    procedure TranslateForm(AForm: TCustomForm);
    procedure TranslateComponent(AComponent: TComponent);
    procedure TranslateContainer(AOwner: TComponent);
    procedure RetranslateOpenForms;
  end;

  ITranslator = interface
    ['{E5F6A7B8-C9D0-1234-EF01-345678901234}']
    function Translate(const Key: string): string;
    function Msg(const Key: string): string;
    function Format(const Key: string; const Args: array of const): string; overload;
    function Plural(const Key: string; Count: Integer): string;
    procedure TranslateForm(AForm: TCustomForm);
    procedure TranslateComponent(AComponent: TComponent);
    procedure TranslateContainer(AOwner: TComponent);
    procedure RetranslateOpenForms;
  end;

  ILanguageManager = interface
    ['{F6A7B8C9-D0E1-2345-F012-456789012345}']
    function GetCurrentLanguage: string;
    function GetFallbackLanguage: string;
    function GetTranslator: ITranslator;
    function IsDiscoveryMode: Boolean;
    function IsAuditMode: Boolean;
    procedure Initialize(const BasePath: string = '');
    procedure Reload;
  end;

implementation

end.
