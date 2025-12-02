unit comercial.controller.service;

interface

uses
  comercial.controller.interfaces;

type

  TControllerService = class(TInterfacedObject, iControllerService)
  private
  public
    constructor create;
    destructor destroy; override;
    class function New: iControllerService;
    function mercadolivre: iControllerServiceGeneric;
    function nfse: iControllerServiceGeneric;
  end;

implementation

{ ControllerService }

constructor TControllerService.create;
begin

end;

destructor TControllerService.destroy;
begin

  inherited;
end;

function TControllerService.mercadolivre: iControllerServiceGeneric;
begin

end;

class function TControllerService.New: iControllerService;
begin

end;

function TControllerService.nfse: iControllerServiceGeneric;
begin

end;

end.
