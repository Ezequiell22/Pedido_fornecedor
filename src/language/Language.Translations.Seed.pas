unit Language.Translations.Seed;

interface

type
  TTranslationSeed = class
  public
    class procedure RegisterCatalogStrings; static;
  end;

implementation

uses
  System.SysUtils, System.Classes,
  Language.Translations.Catalog,
  comercial.view.index;

const
  LANG_DELIM = #1;

function PackLanguages(const Entry: TTranslationEntry): string;
begin
  Result := Entry.TextPt + LANG_DELIM + Entry.TextEn + LANG_DELIM + Entry.TextEs;
end;

class procedure TTranslationSeed.RegisterCatalogStrings;
var
  Entry: TTranslationEntry;
  Line: string;
  Exists: Boolean;
  I: Integer;
begin
  if not Assigned(frmIndex) or not Assigned(frmIndex.siLang1) then
    Exit;

  frmIndex.siLang1.NumOfLanguages := 3;

  for Entry in TTranslationCatalog.AllEntries do
  begin
    if Entry.FormClass <> '' then
      Continue;

    Line := Entry.ComponentName + '=' + PackLanguages(Entry);
    Exists := False;
    for I := 0 to frmIndex.siLang1.Strings.Count - 1 do
      if SameText(Copy(frmIndex.siLang1.Strings[I], 1, Length(Entry.ComponentName)),
        Entry.ComponentName) then
      begin
        Exists := True;
        Break;
      end;

    if not Exists then
      frmIndex.siLang1.Strings.Add(Line);
  end;
end;

end.
