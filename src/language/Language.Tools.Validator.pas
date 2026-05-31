unit Language.Tools.Validator;

interface

uses
  System.SysUtils,
  System.Classes;

type
  TLanguageValidationResult = record
    MissingKeys: Integer;
    DuplicateKeys: Integer;
    EmptyValues: Integer;
    InconsistentKeys: Integer;
    Details: TStringList;
    function Summary: string;
    procedure Clear;
  end;

  TLanguageValidator = class
  public
    class function Validate(const LanguagesPath: string;
      const ReferenceLanguage: string = 'pt'): TLanguageValidationResult; static;
  end;

implementation

uses
  System.IOUtils,
  System.Generics.Collections,
  Language.JsonProvider;

function TLanguageValidationResult.Summary: string;
begin
  Result := Format(
    'Missing Keys: %d'#13#10'Duplicate Keys: %d'#13#10'Empty Values: %d'#13#10 +
    'Inconsistent Keys: %d',
    [MissingKeys, DuplicateKeys, EmptyValues, InconsistentKeys]);
end;

procedure TLanguageValidationResult.Clear;
begin
  MissingKeys := 0;
  DuplicateKeys := 0;
  EmptyValues := 0;
  InconsistentKeys := 0;
  if Details <> nil then
    Details.Clear;
end;

class function TLanguageValidator.Validate(const LanguagesPath: string;
  const ReferenceLanguage: string): TLanguageValidationResult;
var
  Provider: TJsonLanguageProvider;
  Available: TStringList;
  RefTrans, LangTrans, Plurals: TStrings;
  RefKeys, LangKeys: TDictionary<string, Boolean>;
  Lang, Key: string;
  I: Integer;
begin
  Result.Clear;
  Result.Details := TStringList.Create;
  Provider := TJsonLanguageProvider.Create(LanguagesPath);
  Available := Provider.GetAvailableLanguages;
  RefKeys := TDictionary<string, Boolean>.Create;
  LangKeys := TDictionary<string, Boolean>.Create;
  try
    Provider.LoadLanguage(ReferenceLanguage, RefTrans, Plurals);
    try
      for I := 0 to RefTrans.Count - 1 do
      begin
        Key := RefTrans.Names[I];
        if Key = '' then
          Continue;
        if RefKeys.ContainsKey(Key) then
          Inc(Result.DuplicateKeys)
        else
          RefKeys.Add(Key, True);
        if Trim(RefTrans.ValueFromIndex[I]) = '' then
          Inc(Result.EmptyValues);
      end;

      for Lang in Available do
      begin
        if SameText(Lang, ReferenceLanguage) then
          Continue;
        Provider.LoadLanguage(Lang, LangTrans, Plurals);
        try
          LangKeys.Clear;
          for I := 0 to LangTrans.Count - 1 do
          begin
            Key := LangTrans.Names[I];
            if LangKeys.ContainsKey(Key) then
              Inc(Result.DuplicateKeys)
            else
              LangKeys.Add(Key, True);
            if Trim(LangTrans.ValueFromIndex[I]) = '' then
              Inc(Result.EmptyValues);
            if not RefKeys.ContainsKey(Key) then
            begin
              Inc(Result.InconsistentKeys);
              Result.Details.Add('Extra key in ' + Lang + ': ' + Key);
            end;
          end;
          for Key in RefKeys.Keys do
          begin
            if not LangKeys.ContainsKey(Key) then
            begin
              Inc(Result.MissingKeys);
              Result.Details.Add('Missing in ' + Lang + ': ' + Key);
            end;
          end;
        finally
          LangTrans.Free;
          Plurals.Free;
        end;
      end;
    finally
      RefTrans.Free;
      Plurals.Free;
    end;
  finally
    Available.Free;
    RefKeys.Free;
    LangKeys.Free;
  end;
end;

end.
