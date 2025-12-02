unit comercial.controller;

interface

uses
  comercial.controller.interfaces;

type
  TController = class(TInterfacedobject, iController)
  private
    FBusiness : iControllerBusiness;
  public
    constructor create;
    destructor destroy; override;
    class function New: iController;
    function business : iControllerBusiness;
  end;

implementation

uses
  comercial.controller.business;

{ TController }

function TController.business: iControllerBusiness;
begin
  if not Assigned(FBusiness) then
    FBusiness := TcontrollerBusiness.New;

  result := FBusiness;
end;

constructor TController.create;
begin

end;

destructor TController.destroy;
begin

  inherited;
end;


class function TController.New: iController;
begin
  result := self.create
end;

end.
