unit Language.Runtime.Manager;

interface

uses
  Language.Core.Interfaces;

function LanguageManager: ILanguageManager;

implementation

uses
  System.SysUtils,
  System.Classes,
  Language.Runtime.Config,
  Language.Runtime.Cache,
  Language.Runtime.Logger,
  Language.Runtime.Translator,
  Language.JsonProvider,
  Language.VCL.Hook;

type
  TLanguageManager = class(TInterfacedObject, ILanguageManager)
  private
    FConfig: TLanguageConfig;
    FCache: TTranslationCache;
    FFallbackCache: TTranslationCache;
    FTranslator: ITranslator;
    FProvider: ILanguageProvider;
    FInitialized: Boolean;
    procedure LoadCaches;
    procedure BuildFallbackChain(const LangCode: string; Chain: TStringList);
    procedure MergeLanguage(const LangCode: string; Target: TTranslationCache);
  public
    constructor Create;
    destructor Destroy; override;
    function GetCurrentLanguage: string;
    function GetFallbackLanguage: string;
    function GetTranslator: ITranslator;
    function IsDiscoveryMode: Boolean;
    function IsAuditMode: Boolean;
    procedure Initialize(const BasePath: string = '');
    procedure Reload;
  end;

var
  GManager: ILanguageManager;

function LanguageManager: ILanguageManager;
begin
  if GManager = nil then
    GManager := TLanguageManager.Create;
  Result := GManager;
end;

constructor TLanguageManager.Create;
begin
  inherited;
  FCache := TTranslationCache.Create;
  FFallbackCache := TTranslationCache.Create;
  FInitialized := False;
end;

destructor TLanguageManager.Destroy;
begin
  FCache.Free;
  FFallbackCache.Free;
  inherited;
end;

function TLanguageManager.GetCurrentLanguage: string;
begin
  Result := FConfig.Current;
end;

function TLanguageManager.GetFallbackLanguage: string;
begin
  Result := FConfig.Fallback;
end;

function TLanguageManager.GetTranslator: ITranslator;
begin
  Result := FTranslator;
end;

function TLanguageManager.IsDiscoveryMode: Boolean;
begin
  Result := FConfig.DiscoveryMode;
end;

function TLanguageManager.IsAuditMode: Boolean;
begin
  Result := FConfig.AuditMode;
end;

procedure TLanguageManager.BuildFallbackChain(const LangCode: string;
  Chain: TStringList);
var
  Code, Region: string;
  P: Integer;
begin
  Chain.Clear;
  Code := LowerCase(LangCode);
  Chain.Add(Code);
  P := Pos('-', Code);
  if P > 0 then
  begin
    Region := Copy(Code, 1, P - 1);
    if Chain.IndexOf(Region) < 0 then
      Chain.Add(Region);
  end;
  if Chain.IndexOf(FConfig.Fallback) < 0 then
    Chain.Add(FConfig.Fallback);
  if Chain.IndexOf('pt') < 0 then
    Chain.Add('pt');
end;

procedure TLanguageManager.MergeLanguage(const LangCode: string;
  Target: TTranslationCache);
var
  Trans, Plurals: TStrings;
  I, DotPos: Integer;
  Key, Existing: string;
begin
  FProvider.LoadLanguage(LangCode, Trans, Plurals);
  try
    for I := 0 to Trans.Count - 1 do
    begin
      Key := Trans.Names[I];
      if not Target.TryGetValue(Key, Existing) then
        Target.Add(Key, Trans.ValueFromIndex[I]);
    end;
    for I := 0 to Plurals.Count - 1 do
    begin
      Key := Plurals.Names[I];
      DotPos := Pos('.', Key);
      if DotPos > 0 then
      begin
        if not Target.TryGetPlural(Copy(Key, 1, DotPos - 1),
          Copy(Key, DotPos + 1, MaxInt), Existing) then
          Target.AddPlural(Copy(Key, 1, DotPos - 1),
            Copy(Key, DotPos + 1, MaxInt), Plurals.ValueFromIndex[I]);
      end;
    end;
  finally
    Trans.Free;
    Plurals.Free;
  end;
end;

procedure TLanguageManager.LoadCaches;
var
  Chain: TStringList;
  I: Integer;
begin
  FCache.Clear;
  FFallbackCache.Clear;

  Chain := TStringList.Create;
  try
    BuildFallbackChain(FConfig.Current, Chain);
    MergeLanguage(Chain[0], FCache);
    for I := 1 to Chain.Count - 1 do
      MergeLanguage(Chain[I], FFallbackCache);
  finally
    Chain.Free;
  end;

  FTranslator := TLanguageTranslator.Create(FConfig, FCache, FFallbackCache);
end;

procedure TLanguageManager.Initialize(const BasePath: string);
var
  Path: string;
begin
  if BasePath <> '' then
    Path := BasePath
  else
    Path := ExtractFilePath(ParamStr(0));

  FConfig := TLanguageConfigReader.Load(Path);
  TTranslationLogger.Configure(FConfig.LogsPath);
  FProvider := TJsonLanguageProvider.Create(FConfig.LanguagesPath);
  LoadCaches;
  TLanguageHook.Install(FTranslator);
  FInitialized := True;
  TTranslationLogger.Info('Language platform initialized. Current=' + FConfig.Current);
end;

procedure TLanguageManager.Reload;
begin
  LoadCaches;
  TLanguageHook.RetranslateAll;
  TTranslationLogger.Info('Languages reloaded. Current=' + FConfig.Current);
end;

initialization

finalization
  GManager := nil;

end.
