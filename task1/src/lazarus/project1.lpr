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
  TMatrix =  array [-1..N,-1..N] of  integer;
  { TChromatim }
  TChromatim = class(TCustomApplication)
  protected
    A:TMatrix;
    E:array [1..N] of TExits;
    x,y:integer;
    k:word;
    stepDo,stepBack:boolean;
    procedure Init(it:string;param:real);
    procedure Walk(dir:TExits;isForward:boolean);
    procedure Log(message:string);
    procedure DoRun; override;


  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TChromatim }

procedure  TChromatim.Log(message:string);
var F:Text;
    i,j,radius:integer;
begin
  AssignFile(f,'log.txt');
  Append(f);
  writeln(f,'==============');
  writeln(f,message);
  writeln(f,'k=',k,', x=',x,' ,y=',y,' , cx=',(N div 2)-x,' , cy=',(N div 2)-y,' , lim=',N-k+3);
  radius:=9;
  for i:= 1 to N do begin
    if i<=k then
      write(f,ord(E[i]));
    if i mod 60 = 0 then
      writeln(f);
  end;
  writeln(f);
  writeln(f);
  for j:=(N div 2)+radius downto (N div 2)-radius do begin
    for i:=(N div 2)-radius to (N div 2)+radius-1 do begin
      if A[i,j] = -1 then
        write(f,'X')
      else if A[i,j] = 0 then
        write(f,'.')
      else if A[i,j] > 0 then
        case (E[A[i,j]]) of
         up:write(f,'^');
         left:write(f,'<');
         down:write(f,'V');
         right:write(f,'>');
         none:write(f,'+');
        end
      else
        write(f,'E');
    end;
    writeln(f);
  end;
  close(f);

end;

procedure TChromatim.Init(it:string;param:real);
var i,j:integer;
    F:Text;
begin
  AssignFile(f,'log.txt');
  Rewrite(f);
  CloseFile(f);
  // fast zero fill
  FillByte(A,(N+2)*(N+2),0);
  //set border of given type
  case it of
    'border':
      //border width
      begin

        for i:=-1 to N do
          for j:=-1 to N do begin
            if    ((i)<param)
               OR ((N-i-1)<param)
               OR ((j)<param)
               OR ((N-j)<param)
            then
              A[i,j]:=-1;
        end;
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
      x := x + shift;
  end;

end;

procedure TChromatim.DoRun;
var
  ErrorMsg: String;
  cnt:Cardinal;
  i:integer;
begin
  //<debug>
  cnt:=0;
  //</debug>
  Init('border', (N-sqrt(n))/2);
  while (true) do begin
    //<debug>
    cnt:=cnt+1;
    if(cnt mod $f000000 = 0) then begin
      WriteLn(cnt,' ',k);
      for i:=1 to k do begin
        write(ord(E[i]));
      end;
      Log('STEP');
      writeln;
 //      Sleep(500);
  //   readln;

   //   readln;
    end;
  //  Log('STEP '+inttostr(cnt));
    //</debug>
    //step ->>
    Walk(E[k],true);
    //check next grid cell
    if(A[x,y] = 0) then begin
      if (k<N) then
        //check if last ball too far from middle
      //  if ( ( abs((N div 2)-x) + abs((N div 2)-y) ) > (N-k+3) ) then
     //     stepDo:=false
      //  else
          stepDo:=true
      else
        stepDo:=false
    end
    else
    if( (A[x,y] < 0) OR (A[x,y]>1) ) then
      stepDo:=false
    else
    //so we at start A[x,y]=1
    if (k<>N) then
      stepDo := false
    else begin
        //SOLUTION!
        //Do some staff about it
        //<debug>


        WriteLn('SOLUTION');
        Log('SOLUTION');

        WriteLn(cnt,' ',k);
        for i:=1 to k do
          write(ord(E[i]));
        stepDo:=false;
    //    readln;
        //</debug>
    end;
    if (stepDo) then
      if ( ( abs((N div 2)-x) + abs((N div 2)-y) ) > (N-k+3) ) then
        stepDo:=false;



 {   if ( ( abs((N div 2)-x) + abs((N div 2)-y) ) > (N-k+3) ) then begin

    end;}

    //choose step forward / change direction / step backward
    if(stepDo) then begin
      k := k + 1;
      A[x,y] := k;
      E[k] := up;
    end
    else begin
      //step <--
      stepBack := true;
      while(stepBack) do begin
        Walk(E[k],false);
        inc(E[k]);
        if (E[k]<>none) then begin
          stepDo:=true;
          stepback:=false;
        end
        else begin
          A[x,y]:=0;
          k:=k-1;
          if (k=1) then begin
            //last step ever
            //Nothing else to do here
            //EJECT
            break;
          end;
        end;
      end;
    end;

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





































