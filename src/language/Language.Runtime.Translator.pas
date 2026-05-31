unit Language.Runtime.Translator;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  Language.Core.Interfaces,
  Language.Runtime.Cache,
  Language.Runtime.Config;

type
  TLanguageTranslator = class(TInterfacedObject, ITranslator, IMessageTranslator, IFormTranslator)
  private
    FConfig: TLanguageConfig;
    FCache: TTranslationCache;
    FFallbackCache: TTranslationCache;
    FAuditMode: Boolean;
    FDiscoveryMode: Boolean;
    FCurrentLanguage: string;
    FDiscoveryFile: string;
    function ResolveKey(const Key: string): string;
    function ResolvePluralKey(const Key: string; Count: Integer): string;
    function ApplyPlaceholders(const Template: string; const Args: array of const): string;
    procedure WriteDiscovery(const Key, Original: string);
    function FormatAuditMissing(const Key: string): string;
  public
    constructor Create(const AConfig: TLanguageConfig;
      ACache, AFallbackCache: TTranslationCache);
    function Translate(const Key: string): string;
    function Msg(const Key: string): string;
    function Format(const Key: string; const Args: array of const): string;
    function Plural(const Key: string; Count: Integer): string;
    procedure TranslateForm(AForm: TCustomForm);
    procedure TranslateComponent(AComponent: TComponent);
    procedure TranslateContainer(AOwner: TComponent);
    procedure RetranslateOpenForms;
  end;

implementation

uses
  System.IOUtils,
  System.Variants,
  Language.Runtime.Logger,
  Language.VCL.Keys,
  Language.VCL.ComponentWalker;

function TLanguageTranslator.FormatAuditMissing(const Key: string): string;
begin
  Result := '[MISSING] ' + Key;
end;

constructor TLanguageTranslator.Create(const AConfig: TLanguageConfig;
  ACache, AFallbackCache: TTranslationCache);
begin
  inherited Create;
  FConfig := AConfig;
  FCache := ACache;
  FFallbackCache := AFallbackCache;
  FAuditMode := AConfig.AuditMode;
  FDiscoveryMode := AConfig.DiscoveryMode;
  FCurrentLanguage := AConfig.Current;
  FDiscoveryFile := IncludeTrailingPathDelimiter(AConfig.LanguagesPath) + 'discovery.json';
end;

procedure TLanguageTranslator.WriteDiscovery(const Key, Original: string);
var
  SL: TStringList;
begin
  if not FDiscoveryMode then
    Exit;
  SL := TStringList.Create;
  try
    if FileExists(FDiscoveryFile) then
      SL.LoadFromFile(FDiscoveryFile, TEncoding.UTF8);
    if SL.IndexOfName(Key) < 0 then
    begin
      SL.Values[Key] := Original;
      if not TDirectory.Exists(FConfig.LanguagesPath) then
        TDirectory.CreateDirectory(FConfig.LanguagesPath);
      SL.SaveToFile(FDiscoveryFile, TEncoding.UTF8);
    end;
  finally
    SL.Free;
  end;
end;

function TLanguageTranslator.ResolveKey(const Key: string): string;
var
  Value: string;
begin
  if FCache.TryGetValue(Key, Value) then
    Exit(Value);

  if FFallbackCache.TryGetValue(Key, Value) then
  begin
    TTranslationLogger.FallbackUsed(Key, FCurrentLanguage, FConfig.Fallback);
    Exit(Value);
  end;

  TTranslationLogger.MissingKey(Key, FCurrentLanguage);
  if FAuditMode then
    Result := FormatAuditMissing(Key)
  else
    Result := Key;
end;

function TLanguageTranslator.ResolvePluralKey(const Key: string; Count: Integer): string;
var
  Form: string;
  Value: string;
begin
  if Count = 1 then
    Form := 'one'
  else
    Form := 'other';

  if FCache.TryGetPlural(Key, Form, Value) then
    Exit(Value);
  if FFallbackCache.TryGetPlural(Key, Form, Value) then
  begin
    TTranslationLogger.FallbackUsed(Key, FCurrentLanguage, FConfig.Fallback);
    Exit(Value);
  end;

  TTranslationLogger.MissingKey(Key + '.' + Form, FCurrentLanguage);
  if FAuditMode then
    Result := FormatAuditMissing(Key)
  else
    Result := Key;
end;

function TLanguageTranslator.ApplyPlaceholders(const Template: string;
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

function TLanguageTranslator.Translate(const Key: string): string;
begin
  Result := ResolveKey(Key);
end;

function TLanguageTranslator.Msg(const Key: string): string;
begin
  Result := ResolveKey(Key);
end;

function TLanguageTranslator.Format(const Key: string; const Args: array of const): string;
begin
  Result := ApplyPlaceholders(ResolveKey(Key), Args);
end;

function TLanguageTranslator.Plural(const Key: string; Count: Integer): string;
begin
  Result := ApplyPlaceholders(ResolvePluralKey(Key, Count), [Count]);
end;

procedure TLanguageTranslator.TranslateComponent(AComponent: TComponent);
var
  Key, Translated, Original: string;
  Form: TCustomForm;
begin
  if AComponent = nil then
    Exit;

  Form := nil;
  if AComponent.Owner is TCustomForm then
    Form := TCustomForm(AComponent.Owner);
  if Form = nil then
    Exit;

  Original := TComponentCaptionReader.GetCaption(AComponent);
  if Original = '' then
    Exit;

  Key := TLanguageKeys.ComponentKey(Form, AComponent);
  if FDiscoveryMode then
    WriteDiscovery(Key, Original);

  Translated := ResolveKey(Key);
  if Translated <> Key then
    TComponentCaptionReader.SetCaption(AComponent, Translated);
end;

procedure TLanguageTranslator.TranslateContainer(AOwner: TComponent);
var
  Form: TCustomForm;
begin
  if AOwner = nil then
    Exit;
  if AOwner is TCustomForm then
    Form := TCustomForm(AOwner)
  else if AOwner.Owner is TCustomForm then
    Form := TCustomForm(AOwner.Owner)
  else
    Form := nil;
  TComponentWalker.Walk(AOwner, Form, Self);
end;

procedure TLanguageTranslator.TranslateForm(AForm: TCustomForm);
var
  Key, Translated: string;
begin
  if AForm = nil then
    Exit;

  Key := TLanguageKeys.FormCaptionKey(AForm);
  if FDiscoveryMode then
    WriteDiscovery(Key, AForm.Caption);

  Translated := ResolveKey(Key);
  if Translated <> Key then
    AForm.Caption := Translated;

  TComponentWalker.Walk(AForm, AForm, Self);
end;

procedure TLanguageTranslator.RetranslateOpenForms;
var
  I: Integer;
begin
  for I := 0 to Screen.FormCount - 1 do
    TranslateForm(Screen.Forms[I]);
end;

end.
