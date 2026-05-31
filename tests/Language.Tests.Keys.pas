unit Language.Tests.Keys;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestLanguageKeys = class
  public
    [Test]
    procedure FormClassKeyRemovesTPrefix;
    [Test]
    procedure FormCaptionKeyUsesNamespace;
    [Test]
    procedure ComponentKeyUsesFormAndComponentName;
    [Test]
    procedure NamedKeyBuildsCustomNamespace;
  end;

implementation

uses
  Language.VCL.Keys;

procedure TTestLanguageKeys.FormClassKeyRemovesTPrefix;
begin
  Assert.AreEqual('FRMFORNECEDOR', TLanguageKeys.FormClassKey('TfrmFornecedor'));
end;

procedure TTestLanguageKeys.FormCaptionKeyUsesNamespace;
begin
  Assert.AreEqual('FORM_FRMCLIENTE.CAPTION',
    TLanguageKeys.NamedKey('FORM_FRMCLIENTE', 'CAPTION'));
end;

procedure TTestLanguageKeys.ComponentKeyUsesFormAndComponentName;
begin
  Assert.AreEqual('FORM_FRMCLIENTE.BTN_SAVE',
    TLanguageKeys.NamedKey('FORM_FRMCLIENTE', 'BTN_SAVE'));
end;

procedure TTestLanguageKeys.NamedKeyBuildsCustomNamespace;
begin
  Assert.AreEqual('FORM_PEDIDO.GRID_COL0',
    TLanguageKeys.NamedKey('FORM_PEDIDO', 'GRID_COL0'));
end;

end.
