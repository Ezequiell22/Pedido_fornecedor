unit Language.Tests.Cache;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestLanguageCache = class
  public
    [Test]
    procedure AddAndRetrieveValue;
    [Test]
    procedure TryGetValueReturnsFalseForMissingKey;
    [Test]
    procedure ClearRemovesAllEntries;
    [Test]
    procedure AddPluralForms;
    [Test]
    procedure LookupPerformanceUnderOneMillisecond;
  end;

implementation

uses
  System.SysUtils,
  System.Diagnostics,
  Language.Runtime.Cache;

procedure TTestLanguageCache.AddAndRetrieveValue;
var
  Cache: TTranslationCache;
  Value: string;
begin
  Cache := TTranslationCache.Create;
  try
    Cache.Add('BTN_SAVE', 'Salvar');
    Assert.IsTrue(Cache.TryGetValue('BTN_SAVE', Value));
    Assert.AreEqual('Salvar', Value);
    Assert.AreEqual(1, Cache.Count);
  finally
    Cache.Free;
  end;
end;

procedure TTestLanguageCache.TryGetValueReturnsFalseForMissingKey;
var
  Cache: TTranslationCache;
  Value: string;
begin
  Cache := TTranslationCache.Create;
  try
    Assert.IsFalse(Cache.TryGetValue('MISSING_KEY', Value));
  finally
    Cache.Free;
  end;
end;

procedure TTestLanguageCache.ClearRemovesAllEntries;
var
  Cache: TTranslationCache;
  Value: string;
begin
  Cache := TTranslationCache.Create;
  try
    Cache.Add('KEY1', 'A');
    Cache.Clear;
    Assert.AreEqual(0, Cache.Count);
    Assert.IsFalse(Cache.TryGetValue('KEY1', Value));
  finally
    Cache.Free;
  end;
end;

procedure TTestLanguageCache.AddPluralForms;
var
  Cache: TTranslationCache;
  Value: string;
begin
  Cache := TTranslationCache.Create;
  try
    Cache.AddPlural('ITEMS_FOUND', 'one', '{0} item');
    Cache.AddPlural('ITEMS_FOUND', 'other', '{0} items');
    Assert.IsTrue(Cache.TryGetPlural('ITEMS_FOUND', 'one', Value));
    Assert.AreEqual('{0} item', Value);
    Assert.IsTrue(Cache.TryGetPlural('ITEMS_FOUND', 'other', Value));
    Assert.AreEqual('{0} items', Value);
  finally
    Cache.Free;
  end;
end;

procedure TTestLanguageCache.LookupPerformanceUnderOneMillisecond;
const
  KEY_COUNT = 50000;
var
  Cache: TTranslationCache;
  I: Integer;
  Key, Value: string;
  Sw: TStopwatch;
  ElapsedMs: Double;
begin
  Cache := TTranslationCache.Create;
  try
    for I := 0 to KEY_COUNT - 1 do
    begin
      Key := 'KEY_' + IntToStr(I);
      Cache.Add(Key, 'Value ' + IntToStr(I));
    end;

    Sw := TStopwatch.StartNew;
    for I := 0 to 999 do
    begin
      Key := 'KEY_' + IntToStr(I * 50);
      if not Cache.TryGetValue(Key, Value) then
        Assert.Fail('Lookup failed for ' + Key);
    end;
    Sw.Stop;
    ElapsedMs := Sw.Elapsed.TotalMilliseconds;
    Assert.IsTrue(ElapsedMs < 1000,
      Format('1000 lookups took %.3f ms (expected < 1000 ms)', [ElapsedMs]));
  finally
    Cache.Free;
  end;
end;

end.
