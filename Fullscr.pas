unit Fullscr;
//****************************************************************************************
//  Author : Kyriakopoulos Elias  ©  1997-1999
//  This File is part of the EliFrac Project
//****************************************************************************************
interface

uses
  Windows, {Messages,} SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TFullScreen = class(TForm)
    procedure FormClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  FullScreen: TFullScreen;
  temp2,temp3 : TBitmap;
  fullrect,t2rect : Trect;
  zoomfactor : Integer;

//const
//VK_PAGEUP   =  33;  //VK_PRIOR = 33;
//VK_PAGEDOWN =  34;  //VK_NEXT = 34;

procedure clear;

implementation

uses Main;

{$R *.DFM}

procedure TFullScreen.FormClick(Sender: TObject);
begin
close;
end;

procedure TFullScreen.FormPaint(Sender: TObject);
begin
 FullScreen.Canvas.StretchDraw(fullrect,temp2);
end;

procedure TFullScreen.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//temp2.free;
//temp3.free;
Action := caFree;
end;

procedure TFullScreen.FormKeyPress(Sender: TObject; var Key: Char);
begin
   case key of
   #27 : close;
   '+' : begin
           inc(zoomfactor);
           if (zoomfactor = 0) or (zoomfactor = -1) then zoomfactor := 1;
           if zoomfactor > 0 then
           begin
           fullrect.right := BM.temp.Width  * zoomfactor;
           fullrect.bottom :=BM.temp.Height * zoomfactor;
           Paint;
           end else if zoomfactor < 0 then
                  begin
                  fullrect.right := BM.temp.width div (-zoomfactor);
                  fullrect.bottom := BM.temp.height div (-zoomfactor);
                  Paint;
                  end;

         end;

   '-' : begin
          dec(zoomfactor);
          if (zoomfactor = 0) or (zoomfactor = 1) then zoomfactor := -1;
          if zoomfactor > 0 then
          begin
          fullrect.right := BM.temp.width * zoomfactor;
          fullrect.bottom := BM.temp.height * zoomfactor;
          clear;
          Paint;
          end else if zoomfactor < 0 then
                  begin
                  fullrect.right :=  BM.temp.width  div (-zoomfactor);
                  fullrect.bottom := BM.temp.height div (-zoomfactor);
                  clear;
                  Paint;
                  end;
         end;
    end; // case
end;

procedure TFullScreen.FormShow(Sender: TObject);
begin
  SetBounds(0,0,screen.width,screen.height);
  Fullscreen.top:=0;
  Fullscreen.left:=0;
  Fullscreen.height:=screen.height;
  Fullscreen.width:=screen.width;
  BringToFront;
end;

procedure TFullScreen.FormCreate(Sender: TObject);
begin
temp2 := TBitmap.Create;
temp2.width := BM.temp.width;
temp2.height := BM.temp.height;

temp3 := TBitmap.Create;          //  For some strange reason the "OnKeyDown" Procedure
temp3.width := BM.temp.width;     //  will not work if temp3 is not initialized here.
temp3.height := BM.temp.height;   //  So leave it here for now, until I find the BUG.
                                  //  It doesn't even need to be assigned anything.

Width := screen.width;
Height := screen.width;
zoomfactor := 1;
fullrect := Rect(0,0,BM.temp.width,BM.temp.height);
t2rect := Rect(0,0,temp2.width,temp2.height);
temp2.Canvas.CopyRect(t2rect,BM.temp.Canvas,t2rect);
//temp3.Canvas.CopyRect(t2rect,BM.temp.Canvas,t2rect);
BringToFront;
end;

procedure clear;
begin
with FullScreen.Canvas do
  begin
   Brush.Color := clblack; //BM.Color;
   Brush.Style := bsSolid;
   Pen.Mode := pmCopy;
   PatBlt(handle,0,0,Fullscreen.Width,Fullscreen.Height,BLACKNESS);
  end;
end;

procedure TFullScreen.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

case key of
  VK_DOWN : begin
              if fullrect.bottom >= (Fullscreen.Height + 2) then
              begin
              dec(fullrect.top,2);
              dec(fullrect.bottom,2);
              temp2.Canvas.CopyRect(t2rect,temp2.Canvas,t2rect);
              Paint;
              end;
            end;
   VK_UP : begin
             if (fullrect.bottom >= Fullscreen.Height) and (fullrect.top < 0 ) then
              begin
            inc(fullrect.top,2);
            inc(fullrect.bottom,2);
            temp2.Canvas.CopyRect(t2rect,temp2.Canvas,t2rect);
            Paint;
            end;
            end;
   VK_LEFT : begin
              if Shift = [ssAlt] then begin
               if (fullrect.right >= Fullscreen.Width) and (fullrect.left < 0 ) then
                begin
               inc(fullrect.left,30);
               inc(fullrect.right,30);
               temp2.Canvas.CopyRect(t2rect,temp2.Canvas,t2rect);
               Paint;
               end;
              end
              else
               if (fullrect.right >= Fullscreen.Width) and (fullrect.left < 0 ) then
                begin
                 inc(fullrect.left,2);
                 inc(fullrect.right,2);
                 temp2.Canvas.CopyRect(t2rect,temp2.Canvas,t2rect);
                 Paint;
                end;
              end;
   VK_RIGHT : begin
              if Shift = [ssAlt] then begin
               if fullrect.right >= (Fullscreen.Width +30) then
                begin
                 dec(fullrect.left,30);
                 dec(fullrect.right,30);
                 temp2.Canvas.CopyRect(t2rect,temp2.Canvas,t2rect);
                 Paint;
                 end;
              end
              else
               if fullrect.right >= Fullscreen.Width+2 then
              begin
              dec(fullrect.left,2);
              dec(fullrect.right,2);
              temp2.Canvas.CopyRect(t2rect,temp2.Canvas,t2rect);
              Paint;
              end;
              end;
 {VK_PAGEDOWN}
 VK_NEXT    : begin
              if fullrect.bottom >= (Fullscreen.Height + 30) then
              begin
              dec(fullrect.top,30);
              dec(fullrect.bottom,30);
              temp2.Canvas.CopyRect(t2rect,temp2.Canvas,t2rect);
              Paint;
              end;
              end;
 {VK_PAGEUP}
 VK_PRIOR   : begin
              if (fullrect.bottom >= Fullscreen.Height) and (fullrect.top < 0 ) then
              begin
              inc(fullrect.top,30);
              inc(fullrect.bottom,30);
              temp2.Canvas.CopyRect(t2rect,temp2.Canvas,t2rect);
              Paint;
              end;
              end;
 end; // case.
end;

end.
