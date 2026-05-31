unit Language.Tests.Config;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestLanguageConfig = class
  private
    FBasePath: string;
    FTempPath: string;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure LoadsCurrentLanguageFromProjectConfig;
    [Test]
    procedure LoadsFallbackLanguageFromProjectConfig;
    [Test]
    procedure LoadsHotReloadFlag;
    [Test]
    procedure LoadsAuditAndDiscoveryFlagsFromTempConfig;
    [Test]
    procedure UsesDefaultsWhenConfigFileMissing;
  end;

implementation

uses
  System.SysUtils,
  Language.Runtime.Config,
  Language.Tests.Helpers;

procedure TTestLanguageConfig.Setup;
begin
  FBasePath := TLanguageTestHelper.ResolveProjectBase;
  FTempPath := TLanguageTestHelper.CreateTempDir;
end;

procedure TTestLanguageConfig.TearDown;
begin
  TLanguageTestHelper.CleanupTempDir(FTempPath);
end;

procedure TTestLanguageConfig.LoadsCurrentLanguageFromProjectConfig;
var
  Cfg: TLanguageConfig;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Assert.AreEqual('pt', Cfg.Current);
end;

procedure TTestLanguageConfig.LoadsFallbackLanguageFromProjectConfig;
var
  Cfg: TLanguageConfig;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Assert.AreEqual('en', Cfg.Fallback);
end;

procedure TTestLanguageConfig.LoadsHotReloadFlag;
var
  Cfg: TLanguageConfig;
begin
  Cfg := TLanguageConfigReader.Load(FBasePath);
  Assert.IsTrue(Cfg.HotReload);
end;

procedure TTestLanguageConfig.LoadsAuditAndDiscoveryFlagsFromTempConfig;
var
  Cfg: TLanguageConfig;
begin
  TLanguageTestHelper.WriteConfig(FTempPath, 'es', 'en', True, True, True);
  Cfg := TLanguageConfigReader.Load(FTempPath);
  Assert.AreEqual('es', Cfg.Current);
  Assert.IsTrue(Cfg.AuditMode);
  Assert.IsTrue(Cfg.DiscoveryMode);
end;

procedure TTestLanguageConfig.UsesDefaultsWhenConfigFileMissing;
var
  Cfg: TLanguageConfig;
  EmptyPath: string;
begin
  EmptyPath := IncludeTrailingPathDelimiter(FTempPath) + 'empty' + PathDelim;
  ForceDirectories(EmptyPath);
  Cfg := TLanguageConfigReader.Load(EmptyPath);
  Assert.AreEqual('pt', Cfg.Current);
  Assert.AreEqual('en', Cfg.Fallback);
end;

end.
