unit Language.VCL.Hook;

interface

uses
  Language.Core.Interfaces;

type
  TLanguageHook = class
  public
    class procedure Install(ATranslator: ITranslator); static;
    class procedure RetranslateAll; static;
  end;

implementation

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Language.Runtime.Translator;

var
  GTranslator: ITranslator;
  GInstalled: Boolean;
  OldOnMessage: TMessageEvent;
  OldOnShowHint: THintEvent;
  GTranslatedForms: TStringList;

procedure ApplicationOnMessage(var Msg: TMsg; var Handled: Boolean);
var
  I: Integer;
  Form: TCustomForm;
begin
  if GInstalled and (GTranslator <> nil) and (Msg.message = WM_SHOWWINDOW) and
    (Msg.wParam = 1) then
  begin
    for I := 0 to Screen.FormCount - 1 do
    begin
      Form := Screen.Forms[I];
      if Form.Handle = Msg.hwnd then
      begin
        if GTranslatedForms.IndexOf(Form.Name) < 0 then
        begin
          GTranslatedForms.Add(Form.Name);
          TLanguageTranslator(GTranslator).TranslateForm(Form);
        end;
        Break;
      end;
    end;
  end;

  if Assigned(OldOnMessage) then
    OldOnMessage(Msg, Handled);
end;

procedure ApplicationOnHint(var HintStr: string);
var
  Key, Translated: string;
begin
  if (GTranslator <> nil) and (HintStr <> '') then
  begin
    Key := 'HINT.' + HintStr;
    Translated := GTranslator.Translate(Key);
    if Translated <> Key then
      HintStr := Translated;
  end;
  if Assigned(OldOnShowHint) then
    OldOnShowHint(HintStr);
end;

class procedure TLanguageHook.Install(ATranslator: ITranslator);
begin
  GTranslator := ATranslator;
  if not GInstalled then
  begin
    GTranslatedForms := TStringList.Create;
    OldOnMessage := Application.OnMessage;
    OldOnShowHint := Application.OnShowHint;
    Application.OnMessage := ApplicationOnMessage;
    Application.OnShowHint := ApplicationOnHint;
    GInstalled := True;
  end;
end;

class procedure TLanguageHook.RetranslateAll;
var
  I: Integer;
begin
  if GTranslator = nil then
    Exit;
  GTranslatedForms.Clear;
  GTranslator.RetranslateOpenForms;
end;

finalization
  GTranslatedForms.Free;

end.
