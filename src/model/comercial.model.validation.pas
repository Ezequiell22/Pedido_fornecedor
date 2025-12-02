unit comercial.model.validation;

interface

function IsValidCNPJ(const S: string): Boolean;

implementation

uses
  System.SysUtils;

function IsAllSame(const S: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 2 to Length(S) do
    if S[I] <> S[1] then
    begin
      Result := False;
      Exit;
    end;
end;

function DigitsOnly(const S: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    if CharInSet(S[I], ['0' .. '9']) then
      Result := Result + S[I];
end;

function IsValidCNPJ(const S: string): Boolean;
const
  W1: array [1 .. 12] of Integer = (5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2);
  W2: array [1 .. 13] of Integer = (6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2);
var
  D: string;
  I, Sum, R, D1, D2: Integer;
begin
  D := DigitsOnly(S);
  if Length(D) <> 14 then
  begin
    Result := False;
    Exit;
  end;
  if IsAllSame(D) then
  begin
    Result := False;
    Exit;
  end;
  Sum := 0;
  for I := 1 to 12 do
    Sum := Sum + (Ord(D[I]) - Ord('0')) * W1[I];
  R := Sum mod 11;
  if R < 2 then
    D1 := 0
  else
    D1 := 11 - R;
  Sum := 0;
  for I := 1 to 12 do
    Sum := Sum + (Ord(D[I]) - Ord('0')) * W2[I];
  Sum := Sum + D1 * W2[13];
  R := Sum mod 11;
  if R < 2 then
    D2 := 0
  else
    D2 := 11 - R;
  Result := ((Ord(D[13]) - Ord('0')) = D1) and ((Ord(D[14]) - Ord('0')) = D2);
end;

end.
