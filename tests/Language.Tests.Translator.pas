unit Language.Tests.Translator;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestLanguageTranslator = class
  private
    FBasePath: string;
    FTempPath: string;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TranslateExistingKey;
    [Test]
    procedure TranslateMissingKeyReturnsKeyWhenNoFallback;
    [Test]
    procedure TranslateMissingKeyUsesFallback;
    [Test]
    procedure MsgReturnsSameAsTranslate;
    [Test]
    procedure FormatPlaceholderSubstitution;
    [Test]
    procedure FormatMultiplePlaceholders;
    [Test]
    procedure PluralSingularForm;
    [Test]
    procedure PluralOtherForm;
    [Test]
    procedure AuditModeMarksMissingKeys;
    [Test]
    procedure DiscoveryModeWritesNewKeysToFile;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Controls,
  Language.Runtime.Config,
  Language.Runtime.Cache,
  Language.Runtime.Translator,
  Language.Tests.Helpers;

procedure TTestLanguageTranslator.Setup;
begin
  FBasePath := TLanguageTestHelper.ResolveProjectBase;
  FTempPath := TLanguageTestHelper.CreateTempDir;
end;

procedure TTestLanguageTranslator.TearDown;
begin
  TLanguageTestHelper.CleanupTempDir(FTempPath);
end;

function MakeTranslator(const Cfg: TLanguageConfig; Cache, Fallback: TTranslationCache)
  : TLanguageTranslator;
begin
  Result := TLanguageTranslator.Create(Cfg, Cache, Fallback);
end;

procedure TTestLanguageTranslator.TranslateExistingKey;
var
  Cfg: TLanguageConfig;
  Cache, Fallback: TTranslationCache;
  T: TLanguageTranslator;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Cache := TTranslationCache.Create;
  Fallback := TTranslationCache.Create;
  try
    Cache.Add('MSG_TEST', 'Valor PT');
    T := MakeTranslator(Cfg, Cache, Fallback);
    Assert.AreEqual('Valor PT', T.Translate('MSG_TEST'));
  finally
    Fallback.Free;
    Cache.Free;
  end;
end;

procedure TTestLanguageTranslator.TranslateMissingKeyReturnsKeyWhenNoFallback;
var
  Cfg: TLanguageConfig;
  Cache, Fallback: TTranslationCache;
  T: TLanguageTranslator;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Cfg.AuditMode := False;
  Cache := TTranslationCache.Create;
  Fallback := TTranslationCache.Create;
  try
    T := MakeTranslator(Cfg, Cache, Fallback);
    Assert.AreEqual('UNKNOWN_KEY', T.Translate('UNKNOWN_KEY'));
  finally
    Fallback.Free;
    Cache.Free;
  end;
end;

procedure TTestLanguageTranslator.TranslateMissingKeyUsesFallback;
var
  Cfg: TLanguageConfig;
  Cache, Fallback: TTranslationCache;
  T: TLanguageTranslator;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Cfg.Current := 'es';
  Cfg.Fallback := 'en';
  Cache := TTranslationCache.Create;
  Fallback := TTranslationCache.Create;
  try
    Fallback.Add('MSG_FALLBACK', 'Fallback EN');
    T := MakeTranslator(Cfg, Cache, Fallback);
    Assert.AreEqual('Fallback EN', T.Translate('MSG_FALLBACK'));
  finally
    Fallback.Free;
    Cache.Free;
  end;
end;

procedure TTestLanguageTranslator.MsgReturnsSameAsTranslate;
var
  Cfg: TLanguageConfig;
  Cache, Fallback: TTranslationCache;
  T: TLanguageTranslator;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Cache := TTranslationCache.Create;
  Fallback := TTranslationCache.Create;
  try
    Cache.Add('MSG_ALERT', 'Alerta');
    T := MakeTranslator(Cfg, Cache, Fallback);
    Assert.AreEqual(T.Translate('MSG_ALERT'), T.Msg('MSG_ALERT'));
  finally
    Fallback.Free;
    Cache.Free;
  end;
end;

procedure TTestLanguageTranslator.FormatPlaceholderSubstitution;
var
  Cfg: TLanguageConfig;
  Cache, Fallback: TTranslationCache;
  T: TLanguageTranslator;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Cache := TTranslationCache.Create;
  Fallback := TTranslationCache.Create;
  try
    Cache.Add('MSG_CLIENTE', 'Cliente {0} nao encontrado');
    T := MakeTranslator(Cfg, Cache, Fallback);
    Assert.AreEqual('Cliente 123 nao encontrado', T.Format('MSG_CLIENTE', [123]));
  finally
    Fallback.Free;
    Cache.Free;
  end;
end;

procedure TTestLanguageTranslator.FormatMultiplePlaceholders;
var
  Cfg: TLanguageConfig;
  Cache, Fallback: TTranslationCache;
  T: TLanguageTranslator;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Cache := TTranslationCache.Create;
  Fallback := TTranslationCache.Create;
  try
    Cache.Add('MSG_RANGE', 'De {0} ate {1}');
    T := MakeTranslator(Cfg, Cache, Fallback);
    Assert.AreEqual('De 10 ate 20', T.Format('MSG_RANGE', [10, 20]));
  finally
    Fallback.Free;
    Cache.Free;
  end;
end;

procedure TTestLanguageTranslator.PluralSingularForm;
var
  Cfg: TLanguageConfig;
  Cache, Fallback: TTranslationCache;
  T: TLanguageTranslator;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Cache := TTranslationCache.Create;
  Fallback := TTranslationCache.Create;
  try
    Cache.AddPlural('ITEMS_FOUND', 'one', '{0} item found');
    Cache.AddPlural('ITEMS_FOUND', 'other', '{0} items found');
    T := MakeTranslator(Cfg, Cache, Fallback);
    Assert.AreEqual('1 item found', T.Plural('ITEMS_FOUND', 1));
  finally
    Fallback.Free;
    Cache.Free;
  end;
end;

procedure TTestLanguageTranslator.PluralOtherForm;
var
  Cfg: TLanguageConfig;
  Cache, Fallback: TTranslationCache;
  T: TLanguageTranslator;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Cache := TTranslationCache.Create;
  Fallback := TTranslationCache.Create;
  try
    Cache.AddPlural('ITEMS_FOUND', 'one', '{0} item found');
    Cache.AddPlural('ITEMS_FOUND', 'other', '{0} items found');
    T := MakeTranslator(Cfg, Cache, Fallback);
    Assert.AreEqual('5 items found', T.Plural('ITEMS_FOUND', 5));
  finally
    Fallback.Free;
    Cache.Free;
  end;
end;

procedure TTestLanguageTranslator.AuditModeMarksMissingKeys;
var
  Cfg: TLanguageConfig;
  Cache, Fallback: TTranslationCache;
  T: TLanguageTranslator;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Cfg.AuditMode := True;
  Cache := TTranslationCache.Create;
  Fallback := TTranslationCache.Create;
  try
    T := MakeTranslator(Cfg, Cache, Fallback);
    Assert.AreEqual('[MISSING] FORM_X.BTN_SAVE', T.Translate('FORM_X.BTN_SAVE'));
  finally
    Fallback.Free;
    Cache.Free;
  end;
end;

procedure TTestLanguageTranslator.DiscoveryModeWritesNewKeysToFile;
var
  Cfg: TLanguageConfig;
  Cache, Fallback: TTranslationCache;
  T: TLanguageTranslator;
  Form: TForm;
  Btn: TButton;
  SL: TStringList;
  DiscoveryFile: string;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Cfg.DiscoveryMode := True;
  Cfg.LanguagesPath := FTempPath + 'Languages' + PathDelim;
  Cache := TTranslationCache.Create;
  Fallback := TTranslationCache.Create;
  Form := TForm.Create(nil);
  Btn := TButton.Create(Form);
  try
    Form.Caption := 'Formulario Teste';
    Btn.Name := 'btnNovo';
    Btn.Caption := 'Novo';
    Btn.Parent := Form;

    T := MakeTranslator(Cfg, Cache, Fallback);
    T.TranslateForm(Form);

    DiscoveryFile := Cfg.LanguagesPath + 'discovery.json';
    Assert.IsTrue(FileExists(DiscoveryFile));
    SL := TStringList.Create;
    try
      SL.LoadFromFile(DiscoveryFile, TEncoding.UTF8);
      Assert.IsTrue(SL.IndexOfName('FORM_FORM.BTNNOVO') >= 0,
        'Expected discovery key for btnNovo');
    finally
      SL.Free;
    end;
  finally
    Form.Free;
    Fallback.Free;
    Cache.Free;
  end;
end;

end.
