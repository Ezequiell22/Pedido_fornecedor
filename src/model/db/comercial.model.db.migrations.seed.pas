unit comercial.model.db.migrations.seed;

interface

type
  TDbMigrationsSeed = class
  public
    procedure Apply(const AExcelPath: string);
  private
    procedure ApplyFromXlsx(const AFilePath: string);
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Zip,
  System.Variants,
  System.Generics.Collections,
  Xml.XMLDoc,
  Xml.XMLIntf,
  Data.DB,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD,
  comercial.model.entity.Fornecedor,
  comercial.model.entity.PedidoCompra,
  comercial.model.entity.PedcompraItem,
  comercial.model.DAO.Fornecedor,
  comercial.model.DAO.PedidoCompra,
  comercial.model.DAO.PedcompraItem, comercial.model.DAO.interfaces;

procedure TDbMigrationsSeed.Apply(const AExcelPath: string);
begin
  if SameText(ExtractFileExt(AExcelPath), '.xlsx') and FileExists(AExcelPath) then
  begin
    ApplyFromXlsx(AExcelPath);
    Exit;
  end;

end;
function ColIndex(const Ref: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(Ref) do
  begin
    if CharInSet(Ref[i], ['A'..'Z']) then
      Result := Result * 26 + (Ord(Ref[i]) - Ord('A') + 1)
    else
      Break;
  end;
  Dec(Result);
end;

function LocalName(const S: string): string;
var
  p: Integer;
begin
  p := LastDelimiter(':', S);
  if p > 0 then
    Result := Copy(S, p + 1, MaxInt)
  else
    Result := S;
end;

function FindChildByLocalName(const N: IXMLNode; const Name: string): IXMLNode;
var
  i: Integer;
begin
  Result := nil;
  if N = nil then Exit;
  for i := 0 to N.ChildNodes.Count - 1 do
    if SameText(LocalName(N.ChildNodes[i].NodeName), Name) then
      Exit(N.ChildNodes[i]);
end;

function FindChildrenByLocalName(const N: IXMLNode; const Name: string): TArray<IXMLNode>;
var
  i, k: Integer;
begin
  k := 0;
  SetLength(Result, 0);
  if N = nil then Exit;
  for i := 0 to N.ChildNodes.Count - 1 do
    if SameText(LocalName(N.ChildNodes[i].NodeName), Name) then
    begin
      Inc(k);
      SetLength(Result, k);
      Result[k-1] := N.ChildNodes[i];
    end;
end;

function LoadXmlFromZip(const Zip: TZipFile; const Path: string): IXMLDocument;
var
  idx: Integer;
  ms: TMemoryStream;
  bytes: TBytes;
begin
  Result := TXMLDocument.Create(nil);
  idx := Zip.IndexOf(Path);
  if idx < 0 then Exit;
  ms := TMemoryStream.Create;
  try
    Zip.Read(idx, bytes);
    if Length(bytes) > 0 then
    begin
      ms.WriteBuffer(bytes, Length(bytes));
      ms.Position := 0;
    end;
    ms.Position := 0;
    (Result as IXMLDocument).LoadFromStream(ms);
    (Result as IXMLDocument).Active := True;
  finally
    ms.Free;
  end;
end;

function ReadSharedStrings(const Zip: TZipFile): TArray<string>;
var
  doc: IXMLDocument;
  si, tNode: IXMLNode;
  i, j: Integer;
  parts: TArray<IXMLNode>;
begin
  doc := LoadXmlFromZip(Zip, 'xl/sharedStrings.xml');
  if doc = nil then Exit;
  SetLength(Result, doc.DocumentElement.ChildNodes.Count);
  for i := 0 to doc.DocumentElement.ChildNodes.Count - 1 do
  begin
    si := doc.DocumentElement.ChildNodes[i];
    Result[i] := '';
    parts := FindChildrenByLocalName(si, 't');
    if Length(parts) = 0 then
    begin
      tNode := FindChildByLocalName(si, 't');
      if tNode <> nil then
        Result[i] := tNode.Text;
    end
    else
    begin
      for j := 0 to Length(parts) - 1 do
        Result[i] := Result[i] + parts[j].Text;
    end;
  end;
end;

function ReadSheetRows(const Zip: TZipFile; const SheetPath: string; const Shared: TArray<string>): TArray<TArray<string>>;
var
  doc: IXMLDocument;
  worksheetNode, sheetData, rowNode, cellNode, vNode: IXMLNode;
  rIdx, cIdx, maxCol, i, j: Integer;
  rows: TList<TArray<string>>;
  rowArr: TArray<string>;
  ref, tVal, vText: string;
begin
  rows := TList<TArray<string>>.Create;
  try
    doc := LoadXmlFromZip(Zip, SheetPath);
    if (doc = nil) or (doc.DocumentElement = nil) then
    begin
      Result := nil;
      Exit;
    end;
    worksheetNode := doc.DocumentElement;
    sheetData := FindChildByLocalName(worksheetNode, 'sheetData');
    if sheetData = nil then
    begin
      Result := nil;
      Exit;
    end;
    for i := 0 to sheetData.ChildNodes.Count - 1 do
    begin
      rowNode := sheetData.ChildNodes[i];
      if not SameText(LocalName(rowNode.NodeName), 'row') then
        Continue;
      rIdx := StrToIntDef(VarToStr(rowNode.Attributes['r']), 0);
      if rIdx = 1 then
        Continue;
      maxCol := 0;
      for j := 0 to rowNode.ChildNodes.Count - 1 do
      begin
        cellNode := rowNode.ChildNodes[j];
        if not SameText(LocalName(cellNode.NodeName), 'c') then
          Continue;
        ref := VarToStr(cellNode.Attributes['r']);
        cIdx := ColIndex(ref);
        if cIdx > maxCol then maxCol := cIdx;
      end;
      SetLength(rowArr, maxCol + 1);
      for j := 0 to rowNode.ChildNodes.Count - 1 do
      begin
        cellNode := rowNode.ChildNodes[j];
        if not SameText(LocalName(cellNode.NodeName), 'c') then
          Continue;
        ref := VarToStr(cellNode.Attributes['r']);
        cIdx := ColIndex(ref);
        tVal := VarToStr(cellNode.Attributes['t']);
        vNode := FindChildByLocalName(cellNode, 'v');
        vText := '';
        if vNode <> nil then
          vText := vNode.Text;
        if SameText(tVal, 's') then
        begin
          if (Length(Shared) > 0) and (vText <> '') then
            vText := Shared[StrToIntDef(vText, 0)];
        end;
        rowArr[cIdx] := vText;
      end;
      rows.Add(rowArr);
    end;
    Result := rows.ToArray;
  finally
    rows.Free;
  end;
end;

function ReadSheetHeader(const Zip: TZipFile; const SheetPath: string; const Shared: TArray<string>): TArray<string>;
var
  doc: IXMLDocument;
  worksheetNode, sheetData, rowNode, cellNode, vNode: IXMLNode;
  maxCol, j, cIdx: Integer;
  ref, tVal, vText: string;
begin
  SetLength(Result, 0);
  doc := LoadXmlFromZip(Zip, SheetPath);
  if (doc = nil) or (doc.DocumentElement = nil) then Exit;
  worksheetNode := doc.DocumentElement;
  sheetData := FindChildByLocalName(worksheetNode, 'sheetData');
  if sheetData = nil then Exit;
  if sheetData.ChildNodes.Count = 0 then Exit;
  rowNode := sheetData.ChildNodes[0];
  if not SameText(LocalName(rowNode.NodeName), 'row') then Exit;
  maxCol := 0;
  for j := 0 to rowNode.ChildNodes.Count - 1 do
  begin
    cellNode := rowNode.ChildNodes[j];
    if not SameText(LocalName(cellNode.NodeName), 'c') then
      Continue;
    ref := VarToStr(cellNode.Attributes['r']);
    cIdx := ColIndex(ref);
    if cIdx > maxCol then maxCol := cIdx;
  end;
  SetLength(Result, maxCol + 1);
  for j := 0 to rowNode.ChildNodes.Count - 1 do
  begin
    cellNode := rowNode.ChildNodes[j];
    if not SameText(LocalName(cellNode.NodeName), 'c') then
      Continue;
    ref := VarToStr(cellNode.Attributes['r']);
    cIdx := ColIndex(ref);
    tVal := VarToStr(cellNode.Attributes['t']);
    vNode := FindChildByLocalName(cellNode, 'v');
    vText := '';
    if vNode <> nil then
      vText := vNode.Text;
    if SameText(tVal, 's') then
    begin
      if (Length(Shared) > 0) and (vText <> '') then
        vText := Shared[StrToIntDef(vText, 0)];
    end;
    Result[cIdx] := Trim(vText);
  end;
end;

function IndexOfHeader(const Header: TArray<string>; const Name: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Length(Header) - 1 do
    if SameText(UpperCase( Header[i] ), UpperCase(Name)) then
      Exit(i);
end;

function HasAllColumns(const Header: TArray<string>; const Names: array of string): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := Low(Names) to High(Names) do
    if IndexOfHeader( Header ,  Names[i]) < 0 then
    begin
      Result := False;
      Exit;
    end;
end;

function VStr(const S: string): Variant;
begin
  if Trim(S) = '' then
    Result := Null
  else
    Result := S;
end;

function VInt(const S: string): Variant;
var
  v: Integer;
begin
  if TryStrToInt(Trim(S), v) then
    Result := v
  else
    Result := Null;
end;

function VFloat(const S: string): Variant;
var
  f: Double;
begin
  if TryStrToFloat(Trim(S), f) then
    Result := f
  else
    Result := 0;
end;

function VDate(const S: string): Variant;
var
  f: Double;
  d: TDateTime;
begin
  if TryStrToFloat(Trim(S), f) then
  begin
    d := f;
    Result := VarFromDateTime(d);
    Exit;
  end;
  if TryStrToDate(Trim(S), d) then
    Result := VarFromDateTime(d)
  else
    Result := Now;
end;

procedure TDbMigrationsSeed.ApplyFromXlsx(const AFilePath: string);
var
  Zip: TZipFile;
  Shared: TArray<string>;
  Rows: TArray<TArray<string>>;
  Q: iQuery;
  i: Integer;
  daoF: iModelDAOEntity<TModelEntityFornecedor>;
  daoP: iModelDAOEntity<TModelEntityPedidoCompra>;
  daoI: iModelDAOEntity<TModelEntityPedcompraItem>;
begin
  Zip := TZipFile.Create;
  try
    Zip.Open(AFilePath, zmRead);
    Shared := ReadSharedStrings(Zip);
    Q := TModelResourceQueryFD.New;
    daoF := TModelDAOFornecedor.New;
    daoP := TModelDAOPedidoCompra.New;
    daoI := TModelDAOPedcompraItem.New;

    Q.active(False).sqlClear.sqlAdd('delete from PEDCOMPRA_ITEM')
    .execSql();
    Q.active(False).sqlClear.sqlAdd('delete from PEDIDO_COMPRA')
    .execSql();
    Q.active(False).sqlClear.sqlAdd('delete from fornecedores')
    .execSql();

    var H1 := ReadSheetHeader(Zip, 'xl/worksheets/sheet1.xml', Shared);
    if HasAllColumns(H1, ['COD_CLIFOR','RAZAO','COD_ESTADO','FANTASIA','COD_PAIS','CLIENTE','FORNEC']) then
    begin
      var idxCOD_CLIFOR := IndexOfHeader(H1, 'COD_CLIFOR');
      var idxRAZAO := IndexOfHeader(H1, 'RAZAO');
      var idxCOD_ESTADO := IndexOfHeader(H1, 'COD_ESTADO');
      var idxFANTASIA := IndexOfHeader(H1, 'FANTASIA');
      var idxCOD_PAIS := IndexOfHeader(H1, 'COD_PAIS');
      var idxCLIENTE := IndexOfHeader(H1, 'CLIENTE');
      var idxFORNEC := IndexOfHeader(H1, 'FORNEC');
      Rows := ReadSheetRows(Zip, 'xl/worksheets/sheet1.xml', Shared);
      for i := 0 to Length(Rows) - 1 do
      begin
        daoF.This
          .COD_CLIFOR(VarAsType(VInt(Rows[i][idxCOD_CLIFOR]), varInteger))
          .RAZAO(VarToStr(VStr(Rows[i][idxRAZAO])))
          .COD_ESTADO(VarToStr(VStr(Rows[i][idxCOD_ESTADO])))
          .FANTASIA(VarToStr(VStr(Rows[i][idxFANTASIA])))
          .COD_PAIS(VarToStr(VStr(Rows[i][idxCOD_PAIS])))
          .CLIENTE(VarToStr(VStr(Rows[i][idxCLIENTE])))
          .FORNEC(VarToStr(VStr(Rows[i][idxFORNEC])))
          .&End
        .Insert;
      end;
    end;

    var H3 := ReadSheetHeader(Zip, 'xl/worksheets/sheet2.xml', Shared);
    if HasAllColumns(H3, ['COD_PEDIDOCOMPRA','COD_EMPRESA',
    'COD_CLIFOR','COD_MOEDA','DT_EMISSAO','DT_PREVISAOENTREGA',
    'DT_ENTREGA','TIPO_COMPRA']) then
    begin
      var iCOD_PEDIDOCOMPRA := IndexOfHeader(H3, 'COD_PEDIDOCOMPRA');
      var iCOD_EMPRESA := IndexOfHeader(H3, 'COD_EMPRESA');
      var iCOD_CLIFOR := IndexOfHeader(H3, 'COD_CLIFOR');
      var iCOD_MOEDA := IndexOfHeader(H3, 'COD_MOEDA');
      var iDT_EMISSAO := IndexOfHeader(H3, 'DT_EMISSAO');
      var iDT_PREVISTA := IndexOfHeader(H3, 'DT_PREVISAOENTREGA');
      var iDT_ENTREGA := IndexOfHeader(H3, 'DT_ENTREGA');
      var iTIPO := IndexOfHeader(H3, 'TIPO_COMPRA');
      Rows := ReadSheetRows(Zip, 'xl/worksheets/sheet2.xml', Shared);
      for i := 0 to Length(Rows) - 1 do
      begin
        if DAOF
          .GetbyId(VarAsType(VInt(Rows[i][iCOD_CLIFOR]), varInteger))
          .GetDataSet.FieldByName('COD_CLIFOR').AsInteger <= 0 then
            continue;

//        if VarAsType(VInt(Rows[i][iCOD_EMPRESA]), varInteger) <> 200 then
//        continue;

        try
        daoP.This
          .COD_PEDIDOCOMPRA(VarAsType(VInt(Rows[i][iCOD_PEDIDOCOMPRA]), varInteger))
          .COD_EMPRESA(VarAsType(VInt(Rows[i][iCOD_EMPRESA]), varInteger))
          .COD_CLIFOR(VarAsType(VInt(Rows[i][iCOD_CLIFOR]), varInteger))
          .COD_MOEDA(VarToStr(VStr(Rows[i][iCOD_MOEDA])))
          .DT_EMISSAO(VarToDateTime(VDate(Rows[i][iDT_EMISSAO])))
          .DT_PREVISAOENTREGA(VarToDateTime(VDate(Rows[i][iDT_PREVISTA])))
          .DT_ENTREGA(VarToDateTime(VDate(Rows[i][iDT_ENTREGA])))
          .TIPO_COMPRA(VarToStr(VStr(Rows[i][iTIPO])))
          .&End
          .Insert;
        except

        end;
      end;
    end;


    var H2 := ReadSheetHeader(Zip, 'xl/worksheets/sheet3.xml', Shared);
    if HasAllColumns(H2, ['COD_PEDIDOCOMPRA','COD_EMPRESA','SEQUENCIA',
    'COD_Item','COD_unidadecompra','QTD_PEDIDA',
    'QTD_RECEBIDA','DESCRICAO','PRECO_UNITARIO',
    'PERC_DESCTO','VALOR_DESCTO','PERC_FINANC',
    'VALOR_TOTAL','DT_INCLUSAO','DT_SOLICITADA','DT_RECEBIDA']) then
    begin



      var iCOD_PED := IndexOfHeader(H2, 'COD_PEDIDOCOMPRA');
      var iCOD_EMP := IndexOfHeader(H2, 'COD_EMPRESA');
      var iSEQ := IndexOfHeader(H2, 'SEQUENCIA');
      var iCOD_ITEM := IndexOfHeader(H2, 'COD_Item');
      var iCOD_UN := IndexOfHeader(H2, 'COD_unidadecompra');
      var iQTDE_PED := IndexOfHeader(H2, 'QTD_PEDIDA');
      var iQTDE_REC := IndexOfHeader(H2, 'QTD_RECEBIDA');
      var iDESC := IndexOfHeader(H2, 'DESCRICAO');
      var iPRECO := IndexOfHeader(H2, 'PRECO_UNITARIO');
      var iPERC_DESC := IndexOfHeader(H2, 'PERC_DESCTO');
      var iVAL_DESC := IndexOfHeader(H2, 'VALOR_DESCTO');
      var iPERC_FIN := IndexOfHeader(H2, 'PERC_FINANC');
      var iVAL_FIN := IndexOfHeader(H2, 'VALOR_FINANC');
      var iVAL_TOTAL := IndexOfHeader(H2, 'VALOR_TOTAL');
      var iDT_INC := IndexOfHeader(H2, 'DT_INCLUSAO');
      var iDT_SOL := IndexOfHeader(H2, 'DT_SOLICITADA');
      var iDT_REC := IndexOfHeader(H2, 'DT_RECEBIDA');
      Rows := ReadSheetRows(Zip, 'xl/worksheets/sheet3.xml', Shared);
      for i := 0 to Length(Rows) - 1 do
      begin

//        if VarAsType(VInt(Rows[i][iCOD_EMP]), varInteger) <> 200 then
//         continue;
        try
        daoI.This
          .COD_PEDIDOCOMPRA(VarAsType(VInt(Rows[i][iCOD_PED]), varInteger))
          .COD_EMPRESA(VarAsType(VInt(Rows[i][iCOD_EMP]), varInteger))
          .SEQUENCIA(VarAsType(VInt(Rows[i][iSEQ]), varInteger))
          .COD_Item(VarAsType(VInt(Rows[i][iCOD_ITEM]), varInteger))
          .COD_unidadecompra(VarToStr(VStr(Rows[i][iCOD_UN])))
          .QTD_PEDIDA(VarAsType(VFloat(Rows[i][iQTDE_PED]), varDouble))
          .QTD_RECEBIDA(VarAsType(VFloat(Rows[i][iQTDE_REC]), varDouble))
          .DESCRICAO(VarToStr(VStr(Rows[i][iDESC])))
          .PRECO_UNITARIO(VarAsType(VFloat(Rows[i][iPRECO]), varDouble))
          .PERC_DESCTO(VarAsType(VFloat(Rows[i][iPERC_DESC]), varDouble))
          .VALOR_DESCTO(VarAsType(VFloat(Rows[i][iVAL_DESC]), varDouble))
          .PERC_FINANC(VarAsType(VFloat(Rows[i][iPERC_FIN]), varDouble))
          .VALOR_FINANC(VarAsType(VFloat(Rows[i][iVAL_DESC]), varDouble))
          .VALOR_TOTAL(VarAsType(VFloat(Rows[i][iVAL_TOTAL]), varDouble))
          .DT_INCLUSAO(VarToDateTime(VDate(Rows[i][iDT_INC])))
          .DT_SOLICITADA(VarToDateTime(VDate(Rows[i][iDT_SOL])))
          .DT_RECEBIDA(VarToDateTime(VDate(Rows[i][iDT_REC])))
          .&End
          .Insert;
        except
//       rever tratamento por causa da chave
        end;
      end;
    end;
  finally
    Zip.Close;
    Zip.Free;
  end;
end;

end.
