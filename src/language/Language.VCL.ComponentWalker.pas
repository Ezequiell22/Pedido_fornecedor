unit Language.VCL.ComponentWalker;

interface

uses
  System.SysUtils,
  Vcl.Controls,
  Vcl.Menus,
  Vcl.ActnList,
  Vcl.ComCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Language.Core.Interfaces;

type
  TComponentCaptionReader = class
  public
    class function GetCaption(AComponent: TComponent): string; static;
    class procedure SetCaption(AComponent: TComponent; const Value: string); static;
    class function GetHint(AComponent: TComponent): string; static;
    class procedure SetHint(AComponent: TComponent; const Value: string); static;
  end;

  TComponentWalker = class
  public
    class procedure Walk(AComponent: TComponent; AForm: TCustomForm;
      ATranslator: ITranslator); static;
    class procedure WalkMenuItems(AItem: TMenuItem; AForm: TCustomForm;
      ATranslator: ITranslator); static;
  end;

implementation

uses
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Language.VCL.Keys;

class function TComponentCaptionReader.GetCaption(AComponent: TComponent): string;
begin
  Result := '';
  if AComponent is TCustomLabel then
    Result := TCustomLabel(AComponent).Caption
  else if AComponent is TCustomGroupBox then
    Result := TCustomGroupBox(AComponent).Caption
  else if AComponent is TCustomCheckBox then
    Result := TCustomCheckBox(AComponent).Caption
  else if AComponent is TCustomRadioButton then
    Result := TCustomRadioButton(AComponent).Caption
  else if AComponent is TCustomButton then
    Result := TCustomButton(AComponent).Caption
  else if AComponent is TCustomPanel then
    Result := TCustomPanel(AComponent).Caption
  else if AComponent is TTabSheet then
    Result := TTabSheet(AComponent).Caption;
end;

class procedure TComponentCaptionReader.SetCaption(AComponent: TComponent;
  const Value: string);
begin
  if AComponent is TCustomLabel then
    TCustomLabel(AComponent).Caption := Value
  else if AComponent is TCustomGroupBox then
    TCustomGroupBox(AComponent).Caption := Value
  else if AComponent is TCustomCheckBox then
    TCustomCheckBox(AComponent).Caption := Value
  else if AComponent is TCustomRadioButton then
    TCustomRadioButton(AComponent).Caption := Value
  else if AComponent is TCustomButton then
    TCustomButton(AComponent).Caption := Value
  else if AComponent is TCustomPanel then
    TCustomPanel(AComponent).Caption := Value
  else if AComponent is TTabSheet then
    TTabSheet(AComponent).Caption := Value;
end;

class function TComponentCaptionReader.GetHint(AComponent: TComponent): string;
begin
  Result := '';
  if AComponent is TControl then
    Result := TControl(AComponent).Hint;
end;

class procedure TComponentCaptionReader.SetHint(AComponent: TComponent;
  const Value: string);
begin
  if AComponent is TControl then
    TControl(AComponent).Hint := Value;
end;

class procedure TComponentWalker.WalkMenuItems(AItem: TMenuItem;
  AForm: TCustomForm; ATranslator: ITranslator);
var
  I: Integer;
  Key, Translated: string;
begin
  if (AItem = nil) or (AForm = nil) or (ATranslator = nil) then
    Exit;
  for I := 0 to AItem.Count - 1 do
  begin
    if AItem.Items[I].Caption <> '-' then
    begin
      Key := TLanguageKeys.ComponentKey(AForm, AItem.Items[I]);
      Translated := ATranslator.Translate(Key);
      if Translated <> Key then
        AItem.Items[I].Caption := Translated;
    end;
    if AItem.Items[I].Count > 0 then
      WalkMenuItems(AItem.Items[I], AForm, ATranslator);
  end;
end;

class procedure TComponentWalker.Walk(AComponent: TComponent; AForm: TCustomForm;
  ATranslator: ITranslator);
var
  I: Integer;
  Key, Translated, HintKey: string;
  F: TCustomForm;
begin
  if (AComponent = nil) or (ATranslator = nil) then
    Exit;

  if AComponent is TCustomForm then
    F := TCustomForm(AComponent)
  else
    F := AForm;

  if (F <> nil) and (AComponent.Name <> '') then
  begin
    if TComponentCaptionReader.GetCaption(AComponent) <> '' then
      ATranslator.TranslateComponent(AComponent);

    if TComponentCaptionReader.GetHint(AComponent) <> '' then
    begin
      HintKey := TLanguageKeys.ComponentKey(F, AComponent) + '.HINT';
      Translated := ATranslator.Translate(HintKey);
      if Translated <> HintKey then
        TComponentCaptionReader.SetHint(AComponent, Translated);
    end;
  end;

  if AComponent is TMainMenu then
    WalkMenuItems(TMainMenu(AComponent).Items, F, ATranslator)
  else if AComponent is TPopupMenu then
    WalkMenuItems(TPopupMenu(AComponent).Items, F, ATranslator)
  else if AComponent is TActionList then
  begin
    for I := 0 to TActionList(AComponent).ActionCount - 1 do
    begin
      if F <> nil then
      begin
        Key := TLanguageKeys.ComponentKey(F, TActionList(AComponent).Actions[I]);
        Translated := ATranslator.Translate(Key);
        if Translated <> Key then
          TActionList(AComponent).Actions[I].Caption := Translated;
      end;
    end;
  end
  else if (AComponent is TStatusBar) and (F <> nil) then
  begin
    for I := 0 to TStatusBar(AComponent).Panels.Count - 1 do
    begin
      Key := TLanguageKeys.NamedKey('FORM_' + TLanguageKeys.FormClassKey(F.ClassName),
        AComponent.Name + '_PANEL' + IntToStr(I));
      Translated := ATranslator.Translate(Key);
      if Translated <> Key then
        TStatusBar(AComponent).Panels[I].Text := Translated;
    end;
  end
  else if (AComponent is TDBGrid) and (F <> nil) then
  begin
    for I := 0 to TDBGrid(AComponent).Columns.Count - 1 do
    begin
      Key := TLanguageKeys.NamedKey('FORM_' + TLanguageKeys.FormClassKey(F.ClassName),
        AComponent.Name + '_COL' + TDBGrid(AComponent).Columns[I].FieldName);
      if Key = '' then
        Key := TLanguageKeys.NamedKey('FORM_' + TLanguageKeys.FormClassKey(F.ClassName),
          AComponent.Name + '_COL' + IntToStr(I));
      Translated := ATranslator.Translate(Key);
      if Translated <> Key then
        TDBGrid(AComponent).Columns[I].Title.Caption := Translated;
    end;
  end
  else if (AComponent is TStringGrid) and (F <> nil) then
  begin
    for I := 0 to TStringGrid(AComponent).ColCount - 1 do
    begin
      if TStringGrid(AComponent).Cells[I, 0] <> '' then
      begin
        Key := TLanguageKeys.NamedKey('FORM_' + TLanguageKeys.FormClassKey(F.ClassName),
          AComponent.Name + '_COL' + IntToStr(I));
        Translated := ATranslator.Translate(Key);
        if Translated <> Key then
          TStringGrid(AComponent).Cells[I, 0] := Translated;
      end;
    end;
  end;

  if AComponent is TWinControl then
  begin
    for I := 0 to TWinControl(AComponent).ControlCount - 1 do
      Walk(TWinControl(AComponent).Controls[I], F, ATranslator);
  end;

  for I := 0 to AComponent.ComponentCount - 1 do
    if not (AComponent.Components[I] is TWinControl) then
      Walk(AComponent.Components[I], F, ATranslator);
end;

end.
