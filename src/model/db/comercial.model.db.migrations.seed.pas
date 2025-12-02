unit comercial.model.db.migrations.seed;

interface

type
  TDbMigrationsSeed = class
  public
    procedure Apply(const AExcelPath: string);
  end;

implementation

uses
  System.SysUtils,
  System.Variants,
  ComObj,
  Data.DB,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD;

procedure TDbMigrationsSeed.Apply(const AExcelPath: string);
var
  Excel, Workbook, WS1, WS2, WS3: OleVariant;
  Q: iQuery;
  r: Integer;
  v: Variant;
begin
  Excel := CreateOleObject('Excel.Application');
  try
    Workbook := Excel.Workbooks.Open(AExcelPath);
    WS1 := Workbook.Worksheets.Item[1];
    WS2 := Workbook.Worksheets.Item[2];
    WS3 := Workbook.Worksheets.Item[3];

    Q := TModelResourceQueryFD.New;

    r := 2;
    while True do
    begin
      v := WS1.Cells[r, 1].Value;
      if VarIsNull(v) or VarIsEmpty(v) then Break;
      Q.active(False).sqlClear
        .sqlAdd('insert into FORNECEDORES (COD_CLIFOR, RAZAO, COD_ESTADO, FANTASIA, COD_PAIS, CLIENTE, FORNEC) values (:COD_CLIFOR, :RAZAO, :COD_ESTADO, :FANTASIA, :COD_PAIS, :CLIENTE, :FORNEC)')
        .addParam('COD_CLIFOR', v)
        .addParam('RAZAO', WS1.Cells[r, 2].Value)
        .addParam('COD_ESTADO', WS1.Cells[r, 3].Value)
        .addParam('FANTASIA', WS1.Cells[r, 4].Value)
        .addParam('COD_PAIS', WS1.Cells[r, 5].Value)
        .addParam('CLIENTE', WS1.Cells[r, 6].Value)
        .addParam('FORNEC', WS1.Cells[r, 7].Value)
        .execSql;
      Inc(r);
    end;


    r := 2;
    while True do
    begin
      v := WS3.Cells[r, 1].Value;
      if VarIsNull(v) or VarIsEmpty(v) then Break;
      Q.active(False).sqlClear
        .sqlAdd('insert into PEDIDO_COMPRA (COD_PEDIDOCOMPRA, COD_CLIFOR, COD_USUARIO, TOTAL, COD_EMPRESA, COD_FILIAL, COD_DEPARTAMENTO, COD_CENTRO_CUSTO, DT_EMISSAO, COD_CONDPAGTO, ORDEM_COMPRA, VALOR_IMPOSTOS, COD_COMPRADOR, PESO, VOLUME, COD_TIPOFRETE, DATA_PREVISTA_ENTREGA, DT_ENTREGA, TIPO_COMPRA) ' +
                'values (:COD_PEDIDOCOMPRA, :COD_CLIFOR, :COD_USUARIO, :TOTAL, :COD_EMPRESA, :COD_FILIAL, :COD_DEPARTAMENTO, :COD_CENTRO_CUSTO, :DT_EMISSAO, :COD_CONDPAGTO, :ORDEM_COMPRA, :VALOR_IMPOSTOS, :COD_COMPRADOR, :PESO, :VOLUME, :COD_TIPOFRETE, :DATA_PREVISTA_ENTREGA, :DT_ENTREGA, :TIPO_COMPRA)')
        .addParam('COD_PEDIDOCOMPRA', v)
        .addParam('COD_CLIFOR', WS3.Cells[r, 2].Value)
        .addParam('COD_USUARIO', WS3.Cells[r, 3].Value)
        .addParam('TOTAL', WS3.Cells[r, 4].Value)
        .addParam('COD_EMPRESA', WS3.Cells[r, 5].Value)
        .addParam('COD_FILIAL', WS3.Cells[r, 6].Value)
        .addParam('COD_DEPARTAMENTO', WS3.Cells[r, 7].Value)
        .addParam('COD_CENTRO_CUSTO', WS3.Cells[r, 8].Value)
        .addParam('DT_EMISSAO', WS3.Cells[r, 9].Value)
        .addParam('COD_CONDPAGTO', WS3.Cells[r, 10].Value)
        .addParam('ORDEM_COMPRA', WS3.Cells[r, 11].Value)
        .addParam('VALOR_IMPOSTOS', WS3.Cells[r, 12].Value)
        .addParam('COD_COMPRADOR', WS3.Cells[r, 13].Value)
        .addParam('PESO', WS3.Cells[r, 14].Value)
        .addParam('VOLUME', WS3.Cells[r, 15].Value)
        .addParam('COD_TIPOFRETE', WS3.Cells[r, 16].Value)
        .addParam('DATA_PREVISTA_ENTREGA', WS3.Cells[r, 17].Value)
        .addParam('DT_ENTREGA', WS3.Cells[r, 18].Value)
        .addParam('TIPO_COMPRA', WS3.Cells[r, 19].Value)
        .execSql;
      Inc(r);
    end;

      r := 2;
    while True do
    begin
      v := WS2.Cells[r, 1].Value;
      if VarIsNull(v) or VarIsEmpty(v) then Break;
      Q.active(False).sqlClear
        .sqlAdd('insert into PEDCOMPRA_ITEM (COD_PEDIDOCOMPRA, COD_PRODUTO, QUANTIDADE, VL_UNITARIO, VL_TOTAL, COD_EMPRESA, COD_FILIAL, COD_DEPARTAMENTO, COD_CENTRO_CUSTO, DESCONTO, ACRESCIMO, IPI, VALOR_IPI, PESO, VOLUME, SEQUENCIA, DT_INCLUSAO, DT_SOLICITADA, DT_RECEBIDA) ' +
                'values (:COD_PEDIDOCOMPRA, :COD_PRODUTO, :QUANTIDADE, :VL_UNITARIO, :VL_TOTAL, :COD_EMPRESA, :COD_FILIAL, :COD_DEPARTAMENTO, :COD_CENTRO_CUSTO, :DESCONTO, :ACRESCIMO, :IPI, :VALOR_IPI, :PESO, :VOLUME, :SEQUENCIA, :DT_INCLUSAO, :DT_SOLICITADA, :DT_RECEBIDA)')
        .addParam('COD_PEDIDOCOMPRA', v)
        .addParam('COD_PRODUTO', WS2.Cells[r, 2].Value)
        .addParam('QUANTIDADE', WS2.Cells[r, 3].Value)
        .addParam('VL_UNITARIO', WS2.Cells[r, 4].Value)
        .addParam('VL_TOTAL', WS2.Cells[r, 5].Value)
        .addParam('COD_EMPRESA', 0)
        .addParam('COD_FILIAL', 0)
        .addParam('COD_DEPARTAMENTO', 0)
        .addParam('COD_CENTRO_CUSTO', 0)
        .addParam('DESCONTO', 0)
        .addParam('ACRESCIMO', 0)
        .addParam('IPI', 0)
        .addParam('VALOR_IPI', 0)
        .addParam('PESO', 0)
        .addParam('VOLUME', 0)
        .addParam('SEQUENCIA', Null)
        .addParam('DT_INCLUSAO', Null)
        .addParam('DT_SOLICITADA', Null)
        .addParam('DT_RECEBIDA', Null)
        .execSql;
      Inc(r);
    end;


  finally
    try
      Excel.Quit;
    except
    end;
  end;
end;

end.
