unit Language.Runtime.Logger;

interface

uses
  System.SysUtils;

type
  TTranslationLogger = class
  private
    class var FLogPath: string;
    class procedure AppendLine(const Level, Msg: string); static;
  public
    class procedure Configure(const LogsPath: string); static;
    class procedure Warn(const Msg: string); static;
    class procedure Info(const Msg: string); static;
    class procedure Error(const Msg: string); static;
    class procedure MissingKey(const Key, Language: string); static;
    class procedure FallbackUsed(const Key, FromLang, ToLang: string); static;
  end;

implementation

uses
  System.Classes,
  System.IOUtils,
  System.DateUtils,
  System.SyncObjs;

var
  GLogLock: TCriticalSection;

class procedure TTranslationLogger.Configure(const LogsPath: string);
var
  Dir: string;
begin
  Dir := IncludeTrailingPathDelimiter(LogsPath);
  if not TDirectory.Exists(Dir) then
    TDirectory.CreateDirectory(Dir);
  FLogPath := Dir + 'translation.log';
  if GLogLock = nil then
    GLogLock := TCriticalSection.Create;
end;

class procedure TTranslationLogger.AppendLine(const Level, Msg: string);
var
  W: TStreamWriter;
  Line: string;
begin
  if FLogPath = '' then
    Exit;
  Line := Level + ' ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + #13#10 + Msg;
  GLogLock.Enter;
  try
    W := TStreamWriter.Create(FLogPath, True, TEncoding.UTF8);
    try
      W.WriteLine(Line);
      W.WriteLine('');
    finally
      W.Free;
    end;
  finally
    GLogLock.Leave;
  end;
end;

class procedure TTranslationLogger.Warn(const Msg: string);
begin
  AppendLine('WARN', Msg);
end;

class procedure TTranslationLogger.Info(const Msg: string);
begin
  AppendLine('INFO', Msg);
end;

class procedure TTranslationLogger.Error(const Msg: string);
begin
  AppendLine('ERROR', Msg);
end;

class procedure TTranslationLogger.MissingKey(const Key, Language: string);
begin
  Warn('Missing Key:' + #13#10 + Key + #13#10#13#10 + 'Language:' + #13#10 + Language);
end;

class procedure TTranslationLogger.FallbackUsed(const Key, FromLang, ToLang: string);
begin
  Info('Fallback used for key [' + Key + ']: ' + FromLang + ' -> ' + ToLang);
end;

initialization

finalization
  FreeAndNil(GLogLock);

end.
