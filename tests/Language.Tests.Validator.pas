unit Language.Tests.Validator;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestLanguageValidator = class
  private
    FBasePath: string;
    FTempPath: string;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure ProjectLanguagesHaveNoDuplicates;
    [Test]
    procedure ProjectLanguagesHaveNoMissingKeys;
    [Test]
    procedure DetectsMissingKeysBetweenLanguages;
    [Test]
    procedure DetectsEmptyTranslationValues;
    [Test]
    procedure DetectsExtraKeysInSecondaryLanguage;
  end;

implementation

uses
  System.SysUtils,
  Language.Tools.Validator,
  Language.Tests.Helpers;

procedure TTestLanguageValidator.Setup;
begin
  FBasePath := TLanguageTestHelper.ResolveProjectBase;
  FTempPath := TLanguageTestHelper.CreateTempDir;
end;

procedure TTestLanguageValidator.TearDown;
begin
  TLanguageTestHelper.CleanupTempDir(FTempPath);
end;

procedure TTestLanguageValidator.ProjectLanguagesHaveNoDuplicates;
var
  R: TLanguageValidationResult;
begin
  R := TLanguageValidator.Validate(TLanguageTestHelper.LanguagesPath, 'pt');
  try
    Assert.AreEqual(0, R.DuplicateKeys);
  finally
    R.Details.Free;
  end;
end;

procedure TTestLanguageValidator.ProjectLanguagesHaveNoMissingKeys;
var
  R: TLanguageValidationResult;
begin
  R := TLanguageValidator.Validate(TLanguageTestHelper.LanguagesPath, 'pt');
  try
    Assert.AreEqual(0, R.MissingKeys, R.Details.Text);
  finally
    R.Details.Free;
  end;
end;

procedure TTestLanguageValidator.DetectsMissingKeysBetweenLanguages;
var
  R: TLanguageValidationResult;
begin
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'pt',
    '{ "KEY_A": "A", "KEY_B": "B" }');
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'en',
    '{ "KEY_A": "A" }');

  R := TLanguageValidator.Validate(FTempPath + 'Languages' + PathDelim, 'pt');
  try
    Assert.IsTrue(R.MissingKeys > 0);
    Assert.IsTrue(Pos('KEY_B', R.Details.Text) > 0);
  finally
    R.Details.Free;
  end;
end;

procedure TTestLanguageValidator.DetectsEmptyTranslationValues;
var
  R: TLanguageValidationResult;
begin
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'pt',
    '{ "KEY_EMPTY": "" }');
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'en',
    '{ "KEY_EMPTY": "Value" }');

  R := TLanguageValidator.Validate(FTempPath + 'Languages' + PathDelim, 'pt');
  try
    Assert.IsTrue(R.EmptyValues > 0);
  finally
    R.Details.Free;
  end;
end;

procedure TTestLanguageValidator.DetectsExtraKeysInSecondaryLanguage;
var
  R: TLanguageValidationResult;
begin
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'pt',
    '{ "KEY_A": "A" }');
  TLanguageTestHelper.WriteLanguageJson(FTempPath, 'en',
    '{ "KEY_A": "A", "KEY_EXTRA": "Extra" }');

  R := TLanguageValidator.Validate(FTempPath + 'Languages' + PathDelim, 'pt');
  try
    Assert.IsTrue(R.InconsistentKeys > 0);
    Assert.IsTrue(Pos('KEY_EXTRA', R.Details.Text) > 0);
  finally
    R.Details.Free;
  end;
end;

end.
