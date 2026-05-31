unit Language.Tests.TsiLang.Config;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestTsiLangConfig = class
  private
    FBasePath: string;
    FTempPath: string;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure LoadsCurrentAndFallbackFromConfigIni;
    [Test]
    procedure MapsLanguageCodesToTsiLangIndexes;
    [Test]
    procedure ResolvesRegionalLanguageCodeToBaseIndex;
    [Test]
    procedure LoadsCustomTranslationFilePath;
    [Test]
    procedure UsesDefaultTranslationFileWhenNotConfigured;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  Language.Runtime.Config,
  Language.Tests.Helpers;

procedure TTestTsiLangConfig.Setup;
begin
  FBasePath := TLanguageTestHelper.ResolveProjectBase;
  FTempPath := TLanguageTestHelper.CreateTempDir;
end;

procedure TTestTsiLangConfig.TearDown;
begin
  TLanguageTestHelper.CleanupTempDir(FTempPath);
end;

procedure TTestTsiLangConfig.LoadsCurrentAndFallbackFromConfigIni;
var
  Cfg: TLanguageConfig;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Assert.AreEqual('pt', Cfg.Current);
  Assert.AreEqual('en', Cfg.Fallback);
  Assert.IsTrue(Cfg.HotReload);
end;

procedure TTestTsiLangConfig.MapsLanguageCodesToTsiLangIndexes;
var
  Cfg: TLanguageConfig;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Assert.AreEqual(1, TLanguageConfigReader.LanguageIndex(Cfg, 'pt'));
  Assert.AreEqual(2, TLanguageConfigReader.LanguageIndex(Cfg, 'en'));
  Assert.AreEqual(3, TLanguageConfigReader.LanguageIndex(Cfg, 'es'));
end;

procedure TTestTsiLangConfig.ResolvesRegionalLanguageCodeToBaseIndex;
var
  Cfg: TLanguageConfig;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Assert.AreEqual(3, TLanguageConfigReader.LanguageIndex(Cfg, 'es-MX'));
end;

procedure TTestTsiLangConfig.LoadsCustomTranslationFilePath;
var
  Cfg: TLanguageConfig;
  Ini: TStringList;
begin
  Ini := TStringList.Create;
  try
    Ini.Add('[Language]');
    Ini.Add('Current=en');
    Ini.Add('Fallback=pt');
    Ini.Add('TranslationFile=Languages\custom.sil');
    Ini.SaveToFile(FTempPath + PathDelim + 'Config.ini');
  finally
    Ini.Free;
  end;

  Cfg := TLanguageConfigReader.Load(FTempPath + PathDelim);
  Assert.IsTrue(Pos('custom.sil', Cfg.TranslationFile) > 0);
end;

procedure TTestTsiLangConfig.UsesDefaultTranslationFileWhenNotConfigured;
var
  Cfg: TLanguageConfig;
begin
  Cfg := TLanguageConfigReader.Load(FTempPath + PathDelim);
  Assert.IsTrue(Pos('comercial.sil', Cfg.TranslationFile) > 0);
end;

end.
