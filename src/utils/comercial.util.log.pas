unit comercial.util.log;

interface

type
  TLog = class
  public
    class constructor Create;
    class destructor Destroy;
    class procedure Info(const Msg: string); static;
    class procedure Warn(const Msg: string); static;
    class procedure Error(const Msg: string); static;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.IniFiles,
  System.DateUtils,
  System.SyncObjs;

var
  GLock: TCriticalSection;
  GFileName: string;

procedure AppendLine(const Line: string);
var W: TStreamWriter;
begin
  GLock.Enter;
  try
    W := TStreamWriter.Create(GFileName, True, TEncoding.UTF8);
    try
      W.WriteLine(Line);
    finally
      W.Free;
    end;
  finally
    GLock.Leave;
  end;
end;

function Timestamp: string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now);
end;

class constructor TLog.Create;
var iniPath, dir, fileCfg: string;
    ini: TIniFile;
begin
  GLock := TCriticalSection.Create;
  iniPath := ExtractFilePath(ParamStr(0)) + 'comercial.ini';
  dir := ExtractFilePath(ParamStr(0)) + 'logs' + PathDelim;
  fileCfg := dir + 'comercial.log';
  if FileExists(iniPath) then
  begin
    ini := TIniFile.Create(iniPath);
    try
      dir := ini.ReadString('Log', 'Dir', dir);
      fileCfg := ini.ReadString('Log', 'File', fileCfg);
    finally
      ini.Free;
    end;
  end;
  if not TDirectory.Exists(dir) then
    TDirectory.CreateDirectory(dir);
  if ExtractFilePath(fileCfg) <> '' then
  begin
    if not TDirectory.Exists(ExtractFilePath(fileCfg)) then
      TDirectory.CreateDirectory(ExtractFilePath(fileCfg));
  end;
  GFileName := fileCfg;
end;

class destructor TLog.Destroy;
begin
  GLock.Free;
end;

class procedure TLog.Info(const Msg: string);
begin
  AppendLine('INFO ' + Timestamp + ' ' + Msg);
end;

class procedure TLog.Warn(const Msg: string);
begin
  AppendLine('WARN ' + Timestamp + ' ' + Msg);
end;

class procedure TLog.Error(const Msg: string);
begin
  AppendLine('ERROR ' + Timestamp + ' ' + Msg);
end;

end.

