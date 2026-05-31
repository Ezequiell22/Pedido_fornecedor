unit Language.Tests.JsonProvider;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestLanguageJsonProvider = class
  private
    FBasePath: string;
    FTempPath: string;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure LoadsTranslationsFromProjectFiles;
    [Test]
    procedure ParsesPluralEntries;
    [Test]
    procedure SkipsMetadataSection;
    [Test]
    procedure ListsAvailableLanguages;
    [Test]
    procedure ReturnsEmptyForMissingLanguageFile;
    [Test]
    procedure ResolvesRegionalCodeToBaseLanguageFile;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  Language.JsonProvider,
  Language.Tests.Helpers;

procedure TTestLanguageJsonProvider.Setup;
begin
  FBasePath := TLanguageTestHelper.ResolveProjectBase;
  FTempPath := TLanguageTestHelper.CreateTempDir;
end;

procedure TTestLanguageJsonProvider.TearDown;
begin
  TLanguageTestHelper.CleanupTempDir(FTempPath);
end;

procedure TTestLanguageJsonProvider.LoadsTranslationsFromProjectFiles;
var
  Provider: TJsonLanguageProvider;
  Trans, Plurals: TStrings;
begin
  Provider := TJsonLanguageProvider.Create(TLanguageTestHelper.LanguagesPath);
  Provider.LoadLanguage('pt', Trans, Plurals);
  try
    Assert.IsTrue(Trans.Count > 10);
    Assert.AreEqual('Módulo Comercial', Trans.Values['FORM_FRMINDEX.CAPTION']);
  finally
    Trans.Free;
    Plurals.Free;
  end;
end;

procedure TTestLanguageJsonProvider.ParsesPluralEntries;
var
  Provider: TJsonLanguageProvider;
  Trans, Plurals: TStrings;
begin
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'pt',
    '{' + sLineBreak +
    '  "ITEMS_FOUND": {' + sLineBreak +
    '    "one": "{0} item",' + sLineBreak +
    '    "other": "{0} items"' + sLineBreak +
    '  }' + sLineBreak +
    '}');

  Provider := TJsonLanguageProvider.Create(FTempPath + 'Languages' + PathDelim);
  Provider.LoadLanguage('pt', Trans, Plurals);
  try
    Assert.AreEqual('{0} item', Plurals.Values['ITEMS_FOUND.one']);
    Assert.AreEqual('{0} items', Plurals.Values['ITEMS_FOUND.other']);
    Assert.AreEqual(0, Trans.Count);
  finally
    Trans.Free;
    Plurals.Free;
  end;
end;

procedure TTestLanguageJsonProvider.SkipsMetadataSection;
var
  Provider: TJsonLanguageProvider;
  Trans, Plurals: TStrings;
begin
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'en',
    '{' + sLineBreak +
    '  "_metadata": { "language": "en", "version": "1.0.0" },' + sLineBreak +
    '  "BTN_SAVE": "Save"' + sLineBreak +
    '}');

  Provider := TJsonLanguageProvider.Create(FTempPath + 'Languages' + PathDelim);
  Provider.LoadLanguage('en', Trans, Plurals);
  try
    Assert.AreEqual(1, Trans.Count);
    Assert.AreEqual('Save', Trans.Values['BTN_SAVE']);
    Assert.IsFalse(Trans.IndexOfName('_metadata') >= 0);
  finally
    Trans.Free;
    Plurals.Free;
  end;
end;

procedure TTestLanguageJsonProvider.ListsAvailableLanguages;
var
  Provider: TJsonLanguageProvider;
  Available: TStringList;
begin
  Provider := TJsonLanguageProvider.Create(TLanguageTestHelper.LanguagesPath);
  Available := Provider.GetAvailableLanguages;
  try
    Assert.IsTrue(Available.IndexOf('pt') >= 0);
    Assert.IsTrue(Available.IndexOf('en') >= 0);
    Assert.IsTrue(Available.IndexOf('es') >= 0);
  finally
    Available.Free;
  end;
end;

procedure TTestLanguageJsonProvider.ReturnsEmptyForMissingLanguageFile;
var
  Provider: TJsonLanguageProvider;
  Trans, Plurals: TStrings;
begin
  Provider := TJsonLanguageProvider.Create(FTempPath + 'Languages' + PathDelim);
  Provider.LoadLanguage('fr', Trans, Plurals);
  try
    Assert.AreEqual(0, Trans.Count);
  finally
    Trans.Free;
    Plurals.Free;
  end;
end;

procedure TTestLanguageJsonProvider.ResolvesRegionalCodeToBaseLanguageFile;
var
  Provider: TJsonLanguageProvider;
  Trans, Plurals: TStrings;
begin
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'es',
    '{ "MSG_HELLO": "Hola" }');

  Provider := TJsonLanguageProvider.Create(FTempPath + 'Languages' + PathDelim);
  Provider.LoadLanguage('es-MX', Trans, Plurals);
  try
    Assert.AreEqual('Hola', Trans.Values['MSG_HELLO']);
  finally
    Trans.Free;
    Plurals.Free;
  end;
end;

end.
