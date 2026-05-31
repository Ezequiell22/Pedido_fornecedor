unit Language.VCL.Keys;

interface

uses
  System.SysUtils,
  Vcl.Controls;

type
  TLanguageKeys = class
  public
    class function FormClassKey(const FormClassName: string): string; static;
    class function FormCaptionKey(AForm: TCustomForm): string; static;
    class function ComponentKey(AForm: TCustomForm; AComponent: TComponent): string; static;
    class function NamedKey(const FormPrefix, ElementName: string): string; static;
  end;

implementation

class function TLanguageKeys.FormClassKey(const FormClassName: string): string;
var
  N: string;
begin
  N := FormClassName;
  if (Length(N) > 0) and (N[1] = 'T') then
    N := Copy(N, 2, MaxInt);
  Result := UpperCase(N);
end;

class function TLanguageKeys.FormCaptionKey(AForm: TCustomForm): string;
begin
  Result := 'FORM_' + FormClassKey(AForm.ClassName) + '.CAPTION';
end;

class function TLanguageKeys.ComponentKey(AForm: TCustomForm;
  AComponent: TComponent): string;
begin
  Result := 'FORM_' + FormClassKey(AForm.ClassName) + '.' + UpperCase(AComponent.Name);
end;

class function TLanguageKeys.NamedKey(const FormPrefix, ElementName: string): string;
begin
  Result := FormPrefix + '.' + UpperCase(ElementName);
end;

end.
