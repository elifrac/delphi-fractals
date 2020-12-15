unit PCSpk;

{* Program : PCSpk.Pas
   Purpose : TPCSpeaker Component

   Author        Version  Last Changed  Comments
   ------        -------  ------------  --------
   Song Weng Sam 1.01     Aug. 28, 96   Initial Release (Version set to 1.01
                                        to match the 16bit version which is
                                        currently 1.01 too.)
*}

interface

uses
   Classes, WinProcs, Forms;

type
   TPCSpeaker = class(TComponent)
   private
      { Private declarations }
      procedure NoSound;
      procedure Sound(Freq: Word);
      procedure SetPort(address, value: Word);
      function GetPort(address: Word): Word;
   protected
      { Protected declarations }
   public
      { Public declarations }
      procedure Delay(MSecs: Integer);
      procedure Play(Freq: Word; MSecs: Integer);
      procedure Stop;
   published
      { Published declarations }
   end;

procedure Register;

implementation

procedure TPCSpeaker.NoSound;
var
   wValue: Word;
begin
   wValue := GetPort($61);
   wValue := wValue and $FC;
   SetPort($61, wValue);
end;

procedure TPCSpeaker.Sound(Freq: Word);
var
   B: Word;
begin
   if Freq > 18 then begin
      Freq := Word(1193181 div LongInt(Freq));

      B := GetPort($61);

      if (B and 3) = 0 then begin
         SetPort($61, B or 3);
         SetPort($43, $B6);
      end;

      SetPort($42, Freq);
      SetPort($42, (Freq SHR 8));
   end;
end;

procedure TPCSpeaker.Delay(MSecs: Integer);
var
   FirstTickCount : LongInt;
begin
   FirstTickCount:=GetTickCount;
   repeat
      Application.ProcessMessages; {allowing access to other controls, etc.}
   until ((GetTickCount-FirstTickCount) >= LongInt(MSecs));
end;

procedure TPCSpeaker.Play(Freq: Word; MSecs: Integer);
begin
   Sound(Freq);
   Delay(MSecs);
   NoSound;
end;

procedure TPCSpeaker.Stop;
begin
   NoSound;
end;

procedure TPCSpeaker.SetPort(address, value: Word);
var
   bValue: Byte;
begin
   bValue := trunc(value and 255);
   asm
      mov DX, address
      mov AL, bValue
      out DX, AL
   end;
end;

function TPCSpeaker.GetPort(address: Word): Word;
var
   bValue: Byte;
begin
   asm
      mov DX, address
      in  AL, DX
      mov bValue, AL
   end;
   result := bValue;
end;

procedure Register;
begin
   RegisterComponents('SongWS', [TPCSpeaker]);
end;

end.
