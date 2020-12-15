
{Function : Cadd(x,y)  Πρόσθεση δύο μιγαδικών αριθμών}
function Cadd(x,y : Complex) : Complex;
begin
Result.real := x.real + y.real;
Result.img  := x.img + y.img;
end;

{Function : Csub(x,y)  Αφαίρεση δύο μιγαδικών αριθμών}
function Csub(x,y : Complex) : Complex;
begin
Result.real := x.real - y.real;
Result.img  := x.img - y.img;
end;

{Function : Cmul(x,y)  Πολλαπλασιασμός δύο μιγαδικών αριθμών}
function Cmul(x,y : Complex) : Complex;
begin
 Result.real := x.real * y.real - x.img * y.img;
 Result.img  := x.img * y.real + x.real * y.img;
end;

{Function : Cmulf(x,y)  Πολλαπλασιασμός μιγαδικού με πραγματικό αριθμό}
function Cmulf(x : Complex; y : Extended) : Complex;
begin
Result.real := x.real * y;
Result.img  := x.img  * y;
end;

{Τετράγωνο Μιγαδικού}
function Csqr(x : Complex) : Complex;
begin
 Result := Cmul(x,x);
end;

{Function : Cdiv(x,y)  Διαίρεση δύο μιγαδικών αριθμών}
function Cdiv(x,y : Complex) : Complex;
var
denom : Extended;
begin
denom := y.real * y.real + y.img * y.img;
//try
if denom <> 0 then
begin
Result.real := (x.real * y.real + x.img * y.img) / denom;
Result.img  := (x.img * y.real - x.real * y.img) / denom;
end
//except
else begin
 Result.real := 0;
 Result.img  := 0;
end;
end;

{Magnitude of a complex number}
function Cmagn(x : Complex) : Extended;
begin
 Result := sqrt(x.real*x.real + x.img*x.img);
end;

{Normalize a complex number}
function Cnorm(x : Complex) : Complex;
var
denom : Extended;
begin
 denom := Cmagn(x);
 Result.real := x.real / denom;
 Result.img  := x.img / denom;
end;

// Συνημίτονο Μιγαδικού.
function Ccos(x : Complex) : Complex;
begin
Result.real := cos(x.real)*cosh(x.img);
Result.img  := -sin(x.real)*sinh(x.img);
end;

// Ημίτονο Μιγαδικού.
function Csin(x : Complex) : Complex;
begin
Result.real := sin(x.real)*cosh(x.img);
Result.img  := cos(x.real)*sinh(x.img);
end;

{Make a complex number out of two Extendeds}
function Complexfunc(r,i :Extended) : Complex;
begin
Result.real := r;
Result.img  := i;
end;

function Cconjugate(r,i :Extended) : Complex;
begin
Result.real := r;
Result.img  := -i;
end;

function C2Dabs(x : Complex) : Extended;
begin
//Result := abs(x.real)+abs(x.img);
Result := sqrt(sqr(x.real)+sqr(x.img));
end;

function Cabs(x : Complex): Complex;
begin
Result.real := sqrt(sqr(x.real)+sqr(x.img));
Result.img := 0.00000000;
end;

function Ccosh(x : Complex) : Complex;
begin
Result.real := cosh(x.real)*cos(x.img);
Result.img := sinh(x.real)*sin(x.img);
end;

function Csinh(x : Complex) : Complex;
begin
Result.real := sinh(x.real)*cos(x.img);
Result.img := cosh(x.real)*sin(x.img);
end;

//  e^(x+iy)   = (e^x) (cos(y) + i sin(y))

function Cexp(x : Complex) : Complex;
var
dum : Extended;
begin
  dum := exp(x.real);
  Result.real := dum * cos(x.img);
  Result.img  := dum * sin(x.img);
end;

// ident(x+iy) = x+iy
function Ident(x : Complex) : Extended;
begin
 Result := x.real + x.img;
end;

function Cflip(x : Complex) : Complex;
begin
result.real := x.img;
result.img  := x.real;
end;

// sqrt(x+iy) = sqrt(sqrt(x^2+y^2)) * (cos(atan(y/x)/2) + i sin(atan(y/x)/2))
function Csqrt(x : Complex) : Complex;
begin
 result.real := sqrt(hypot(x.real,x.img)) * cos(arctan2(x.img,x.real)/2);
 result.img  := sin(arctan2(x.img,x.real)/2);
end;

// atan(z) = i/2* log((1-i*z)/(1+i*z))

function cequal (x, y : Complex) : boolean;
// return TRUE if x = y
begin
cequal := (x.real = y.real) and (x.img = y.img)
end;

// log(x+iy) = (1/2)log(x^2 + y^2) + i(atan(y/x) + 2kPi)
//        for k = 0, -1, 1, -2, 2, ...
//(The log function refers to log base e, or ln. The expression atan(y/x) is an angle between
// -pi and pi in the quadrant containing (x,y) implemented in C as the atan2() function.)
function Clog(x : Complex): Complex;
begin
 result.img := arctan2(x.img,x.real);   // for k = 0;
 result.real := 0.5*(ln(sqr(x.real) + sqr(x.img)));
end;

//     z^w = e^(w*log(z))
function ComplexPower(xx,yy : Complex): Complex;
var
   cLg, t : Complex;
   e2x, siny, cosy : Extended;
begin
 if (xx.real = 0) and (xx.img = 0) then // zero raised to anything is zero
  begin
   result.real := 0.0;
   result.img := 0.0;
   exit;
  end;
   cLg := Clog(xx);
   t := cmul(cLg,yy);
   if(t.real < -690) then e2x := 0
   else  e2x := exp(t.real);
   sincos(t.img, siny, cosy);

 result.real := e2x * cosy;
 result.img := e2x * siny;
end;

function Czero : Complex;
begin
result.real := 0.0;
result.img := 0.0;
end;

function cintdiv_RC(f1:extended;  z:Complex) : Complex;  // 9-12-99
var
dis : Extended;
begin
dis := z.real*z.real+z.img*z.img;
//try
if dis <> 0 then
begin
cintdiv_RC.real:=(f1*z.real)/ dis; //(z.real*z.real+z.img*z.img);
cintdiv_RC.img:=(-f1*z.img)/ dis;      //((z.real*z.real+z.img*z.img));
end
//except
else begin
cintdiv_RC.real:= 0;
cintdiv_RC.img:= 0;
end;
end;






