unit Language.Tests.Translator;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestTranslatorCatalog = class
  public
    [Test]
    procedure ResolvesPortugueseMessages;
    [Test]
    procedure ResolvesEnglishMessages;
    [Test]
    procedure ResolvesSpanishMessages;
    [Test]
    procedure AppliesPlaceholderPattern;
    [Test]
    procedure ResolvesFornecedorFormLabelsInEnglish;
    [Test]
    procedure ResolvesIndexMenuInSpanish;
  end;

implementation

uses
  System.SysUtils,
  Language.Translations.Catalog;

procedure TTestTranslatorCatalog.ResolvesPortugueseMessages;
begin
  Assert.AreEqual('Informe o nome fantasia.',
    TTranslationCatalog.MessageText('pt', 'MSG_FANTASIA_OBRIGATORIO'));
end;

procedure TTestTranslatorCatalog.ResolvesEnglishMessages;
begin
  Assert.AreEqual('Trade name is required.',
    TTranslationCatalog.MessageText('en', 'MSG_FANTASIA_OBRIGATORIO'));
  Assert.AreEqual('Legal name is required.',
    TTranslationCatalog.MessageText('en', 'MSG_RAZAO_OBRIGATORIA'));
end;

procedure TTestTranslatorCatalog.ResolvesSpanishMessages;
begin
  Assert.AreEqual('Indique el nombre de fantasia.',
    TTranslationCatalog.MessageText('es', 'MSG_FANTASIA_OBRIGATORIO'));
end;

procedure TTestTranslatorCatalog.AppliesPlaceholderPattern;
var
  Template: string;
begin
  Template := TTranslationCatalog.MessageText('en', 'MSG_RELATORIO_SALVO');
  Assert.IsTrue(Pos('{0}', Template) > 0);
end;

procedure TTestTranslatorCatalog.ResolvesFornecedorFormLabelsInEnglish;
var
  Entries: TArray<TTranslationEntry>;
  Entry: TTranslationEntry;
  Found: Boolean;
begin
  Found := False;
  TTranslationCatalog.GetFormEntries('TfrmFornecedor', Entries);
  for Entry in Entries do
    if SameText(Entry.ComponentName, 'Label2') then
    begin
      Assert.AreEqual('Trade Name',
        TTranslationCatalog.TextByIndex(2, Entry));
      Found := True;
    end;
  Assert.IsTrue(Found, 'Label2 entry missing for TfrmFornecedor');
end;

procedure TTestTranslatorCatalog.ResolvesIndexMenuInSpanish;
var
  Entries: TArray<TTranslationEntry>;
  Entry: TTranslationEntry;
begin
  TTranslationCatalog.GetFormEntries('TfrmIndex', Entries);
  for Entry in Entries do
    if SameText(Entry.ComponentName, 'ButtonFornecedores') then
    begin
      Assert.AreEqual('Proveedores',
        TTranslationCatalog.TextByIndex(3, Entry));
      Exit;
    end;
  Assert.Fail('ButtonFornecedores entry missing for TfrmIndex');
end;

end.
