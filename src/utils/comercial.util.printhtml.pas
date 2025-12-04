unit comercial.util.printhtml;

interface

type
  TPrintHtmlPedido = class
  public
    class function GerarRelatorioPorProduto(const aFilePath: string): string;
    class function GerarRelatorioPorFornecedor(const aFilePath: string): string;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Data.DB,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD,
  comercial.util.log;


class function TPrintHtmlPedido.GerarRelatorioPorProduto( const aFilePath: string): string;
var
  Q: iQuery;
  SB: TStringBuilder;
  targetFile, targetDir, nameDefault: string;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False)
    .sqlClear
    .sqlAdd('select i.COD_Item as IDPRODUTO, i.DESCRICAO,')
    .sqlAdd('       avg(i.PRECO_UNITARIO) as PRECO_MEDIO,')
    .sqlAdd('       sum(i.QTD_PEDIDA) as QTD_TOTAL,')
    .sqlAdd('       sum(i.VALOR_TOTAL) as VALOR_TOTAL')
    .sqlAdd('  from PEDCOMPRA_ITEM i')
    .sqlAdd(' group by i.COD_Item, i.DESCRICAO')
    .sqlAdd(' order by i.DESCRICAO')
    .open;

  SB := TStringBuilder.Create;
  try
    SB.AppendLine('<!DOCTYPE html>');
    SB.AppendLine('<html lang="pt-br">');
    SB.AppendLine('<head>');
    SB.AppendLine('<meta charset="utf-8">');
    SB.AppendLine('<title>Compras por Produto</title>');
    SB.AppendLine('<style>');
    SB.AppendLine('body{font-family:Segoe UI, Arial, sans-serif; margin:24px; color:#222;}');
    SB.AppendLine('h1{margin:0 0 8px 0; font-size:20px;}');
    SB.AppendLine('table{border-collapse:collapse; width:100%;}');
    SB.AppendLine('thead th{background:#f5f5f5; border:1px solid #ddd; padding:8px; font-weight:600;}');
    SB.AppendLine('tbody td{border:1px solid #eee; padding:8px;}');
    SB.AppendLine('tbody tr:nth-child(even){background:#fafafa;}');
    SB.AppendLine('.text-right{ text-align:right; }');
    SB.AppendLine('</style>');
    SB.AppendLine('</head>');
    SB.AppendLine('<body>');
    SB.AppendLine('<h1>Compras por Produto</h1>');

    SB.AppendLine('<table>');
    SB.AppendLine('<thead><tr><th>ID</th><th>Descrição</th><th class="text-right">Preço médio</th><th class="text-right">Quantidade total</th><th class="text-right">Valor total</th></tr></thead>');
    SB.AppendLine('<tbody>');
    Q.DataSet.First;
    while not Q.DataSet.Eof do
    begin
      SB.Append('<tr>');
      SB.Append('<td>' + Q.DataSet.FieldByName('IDPRODUTO').AsString + '</td>');
      SB.Append('<td>' + Q.DataSet.FieldByName('DESCRICAO').AsString + '</td>');
      SB.Append('<td class="text-right">' + FormatFloat('0.00', Q.DataSet.FieldByName('PRECO_MEDIO').AsFloat) + '</td>');
      SB.Append('<td class="text-right">' + Q.DataSet.FieldByName('QTD_TOTAL').AsString + '</td>');
      SB.Append('<td class="text-right">' + FormatFloat('0.00', Q.DataSet.FieldByName('VALOR_TOTAL').AsFloat) + '</td>');
      SB.AppendLine('</tr>');
      Q.DataSet.Next;
    end;
    SB.AppendLine('</tbody></table>');
    SB.AppendLine('</body>');
    SB.AppendLine('</html>');

    nameDefault := Format('compras_por_produto_%s.html', [FormatDateTime('yyyymmdd', now)]);
    if aFilePath = '' then
    begin
      targetDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'reports');
      targetFile := targetDir + nameDefault;
    end
    else if TDirectory.Exists(aFilePath) then
    begin
      targetDir := IncludeTrailingPathDelimiter(aFilePath);
      targetFile := targetDir + nameDefault;
    end
    else
    begin
      targetDir := ExtractFilePath(aFilePath);
      if targetDir = '' then
        targetDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'reports');
      targetFile := targetDir + ExtractFileName(aFilePath);
    end;

    try
      if not TDirectory.Exists(targetDir) then
        TDirectory.CreateDirectory(targetDir);
      TFile.WriteAllText(targetFile, SB.ToString, TEncoding.UTF8);
    except
      on E: Exception do
      begin
        TLog.Error('Print HTML ComprasPorProduto save failed: ' + E.ClassName + ' | ' + E.Message + ' | Path=' + targetFile);
        raise;
      end;
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

class function TPrintHtmlPedido.GerarRelatorioPorFornecedor( const aFilePath: string): string;
var
  Q: iQuery;
  SB: TStringBuilder;
  targetFile, targetDir, nameDefault: string;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False)
    .sqlClear
    .sqlAdd('select f.COD_CLIFOR, f.FANTASIA, sum(i.VALOR_TOTAL) as VALOR_TOTAL')
    .sqlAdd('  from PEDIDO_COMPRA d')
    .sqlAdd('  left join FORNECEDORES f on f.COD_CLIFOR = d.COD_CLIFOR')
    .sqlAdd('  left join PEDCOMPRA_ITEM i on i.COD_PEDIDOCOMPRA = d.COD_PEDIDOCOMPRA')
    .sqlAdd(' group by f.COD_CLIFOR, f.FANTASIA')
    .sqlAdd(' order by f.fantasia')
    .open;

  SB := TStringBuilder.Create;
  try
    SB.AppendLine('<!DOCTYPE html>');
    SB.AppendLine('<html lang="pt-br">');
    SB.AppendLine('<head>');
    SB.AppendLine('<meta charset="utf-8">');
    SB.AppendLine('<title>Compras por Fornecedor</title>');
    SB.AppendLine('<style>');
    SB.AppendLine('body{font-family:Segoe UI, Arial, sans-serif; margin:24px; color:#222;}');
    SB.AppendLine('h1{margin:0 0 8px 0; font-size:20px;}');
    SB.AppendLine('table{border-collapse:collapse; width:100%;}');
    SB.AppendLine('thead th{background:#f5f5f5; border:1px solid #ddd; padding:8px; font-weight:600;}');
    SB.AppendLine('tbody td{border:1px solid #eee; padding:8px;}');
    SB.AppendLine('tbody tr:nth-child(even){background:#fafafa;}');
    SB.AppendLine('.text-right{ text-align:right; }');
    SB.AppendLine('</style>');
    SB.AppendLine('</head>');
    SB.AppendLine('<body>');
    SB.AppendLine('<h1>Compras por Fornecedor</h1>');

    SB.AppendLine('<table>');
    SB.AppendLine('<thead><tr><th>ID Fornecedor</th><th>Fantasia</th><th class="text-right">Valor total</th></tr></thead>');
    SB.AppendLine('<tbody>');
    Q.DataSet.First;
    while not Q.DataSet.Eof do
    begin
      SB.Append('<tr>');
      SB.Append('<td>' + Q.DataSet.FieldByName('COD_CLIFOR').AsString + '</td>');
      SB.Append('<td>' + Q.DataSet.FieldByName('FANTASIA').AsString + '</td>');
      SB.Append('<td class="text-right">' + FormatFloat('0.00', Q.DataSet.FieldByName('VALOR_TOTAL').AsFloat) + '</td>');
      SB.AppendLine('</tr>');
      Q.DataSet.Next;
    end;
    SB.AppendLine('</tbody></table>');
    SB.AppendLine('</body>');
    SB.AppendLine('</html>');

    nameDefault := Format('compras_por_fornecedor_%s.html', [FormatDateTime('yyyymmdd', now)]);
    if aFilePath = '' then
    begin
      targetDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'reports');
      targetFile := targetDir + nameDefault;
    end
    else if TDirectory.Exists(aFilePath) then
    begin
      targetDir := IncludeTrailingPathDelimiter(aFilePath);
      targetFile := targetDir + nameDefault;
    end
    else
    begin
      targetDir := ExtractFilePath(aFilePath);
      if targetDir = '' then
        targetDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'reports');
      targetFile := targetDir + ExtractFileName(aFilePath);
    end;

    try
      if not TDirectory.Exists(targetDir) then
        TDirectory.CreateDirectory(targetDir);
      TFile.WriteAllText(targetFile, SB.ToString, TEncoding.UTF8);
    except
      on E: Exception do
      begin
        TLog.Error('Print HTML Fornecedor save failed: ' + E.ClassName + ' | ' + E.Message + ' | Path=' + targetFile);
        raise;
      end;
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;


end.

