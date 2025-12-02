unit comercial.model.DAO.interfaces;

interface

uses
  Data.DB,
  system.Generics.Collections;

type
  iModelDAOEntity<t> = interface
    ['{20C172F2-01EA-4515-93CD-1740F4767933}']
    function Delete: iModelDAOEntity<t>;
    function DataSet(AValue: TDataSource): iModelDAOEntity<t>;
    function Get: iModelDAOEntity<t>; overload;
    function GetDataSet: TDataSet;
    function Get(AFieldsWhere: TDictionary<string, Variant>)
      : iModelDAOEntity<t>; overload;
    function Insert: iModelDAOEntity<t>;
    function This: t;
    function Update: iModelDAOEntity<t>;
    function GetbyId(AValue: integer): iModelDAOEntity<t>;
  end;

implementation

end.
