unit Language.Tests.Manager;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestLanguageManager = class
  private
    FTempPath: string;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure InitializeLoadsCurrentLanguage;
    [Test]
    procedure ReloadUpdatesCacheFromDisk;
    [Test]
    procedure FallbackChainLoadsRegionalLanguage;
    [Test]
    procedure HotReloadReturnsUpdatedTranslation;
  end;

implementation

uses
  System.SysUtils,
  Language.Runtime.Manager,
  Language.Tests.Helpers;

procedure TTestLanguageManager.Setup;
begin
  FTempPath := TLanguageTestHelper.CreateTempDir;
end;

procedure TTestLanguageManager.TearDown;
begin
  TLanguageTestHelper.CleanupTempDir(FTempPath);
end;

procedure TTestLanguageManager.InitializeLoadsCurrentLanguage;
begin
  TLanguageTestHelper.WriteConfig(FTempPath, 'en', 'pt', True, False, False);
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'en',
    '{ "MSG_WELCOME": "Welcome" }');
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'pt',
    '{ "MSG_WELCOME": "Bem-vindo" }');

  LanguageManager.Initialize(FTempPath);
  Assert.AreEqual('en', LanguageManager.GetCurrentLanguage);
  Assert.AreEqual('Welcome', LanguageManager.GetTranslator.Translate('MSG_WELCOME'));
end;

procedure TTestLanguageManager.ReloadUpdatesCacheFromDisk;
begin
  TLanguageTestHelper.WriteConfig(FTempPath, 'pt', 'en', True, False, False);
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'pt',
    '{ "MSG_STATUS": "Original" }');
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'en', '{ "MSG_STATUS": "Fallback" }');

  LanguageManager.Initialize(FTempPath);
  Assert.AreEqual('Original', LanguageManager.GetTranslator.Translate('MSG_STATUS'));

  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'pt',
    '{ "MSG_STATUS": "Atualizado" }');
  LanguageManager.Reload;
  Assert.AreEqual('Atualizado', LanguageManager.GetTranslator.Translate('MSG_STATUS'));
end;

procedure TTestLanguageManager.FallbackChainLoadsRegionalLanguage;
begin
  TLanguageTestHelper.WriteConfig(FTempPath, 'es-MX', 'en', True, False, False);
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'es',
    '{ "MSG_HELLO": "Hola" }');
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'en',
    '{ "MSG_HELLO": "Hello" }');
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'pt',
    '{ "MSG_HELLO": "Ola" }');

  LanguageManager.Initialize(FTempPath);
  Assert.AreEqual('Hola', LanguageManager.GetTranslator.Translate('MSG_HELLO'));
end;

procedure TTestLanguageManager.HotReloadReturnsUpdatedTranslation;
begin
  TLanguageTestHelper.WriteConfig(FTempPath, 'pt', 'en', True, False, False);
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'pt',
    '{ "BTN_SAVE": "Salvar" }');
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'en',
    '{ "BTN_SAVE": "Save" }');

  LanguageManager.Initialize(FTempPath);
  Assert.AreEqual('Salvar', LanguageManager.GetTranslator.Translate('BTN_SAVE'));

  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'pt',
    '{ "BTN_SAVE": "Gravar" }');
  LanguageManager.Reload;
  Assert.AreEqual('Gravar', LanguageManager.GetTranslator.Translate('BTN_SAVE'));
end;

end.
