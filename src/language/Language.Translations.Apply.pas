unit Language.Translations.Apply;

interface

uses
  Vcl.Forms;

type
  TTranslationApply = class
  public
    class procedure ApplyForm(AForm: TForm; const LangCode: string;
      const ApplyFormCaption: Boolean = True); static;
    class procedure ApplyMainForm(const LangCode: string); static;
  end;

implementation

uses
  System.SysUtils, System.TypInfo, System.Classes,
  Language.Translations.Catalog,
  comercial.view.index;

procedure SetComponentText(AComponent: TComponent; const PropName,
  AValue: string);
begin
  if AComponent = nil then
    Exit;
  if IsPublishedProp(AComponent, PropName) then
    SetPropValue(AComponent, PropName, AValue);
end;

class procedure TTranslationApply.ApplyForm(AForm: TForm; const LangCode: string;
  const ApplyFormCaption: Boolean);
var
  Entries: TArray<TTranslationEntry>;
  Entry: TTranslationEntry;
  LangIndex: Integer;
  Comp: TComponent;
  Value: string;
begin
  if AForm = nil then
    Exit;

  LangIndex := TTranslationCatalog.LanguageIndex(LangCode);
  TTranslationCatalog.GetFormEntries(AForm.ClassName, Entries);

  for Entry in Entries do
  begin
    Value := TTranslationCatalog.TextByIndex(LangIndex, Entry);
    if Entry.ComponentName = '' then
    begin
      if ApplyFormCaption then
        AForm.Caption := Value;
    end
    else
    begin
      Comp := AForm.FindComponent(Entry.ComponentName);
      SetComponentText(Comp, Entry.PropertyName, Value);
    end;
  end;
end;

class procedure TTranslationApply.ApplyMainForm(const LangCode: string);
begin
  if Assigned(frmIndex) then
    ApplyForm(frmIndex, LangCode, True);
end;

end.
