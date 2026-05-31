unit Language.JsonProvider;

interface

uses
  System.SysUtils,
  System.Classes,
  Language.Core.Interfaces;

type
  TJsonLanguageProvider = class(TInterfacedObject, ILanguageProvider)
  private
    FLanguagesPath: string;
    function LanguageFilePath(const LanguageCode: string): string;
    procedure ParseJsonFlat(const Json: string; Translations, Plurals: TStrings);
    function UnescapeJson(const S: string): string;
    function ReadJsonString(const Json: string; var Pos: Integer): string;
    procedure SkipWhitespace(const Json: string; var Pos: Integer);
  public
    constructor Create(const ALanguagesPath: string);
    procedure LoadLanguage(const LanguageCode: string;
      out Translations: TStrings; out Plurals: TStrings);
    function GetAvailableLanguages: TStringList;
    function LanguagesPath: string;
  end;

implementation

uses
  System.IOUtils,
  Language.Runtime.Logger;

constructor TJsonLanguageProvider.Create(const ALanguagesPath: string);
begin
  inherited Create;
  FLanguagesPath := IncludeTrailingPathDelimiter(ALanguagesPath);
end;

function TJsonLanguageProvider.LanguagesPath: string;
begin
  Result := FLanguagesPath;
end;

function TJsonLanguageProvider.LanguageFilePath(const LanguageCode: string): string;
var
  Code: string;
  P: Integer;
begin
  Code := LanguageCode;
  P := Pos('-', Code);
  if P > 0 then
    Code := Copy(Code, 1, P - 1);
  Result := FLanguagesPath + LowerCase(Code) + '.json';
end;

procedure TJsonLanguageProvider.SkipWhitespace(const Json: string; var Pos: Integer);
begin
  while (Pos <= Length(Json)) and (Json[Pos] in [' ', #9, #10, #13, ',']) do
    Inc(Pos);
end;

function TJsonLanguageProvider.UnescapeJson(const S: string): string;
var
  I: Integer;
begin
  Result := '';
  I := 1;
  while I <= Length(S) do
  begin
    if (S[I] = '\') and (I < Length(S)) then
    begin
      Inc(I);
      case S[I] of
        '"': Result := Result + '"';
        '\': Result := Result + '\';
        'n': Result := Result + #10;
        'r': Result := Result + #13;
        't': Result := Result + #9;
      else
        Result := Result + S[I];
      end;
    end
    else
      Result := Result + S[I];
    Inc(I);
  end;
end;

function TJsonLanguageProvider.ReadJsonString(const Json: string;
  var Pos: Integer): string;
var
  Start: Integer;
  Escaped: Boolean;
begin
  Result := '';
  if (Pos > Length(Json)) or (Json[Pos] <> '"') then
    Exit;
  Inc(Pos);
  Start := Pos;
  Escaped := False;
  while Pos <= Length(Json) do
  begin
    if Escaped then
      Escaped := False
    else if Json[Pos] = '\' then
      Escaped := True
    else if Json[Pos] = '"' then
    begin
      Result := UnescapeJson(Copy(Json, Start, Pos - Start));
      Inc(Pos);
      Exit;
    end;
    Inc(Pos);
  end;
end;

procedure TJsonLanguageProvider.ParseJsonFlat(const Json: string;
  Translations, Plurals: TStrings);
var
  P, Depth, SubP: Integer;
  Key, Value, SubKey, SubVal: string;
begin
  P := 1;
  SkipWhitespace(Json, P);
  if (P <= Length(Json)) and (Json[P] = '{') then
    Inc(P);

  while P <= Length(Json) do
  begin
    SkipWhitespace(Json, P);
    if (P > Length(Json)) or (Json[P] = '}') then
      Break;

    Key := ReadJsonString(Json, P);
    SkipWhitespace(Json, P);
    if (P <= Length(Json)) and (Json[P] = ':') then
      Inc(P);
    SkipWhitespace(Json, P);

    if Key = '_metadata' then
    begin
      if (P <= Length(Json)) and (Json[P] = '{') then
      begin
        Depth := 1;
        Inc(P);
        while (P <= Length(Json)) and (Depth > 0) do
        begin
          if Json[P] = '{' then
            Inc(Depth)
          else if Json[P] = '}' then
            Dec(Depth);
          Inc(P);
        end;
      end;
      Continue;
    end;

    if (P <= Length(Json)) and (Json[P] = '"') then
    begin
      Value := ReadJsonString(Json, P);
      if Key <> '' then
        Translations.Values[Key] := Value;
    end
    else if (P <= Length(Json)) and (Json[P] = '{') then
    begin
      Inc(P);
      while P <= Length(Json) do
      begin
        SkipWhitespace(Json, P);
        if (P <= Length(Json)) and (Json[P] = '}') then
        begin
          Inc(P);
          Break;
        end;
        SubKey := ReadJsonString(Json, P);
        SkipWhitespace(Json, P);
        if (P <= Length(Json)) and (Json[P] = ':') then
          Inc(P);
        SkipWhitespace(Json, P);
        SubVal := ReadJsonString(Json, P);
        if (Key <> '') and (SubKey <> '') then
          Plurals.Values[Key + '.' + SubKey] := SubVal;
        SkipWhitespace(Json, P);
      end;
    end
    else
      Inc(P);
  end;
end;

procedure TJsonLanguageProvider.LoadLanguage(const LanguageCode: string;
  out Translations: TStrings; out Plurals: TStrings);
var
  FilePath, Content: string;
begin
  Translations := TStringList.Create;
  Plurals := TStringList.Create;
  FilePath := LanguageFilePath(LanguageCode);
  if not FileExists(FilePath) then
  begin
    TTranslationLogger.Error('Language file not found: ' + FilePath);
    Exit;
  end;
  Content := TFile.ReadAllText(FilePath, TEncoding.UTF8);
  try
    ParseJsonFlat(Content, Translations, Plurals);
  except
    on E: Exception do
      TTranslationLogger.Error('JSON parsing error in ' + FilePath + ': ' + E.Message);
  end;
end;

function TJsonLanguageProvider.GetAvailableLanguages: TStringList;
var
  Files: TStringDynArray;
  F: string;
  ExtPos: Integer;
begin
  Result := TStringList.Create;
  if not TDirectory.Exists(FLanguagesPath) then
    Exit;
  Files := TDirectory.GetFiles(FLanguagesPath, '*.json');
  for F in Files do
  begin
    ExtPos := LastDelimiter('.', ExtractFileName(F));
    if ExtPos > 0 then
      Result.Add(LowerCase(Copy(ExtractFileName(F), 1, ExtPos - 1)));
  end;
end;

end.
