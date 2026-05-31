unit Language.Runtime.Cache;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Language.Core.Interfaces;

type
  TTranslationCache = class(TInterfacedObject, ITranslationCache)
  private
    FEntries: TDictionary<string, string>;
    FPlurals: TDictionary<string, string>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(const Key, Value: string);
    procedure AddPlural(const Key, Form, Value: string);
    function TryGetValue(const Key: string; out Value: string): Boolean;
    function TryGetPlural(const Key, Form: string; out Value: string): Boolean;
    function Count: Integer;
  end;

implementation

constructor TTranslationCache.Create;
begin
  inherited;
  FEntries := TDictionary<string, string>.Create;
  FPlurals := TDictionary<string, string>.Create;
end;

destructor TTranslationCache.Destroy;
begin
  FEntries.Free;
  FPlurals.Free;
  inherited;
end;

procedure TTranslationCache.Clear;
begin
  FEntries.Clear;
  FPlurals.Clear;
end;

procedure TTranslationCache.Add(const Key, Value: string);
begin
  FEntries.AddOrSetValue(Key, Value);
end;

procedure TTranslationCache.AddPlural(const Key, Form, Value: string);
begin
  FPlurals.AddOrSetValue(Key + '.' + Form, Value);
end;

function TTranslationCache.TryGetValue(const Key: string; out Value: string): Boolean;
begin
  Result := FEntries.TryGetValue(Key, Value);
end;

function TTranslationCache.TryGetPlural(const Key, Form: string; out Value: string): Boolean;
begin
  Result := FPlurals.TryGetValue(Key + '.' + Form, Value);
end;

function TTranslationCache.Count: Integer;
begin
  Result := FEntries.Count;
end;

end.
