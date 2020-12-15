unit Msgs;

interface

uses Graphics;

const

  Times    = 'Times New Roman';
  Arial    = 'Arial';
  MsgFonte = Times;


  NbBanner      = 3;
  Type  TBanner = Record FName : String; FSize : Integer ; FStyle : TFontStyles ; Text : String End;
        TBannerArray = array[0..NbBanner-1] of TBanner;
  Const Banner : TBannerArray = (
  { Banner 1 }  ( FName:Times; FSize:28; FStyle:[fsBold];
                    Text:' EliFrac     version 2.0    '
              ),( FName:Arial; FSize:22; FStyle:[fsBold];
                  Text:' (c) Kyriakopoulos Elias 1997 - 2000 '
              ),( FName:Arial; FSize:22; FStyle:[fsBold,fsItalic];
                  Text:'3D Animation : John Biddiscombe ©1997    '
              ));
  AboutMessages = 3;  // Messages number
  Type  AboutM = array [1..AboutMessages] of String;
  Const AboutMsg : AboutM = ( // If you modify the number of messages, don't forget to change the const AboutMessages
       { Message 1 }  (' email: elep50@hotmail.com '
       { Message 2 }),(' Elifrac Is Free.      Fractals for the masses '
       { Message 3 }),(' 3D Animation by John Biddiscombe ©1997     '
                   )); // End of messages

implementation

end.
