unit comercial.model.resource.impl.queryIBX;

interface

uses
  Data.DB,
  System.SysUtils,
  IBX.IBQuery,
  IBX.IBDatabase,
  comercial.model.resource.impl.factory,
  comercial.model.resource.interfaces,
  comercial.util.log;

type
  TModelResourceQueryIBX = class(TInterfacedObject, iQuery)
  private
    FQuery: TIBQuery;
    FConexao : iConexao;
    FConnection : TIBDatabase;
    FFDTransaction: TIBTransaction;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iQuery;
    function active(aValue: boolean): iQuery;
    function addParam(aParam: string; aValue: Variant): iQuery;
    function DataSet: TDataSet;
    function execSql( commit : Boolean = True): iQuery;
    function open: iQuery;
    function sqlClear: iQuery;
    function sqlAdd(aValue: string): iQuery;
    function isEmpty: boolean;
    function eof: boolean;
    procedure next;
  end;

implementation

function TModelResourceQueryIBX.active(aValue: boolean): iQuery;
begin
  result := Self;
  FQuery.active := aValue;
end;

function TModelResourceQueryIBX.addParam(aParam: string; aValue: Variant): iQuery;
begin
  result := Self;
  FQuery.ParamByName(aParam).Value := aValue;
end;

constructor TModelResourceQueryIBX.Create;
begin

  FQuery := TIBQuery.Create(nil);
  FFDTransaction := TIBTransaction.Create(nil);

  FConexao := TResource.New
  .Conexao;
  FConnection := TIBDatabase(FConexao.Connect);
  FFDTransaction.DefaultDatabase := FConnection;
  FFDTransaction.Params.Clear;
  FFDTransaction.Params.Add('read_committed');
  FFDTransaction.Params.Add('rec_version');
  FFDTransaction.Params.Add('nowait');
  FQuery.Database := FConnection;
  FQuery.Transaction := FFDTransaction;

end;

function TModelResourceQueryIBX.DataSet: TDataSet;
begin
  result := FQuery;
end;

destructor TModelResourceQueryIBX.Destroy;
begin

  FFDTransaction.Free;
  FQuery.Free;

  inherited;
end;

function TModelResourceQueryIBX.eof: boolean;
begin
  result := FQuery.eof;
end;

function TModelResourceQueryIBX.execSql( commit : Boolean = True): iQuery;
begin
  result := Self;

  try

    if not FQuery.Transaction.active then
      FQuery.Transaction.StartTransaction;

    FQuery.execSql;

    if FQuery.Transaction.active then
      FQuery.Transaction.Commit;

  except
    on E: exception do
    begin
      if FQuery.Transaction.active then
        FQuery.Transaction.Rollback;
      TLog.Error('SQL Exec: ' + FQuery.SQL.Text + ' | ' + E.ClassName + ' | ' + E.Message);
      raise exception.Create(E.Message);
    end;

  end;
end;

function TModelResourceQueryIBX.isEmpty: boolean;
begin
  result := FQuery.isEmpty;
end;

class function TModelResourceQueryIBX.New: iQuery;
begin
  result := Self.Create;
end;

procedure TModelResourceQueryIBX.next;
begin
  FQuery.next;
end;

function TModelResourceQueryIBX.open: iQuery;
begin
  if not FQuery.Transaction.Active then
    FQuery.Transaction.StartTransaction
  else
  begin
      FQuery.Transaction.CommitRetaining;
  end;
  try
    FQuery.open;
  except
    on E: Exception do
    begin
      TLog.Error('SQL Open: ' + FQuery.SQL.Text + ' | ' + E.ClassName + ' | ' + E.Message);
      raise;
    end;
  end;
end;

function TModelResourceQueryIBX.sqlAdd(aValue: string): iQuery;
begin
  result := Self;
  FQuery.SQL.Add(aValue);
end;

function TModelResourceQueryIBX.sqlClear: iQuery;
begin
  result := Self;
  FQuery.SQL.Clear;
end;

end.
