unit Language.Tests.VCL;

interface

uses
  DUnitX.TestFramework,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Controls,
  Language.Core.Interfaces,
  Language.Runtime.Cache;

type
  TTestTranslateForm = class(TForm)
  public
    btnSave: TButton;
    lblName: TLabel;
    grpInfo: TGroupBox;
    constructor Create(AOwner: TComponent); override;
  end;

  [TestFixture]
  TTestLanguageVCL = class
  private
    FTempPath: string;
    FCache: TTranslationCache;
    FFallback: TTranslationCache;
    FTranslator: ITranslator;
    procedure BuildTranslator;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TranslateFormCaption;
    [Test]
    procedure TranslateButtonCaption;
    [Test]
    procedure TranslateGroupBoxCaption;
    [Test]
    procedure TranslateDynamicComponent;
    [Test]
    procedure TranslateContainerWalksChildren;
  end;

implementation

uses
  System.SysUtils,
  Language.Runtime.Config,
  Language.Runtime.Cache,
  Language.Runtime.Translator,
  Language.Tests.Helpers;

constructor TTestTranslateForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := 'Titulo Original';

  lblName := TLabel.Create(Self);
  lblName.Name := 'lblName';
  lblName.Caption := 'Nome';
  lblName.Parent := Self;

  btnSave := TButton.Create(Self);
  btnSave.Name := 'btnSave';
  btnSave.Caption := 'Salvar';
  btnSave.Parent := Self;

  grpInfo := TGroupBox.Create(Self);
  grpInfo.Name := 'grpInfo';
  grpInfo.Caption := 'Informacoes';
  grpInfo.Parent := Self;
end;

procedure TTestLanguageVCL.Setup;
begin
  FTempPath := TLanguageTestHelper.CreateTempDir;
  BuildTranslator;
end;

procedure TTestLanguageVCL.TearDown;
begin
  FTranslator := nil;
  FFallback.Free;
  FCache.Free;
  TLanguageTestHelper.CleanupTempDir(FTempPath);
end;

procedure TTestLanguageVCL.BuildTranslator;
var
  Cfg: TLanguageConfig;
begin
  FCache := TTranslationCache.Create;
  FFallback := TTranslationCache.Create;
  Cfg := TLanguageConfigReader.Load(TLanguageTestHelper.ResolveProjectBase);
  Cfg.AuditMode := False;
  Cfg.DiscoveryMode := False;

  FCache.Add('FORM_TESTTRANSLATEFORM.CAPTION', 'Original Title');
  FCache.Add('FORM_TESTTRANSLATEFORM.BTNSAVE', 'Save');
  FCache.Add('FORM_TESTTRANSLATEFORM.LBLNAME', 'Name');
  FCache.Add('FORM_TESTTRANSLATEFORM.GRPINFO', 'Information');
  FCache.Add('FORM_TESTTRANSLATEFORM.BTNDYNAMIC', 'Dynamic');

  FTranslator := TLanguageTranslator.Create(Cfg, FCache, FFallback);
end;

procedure TTestLanguageVCL.TranslateFormCaption;
var
  Form: TTestTranslateForm;
begin
  Form := TTestTranslateForm.Create(nil);
  try
    FTranslator.TranslateForm(Form);
    Assert.AreEqual('Original Title', Form.Caption);
  finally
    Form.Free;
  end;
end;

procedure TTestLanguageVCL.TranslateButtonCaption;
var
  Form: TTestTranslateForm;
begin
  Form := TTestTranslateForm.Create(nil);
  try
    FTranslator.TranslateForm(Form);
    Assert.AreEqual('Save', Form.btnSave.Caption);
  finally
    Form.Free;
  end;
end;

procedure TTestLanguageVCL.TranslateGroupBoxCaption;
var
  Form: TTestTranslateForm;
begin
  Form := TTestTranslateForm.Create(nil);
  try
    FTranslator.TranslateForm(Form);
    Assert.AreEqual('Information', Form.grpInfo.Caption);
  finally
    Form.Free;
  end;
end;

procedure TTestLanguageVCL.TranslateDynamicComponent;
var
  Form: TTestTranslateForm;
  Btn: TButton;
begin
  Form := TTestTranslateForm.Create(nil);
  try
    Btn := TButton.Create(Form);
    Btn.Name := 'btnDynamic';
    Btn.Caption := 'Dinamico';
    Btn.Parent := Form;

    FTranslator.TranslateComponent(Btn);
    Assert.AreEqual('Dynamic', Btn.Caption);
  finally
    Form.Free;
  end;
end;

procedure TTestLanguageVCL.TranslateContainerWalksChildren;
var
  Form: TTestTranslateForm;
begin
  Form := TTestTranslateForm.Create(nil);
  try
    FTranslator.TranslateContainer(Form);
    Assert.AreEqual('Name', Form.lblName.Caption);
    Assert.AreEqual('Save', Form.btnSave.Caption);
  finally
    Form.Free;
  end;
end;

end.
