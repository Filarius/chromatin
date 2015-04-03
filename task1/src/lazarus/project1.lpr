program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

const
  N = 256;
type
  TExits = (up, left, down, right, none);
  TMatrix =  array [-1..N,-1..N] of  byte;
  { TChromatim }
  TChromatim = class(TCustomApplication)
  protected
    A:TMatrix;
    E:array [1..N] of TExits;
    x,y:integer;
    k:byte;
    stepDo:boolean;
    procedure Init(it:string;param:real);
    procedure Walk(dir:TExits;isForward:boolean);
    procedure DoRun; override;


  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TChromatim }


procedure TChromatim.Init(it:string;param:real);
var i,j:integer;
begin
  // fast zero fill
  FillByte(A,(N+2)*(N+2),0);
  //set border of given type
  case it of
    'border':
      for i:=-1 to N do begin
        a[i,-1]:=-1;
        a[i,N]:=-1;
        a[-1,i]:=-1;
        a[N,i]:=-1;
      end;
  end;
  //Place first ball
  x:=N div 2;
  y:=N div 2;
  A[x,y]:=1;
  k:=1;
  E[k]:=up;

end;

procedure TChromatim.Walk(dir:TExits;isForward:boolean);
var shift:ShortInt;
begin
  shift:=1;
  if(not isForward) then
    shift:=-1;
  case dir of
    up:
      y := y + shift;
    left:
      x := x - shift;
    down:
      y := y - shift;
    right:
      y := y + shift;
  end;

end;

procedure TChromatim.DoRun;
var
  ErrorMsg: String;
  steps:Cardinal;
begin

  //<debug>
  steps:=0
  //</debug>
  Init('border',0);
  while (true) do begin
    //step ->>
    Walk(E[k],true);
    //check next grid cell
    if(A[x,y] = 0) then begin
      if (k<=N) then
        stepDo:=true
      else
        stepDo:=false
    end
    else begin
      if( (A[x,y] < 0) OR (A[x,y]>1) )
        stepDo:=false
      else
        //so we at start A[x,y]=1
        if (k=N) then begin
          //SOLUTION!
          //Do some staff about it
        end;
        // here no way to go ahead in any case
        stepDo = false;
    end;
    //choose step forward / change direction / step backward
  end;

 {
 // quick check parameters
 ErrorMsg:=CheckOptions('h','help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h','help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end; }

  { add your program here }

  // stop program loop
  Terminate;
end;

constructor TChromatim.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TChromatim.Destroy;
begin
  inherited Destroy;
end;

procedure TChromatim.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ',ExeName,' -h');
end;

var
  Application: TChromatim;
begin
  Application:=TChromatim.Create(nil);
  Application.Title:='Chromatim';
  Application.Run;
  Application.Free;
end.























end.





































