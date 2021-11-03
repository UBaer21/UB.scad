// ..\Documents\OpenSCAD\libraries

/*
Open SCAD library www.openscad.org by ulrich.baer+openscad@gmail.com (mail me if you need help - i am happy to assist)
Copy this file into your libaries directory (File » show Library)
[https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries]

Use it by starting your project with including the library.
All needed Information will be displayed in your console window, you may need to make that bigger.
Write:
include<ub.scad>   // no ";" [https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Include_Statement]
name="my project"; // the name will never be rendered
 
helpsw=1;       // switch to show the information
$info=1;        // switch to get feedback/info from objects
helpM=1;        // switch to get help for used objects
nozzle=.4;      // set your printers nozzle diameter
layer=.2;       // set your layerhigh
show=2;         // will show you Object n (any number) from this library
anima=1;        // activate animation variables else "tset=.5" can be used
vp=1;           // switch fixed Viewports
name="object";     // used in modules for showing name or number - if 0 no info is shown

Changelog (archive at the very bottom)
313|21  Reordering modules ADD teiler FIX Help txt ADD MO fix missing obj warnings
314|21  ADD Example Fix Linear infotxt
315|21  CHG Anordnen Add center CHG Pfeil  add center add inv CHG Calliper CHG Pivot
316|21  ADD 3Projection CHG Scale CHG Halb CHG Rand add help
317|21  CHG WStern help CHG Caliper CHG GT2Pull ADD gcode CHG Tri, Quad, Kreis
318|21  CHG Tri90, Linse, Pivot, Star, 7Seg

*/

//libraries direkt (program folder\oscad\libaries) !
/*[UB lib]*/
test=42;
/*[Global]*/

helpsw=false;//activates help in console window
//animation
anima=false;
bed=true;
debug=$preview?anima?false:true:false;//activates module information (n)
$info=debug;
//viewpoint
//vp=false;
vp=$preview?false:true;
//Project name
name=undef;
//Düsen ∅
nozzle=0.6;

//Layer hight
layer=0.08;// one step = 0.04 (8mm/200steps)

//Print Bed
printBed=[220,220];
//Printposition;
printPos=bed?printBed/2:[0,0,0];
//global fragment size
hires=false;
fn=$preview?36:hires?144:72;
fs=$preview?1.25:hires?.5:1;
//demo objects
show=0;
//animation var
tset=0;//[0:.01:1]
//clearance
spiel=0.20;

pivotSize=$vpd/15;

vpt=is_num(printPos.z)?printPos:concat(printPos,0);
vpr=bed?[55.00,0.00,25.00]:$vpr;
vpd=bed?300:$vpd;//[50:5:350]
vpf=22.5;


//display project name
texton=name!=undef?$preview?true:false:false;

// Colors
helpMColor="#5500aa";

/*[Constant]*/
/*[Hidden]*/
Version=21.317;//                <<< ---   VERSION  VERSION VERSION ••••••••••••••••
useVersion=undef;
UB=true;
PHI=1.6180339887498948;//1.618033988;
gw=360-360/PHI;// goldener Winkel;
tw=acos(-1/3);// tetraeder winkel;
twF=acos(1/3);// tetraeder winkel face edge face;
inch=25.4; // inch/Zoll
minVal=0.0000001; // minimum für nicht 0
view=$preview?tan($vpf)*$vpd:50000; // größe Sichtfeld 
//echo(tw,twF);
//PHI=(1+sqrt(5))/2;

assert(useVersion?Version>=useVersion:true,str("lib version ",Version," detected, install ",useVersion," ub.scad library‼ ⇒http://v.gd/ubaer"));
assert(version()[0]>2019,"Install current http://openscad.org version");

function l(x)=x*layer;
function n(x)=sign(x)*(abs(x)*nozzle+0.015);// 0.015 padding for slicer
function Inkreis(eck,rU)=cos(180/eck)*rU;
function Umkreis(eck,rI)=rI/cos(180/eck);
function Hypotenuse(a,b)=sqrt(pow(a,2)+pow(b,2));
function Kathete(hyp,kat)=sqrt(pow(hyp,2)-pow(kat,2));
function Sehne(n,r,a)=is_undef(a)?2*r*sin(180/n):2*r*sin(a/2);// n-eck oder a=α winkel zum r=radius
function t3(wert=1,grad=360,delta=0)=sin(($preview?anima?$t:tset:tset)*grad+delta)*wert;
function RotLang(rot=0,l=10,l2,z,e,lz)=let(
rot=is_undef(rot)?0:rot,
l=is_undef(l)?0:l,
l2=is_undef(l2)?l:l2,
lz=is_undef(lz)?l:lz
)
is_undef(z)?is_undef(e)?[sin(rot)*l,cos(rot)*l2]:[sin(rot)*cos(e)*l,cos(rot)*cos(e)*l2,sin(e)*lz]:[sin(rot)*l,cos(rot)*l,z];


function Bezier(t,p0=[0,0],p1=[-20,20],p2=[20,20],p3=[0,0])=
let(
    omt = 1 - t,
    omt2 = omt * omt,
    t2 = t * t
)
p0*(omt2*omt) + p1*(3*omt2*t) + p2*(3*omt*t2) + p3*(t2*t);


function Kreis(r=10,rand=+5,grad=360,grad2,fn=fn,center=true,sek=true,r2=0,rand2,rcenter=0,rot=0,t=[0,0])=
let (
grad2=is_undef(grad2)?grad:grad2,
r=rcenter?r+rand/2:r,
rand2=is_undef(rand2)?rand:rand2,
r2=r2?
    rcenter?r2+rand2/2:r2
    :r,
fn=max(1,floor(abs(fn))),
step=grad/fn,
step2=grad2/fn
)
[

if(!sek&&!rand&&abs(grad)!=360&&grad||r==0)[0+t[0],0+t[1]],
if(r&&grad)for(i=[0:fn])
        let(iw=abs(grad)==360?i%fn:i)
    [sin(rot+(center?-grad/2+90:0)+iw*step)*r+t[0],
    cos(rot+(center?-grad/2+90:0)+iw*step)*r2+t[1]],
if(rand)for(i=[0:fn])
    let(iw=abs(grad2)==360?i%fn:i)
    [sin(rot+(center?grad2/2+90:grad2)+iw*-step2)*(r-rand)+t[0],
    cos(rot+(center?grad2/2+90:grad2)+iw*-step2)*(r2-rand2)+t[1]]

];


function KreisXY(r=5,grad=0)=[r*sin(grad),r*cos(grad)];//depreciated use RotLang

function 5gon(b1=20,l1=15,b2=10,l2=30)=[[0,0],[b1,l1],[b2,l2],[-b2,l2],[-b1,l1]];

function ZigZag(e=5,x=50,y=5,mod=2,delta=+0,base=2,shift=0)=[for(i=[0:e*mod])[i%mod<mod/2+delta?i*x/(e*mod):i*x/(e*mod)+shift,i%mod<mod/2+delta?base:y],[x,0],[0,0]];

function TangentenP(//Tangenten schnittpunkt ab Kreis mit radius rad
grad=150, // Winkel der Tangenten
rad=20, // Kreis radius
r=0// Kreislinien abstand von 0 
)=
    let(
    c=sin(abs(grad)/2)*rad*2,//  Sekante 
    w1=abs(grad)/2,          //  Schenkelwinkel
    w3=180-abs(grad),        //  Scheitelwinkel
    a=(c/sin(w3/2))/2,    
    hc=grad!=180?Kathete(a,c/2):0,  // Sekante tangenten center
    hSek=Kathete(rad,c/2), //center Sekante
    tsRadius=r-rad+hc+hSek
    )
tsRadius;

// two digit dec max 255
function Hex(dec)= 
    let(
    dec=min(abs(dec),255),
    sz=floor(dec/16),
    s1=floor(dec)-(sz*16)
    )
    str(sz>14?"F":
        sz>13?"E":
        sz>12?"D":
        sz>11?"C": 
        sz>10?"B":
        sz>9?"A":sz,      
        s1>14?"F":
        s1>13?"E":
        s1>12?"D":
        s1>11?"C": 
        s1>10?"B":
        s1>9?"A":s1   
  
    );

function Hexstring(c)=str("#",Hex(c[0]*255),Hex(c[1]*255),Hex(c[2]*255));



function RotPoints(grad,points)=[for(i=[0:len(points)-1])RotLang(rot=atan2(points[i][0],points[i][1])+grad,l=norm([points[i][0],points[i][1]]),z=points[i][2])];

function negRed(num)=num<0?str("<font color=red ><b>",num,"</font>"):num; // display console text
function gradB(b,r)=360/(PI*r*2)*b; // winkel zur Bogen strecke b des Kreisradiuses r
function gradS(s,r)=asin(s/(2*r))*2;// winkel zur Sehne s des Kreisradiuses r
function radiusS(n,s,a)=(s/2)/(sin((is_undef(n)?a:360/n)/2));// Radius  zur Sehne
function runden(x,dec=2)=round(x*pow(10,dec))/pow(10,dec);//auf komastelle runden
function grad(grad=0,min=0,sec=0,h=0,prozent=0,gon=0,rad=0)=grad+h/24*360+min/60+sec/3600+atan(prozent/100)+gon/400*360+rad/(2*PI)*360;
function inch(inch)=inch*25.4;
function kreisbogen(r,grad=360)=PI*r*2/360*grad;
function fs2fn(r,grad=360,fs=fs,minf=3)=max(minf,PI*r*2/360*grad/fs);
function clampToX0(points,interval=minVal)=[for(e=points)[abs(e[0])>interval?e[0]:0,e[1]]];
  
// angle between two points used for Bezier
  vektorWinkel= function(p1,p2)p1==p2?[0,0,0]:[ 
            
            -acos((p2.z-p1.z)/norm(p2-p1))+90,
            0,
            atan2(p2.y-p1.y,p2.x-p1.x)-90
            ];

v3= function(v)is_num(v.y)?is_num(v.z)?len(v)==3?v:  // make everything to a vector3
                                          [v.x,v.y,v.z]:
                            concat(v,[0]):
                  concat(v,[0,0]);

// list of parent modules [["name",id]]
parentList= function(n=-1) [for(i=[0:$parent_modules +n])[parent_module(i),i]];

// kleinster teiler
teiler = function (n,div=2) (n%div)?div>n?n:
                                         teiler(n=n,div=div+1):
                                  div;

// generates G-Code (G1 x,y,(z),(e),(f))
gcode=function(points,chunksize=600,i,f)
let(i=is_undef(i)?len(points)-1:i,
chunk=function(pos=0,end) (pos+1)>end?str(chunk(pos=pos-1,end=end),
"G1 X",
points[pos].x,
" Y",points[pos].y,
len(points[pos])>2?str(" Z",points[pos].z,""):"",
len(points[pos])>3?str(" E",points[pos][3],""):"",
f?str(" F",len(points[pos])==5?points[pos][4]:f):"","\n"):""
)
i>+0?str(gcode(i=i-chunksize,chunksize=chunksize,points=points),chunk(i,max(0,i-chunksize))):"";



$fn=fn;
$fs=fs;
help=$preview?anima?false:helpsw:false;
helpFunc=helpsw==1?true:helpsw==true?true:false;//Funktionen
helpMod=helpsw==2?true:helpsw==true?true:false;//Objektmodifikatoren
helpB=helpsw==3?true:helpsw==true?true:false;//Basis help
helpP=helpsw==4?true:helpsw==true?true:false;//Produkte help
help2D=helpsw==5?true:helpsw==true?true:false;// 2D Objekte
//helpM=help;//module help old
$helpM=help;//module help

t=$preview?anima?$t:tset:tset;
t0=$preview?anima?$t*360:tset*360:tset*360;
t1=$preview?anima?sin($t*360):tset:tset;
t2=$preview?anima?sin($t*180):tset:tset;

$vpr=vp?vpr:$vpr;    
$vpt=vp?vpt:$vpt;
$vpd=vp?vpd:$vpd;
$vpf=vp?vpf:$vpf;


messpunkt=$preview?$info:false;//1 für aktiv
$messpunkt=messpunkt;
//n=0;

if (texton)%T(20,-30,25)R(90)color("slategrey")text(str(name),font="DejaVusans:style=bold",halign="left",size=3,$fn=100);
    
if (bed)color(alpha=.1)%Rand(-5,delta=1)square(printBed);
if(version()[0]<2021)
echo(str("<p style=background-color:#ccccdd>",
"<ul>     •••••••••••••••••••••••••• UB (USER libary v2019) included! <a href=http://v.gd/ubaer> v.gd/ubaer </a> •••••••••••••••••••••••••\n",
"••• Version: β",Version," v ",version(),"  ——  Layer: ",layer," Nozzle ∅: ",nozzle," ••• fn=",fn,"••• Spiel: ",spiel," •••"));
else{ echo(str("•••••••••••••••••• UB (USER library v2021) included! v.gd/ubaer  •••••••••••••••••"));
echo(str("• Version: β",Version," v ",version(),"  —  Layer: ",layer," Nozzle ∅: ",nozzle," • fn=",fn," • Spiel: ",spiel," •"));
}



if (!help) if(version()[0]<2021)echo    ("<h4 style=background-color:lightgrey>••••• Help off       use: helpsw=1;  •••••");
    else echo    ("••••• Help off       use: helpsw=1;  •••••");
    

if (help)
{
    echo ("<h3 style=background-color:#ccbbbb><font color='pink'size='5'>••••••• Konstanten:   ••••••••</font></h3>");
    echo(PHI=PHI,gw=gw,tw=tw,twF=twF,inch=inch);
//echo(str("•••••••••• Help is on! (helpsw=1)•• debug=",debug," ••••••••••••••••••••••••"));
//echo();
if (show)echo(str("<font color='darkviolet'size=8> ••• show=",show,"</font>")); 
    

if(!helpFunc)echo("<h4 style=background-color:#bbbbbb>••••• Functions off — use» helpFunc=true; •••••");
if (helpFunc){
echo    ("<h3 style=background-color:#bbbbcc><font color='blue'size='5'>•••••••••• Funktionen:   •••••••••••••••</font></h3>");
echo    ("••• l(x)//Layer  ••  n(x)//Nozzledurchmesser   •••\n
••• Inkreis(eck,rU) •• Umkreis(eck,rI) •••\n
••• Hypotenuse(a,b) length •• Kathete(hyp,kat) length •••\n
••• Sehne(n,r,a) length n-eck/alpha winkel •••\n
••• RotLang(rot,l,z,e,lz) [vector] (e=elevation)•••\n
••• Bezier(t,p0=[0,0],p1=[-20,20],p2=[20,20],p3=[0,0]) points   •••\n
••• Kreis(r=10,rand=+5,grad=360,grad2=+0,fn=fn,center=true,sek=true,r2=0,rand2=0,rcenter=0,rot=0,t=[0,0]) points •••\n
••• KreisXY(r=5,grad=0) [vector]•••\n
••• 5gon(b1=20,l1=15,b2=10,l2=30) points •••\n
••• ZigZag(e=5,x=50,y=5,mod=2,delta=+0,base=2,shift=0) points •••\n
••• TangentenP(grad,rad,r) length •••\n
••• Hexstring(c=[r,g,b]) #hexcolor •••\n
••• RotPoints(grad,points) •••\n
••• negRed(num) negative consolen Werte in rot•••\n   
••• gradB(b,r) grad zum Bogenstück b •••\n 
••• gradS(s,r) grad zur Sehne s •••\n     
••• vollwelle() ⇒ Vollwelle(help=1) •••\n
••• runden(x,dec=2) x runden auf Dezimalstelle ••• \n
••• radiusS(n,s,a); radius zur Sehne ••• \n
••• grad(grad=0,min=0,sec=0,h=0,prozent=0,gon=0,rad=0); Winkelmaßumrechnung ••• \n  
••• inch(inch); Inch⇒mm •••\n 
••• kreisbogen(r,grad=360); ••• \n
••• fs2fn(r,grad=360,fs=fs,minf=3); •••\n
••• vektorWinkel(p1,p2,twist=0); •••\n
••• v3(v); makes v a vector3 •••\n
••• parentList() list with all modules •••\n
••• teiler(n,div=2) least divisior •••\n
••• gcode(points,f) generates gcode in output •••\n
");
    
}

//Objektmodifikatoren
if(!helpMod)echo("<h4 style=background-color:#bbbbbb>••••• Objektmodifikatoren off — use» helpMod=true; •••••");
if (helpMod){
echo    ("<h3 style=background-color:#bbccbb><font color='green'size=5>•••••••••• Objektmodifikatoren:   ••••••</font></h3>");
echo    ("•••• T(x=0,y=0,z=0)•Tz(z=0) ••• R(x=0,y=0,z=0)  ••");
echo    ("•••• M(skewzx=0,skewzy=0,skewxz=0,skewxy=0,skewyz=0,skewyx=+0,scale=1,scalexy=1,scalexz=1,scaleyz=1)••");
echo    ("•••• Col(no=0,alpha=1,pal=0,n=0)multi Objekt color  ••");
echo    ("••••Color(hue=0,alpha=1,v=1,l=0.5,n=0)••");

echo    ("•••• Rund(or=+0,ir=0,chamfer=false,fn=fn)polygon••");
echo    ("•••• Schnitt(on=1,r=0,x=0,y=0,z=0,rx=0,ry=0,sizex=200,sizey=200,sizez=50,center=0)Objekt  ••");    
echo    ("•••• Linear(es=1,s=100,e=2,x=1,y=0,z=0,r=0,re=0,center=0,cx=0,cy=0,cz=0 ••");   
echo    ("•••• Polar(e=3,x=0,y=0,r=0,re=0,end=360,dr=0,mitte=false,n=$info)dr=delta element rotation  ••");
echo    ("•••• Grid(es=[10,10,10],e=[2,2,1],center=true) ••");
echo    ("•••• HexGrid ()");   
echo    ("•••• Klon(tx=10,ty=0,tz=0,rx=0,ry=0,rz=0) Objekt ••• Mklon(tx=10,ty=0,tz=0,rx=0,ry=0,rz=0,mx=0,my=0,mz=0) Objekt  ••");
echo    ("•••• Halb(i=0,x=0,y=0,z=1,2D=0)Objekt      ••");
echo    ("•••• Drehpunkt(rx=0,ry=0,rz=0,x=0,y=0,z=0,messpunkt=1)Objekt      ••");
echo    ("•••• Rundrum(x=+40,y=30,r=10,eck=4,twist=0,grad=0,spiel=0.005,fn=fn,n=$info) polygon RStern(help=1)polygon ••");
echo    ("••••  Kextrude(help=1); ••");  
echo    ("•••• LinEx(help=1) polygon  ••");
echo    ("•••• LinEx2(bh=5,h=1,slices=10,s=1.00,ds=0.01,dh=0.7,fs=1,fh=1,twist=0,n=$info,fn=fn) ••");
echo    ("•••• RotEx(grad=360,fn=fn,center=false)  ••");
echo    ("•••• Rand(rand=n(1),center=false,fn=fn,delta=false,chamfer=false)  ••");
echo    ("•••• Elipse(x=2,y=2,z=0,fn=36)Object••");
echo    ("•••• Ttorus(r=20,twist=360,angle=360,fn=fn)3D-Objekt      ••");
//echo    ("•••• GewindeV1(d=20,s=1.5,w=5,g=1,fn=3,r=0,gd=1.75,detail=5,tz=0,n=1) steigung,windung,gänge,gangdurchmesser      ••");
echo    ("•••• Gewinde(help=1)••");
echo    ("•••• GewindeV3(dn=5,h=10,kern=0,p=1,w=0,profil=0,gh=0.56,g=1,n=$info,fn=36)••");
echo    ("•••• Kontaktwinkel(winkel=60,d=d,center=true,2D=0,inv=false,n=$info) Objekt  ••"); 
echo    ("•••• Bezier(p0=[+0,+10,0],p1=[15,-5,0],p2=[15,+5,0],p3=[0,-10,0],w=1,max=1.0,min=+0.0,fn=50,ex=0,pabs=false,messpunkt=5,n=$info) Objekt •••••");

echo    ("•••• Laser3D(h=4,layer=10,var=0.002,n=$info,on=-1)3D-Objekt ••");

echo    ("\n
•••• Bogen(help=1) opt Polygon   ••\n
•••• SBogen(help=1) opt Polygon   ••\n
•••• Row(help=1) opt. Objekt ••\n
•••• Anordnung(help=1) Objekte ••\n
•••• Bevel(help=1) Objekt ••\n
•••• Scale(help=1) Objekt ••\n

");

}


  if(!helpB)echo("<h4 style=background-color:#bbbbbb>••••• Basis objects off — use» helpB=true; •••••");   
 if(helpB){//  BASIS OBJEKTE   
    
echo();    
echo    ("<h3 style=background-color:#bbddbb><font color='darkgreen'size=5>•••••••••• BasisObjekte:   •••••••••••••</font></h3>");



echo    ("•• [300] Kugelmantel(d=20,rand=n(2),fn=fn); ••••");

echo    ("•• [30] Kegel (d1=12,d2=6,v=1,fn=fn,n=$info,center=false,grad=0)  ••• [31]MK(d1=12,d2=6,v=19.5)//v=Steigung ••••");
echo    ("•• [301] Kegelmantel (d=10,d2=5,v=1,rand=n(2),loch=4.5,grad=0,center=false,fn=fn,n=$info) ••••");
echo    ("•• [32] Ring(h=5,rand=5,d=20,cd=1,center=false,fn=fn,n=$info,2D=0) cd=1,0,-1  ••••");
echo    ("•• [33] Torus(trx=10,d=5,a=360,fn=fn,fn2=fn,r=0,n=1,dia=0,center=true,spheres=0)opt polygon ••••");
echo    ("•• [34] Torus2(m=10,trx=10,a=1,rq=1,d=5,w=2)//m=feinheit,trx = abstand mitte,a = sin verschiebung , rq=mplitude, w wellen •••••");
echo    ("••  WaveEx(help=1)•••••");   
echo    ("•• [35] Pille(l=10,d=5,fn=fn,fn2=36,center=true,n=1,rad=0,rad2=0,loch=false) •••• ");
echo    ("•• [402] Strebe(skew=0,h=20,d=5,rad=4,rad2=3,sc=0,grad=0,spiel=0.1,fn=fn,center=false,n=$info,2D=false)••••");
echo    ("•• WStrebe(grad=45,grad2=0,h=20,d=2,rad=3,rad2=0,sc=0,angle=360,spiel=.1,fn=fn,2D=false,center=true,help=helpM) ••••");
echo    ("•• [36] Twins(h=1,d=0,d11=10,d12=10,d21=10,d22=10,l=20,r=0,fn=60,center=0,sca=+0,2D=false) ••••");
echo    ("•• [37] Kehle(rad=2.5,dia=0,l=20,angle=360,fn=fn,spiel=spiel,fn2=fn,r2=0)••••");
echo    ("••  REcke(help=1)••••");   
echo    ("••  HypKehle(help=1)••HypKehleD()••••"); 

echo    ("•• [46] Text(text=»«,size=5,h=0,cx=0,cy=0,cz=0,center=0,font=Bahnschrift:style=bold)••••");
echo    ("•• [47] W5(kurv=15,arms=3,detail=.3,h=50,tz=+0,start=0.7,end=13.7,topdiameter=1,topenddiameter=1,bottomenddiameter=+2)••••");


echo    ("•• [50] Rohr(grad=90,rad=5,d=8,l1=10,l2=12,fn=fn,fn2=fn,rand=n(2),name=0)••••");
echo    ("•• [51] Dreieck(h=10,ha=10,ha2=ha,s=1,n=1,c=0,2D=0,grad=0)  s=skaliert  c=center   ••••");
echo    ("•• [52] Freiwinkel(w=60,h=5)   ••••");
echo    ("•• [54] Sinuskoerper(h=10,d=33,rand=2,randamp=1,randw=4,amp=1.5,w=4,detail=3,vers=0,fill=0,2D=0,twist=0,scale=1)  amp=Amplitude, w=Wellen, vers=versatz ••••");

echo    ("•• [55] Kassette(r1=2,r2=2,size=20,h=0,gon=3,fn=fn,fn2=36,r=0,grad=90,grad2=90,spiel=0.001,mitte=true,sizey=0,help=helpM)••••");
echo    ("•• Surface(multiple,help=helpM)••••");
echo    ("•• [58] Box(x=8,y=8,z=5,d2=0,c=3.5,s=1.5,eck=4,fnC=36,fnS=24)••••");
echo    ("•• [62] Spirale(grad=400,diff=2,radius=10,rand=n(2),detail=5,exp=1,hull=true)opt Object••••");
echo    ("•• [63] Area(a=10,aInnen=0,rInnen=0,h=0,n=$info)••••");
echo    ("•• [65] Sichel(start=55,max=270,dia=33,radius=30,delta=-1,2D=false)••••");
echo    ("•• [66] Prisma(x1=12,y1=12,z=6,c1=5,s=1,x2=0,y2=0,x2d=0,y2d=0,c2=0,vC=[0,0,0],cRot=0,fnC=fn,fnS=36,n=$info)••••");
echo    ("•• Ccube(help=1)••••");
echo();

echo    ("•• [67] Disphenoid(h=15,l=25,b=20,r=1,ty=0,tz=0,fn=36)••••");
echo    ("•• Zylinder(help=1)••••");
echo    ("•• Welle(help=1) opt polygon••••");
echo    ("•• Anschluss(help=1) ••••");
echo    ("•• KreisSeg(help=1) ••••");

}
 if(!helpP)echo("<h4 style=background-color:#bbbbbb>••••• Produkt objects off — use» helpP=true; •••••");
 if(helpP){ // PRODUKT OBJEKTE

echo    ("<h3 style=background-color:#bbbbbb><font color='grey'><font size=5>•••••••••• Produkt Objekte:   ••••••••••</font></h3>");
echo    ("•• [400] Pivot(p0=[0,0,0],size=pivotSize,active=[1,1,1,1]) ••••");
echo    ("•• [401] Line(p0, p1, d=.5,center=false) ••••");
echo    ("•• [402] SCT(a=90) sin cos tan info ••••");
echo    ("•• [42] Gardena(l=10,d=10) ••••"); 
echo    ("•• [43] Servotraeger(SON=1) ••• Servo(r,narbe) ••••");
echo    ("•• [44] Knochen(l=+15,d=3,d2=5,b=0,fn=36)   ••••");
echo    ("•• [38] Glied(l=12,spiel=0.5,la=+1.5,fn=20) ••• [39][40]DGlied0/1(l1=12,l2=12,la=+1.5) ••••");   
echo    ("•• [41] Luer(male=1,lock=1,slip=1) ••••"); 
echo    ("•• [45] Bitaufnahme(l=10,star=true)••••");
echo    ("•• [48] Imprint(txt1=1,radius=20,abstand=7,rotz=-2,h=l(2),rotx=0,roty=0,stauchx=0,stauchy=0,txt0=›,txt2=‹,size=5,font=DejaVusans:style=bold)        ••••");
echo    ("•• [503] Achshalter(laenge=30,achse=+5,schraube=3,mutter=5.5,schraubenabstand=15,hoehe=8,fn=fn) ••••");

echo    ("•• [504] Achsenklammer(abst=10,achse=3.5,einschnitt=1,h=3,rand=n(2),achsenh=0,fn=72)••••");
echo    ("•• [56] Vorterantrotor(h=40,twist=360,scale=1,zahn=0,rU=10,achsloch=4,ripple=0,caps=2,caps2=0,capdia=6.5,capdia2=0,screw=1.40,screw2=1,screwrot=60,n=1)••••");
echo    ("•• [57] Tugel(dia=10,loch=5,scaleKugel=1,scaleTorus=1)••••");
echo    ("•• [59] ReuleauxIntersect(h=2,rU=5,2D=false) ••••••");
echo    ("•• [60] Glied3(x)  ••• [61] Gelenk(l,w) ••••••");
echo    ("•• [64] Balg(sizex=16,sizey=16,z=10.0,kerb=6.9,rand=-0.5)••••");
echo    ("•• [67] Tring(spiel=+0,angle=153,r=5.0,xd=+0.0,h=1.75,top=n(2.5),base=n(4),name=0)••••");
echo    ("•• [201] Servokopf(rot,spiel)Objekt  ••••");
echo    ("•• [202] Halbrund(h=15,d=3+2*spiel,x=1.0,n=1)Objekt mikroGetriebemotor Wellenaufnahme  ••••");
echo    ("•• [203] Riemenscheibe(e=40,radius=25,nockendurchmesser1=2,nockendurchmesser2=2,hoehe=8,name=$info)Objekt ••••");

echo    ("•• Cring(id=20,grad=230,h=15,rand=3,rad=1,end=1,txt=undef,tWeite=15,tSize=5,center=true,fn=fn,fn2=36)••••");
echo    ("\n
•• PCBcase(help=1);••••\n
•• Klammer(help=1);••••\n
•• Pin(help=1);••••\n
•• CyclGetriebe(help=1);••••\n
•• Buchtung(help=1);••••\n
•• SpiralCut(help=1);••••\n
•• SRing(help=1);••••\n
•• DRing(help=1);opt polygon••••\n
•• GewindeV4(help=1); ••••\n
•• BB(help=1); Ballbearing ••••\n
•• Abzweig(help=1) ••••\n
•• GT2Pulley(help=1) ••••\n
");
}

//  2D 

if(!help2D)echo("<h4 style=background-color:#bbbbbb>••••• help 2D off — use» help2D=true; •••••");
if (help2D){
echo    ("<h3 style=background-color:#aaaacc><font color='lightblue'size=5>•••••• 2D ••••••</font></h3>");
echo    ("•• [100] Trapez(h=2.5,x1=6,x2=3.0,d=1,x2d=0,fn=36,n=$info)••••");
echo    ("•• Tri(grad=60,l=20,h=0,r=0,messpunkt=0,center=+0,top=1,tang=1,fn=fn,n=$info,help=helpM)••••");
echo    ("•• Tri90(grad,a,b,c,help=1) ••••"); 
echo    ("•• Quad((x=20,y=20,r=3,grad=90,grad2=90,fn=36,center=true,centerX=false,n=false,messpunkt=false,help=helpM)••••");
echo    ("•• VorterantQ(size=20,ofs=.5)••••");
echo    ("•• Linse(dia=10,r=7.5,n=$info,messpunkt=true)••••");
echo    ("•• Bogendreieck(rU=5,vari=-1,fn=fn,n=$info) ••• Reuleaux(rU=5,n=$info,fn=fn)••••");
echo    ("•• Stern(e=5,r1=10,r2=5,mod=2,delta=+0,n=$info)••••");
echo    ("•• ZigZag(e=5,es=0,x=50,y=5,mod=2,delta=+0,base=2,center=true,n=$info,help=helpM)••••");
echo ("\n
    •• WStern(help=1);\n
•• Superellipse(help=1);\n
•• Flower(help=1);\n
•• Seg7(help=1);\n
•• WKreis(help=1);\n
•• RSternFill(help=1);\n 
•• Cycloid(help=1);\n
•• SQ(help=1);\n
•• Vollwelle(help=1);\n
•• CycloidZahn(help=1);\n
•• Nut(help=1);\n
•• DBogen(help=1);(opt polygon)\n 
•• Pfeil(help=1);\n
•• Rosette(help=1);\n
•• GT(help=1);
•• Egg(help=1);

"); 
}
//echo ("</p>");
}// end help
// SCHALTER
 if(version()[0]<2021)echo    (str("<h5 style=background-color:#c0bbdd><font color='darkviolet'size=4>Schalter• 
messpunkt=",messpunkt?"<font color='green'>On</font>":"<font color='red'>Off</font>",
" • vp=",vp?"<font color='green'>On</font>":"<font color='red'>Off</font>",
" • anima=",anima?"<font color='green'>On</font>":"<font color='red'>Off</font>",
" • texton=",texton?"<font color='green'>On</font>":"<font color='red'>Off</font>",
" • help=",help?"<font color='green'>On</font>":"<font color='red'>Off</font>",
" • $info=",$info?"<font color='green'>On</font>":"<font color='red'>Off</font>",
" •</font>"));
 else echo    (str("Schalter•\n 
messpunkt=",messpunkt?"🟢✔":"❌",
" • vp=",vp?"🟢✔":"❌",
" • anima=",anima?"🟢✔":"❌",
//" • texton=",texton?"🟢✔":"❌",
" • help=",help?"🟢✔":"❌",
" • $info=",$info?"🟢✔":"❌",
" •"));

if(anima)echo(str("\n Zeit t0:",t0,
    "\nZeit t1:",t1,"\nZeit t2:",t2,"\n
Zeit t3:",t3(),"\n
••••  anima on! tset=",tset," t=0⇒1 || t0=0⇒360 || t1=-1⇔1 || t2=0⇔1 || t3(wert=1,grad=360,delta=0)  •••••"));    
    
if (vp)echo (str(version()[0]<2021?"\n<p style=background-color:#bbbbee;><font size=5 color=#555599>":"","\n\tViewportcontrol vpr: ",$vpr,"\n\t
Viewportcontrol vpt: ",$vpt,"\n\t
Viewportcontrol vpd: ",$vpd,"\n\t
Viewportcontrol vpf: ",$vpf,"\n\t
••••  vp=on  •••••"));
if(!$preview&&version()[0]<2021) echo("<H1 style=background-color:#aaffcc;color:#7766aa;>\nRendering…wait!");   

//////////////////////////// Modules  /////////////////////////////

module Example(variable=1,name=$info,help=$helpM){
 
    if(variable==1)cube(10);
    else if (variable==2)sphere(10);
    
 InfoTxt("Example",["variable",variable,"display",variable?variable==1?"cube":
                                                                "sphere":
                                                    "none"],name);
 HelpTxt("Example",["variable",variable,"name",name],help);   
}


/// Tools / Modificator ///

// short for translate[];
module T(x=0,y=0,z=0,help=$helpM)
{
    //translate([x,y,z])children();
if(is_list(x))
    multmatrix(m=[
    [1,0,0,x[0]],
    [0,1,0,x[1]],    
    [0,0,1,x[2]],
    [0,0,0,1]    
    ])children(); 
else
    multmatrix(m=[
    [1,0,0,x],
    [0,1,0,y],    
    [0,0,1,z],
    [0,0,0,1]    
    ])children(); 


    MO(!$children);
    HelpTxt("T",["x",x,"y",y,"z",z],help);
}

// short for T(z=0);
module Tz(z=0,help=$helpM){
    multmatrix([
        [1,0,0,0],
        [0,1,0,0],    
        [0,0,1,z],
        [0,0,0,1],    
        ])children();    
    MO(!$children);
    HelpTxt("Tz",["z",z],help);
}

// short for rotate(a,v=[0,0,0])
module R(x=0,y=0,z=0,help=$helpM)
{
    rotate([x,y,z])children();
    MO(!$children);
    HelpTxt("R",["x",x,"y",y,"z",z],help);
}


// short for multmatrix and skewing objects
module M(skewzx=0,skewzy=0,skewxz=0,skewxy=0,skewyz=0,skewyx=+0,scale=1,scalexy=1,scalexz=1,scaleyz=1,help=$helpM){
    scalex=scale*scalexy*scalexz;
    scaley=scale*scalexy*scaleyz;
    scalez=scale*scalexz*scaleyz;    
    multmatrix([
    [scalex,skewyx,skewzx,0],
    [skewxy,scaley,skewzy,0],    
    [skewxz,skewyz,scalez,0],
    [0,0,0,1.0],    
    ])children(); 
    MO(!$children);
    HelpTxt("M",["skewzx",skewzx,"skewzy",skewzy,"skewxz",skewxz,"skewxy",skewxy,"skewyz",skewyz,"skewyx",skewyx,"scale",scale,"scalexy",scalexy,"scalexz",scalexz,"scaleyz",scaleyz],help);
}



// multiply children polar (e=number, x/y=radial distance)
module Polar(e=3,x=0,y=0,r=0,re=0,end=360,dr=0,mitte=false,name=$info,n,help=$helpM){
    
   name=is_undef(n)?name:n;
   radius=Hypotenuse(x,y);
   end=end==0?360:end;
   winkel=abs(end)==360?360/e:end/max(1,e-1);
   if(e>+0) rotate(r)for(i=[0:e-1]){
        $idx=i;
        $info=$idx?false:name;
        $helpM=$idx?false:$helpM;
        rotate(e==1&&end<360?winkel/2:i*winkel)translate([x,y,0])rotate([0,0, re+(i*winkel)/end*dr])children();
    }
     if(mitte){
         $idx=e;
         children(); 
     }
 
    InfoTxt("Polar",["elements",str(e,
     //"transX= ",x," transY= ",y,
    "Radius",radius,"mm ",re?str("rotElements=",re,"°"):"",end!=360?str(" End=",end,"°"):""," Element=",winkel,"° Abstand=",2*radius*PI/360*winkel,"mm (Sekante=",2*radius*sin(winkel/2),")")],name);
    HelpTxt("Polar",["e",e,"x",x,"y",y,"r",r,"re",re,"end",end,"dr",dr,"mitte",mitte,"name",name],help);
MO(!$children);
           
     
}



// multiply children linear (e=number, es=distance)
module Linear(e=2,es=1,s=0,x=1,y=0,z=0,r=0,re=0,center=0,cx=0,cy=0,cz=0,name=$info,n,help=$helpM)// ordnet das Element 20× im Abstand x Linear an.. es skaliert die vektoren . cx = center x
{
name=is_undef(n)?name:n;   
$helpM=0;    
s=es==1?s:0;

    cx=center?1:cx;
    cy=center?1:cy;  
    cz=center?1:cz;
if(s!=0&&e>0){if(e>1)translate([cx?-x*es/2*s:0,cy?-y*es/2*s:0,cz?-z*es/2*s:0])for(i=[0:e-1])//for (i=[+0:s/(e-1):s+.00001])
         {
            $idx=i;
            $info=$idx?false:name; 
            rotate([0,0, r])translate([i*x*es*(s/(e-1)),i*y*es*(s/(e-1)),i*z*es*(s/(e-1))])rotate([0,0, re])children();
                
             
         }
      else rotate([0,0, re])children();
      }   
if(s==0&&e>0)for (i=[0:e-1])
         {
            $idx=i;
            $info=$idx?false:name;
            rotate([0,0, r])translate(center?[(e-1)*es*x,(e-1)*es*y,(e-1)*es*z]/-2:[0,0,0])translate([i*es*x,i*es*y,i*es*z])rotate([0,0, re])children();
          
         }        
        
MO(!$children);

InfoTxt("Linear",["länge",str((s?s:e*es)*norm([x,y,z]),"mm")],name);    
HelpTxt("Linear",["e",e,"es",es,"s",s,"x",x,"y",y,"z",z,"r",r,"re",re,"center",center,"cx",cx,"cy",cy,"cz",cz,"name",name],help);       
        
}


//Clone and mirror object
module MKlon(tx=0,ty=0,tz=0,rx=0,ry=0,rz=0,mx,my,mz,help=$helpM)
{
    mx=is_undef(mx)?sign(abs(tx)):mx;
    my=is_undef(my)?sign(abs(ty)):my;
    mz=is_undef(mz)?sign(abs(tz)):mz;
    
	translate([tx,ty,tz])rotate([rx,ry,rz])children();
    $idx=0; 
    union(){
        $helpM=0;
        $info=0; 
        $idx=1; 
	translate([-tx,-ty,-tz])rotate([-rx,-ry,-rz])mirror([mx,my,mz]) children(); }   
    MO(!$children);
    HelpTxt("MKlon",["tx",tx,"ty",ty,"tz",tz,"rx",rx,"ry",ry,"rz",rz,"mx",mx,"my",my,"mz",mz],help);

}

// Clone and mirror (replaced by MKlon)
module Mklon(tx=0,ty=0,tz=0,rx=0,ry=0,rz=0,mx=0,my=0,mz=1)
{
    mx=tx?1:mx;
    my=ty?1:my;
    mz=tz?1:mz;
	translate([tx,ty,tz])rotate([rx,ry,rz])children(); 
    union(){
        $helpM=0;
        $info=0;  
	translate([-tx,-ty,-tz])rotate([-rx,-ry,-rz])mirror([mx,my,mz]) children(); }   
   MO(!$children);
}

// Clone Object
module Klon(tx=0,ty=0,tz=0,rx=0,ry=0,rz=0,help=$helpM){
    union(){
        $idx=0;
        translate([tx,ty,tz])rotate([rx,ry,rz])children();
    }
    union(){
         $idx=1;
        $helpM=0;
        $info=0;  
    translate([-tx,-ty,-tz])rotate([-rx,-ry,-rz])children();  
    }   
    MO(!$children); 
    HelpTxt("Klon",["tx",tx,"ty",ty,"tz",tz,"rx",rx,"ry",ry,"rz",rz],help);   
}


// Cuts away half of Object at [0,0,0]
module Halb(i=0,x=0,y=0,z=0,2D=0,size=view)
{
    if(!2D){
       if(i)difference()
       {
           children();
         R(x?90:0,y?90:0)  cylinder(size,d=size,$fn=6);
          
       }
      if(!i) intersection()
      {
          children();
          R(x?90:0,y?90:0)  cylinder(size,d=size,$fn=6);
      }
  }
  if(2D){
      if(i)difference()
      {
          children();
           T(y?-size/2:0,x?-size/2:0) square(size);
      }
      if(!i) intersection()
      {
          children();
          T(y?-size/2:0,x?-size/2:0) square(size);
      }
  } 
 MO(!$children); 
}



//short for rotate_extrude(angle,convexity=5) with options
module RotEx(grad=360,fn=fn,center=false,cut=false,convexity=5,help=$helpM){
    rotate(center?-grad/2:0) rotate_extrude(angle=grad,convexity=convexity, $fa = abs(grad/fn), $fs = 0.025,$fn=0)intersection(){
           children();
           if(cut)translate([cut==-1?-1000:0,-500])square(1000);
    }

    MO(!$children);   
    if(help)echo(str("<H3><font color='",helpMColor,"' <b>Help RotEx(grad=",grad,",fn=",fn,",center=",center,",cut=",cut,", convexity=",convexity,",help=$helpM);"));   
}

// multiply children in a given matrix (e= number es =distance)
module Grid(e=[2,2,1],es=10,s,center=true,name=$info,help=$helpM){
    function n0(e)=is_undef(e)?1:max(e,1);
    function n0s(e)=max(e-1,1);// e-1 must not be 0
    
    e=is_list(e)?is_num(e[2])?[max(e[0],1),max(e[1],1),n0(e[2])]:
                    concat(e,[1]):
        es[2]?[n0(e),n0(e),n0(e)]:
        [n0(e),n0(e),1];
    
    es=is_undef(s)?is_list(es)?is_num(es[2])?es:
                                concat(es,[0]):
                    is_undef(es)?[0:0:0]:
                        [es,es,es]:
       is_list(s)?is_num(s[2])?[s[0]/n0s(e[0]),s[1]/n0s(e[1]),s[2]/n0s(e[2])]:
                    [s[0]/n0s(e[0]),s[1]/n0s(e[1]),0]:
        [s/n0s(e[0]),s/n0s(e[1]),s/n0s(e[2])];
        
   MO(!$children);
   InfoTxt("Grid",[str("Gridsize(",e,")"),str(e[0]*e[1]*e[2]," elements ",(e[0]-1)*es[0],"×",(e[1]-1)*es[1],"×",(e[2]-1)*es[2],"mm",  center?str(-(e[0]-1)*es[0]/2," ↦",(e[0]-1)*es[0]/2,"",-(e[1]-1)*es[1]/2," ↦",(e[1]-1)*es[1]/2,"×",-(e[2]-1)*es[2]/2," ↦",(e[2]-1)*es[2]/2,"mm"):"")],name);  
       
    HelpTxt("Grid",[
    "e",e
    ,"es",es
    ,"s",[(e[0]-1)*es[0],(e[1]-1)*es[1],(e[2]-1)*es[2]]
    ,"center",center
    ,"name",name]
    ,help);

   translate(center?[((1-e[0])*es[0])/2,((1-e[1])*es[1])/2,((1-e[2])*es[2])/2]:[0,0,0]) for(x=[0:e[0]-1],y=[0:e[1]-1],z=[0:e[2]-1]){
       $idx=[x,y,z];
       $info=norm($idx)?false:name;
       $helpM=norm($idx)?false:$helpM;
       T(x*es[0],y*es[1],z*es[2])children();
   }
}

// Grid but with alternating row offset - hex or circle packing
module HexGrid(e=[11,4],es=5,center=true){
    Grid(e=e,es=is_list(es)?es:[es*sin(60),es],center=center)translate([0,$idx[0]%2?is_list(es)?es[1]/2:es/2:0])children();
    MO(!$children);
}










/// Helper /// (not for creating geometry or objects)


// Cutaway children for preview
module Schnitt(on=$preview,r=0,x=0,y=0,z=-0.01,rx=0,ry=0,sizex=500,sizey=500,sizez=500,center=0)
{
    center=is_bool(center)?center?1:0:center;
    if($children)difference()
    {
        children();
      if((on&&$preview)||on==2)  translate([x,y,z])rotate([rx,ry,r])color([1,0,0,1])translate([center>0?-sizex/2:0,abs(center)==1?-sizey/2:-sizey,center>1||center<0?-sizez/2:0])cube([sizex,sizey,sizez],center=false);
    }
  if (on==2&&!$preview)
      {
         Echo("   »»»»»»»»»»»»»»––SCHNITT in render! ––««««««««««««««« ",color="warning");
        // echo(" «««««««««««««««««««––SCHNITT––»»»»»»»»»»»»»»»»»»»»»»»»»»»» "); 
        // echo("   »»»»»»»»»»»»»»»»»»––SCHNITT––««««««««««««««««««««««««««« ");
         echo();
      }
MO(!$children);     
}

// 3 axis Projection 

module 3Projection(s=10,cut=true,active=[1,1,1],help=$helpM){
    s=is_list(s)?s:[s,s];
    cut=is_list(cut)?cut:[cut,cut,cut];
    $info=false;
    $helpM=false;
   if(active.z) projection(cut=cut.z)children();
   if(active.x) translate([s.x,0,0])projection(cut=cut.x)rotate([0,90,0])children();
   if(active.y) translate([0,s.y,0])projection(cut=cut.y)rotate([-90,0,0])children();
    %children();
    MO(!$children);
    HelpTxt("3Projection",["s",s,"cut",cut,"active",active],help);
    
}


//Arranges (and color) list of children for display
module Anordnen(es=10,e,option=1,axis=1,c=0,r,cl=.5,rot=0,loop=true,center=true,inverse=false,name=$info,help=$helpM){
   
optiE= function(e=[0,0,1])
    let (sqC=sqrt($children))
    e.x*e.y==$children?
    e:
    e.x>4?optiE([e.x-1,e.y,1])://min 4 rows else alternate  to circumvent primes
    e.y>$children?[round(sqC),ceil($children/round(sqC)),1]:
    optiE([ceil(sqC),e.y+1,1]);
    
//echo(optiE());
    e=option==3?is_undef(e)?optiE():
                    is_list(e)?
                        e.z?e:
                        concat(e,1):
                    [ceil($children/e),e,1]:
       is_undef(e)?$children:e;

InfoTxt("Anordnung",["e",e,"children",$children],name);    
$info=false;

    
 if(option==1){
     r=is_undef(r)?(es/2)/sin(180/e):r;
     Polar(e,x=r,re=rot)if(is_undef(c)&&(loop?true:$idx<$children))
         children((inverse?$children-$idx-1:$idx)%$children);//
     else Color(c+1/$children*$idx,l=cl)
         if(loop?true:$idx<$children)children((inverse?$children-$idx-1:$idx)%$children);
     }
     
 if(option==2){
    if(axis==1) Linear(e=e,es=es,re=rot,center=center,x=1)
        if(is_undef(c))children($idx%$children);
            else Color(c+1/$children*$idx,l=cl)children($idx%$children);
    
    if(axis==2) Linear(e=e,es=es,re=rot,center=center,x=0,y=1)
        if(is_undef(c))children($idx%$children);
            else Color(c+1/$children*$idx,l=cl)children($idx%$children);
    if(axis==3) Linear(e=e,es=es,re=rot,center=center,x=0,z=1)
        if(is_undef(c))children($idx%$children);
            else Color(c+1/$children*$idx,l=cl)children($idx%$children);    
 }
 
 if(option==3) Grid(e=e,es=es,center=center){
     childINDX=inverse?(loop?e.x*e.y*e.z:$children -1)-($idx[0]+e.x*$idx[1]):($idx[0]+e.x*$idx[1]);
     rotate(rot)
     if(is_undef(c)&&(loop?true:$idx.x+e.x*$idx.y+e.x*e.y*$idx.z<$children))children(childINDX%$children);
     else Color(([$idx.x/(e.x -1),$idx.y/(e.y -1),$idx.z/e.z]+[ 0,0,cl])){
     if(loop?true:$idx.x+e.x*$idx.y+e.x*e.y*$idx.z<$children)children(childINDX%$children);
     //text(str([$idx.x/(e.x-1), $idx.y/(e.y-1), $idx.z/e.z]+[ 0,0,cl]),size=2);
 }
 }  

 
HelpTxt("Anordnung",["e",e,"es",es,"option",option,"axis",axis,"c",c,"r",r,"cl",cl,"rot=",rot,"loop",loop,"center",center,"inverse",inverse,"name",name],help);
}



co=[
["silver","lightgrey","darkgrey","grey","slategrey","red","orange","lime","cyan","lightblue","darkblue","purple",[.8,.8,.8,.3],[.8,.8,.8,.6],"cyan","magenta","yellow","black","white","red","green","blue",[0.77,0.75,0.72]],//std
["White","Yellow","Magenta","Red","Cyan","Lime","Blue","Gray","Silver","Olive","Purple","Maroon","Teal","Green","Navy","Black"],//VGA
["Gainsboro","LightGray","Silver","DarkGray","Gray","DimGray","LightSlateGray","SlateGray","DarkSlateGray","Black"],//grey
["Pink","LightPink","HotPink","DeepPink","PaleVioletRed","MediumVioletRed"],//pink
["LightSalmon","Salmon","DarkSalmon","LightCoral","IndianRed","Crimson","Firebrick","DarkRed","Red"],//red
["OrangeRed","Tomato","Coral","DarkOrange","Orange"],//orange
["Yellow","LightYellow","LemonChiffon","LightGoldenrodYellow","PapayaWhip","Moccasin","PeachPuff","PaleGoldenrod","Khaki","DarkKhaki","Gold"],//yellows
["Cornsilk","BlanchedAlmond","Bisque","NavajoWhite","Wheat","Burlywood","Tan","RosyBrown","SandyBrown","Goldenrod","DarkGoldenrod","Peru","Chocolate","SaddleBrown","Sienna","Brown","Maroon"],//browns
["DarkOliveGreen","Olive","OliveDrab","YellowGreen","LimeGreen","Lime","LawnGreen","Chartreuse","GreenYellow","SpringGreen","MediumSpringGreen","LightGreen","PaleGreen","DarkSeaGreen","MediumAquamarine","MediumSeaGreen","SeaGreen","ForestGreen","Green","DarkGreen"],//greens
["Cyan","LightCyan","PaleTurquoise","Aquamarine","Turquoise","MediumTurquoise","DarkTurquoise","LightSeaGreen","CadetBlue","DarkCyan","Teal"],//cyans
["LightSteelBlue","PowderBlue","LightBlue","SkyBlue","LightSkyBlue","DeepSkyBlue","DodgerBlue","CornflowerBlue","SteelBlue","RoyalBlue","Blue","MediumBlue","DarkBlue","Navy","MidnightBlue"],//blue
["Lavender","Thistle","Plum","Violet","Orchid","Magenta","MediumOrchid","MediumPurple","BlueViolet","DarkViolet","DarkOrchid","DarkMagenta","Purple","Indigo","DarkSlateBlue","SlateBlue","MediumSlateBlue"],//violetts
["White","Snow","Honeydew","MintCream","Azure","AliceBlue","GhostWhite","WhiteSmoke","Seashell","Beige","OldLace","FloralWhite","Ivory","AntiqueWhite","Linen","LavenderBlush","MistyRose"],//white
["Red","darkorange","Orange","Yellow","Greenyellow","lime","limegreen","turquoise","cyan","deepskyblue","dodgerblue","Blue","Purple","magenta"],//rainbow
["magenta","Purple","Blue","dodgerblue","deepskyblue","cyan","turquoise","limegreen","lime","Greenyellow","Yellow","Orange","darkorange","Red","darkorange","Orange","Yellow","Greenyellow","lime","limegreen","turquoise","cyan","deepskyblue","dodgerblue","Blue","Purple"]//rainbow2
];

// color by color lists
module Col(no=0,alpha=1,pal=0,n=0)
{
   palette=["std","VGA","grey","pink","red","orange","yellow","brown","green","cyan","blue","violett","white","rainbow"]; 
    


    for(i=[0:1:$children-1]){
    $idx=i;
    color(co[pal][(no+i)%len(co[pal])],alpha)children(i);
    if(n)echo(str("<font color=",co[pal][(no+i)%len(co[pal])]," size=5> ███  <font color=black>Color children ($idx) ",i," »»» ",no+i,"/",co[pal][(no+i)%len(co[pal])]," von ",len(co[pal])-1," — Palette ",pal,"/",palette[pal],(no+i>len(co[pal])-1)?" —<font color=red> Out of Range":"","</font>"));
    }
    MO(!$children);
}


// object color with hue (and rgb) also color change for multiple children
module Color(hue=0,alpha=1,v=1,l=0.5,spread=1,name=0,help=$helpM){
    
    function val(delta=0,hue=-hue*360,v=v,l=l*-2+1)=
        v*max(
            min(
                (0.5+sin((hue+delta)))*(l>0?1-l:1)
                +(max(
                    .5+sin((180+hue+delta))
                ,0)*(l<=0?-l:0))
            ,1)
        ,0);
       
       start=90;// to start with red
        
     if($children) for(i=[0:$children-1]){//
            $idx=is_undef($idx)?i:$idx;
            c=is_string(hue)?hue:is_list(hue)?[(hue[0]+i*(1-hue[0]%1.001)/(spread*$children))%1.001,(hue[1]+i*(1-hue[1]%1.001)/(spread*$children))%1.001,(hue[2]+i*(1-hue[2]%1.001)/(spread*$children))%1.001]:[val(start,hue=(-hue-i/(spread*$children))*360),val(+start+120,hue=(-hue-i/(spread*$children))*360),val(start+240,hue=(-hue-i/(spread*$children))*360)];
            color(c,alpha)children(i); 
            
        if(name)  echo(str("Color ",name," child ($idx) ",i," hex=",Hexstring(c)," ",Hex(alpha*255)," <font color=",Hexstring(c),"> ████ </font>RGB=",c));      
        }
        else MO(!$children);

    HelpTxt("Color",[
    "hue",hue,"alpha",alpha,"v",v,"l",l,"spread",spread,"name",name,
        ],help);
}

/// Echo Helper /// console texts

// missing object text
module MO(condition=true,warn=false){
Echo(str(parent_module(2)," has no children!"),color=warn?"warning":"red",condition=condition&&$parent_modules>1,help=false);    
}


// echo color differtiations
module Echo(title,color="#FF0000",size=2,condition=true,help=$helpM){
    
 if(condition)
     if(version()[0]<2021)echo(str("<H",size,"><font color=",color,">",title)); 
     else if (color=="#FF0000"||color=="red")echo(str("\n⭕\t»»» ",title));
     else if (color=="#FFA500"||color=="orange")echo(str("\n🟠\t»»» ",title));    
     else if (color=="#00FF00"||color=="green")echo(str("🟢\t ",title));
     else if (color=="#0000FF"||color=="blue") echo(str("🔵\t ",title));
     else if (color=="#FF00FF"||color=="purple") echo(str("🟣\t ",title));    
     else if (color=="#000000"||color=="black") echo(str("⬤\t ",title));
     else if (color=="#FFFFFF"||color=="white") echo(str("◯\t ",title));
     else if (color=="#FFFF00"||color=="yellow"||color=="warning") echo(str("⚠\t ",title));    
         else echo(str("• ",title)); 
 HelpTxt("Echo",["title",title,"color",color,"size",size,"condition",condition],help);
}

/// display variable values
module InfoTxt(name,string,info=$info,help=$helpM){
  //  https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/User-Defined_Functions_and_Modules#Function_Literals
 joinArray= function(in,out="",pos=0) pos>=len(in)?out: // scad version > 2021
        joinArray(in=in,out=str(out,in[pos]),pos=pos +1);   
    
 if(version()[0]<2021){   
  infoText=[for(i=[0:2:len(string)-1])str(string[i],"=",is_num(string[i+1])?negRed(string[i+1]):string[i+1],i<len(string)-2?", ":"")];
      
if(info)if(is_list(string))echo( 
 str(is_bool(info)?"":"<b>",info," ",name," ", 
infoText[0]
,infoText[1]?infoText[1]:""
,infoText[2]?infoText[2]:""
,infoText[3]?infoText[3]:""
,infoText[4]?infoText[4]:""
,infoText[5]?infoText[5]:""
,infoText[6]?infoText[6]:""
,infoText[7]?infoText[7]:""
,infoText[8]?infoText[8]:""
,infoText[9]?infoText[9]:""
));
else HelpTxt(titel="InfoTxt",string=["name",name,"string","[text,variable]","info",$info],help=1);
}
else {
  infoText=[for(i=[0:2:len(string)-1])str(string[i],"=",string[i+1],i<len(string)-2?", ":"")];
      
if(info)if(is_list(string))echo( 
 str(is_bool(info)?"":"🟩\t•• ",info," ",name," ",
joinArray(infoText)));

else HelpTxt(titel="InfoTxt",string=["name",name,"string","[text,variable]","info",$info],help=1);
}
}

// display the module variables in a copyable format
module HelpTxt(titel,string,help=$helpM){ 
   joinArray= function(in,out="",pos=0) pos>=len(in)?out:
        joinArray(in=in,out=str(out,in[pos]),pos=pos +1); 

helpText=[for(i=[0:2:len(string)-1])str(string[i],"=",string[i+1],",\n  ")];
 if(version()[0]<2021){ 
if(help)if(is_list(string))echo(
    
str("<H3> <font color=",helpMColor,"> Help ",titel, "(",
    helpText[0]
,helpText[1]?helpText[1]:""
,helpText[2]?helpText[2]:""
,helpText[3]?helpText[3]:""
,helpText[4]?helpText[4]:""
,helpText[5]?helpText[5]:""
,helpText[6]?helpText[6]:""
,helpText[7]?helpText[7]:""
,helpText[8]?helpText[8]:""
,helpText[9]?helpText[9]:""
,helpText[10]?helpText[10]:""
,helpText[11]?helpText[11]:""
,helpText[12]?helpText[12]:""
,helpText[13]?helpText[13]:""
,helpText[14]?helpText[14]:""
,helpText[15]?helpText[15]:""
,helpText[16]?helpText[16]:""
,helpText[17]?helpText[17]:""
,helpText[18]?helpText[18]:""
,helpText[19]?helpText[19]:""
,helpText[20]?helpText[20]:"" 
,helpText[21]?helpText[21]:""
,helpText[22]?helpText[22]:""
,helpText[23]?helpText[23]:""
,helpText[24]?helpText[24]:""
,helpText[25]?helpText[25]:""
,helpText[26]?helpText[26]:""
,helpText[27]?helpText[27]:""
,helpText[28]?helpText[28]:""
,helpText[29]?helpText[29]:""


//," name=",name,
," help=$helpM);"));  
else HelpTxt("Help",["titel",titel,"string",["string","data","help",help],"help",help],help=1);
} else{
if(help)if(is_list(string))echo(
    
str("🟪\nHelp ",titel, "(\n  ",
joinArray(helpText)
," help=$helpM\n);\n"));    
else HelpTxt("Help",["titel",titel,"string",string,"help",help],help=1);
}
}




/// Basic Objects ///


module GT2Pulley(
h=6,// Belt h
z=16,// teeth
achse=6.6,//hole
center=true,
name=$info,
help=$helpM){
d=2*z/PI+(0.63-0.254)*2+0.2;
    

center=is_bool(center)?center?1:0:center;
T(center?center<0?[0,0,h/2+1.1]:
            [0,0,0]:
        [z/PI,z/PI,h/2]){
if($info)%Ring(h,d=2*z/PI,rand=-.63,center=true);            
$info=false;            
LinEx(h+1,center=true)GT(z=z,achse=achse);
difference(){
    
MKlon(tz=-h/2-1.1){
Pille(.5,d=d,rad2=0,center=false);//cylinder(.5,d=12);
Tz(.5)Kegel(d1=d,d2=d-2.5,grad=25);
}
cylinder(50,d=achse,center=true);
MKlon(tz=-h/2-1.3)Kegel(achse+0.75);
}
//%Ring(h,d=d,rand=1.38,center=true);

}

InfoTxt("GT2Pulley",["aussenH",h+2.2,"d",d,"radius Riemenmitte",z/PI],name);
HelpTxt("GT2Pulley",["h",h,"z",z,"achse",achse,"center",center,"name",name],help);
}

module KreisSeg(
grad=90,
size=4,
h,
rad=1.0,
r=10,
spiel=.5,
name=$info,
help=$helpM
){
  HelpTxt("KreisSeg",["grad",grad,"size",size,"h",h,"rad",rad,"r",r,"spiel",spiel,"name",name],help);  
  $info=name;  
    rad2=rad+spiel;//spiel

h=is_undef(h)?size:h;

difference(){
Torus(grad=grad,end=+0,trx=r,d=size)Quad(size,h,r=rad);
   difference(){
       linear_extrude(h+5,center=true)polygon([
       [0,0],
       [r-size/2+rad,rad2],
       [r+size/2-rad,rad2],
       [r+size/2+5,rad2 +sin(asin(rad2/(r+size/2-rad)))*(rad+5)],
       [r+size/2+5,-rad],
       ]);
       
    hull(){
       rotate(asin(rad2/(r+size/2-rad))) T(r+size/2-rad)MKlon(tz=h/2-rad)sphere(rad);
       rotate(asin(rad2/(r-size/2+rad))) T(r-size/2+rad)MKlon(tz=h/2-rad)sphere(rad); 
    }
   }
   
   difference(){
    rotate(grad)linear_extrude(h+5,center=true)polygon([
       [0,0],
       [r-size/2+rad,-rad2],
       [r+size/2-rad,-rad2],
       [r+size/2+5,-rad2 -sin(asin(rad2/(r+size/2-rad)))*(rad+5)],
       [r+size/2+5,+rad],
       ]);       
       
    hull(){
       rotate(grad-asin(rad2/(r+size/2-rad))) T(r+size/2-rad)MKlon(tz=h/2-rad)sphere(rad);
       rotate(grad-asin(rad2/(r-size/2+rad))) T(r-size/2+rad)MKlon(tz=h/2-rad)sphere(rad); 
    }
   }   
  
}  
}


module Abzweig(r1=5,r2=20,rad=2,inside=false,spiel=spiel,help=$helpM){
function h(i)=Kathete(r2+rad,cos(i*360/fn)*(r1+rad))-rad; 
function hIn(i)=Kathete(r2+rad,cos(i*360/fn)*(r1+rad*1.50))+rad;     
sc=(r1+rad-rad*sin(asin((r1+rad)/(r2+rad))))/(r1+rad); 
    
intersection(){
    difference(){
        if(!inside)cylinder(r2+rad,r=r1+rad);
        if(inside)scale([1+(1-sc),1])Tz(-r2*2+rad*2)cylinder(r2+rad,r=r1+rad);
        cylinder((r2+rad)*3,r=r1-spiel,center=true);
        if(!inside)R(90)cylinder((r1+rad)*3,r=r2-spiel,center=true,$fa=+1,$fn=undef);   
        Tz(inside?rad*3:rad)for(i=[0:fn]){
         step=360/fn;  
            hull(){
              Tz(inside?-hIn(i):h(i))rotate(i*step)T(r1+rad,z=-rad)Pille(l=.1+r2+(inside?rad*3:rad)-h(i),r=rad,rad=rad,rad2=0,center=false,name=false);  
              Tz(inside?-hIn(i+1):h(i+1))rotate((i+1)*step)T(r1+rad,z=-rad)Pille(l=.1+r2+(inside?rad*3:rad)-h(i+1),r=rad,rad=rad,rad2=0,center=false,name=false);  
            }
   /*hull(){  hull(){
                    Tz(inside?-hIn(i):h(i))rotate(i*step)T(r1+rad)R(90)sphere(r=rad);
                    Tz((inside?-1:1)*r2)rotate(i*step)T(r1+rad)R(90)cylinder(.5,r1=rad,r2=0);
                }
                hull(){
                    Tz(inside?-hIn(i+1):h(i+1))rotate((i+1)*step)T(r1+rad)R(90)sphere(rad);//cylinder(.5,r1=rad,r2=0);
                    Tz((inside?-1:1)*r2)rotate((i+1)*step)T(r1+rad)R(90)cylinder(.5,r1=rad,r2=0);
                }
        }   // end hull */
        }
    }
if(!inside)scale([sc,1.00])cylinder(500,r=r1+rad,center=true);
if(inside)R(90) cylinder(500,r=r2+spiel,center=true);  
}

HelpTxt("Abzweig",["r1",r1,"r2",r2,"rad",rad,"inside",inside,"spiel",spiel],help);
}

module HypKehleD(grad=40,steps=15,l=10,l2,l3,d=3,d3=2.5){
    l3=is_undef(l3)?l:l3;
    l2=is_undef(l2)?l:l2;
    HypKehle(grad=90-grad,l=l2,l2=l3,steps=steps,d1=d,d2=d3);
    R(0,180)HypKehle(grad=90+grad,l=l,l2=l3,d1=d,d2=d3,steps=steps);
}


module HypKehle(l=15,grad=90,d1=3,d2,l2,steps=10,fn=24,fill=true,name=$info,help=$helpM){
    d2=is_undef(d2)?d1:d2;
    l2=is_undef(l2)?l:l2;
    $info=false;
for(i=[0:steps]){
  hull(){
      Tz(i*l/steps)R(-grad+grad/steps*i+180){
         if($children)linear_extrude(.1,scale=0)children(0);
            else cylinder(.1,d1=d1,d2=0,$fn=fn);
      }
      if(fill)R(45)sphere(d=is_num(fill)?fill:max(d1,d2),$fn=fn);
      R(grad) Tz(l2-i*l2/steps)R(grad/steps*i+180)
      if($children)linear_extrude(.1,scale=0)children($children>1?1:0);
      else cylinder(.1,d1=d2,d2=0,$fn=fn);
  }
}
HelpTxt("HypKehle",["l",l,"grad",grad,"d1",d1,"d2",d2,"l2",l2,"steps",steps,"fn",fn,"fill",fill,"name",name],help);
}




module BB(
r=10,
ball=5,
rand=1,
e,
spiel=0.125,
support=0.15,
h,
top,
cage=false,
cyl=true,
achse,
od,
rad=[.75,.75],
center=true,
name=$info,
help=$helpM    
){
$info=false;
$helpM=false;    
rand=is_list(rand)?rand:[rand,rand]; 
top=is_undef(top)?rand[0]/2:top;   
h=is_undef(h)?ball+top*2:h;
    
if(achse&&achse>r*2-ball-2*rand[1]-2*spiel)Echo("BB Achse zu groß - limited",color="red"); 
if(od&&od<r*2+ball+2*rand[0]+2*spiel)Echo("BB OD zu klein - limited",color="red");
if(h<ball) Echo("BB h kleiner Kugel",color="red");
if(h>ball+top*2) Echo("BB Kugel = Walze!",color="green");    
achseDia=is_undef(achse)?r*2-ball-2*rand[1]-2*spiel:min(r*2-ball-2*rand[1]-2*spiel,achse);
oDia=is_undef(od)? r*2+ball+2*rand[0]+2*spiel:max(od,r*2+ball+2*rand[0]+2*spiel);  
e=is_undef(e)?floor(360/gradS(r=r,s=ball+spiel)):min(e,floor(360/gradS(r=r,s=ball+spiel)));    


  InfoTxt("BB",["Achse",achseDia,"Hoch",h,"OD",oDia,"Kugel∅",h>ball+top*2?str(ball,"×",h-top*2):ball,"Anzahl",e],name); 
 Tz(center?0:h/2){   
    Polar(e,r)if(h>ball+top*2)Pille(h-top*2,d=ball);else sphere(d=ball);
    difference(){
        union(){
            Pille(h,d=oDia,rad=rad[0]);//Body
            Tz(center?0:-h/2)children();
        }
      if(achseDia) Strebe(h,d=achseDia,rad=rad[1],center=true);// Achse    
        
        if(h>ball+top*2)Torus(trx=r,d=ball+spiel*2)MKlon(mx=1)Pille(h-top*2+spiel*2,d=$d,2D=+1);
            else Torus(trx=r,d=ball+spiel*2);//Rille
        Mklon(tz=h/2+1.25)Torus(trx=r,d=ball,fn2=6);//innenfase
        Ring(h+1,d=r*2,rand=ball/2,rcenter=true,center=true);//Trennspalt
    }
    
 if (cage) difference(){
    union(){
        if(h>ball+top*2)Torus(trx=r,d=ball-spiel*2)MKlon(mx=1)Pille(h-top*2-spiel*2,d=$d,2D=+1);
            else Torus(trx=r,d=ball-spiel*2);
        Ring(h=h,d=r*2,rand=ball/2,rcenter=true,center=true);
    }
    Polar(e,r)if(h>ball+top*2)Pille(h-top*2+.6,d=ball+.6); else sphere(d=ball+.6);
    Tz(-h/2) Ring(h=top,d=r*2,rand=ball,rcenter=true,center=false);    
 }  

//supportbrim
 if(support&&!cyl)difference(){
     Tz(-h/2) Ring(h=top+.2,d=r*2,rand=ball/2-.5,rcenter=true,center=false);
     
     if (h>ball+top*2) Tz(-h/2+top+ball/2)Polar(e,r)sphere(r=ball/2+support);
         else Polar(e,r)sphere(r=ball/2+support);
 }
 if(cyl)Tz(-h/2){
     Polar(e,r)cylinder(h=h/2,d=ball/2-.5);
     if(support)Ring(l(2),r=r,rand=n(2),rcenter=true);
 }
 }
HelpTxt("BB",["r",r,"ball",ball,"rand",rand,"e",e,"spiel",spiel,"support",support,"h",h,"top",top,"cage",cage,"cyl",cyl,"achse",achse,"od",od,"rad",rad,"center",center,"name",name],help); 
}


module Egg(r1=10,r2=3,breit,grad,r3=true,fs=fs,name=$info,help=$helpM){
    
    breit=is_undef(breit)?r1:breit;
    x=r1-breit/2;
    r2=is_undef(grad)?r2:r1-(Hypotenuse(x,tan(grad)*x));
    a=r1-r2;
    grad=is_undef(grad)?acos(x/a):grad;
    hM=tan(grad)*x;
    
//    %Color(){
//    Kreis(r1,grad=grad,center=false,t=[0,-r1/2]);
//    Kreis(r2,grad=180-grad*2,center=true,t=[hM,0]);
//    Kreis(r1,grad=grad,center=false,rot=180-grad,t=[0,r1/2]);
//    if(r3)Kreis(grad=180,r1/2,rot=180); }
    

    
    points=concat(
        Kreis(r1,grad=grad,rot=-90,center=false,t=[x,0],rand=0,sek=true,fn=fs2fn(r1,grad,fs,5))
       ,Kreis(r2,grad=180-grad*2,rot=-90,center=true,t=[0,hM],rand=0,sek=true,fn=fs2fn(r2,180-grad*2,fs,5))//spitze
       ,Kreis(r1,grad=grad,center=false,rot=90-grad,t=[-x,0],rand=0,sek=true,fn=fs2fn(r1,grad,fs,5))
    );
    
    pointsR3=Kreis(grad=180,r=breit/2,rot=90,rand=0,sek=true,fn=fs2fn(breit/2,180,fs,10));  
        
    polygon(r3?concat(points,pointsR3):points);    

    //if(help)echo("Help Egg(r1=10,r2=3,grad,r3=1,name=$info,help=$helpM);");
    HelpTxt("Egg",["r1",r1,"r2",r2,"breit",breit,"grad",grad,"r3",r3,"fs",fs,"name",name],help);
    InfoTxt("Egg",["hM",hM,"h",str(hM+r2,r3?str("/",hM+r2+breit/2):""),"breit(r3×2)",breit,"grad",grad,"r1",r1,"r2",r2],name);
}



module GT(z=20,achse=3.5,spiel=.05,evolute=true,pulley=true,linear=true,fn=fn,name=$info,help=$helpM){
        fn=max(6,fn);
        p=2; // zahnabstand 
        PLD=0.254; //  ?Mittellinie? Pitch Line distance 
        r1=.15;//kehle basis zahn
        r2=1; // zahn flanken radius im abstand [b,i]
        r3=.555;// zahn spitzen radius
        b=0.4;// abstand mitte Mittelpunkt r2
        h=1.38; //gesamt h (i+ht)
        ht=0.75; // zahnhöhe
        i=.63;  // band dicke  
        breiteZahn=(r2-b)*2;
        umfang=z*p; 



module GT2(){  //GT2
   
   
  pointsGT2= concat(
        [[-p,ht],[-p,ht+i],[p,ht+i],[p,ht]]
            ,Kreis(r=r2,fn=fn/16,grad=22.5,center=false,t=[-b,ht],rot=90,rand=0,sek=true)
            ,Kreis(r=r3,grad=180-45,rot=90,fn=fn/4,t=[0,r3],rand=0,sek=true)            
            ,Kreis(r=r2,fn=fn/16,grad=22.5,center=false,t=[b,ht],rot=-90-22.5,rand=0,sek=true)
        );
   
    T(0,-ht)Rund(0,r1,fn=fn)
        polygon(pointsGT2);
    
//union(){
//%T(-p,ht)square([2*p,i]);
// }    
//    Color("lime")T(0,r3,-0.1)circle(r3,$fn=fn);
//    Color("green")T(0,ht,-.11)intersection(){
//            T(b)circle(r=r2,$fn=fn);
//            T(-b)circle(r=r2,$fn=fn);
//            square([2,0.85],true);
//        }
    //%Color("red")T(0,ht-r1)MKlon(0.736)circle(r1);
  
}
 
   
if(pulley){
    if(evolute){
        offset(-spiel)Rund(0.1,0,fn=fn){
            r=umfang/2/PI;
            difference(){
                circle(r,$fn=z*2);
                for(i=[0:z-1])rotate(i*360/z)
                for(i=[-20:20])rotate(-i)T(-umfang/360*i,r-PLD)GT2();
                if(achse)circle(d=achse-spiel*2,$fn=fn);
            }
            InfoTxt("GT2 Pulley evolute profile",["Dia",r*2-spiel*2-PLD*2,"z",z],name);
                //if(name)echo(str(is_bool(name)?"":"<b>",name," GT2 Pulley evolute profil Dia=",r*2-spiel*2-PLD*2," z=",z));
        }       
     }
    else{
        offset(-spiel)Rund(r1,0,fn=fn){
            r=umfang/2/PI-PLD;
            difference(){
                circle(r,$fn=z*2);
            for(i=[0:z-1])rotate(i*360/z)T(0,r)GT2();
            if(achse)  circle(d=achse-spiel*2,$fn=fn);
            }
            InfoTxt("GT2 Pulley",["Dia",r*2-spiel*2,"z",z],name);
            //echo(str(is_bool(name)?"":"<b>",name," GT2 Pulley Dia=",r*2-spiel*2,"z=",z));
        }
    }

 }
 else {
     $info=false;
     if (linear)Linear(e=z,es=2)GT2();
     else {
         r=umfang/2/PI;
         intersection(){
             Polar(e=z,y=r-PLD)GT2();
             circle(r+i-PLD,$fn=z*2);
         }
     }
     InfoTxt("GT2 Belt",concat(["Länge",z*p],linear?[]:["(aussen",str((umfang/2/PI+i-PLD)*2*PI,")")]),name);
    // echo(str(is_bool(name)?"":"<b>",name," GT2 Belt Länge=",z*p,linear?"":str("(aussen ",(umfang/2/PI+i-PLD)*2*PI,")")));
     
     } 
    
HelpTxt("GT",["z",z,
"achse",achse,
"spiel",spiel,
"evolute",evolute,
"pulley",pulley,
"linear",linear,
"fn",fn,
"name",name     
],help);

}



module Scale(v=[+1.5,+0.8,+0.8,0.6,0.7,1.3],//  scaling factors for quadrants [x-,x+,y-,y+,z-,z+]
2D=true,size=view/2,help=$helpM){
    
  makeV =function(v=v) [for(i=[0:5])is_undef(v[i])?1:v[i]]; 
 v=makeV();
 size=is_undef(size)?bed?printBed:100:size;   
    
if($children)if(2D){
    scale([v[1],v[3]])intersection(){
    children();
    rotate(0)square(size);
    }
    
    scale([v[0],v[3]])intersection(){
    children();
    rotate(90)square(size);
    }
    scale([v[0],v[2]])intersection(){
    children();
    rotate(180)square(size);
    }
    
    scale([v[1],v[2]])intersection(){
    children();
    rotate(-90)square(size);
    }
}else{
    
    scale([v[0],v[2],v[5]])intersection(){
    children();
    rotate(-180)cube(size);
    }  
    scale([v[0],v[3],v[5]])intersection(){
    children();
    rotate(+90)cube(size);
    }   
    scale([v[1],v[3],v[5]])intersection(){
    children();
    rotate(0)cube(size);
    }     
    scale([v[1],v[2],v[5]])intersection(){
    children();
    rotate(-90)cube(size);
    } 
    
    scale([v[0],v[2],v[4]])intersection(){
    children();
    rotate([-90,0,-180])cube(size);
    }  
    scale([v[0],v[3],v[4]])intersection(){
    children();
    rotate([-90,0,90])cube(size);
    }   
    scale([v[1],v[3],v[4]])intersection(){
    children();
    rotate([-90,0,0])cube(size);
    }     
  
    scale([v[1],v[2],v[4]])intersection(){
    children();
    rotate([-90,0,-90])cube(size);
    }       

}
HelpTxt("Scale",["v",v,
"2D",2D,"size",size],help);
MO(!$children);
}

module Rosette(
r1=10,
r2=15,
ratio=2,
wall=0.4,
fn=fn,
rotations,
name=$info,
help=$helpM
){
$info=0;
$helpf=0;
$messpunkt=0;
function rotations(ratio=ratio,n=1)=ratio==0?1:n/ratio%1?rotations(ratio,n+1):n/ratio;//ganzzahliger Wert
rotations=is_undef(rotations)?rotations():rotations;
points=abs(ratio)>1?abs(fn*ratio*rotations):abs(rotations*fn);    


for (i=[0:points-1]){ 
     $idx=i;
     hull(){
     rotate(i*360*rotations/points)translate([r1,0])rotate(i*360*rotations*ratio/points)translate([r2,0])if($children)children(0);else circle(d=wall,$fn=12);
     
     rotate((i+1)*360*rotations/points)translate([r1,0])rotate((i+1)*360*rotations*ratio/points)translate([r2,0])if($children)children($children>1?1:0);else circle(d=wall,$fn=12);
     }
 }
InfoTxt("Rosette",["Rotations",rotations,"Punkte",points],name); 
HelpTxt("Rosette",[ 
    "r1",r1,
    "r2",r2,
    "ratio",ratio,
    "wall",wall,
    "fn",fn,
    "rotations",rotations,
    "name",name
    ], help);
}



module Pfeil(l=[+2,+3.5],b=+2,shift=0,grad=60,d,center=true,name=$info,help=$helpM){
 shift=is_list(shift)?shift:[shift,-shift];
 l=is_list(l)?l:[l/2,l/2]; 
 b=is_list(b)?b:[b,2*(l[1]-shift[0])*tan(grad/2)];
 center=is_bool(center)?center?[1,1]:[0,0]:is_list(center)?center:[center,center];   
 points=[
     [l[1],0],//spitze
     [shift[0],b[1]/2],
     [0,b[0]/2],   
  if(!d)[-l[0],b[0]/2],//End oben
  if(!d)[-l[0]+shift[1],0],//End mitte
  if(!d)[-l[0],-b[0]/2],//End unten
     [0,-b[0]/2],   
     [shift[0],-b[1]/2],   
    ];   


if(d)translate(center.y?center.y<0?[0,d/2]:
                                [0,0]:
                [0,-d/2]){
    Kreis(d=d,rand=b[0],b=-l[0],center=false,rcenter=true); 
    
        translate([0,d/2])polygon(points);
//    intersection(){
//        square(50);
//        difference(){
//            sca=0.4;
//            T(+0)scale([1-sca,1])circle(r=d/2+b[1]/2);
//            T(+0)scale([1.1+sca,1])circle(r=d/2-b[1]/2);//+b[1]/2);
//        }
//        %circle(r=d/2);
//    }
}
 else translate([center.x?center.x>0?0:-l[1]:l[0],center.y?center.y>0?0:-b[1]/2:b[1]/2]) polygon(points);  
    
InfoTxt("Pfeil",["Winkel",2*atan((b[1]/2)/(l[1]-shift[0]))],name);    
HelpTxt("Pfeil",[   
    "l",l,
    "b",b,
    "shift",shift,
    "grad",grad,
    "d",d,
    "center",center,
    "name",name],help);
}



module Gewinde(
dn=6,
p=1,
kern,
breite,
rad1,
rad2,
winkel=60,
wand=+1,
mantel,
h,
gb,
innen=false,
grad=180*7,
start=fn/3,// Einfädelstrecke
end,
korrektur=true,// verbreiterung durch gangwinkel
profil=false,
fn2=4,
fn=fn,
cyl=true,
tz=0,
konisch=0,
center=true,
spiel=.15,
name=$info,
help=$helpM,

s,w=0,g=1,rot2=0,r1=0,detail=fn,name=$info,preset=0,translate=[0,0,0],rotate=[0,0,0],d=0,gd=0,r=0,help=$helpM,endMod=true,new
){
    
 iso_Gewinde=[ //name,pSteigung,dn
    
    ["M1",0.25,1],
    ["M1.2",0.25,1.2],    
    ["M1.6",0.35,1.5],
    ["M2",0.4,2],
    ["M2.5",0.45,2.5],    
    ["M3",0.5,3],
    ["M4",0.7,4],
    ["M5",0.8,5],
    ["M6",1,6],
    ["M7",1,7],
    ["M8",1.25,8],
    ["M9",1.25,9],
    ["M10",1.5,10],
    ["M12",1.75,12], 
    ["M14",2,14],      
    ["M16",2,16],    
    ["M20",2.5,20],     
    ["M24",3,24],     
    ["M30",3.5,30],     
] ;


other_Gewinde=[//search0, pSteigung,dn,winkel,name
["search","p-Steigung[1]","dn[2]","kern[3]","breite[4]","rad1[5]","rad2[6]","winkel[7]","name[8]"], // Spalten
[1,1.814,20.955,20.955-0.640327*1.814*2,undef,0.13732908*1.814,0.13732908*1.814,55,"½-Zoll"],//halb Zoll
[2,1.814,26.441,26.441-0.640327*1.814*2,undef,0.13732908*1.814,0.13732908*1.814,55,"¾-Zoll"],// 3/4 Zoll
["Flasche",3.18,27.43,24.95,.05,.4,.4,65,"PCO-28"],// Flasche 28mmHalsring
["Flasche2",4,27.43,24.95,.05,.4,.4,65,"PCO-28 P4"],// Flasche Badeschaum
];


 // Zeilennr für Suchbegriff [preset]   
 zeile=preset[0]=="M"?search([preset],iso_Gewinde)[0]:
        search([preset],other_Gewinde)[0];
  
    
   if(!(is_undef(useVersion)?0:useVersion>19.88)&&is_undef(new)||new==false){// old Version
       Echo("Using GewindeV2",color="warning");
       if($children)GewindeV2(dn=dn,s=s,w=w,g=g,winkel=winkel,rot2=rot2,r1=r1,kern=kern,fn=fn<20?fn:1,detail=detail,spiel=spiel,n=name,tz=tz,preset=preset,h=is_undef(h)?grad/360*p:h,translate=translate,rotate=rotate,d=d,gd=gd,r=r,center=center,help=help,p=p,endMod=endMod)children();
       else  GewindeV2(dn=dn,s=s,w=w,g=g,winkel=winkel,rot2=rot2,r1=r1,kern=kern,fn=fn<20?fn:1,detail=detail,spiel=spiel,n=name,tz=tz,preset=preset,h=is_undef(h)?grad/360*p:h,translate=translate,rotate=rotate,d=d,gd=gd,r=r,center=center,help=help,p=p,endMod=endMod);
    }
  else if(is_num(zeile)){ // presets
      
      //metric
    if(preset[0]=="M"){  GewindeV4(p=iso_Gewinde [zeile][1],dn=iso_Gewinde[zeile][2]+(innen?spiel*2:0),grad=grad,h=h,winkel=60,name=iso_Gewinde[zeile][0],innen=innen,wand=wand,cyl=cyl,tz=tz,start=start,end=end,fn=fn,fn2=fn2,center=center,spiel=spiel,profil=profil,help=help);
    if($children)difference(){
      children();
        if(innen)Tz(center?tz-iso_Gewinde[zeile][1]/2:
            tz)cylinder(is_undef(h)?(grad+360)*iso_Gewinde[zeile][1]/360:
                        h,d=iso_Gewinde[zeile][2]+(innen?spiel*2:
                                                      0));
    }
     // other
    }else if(preset){
        if(preset=="search")echo(zeile=zeile,Txt=other_Gewinde[zeile]);
        else {
            GewindeV4(p=other_Gewinde [zeile][1],
            dn=other_Gewinde[zeile][2]+(innen?spiel*2:0),
            kern=is_undef(other_Gewinde[zeile][3])?undef:other_Gewinde[zeile][3]+(innen?spiel*2:0),
            breite=is_undef(breite)?other_Gewinde [zeile][4]:breite,
            rad1=is_undef(rad1)?other_Gewinde [zeile][5]:rad1,
            rad2=is_undef(rad1)?other_Gewinde [zeile][6]:rad2,
            winkel=other_Gewinde [zeile][7],
            wand=wand,innen=innen,grad=grad,h=h,start=start,end=end,center=center,profil=profil,fn2=fn2,fn=fn,cyl=cyl,tz=tz,spiel=spiel,
            name=other_Gewinde[zeile][8],
            help=help);
            
        }
    }
    
  
    
  }
  
      else{Polar(g,name=0,r=innen?g%2?0:180/g:0)GewindeV4(p=p,
                dn=dn,
                kern=kern,
                breite=breite,
                rad1=rad1,
                rad2=rad2,
                winkel=winkel,
                wand=wand,
                mantel=mantel,
                h=h,
                gb=gb,
                innen=innen,
                grad=grad,
                start=start,// Einfädelstrecke
                end=end,
                korrektur=korrektur,// verbreiterung durch gangwinkel
                profil=profil,
                fn2=fn2,
                fn=fn,
                cyl=cyl,
                tz=tz,
                konisch=konisch,
                center=center,
                spiel=spiel,
                name=name,
                g=g,
                help=help); 
               Echo(str("Gewinde preset=",preset," Not found!"),color="red",condition=preset);
               if($children)difference(){
                  children();
                    if(innen)Tz(center?tz-p/2:tz-0)cylinder(is_undef(h)?grad*p/360+p:h,d=dn);
                }      
               
            }
    
}




module GewindeV4(
dn=6,
p=1,
kern,
breite,
rad1,
rad2,
winkel=60,
wand=+1,
mantel,
h,
gb,
innen=false,
grad=180*7,
start=fn/3,// Einfädelstrecke
end,
korrektur=true,// verbreiterung durch gangwinkel
profil=false,
fn2=4,
fn=fn,
cyl=true,
tz=0,
konisch=0,
center=true,
spiel=.1,//unused
g=1,// only for  autosize
name=$info,
help=$helpM
){
    winkel=90-winkel/2;
    gver=pow(g,1.5);//autocalc for g
    center=is_num(center)?center:center==true?1:0;
    start=round(start);
    end=is_undef(end)?start:round(end);
    rad1=is_undef(rad1)?p/20/g:rad1;
    rad2=is_undef(rad2)?p/10/g:rad2;
    breite=is_undef(breite)?max(p/8-sin(winkel)*rad1*2,0)/g:breite;
    kern=is_undef(kern)?innen?round((dn-p*1.08/gver)*100)/100:round((dn-p*1.225/gver*+1)*100)/100:kern;
    dn=is_undef(dn)?innen?round((kern+p*1.08/gver)*100)/100:round((kern+p*1.225/gver)*100)/100:dn;
    wand=is_undef(mantel)?innen?wand:wand>kern/2?0:wand:abs(mantel-kern)/2;
    d1=innen?-kern:dn;//Gewindespitzen
    d2=innen?-dn:kern;//Gewindetäler
    grad=is_undef(h)?grad-(grad%(360/fn)):(h-p)/p*360-(((h-p)/p*360)%(360/fn));//windungen
    mantel=is_undef(mantel)?innen?d2-wand*2:wand?kern-wand*2:kern/2+0.0001:innen?-max(mantel,0.0001):max(mantel,0.0001);//innenloch /aussenmantel
    winkelP=atan(p/((d1+d2)/2*PI));//Steigungswinkel
    profilkorrekturY=korrektur?1/sin(90+winkelP):1;
    gb=is_undef(gb)?p/profilkorrekturY:gb;
    gangH=(d1-d2)/2;
    h=grad*p/360+p;
    
    step=180/max(start,end,1);
    
InfoTxt(innen?" Innengewinde ":" Außengewinde ",[
"dn",dn,//"(",innen?d2:d1,")
 "Steigung",p,
 "Kern",kern,
 "Mantel",mantel,
 "Gangwinkel",winkelP,
 "h",h,
str(grad/360," Windungen ("),str(grad,"°)"),
"Ganghöhe",gangH]
,name);
    
Echo(str(name,"Gewinde breite=",breite," rad1(",rad1,")>p/16= ",p/16),condition=breite==0&&rad1>p/16);//,if (breite==0&&rad1>p/16)echo(str("<b><font color=red>",name," Gewinde breite=0 rad1>p/16= ",p/16));
HelpTxt("Gewinde",
["p",p
,"dn",dn
,"kern",kern
,"breite",breite
,"rad1",rad1
,"rad2",rad2
,"winkel",winkel
,"wand",wand
,"mantel",abs(mantel)
,"h",h
,"gb",gb // gang breite gesamt
,"innen",innen
,"grad",grad
,"start",start// Einfädelstrecke
,"end",end
,"korrektur",korrektur// verbreiterung durch gangwinkel
,"profil",profil // 2D Ansicht
,"fn2",fn2
,"fn",fn
,"cyl",cyl
,"tz",tz
,"konisch",konisch
,"center",center
,"spiel",spiel
,"name",name   
],help);

points=[
    for(i=[0:max(start+1,end+1,5)])vollwelle(fn=fn2,l=gb,h=start?gangH*(0.5+sin(i*step-90)/2):gangH,r=rad1,r2=rad2,mitte=breite,grad=start?max(winkel*sin(i*.5*step+0),1):winkel,grad2=[-konisch,konisch],extrude=d2/2,x0=mantel/2,xCenter=-1)   
    ];
 
profilnr=start;
pointskorr=[for(i=[0:len(points[profilnr])-1])[points[profilnr][i][0],points[profilnr][i][1]*profilkorrekturY]];

detail=fn*grad/360;


function faces1(points,start=0)=[[for(i=[0:len(points)-1])i+start]];//bottom
function faces0(points,start=0)=[[for(i=[len(points)-1:-1:0])i+start]];//Top
function faces2(points,start=0)=[for(i=[+0:len(points)-1])each[ //start/end Gang komplett
    [i+start,i+start+1,i+len(points)+start],//skin tri 1
    [i+start,i+len(points)+start,i+len(points)-1+start]//skin tri 2
]];
function faces3(points,start=+0)=[for(i=[2:len(points)-2])       //outer Wall
    [i+start,i+1+start,i+start+len(points)+1,i+start+len(points)]//skin quad
];
function faces31(points,start=+0)=[for(i=[len(points)-2])       //outer Wall (Innengew)
    [start+i,1+start+i,start+len(points)+1+i,start+len(points)+i]//skin quad
];
function faces4(points,start=+0)=[for(i=[0])                    //inner Wall
    [start+i,1+start+i,start+len(points)+1+i,start+len(points)+i]//skin quad
];
function faces41(points,start=+0)=[for(i=[0:len(points)-4])       //inner Wall(Innengew)
    [i+start,i+1+start,i+start+len(points)+1,i+start+len(points)]//skin quad
];
function faces5(points,start=+0)=[for(i=innen?[len(points)-3]:[1])                   //floor 
    [i+start,i+1+start,i+start+len(points)+1,i+start+len(points)]//skin quad
];
function faces6(points,start=+0)=[for(i=innen?[len(points)-1]:[-1])                   // ceil 
    [1+start+i,start+len(points)+1+i,start+len(points)*2+i,start+len(points)+i]//skin quad
];

function RotEx(rot=0,points=points,verschieb=tan(konisch),steigung=p,detail=fn,start=start,end=end)=
[for(rotation=[0:detail*rot/360])for(i=innen?[0:len(points[0])-1]:[len(points[0])-1:-1:0])
[ // Punkt
if(rotation<detail*rot/360-end)(points[min(rotation,max(start,end))][i][0]+verschieb*rotation/detail*steigung)*sin(rotation*360/detail) //⇐ normal
    else (points[detail*rot/360-rotation][i][0]+verschieb*rotation/detail*steigung)*sin(rotation*360/detail),
if(rotation<detail*rot/360-end)profilkorrekturY*points[min(rotation,max(start,end))][i][1]+rotation/detail*steigung //⇐ normal
    else profilkorrekturY*points[detail*rot/360-rotation][i][1]+rotation/detail*steigung,
if(rotation<detail*rot/360-end)(points[min(rotation,max(start,end))][i][0]+verschieb*rotation/detail*steigung)*cos(rotation*360/detail) //⇐ normal
    else (points[detail*rot/360-rotation][i][0]+verschieb*rotation/detail*steigung)*cos(rotation*360/detail) 
] // Punkt end
];

facesALL=concat(
faces0(points=RotEx(+0))//floor endcap
,faces1(points=RotEx(0),start=len(RotEx(grad))-len(RotEx(0)))//top endcap

,[if(innen)for(level=[0:detail-1])each faces31(points=RotEx(0),start=(len(RotEx(0)))*level)
    else for(level=[0:detail-1])each faces3(points=RotEx(0),start=(len(RotEx(0)))*level)]//Outer wall
,[if(innen)for(level=[0:detail-1])each faces41(points=RotEx(0),start=(len(RotEx(0)))*level)
   else for(level=[0:detail-1])each faces4(points=RotEx(0),start=(len(RotEx(0)))*level)]//inner wall
,[for(level=[0:(fn*min(1,grad/360))- 1])each faces5(points=RotEx(0),start=(len(RotEx(0)))*level)]// bottom     
,[for(level=[detail-(fn*min(1,grad/360)):detail- 1])each faces6(points=RotEx(0),start=(len(RotEx(0)))*(level-(innen?1:+0)))]//top wall     
);

pointsALL=RotEx(grad);//3D
if(profil)!Linear(x=0,y=1,es=p)polygon(points=pointskorr); 
else Tz(center?center<0?-p/2+tz:tz:tz+p/2)color(innen?"slategrey":"gold"){
       R(90,0,90) polyhedron(points=pointsALL,faces=facesALL,convexity=5);
    if(cyl)Tz(-p/2)linear_extrude(h,convexity=5,scale=1+h*tan(konisch)/(d2/2))Kreis(r=d2/2,rand=innen?max(wand,+0.0001):mantel<0.01?0:wand,fn=fn,name=0);//Ring(h=h,rand=wand,d=abs(d2),cd=innen?-1:1);
    }

}


module DBogen(
grad=25,
x=50,
rad2=3,
rad,
base=+0,
fn,
fs=fs,
messpunkt=$messpunkt, 
spiel=minVal,
name=$info,
help=$helpM
){
 
l=x;

a=is_undef(grad)?2*asin((rad2-l/2)/(rad2-rad))
    :grad;

r2=rad2*sign(180-a);    //vorzeichen mod für große winkel
a2=90-a/2; //(180-a)/2;

r2x=r2-r2*sin(a/2);//cos(a2);
r=is_undef(grad)?rad:(l-r2x*2)/(2*sin(a/2));
    
h=r*cos(a/2);
r2h=r2*sin(a2);

if($parent_modules<2&&messpunkt){
Caliper(abs(l),h=7,center=1,messpunkt=0,end=2,translate=[00,-2,0]);//color("red")cube([l,1,1],true);
Caliper(Sehne(r=r,a=a),h=7,center=1,messpunkt=0,end=2,translate=[00,-h+r2h+r+2,0]);
Caliper(-h+r2h+r,h=7,in=+2,center=0,messpunkt=0,end=2,translate=[00,+0,0]);
//color("yellow")cube([1,h,1],false);
//color("green")T(-l/2,r2h)cube([r2x,.1,2]);
}
InfoTxt("DBogen",["radius",str(r,"mm"),"∅",str(2*r,"mm"), "r2",r2,"h",str(-h+r2h+r,"mm")],name);//
    
if(!$children&&name)Echo("DBogen has no 2D-Object",color="black");
HelpTxt("DBogen",[
"grad",grad,
"x",x,
"rad2",rad2,
"rad",str(rad,"/*(",r,")*/"),
"base",base,
"fn",fn,
"fs",fs,
"messpunkt",messpunkt,
"spiel",spiel,
"name",name
],help);

   // echo($parent_modules);
 if($children){ 
   $info=false;
   $messpunkt=false;
   $helpM=false;  
/*MKlon(my=1)if($idx<+1){
Col(1)T(y=-h+r2h)rotate(90)Kreis(r=r,rand=1,rcenter=true,grad=a);
MKlon(-l/2+r2,mx=1)rotate(90)Kreis(r=r2,center=false,rand=+1,rcenter=true,grad=a2);
}*/
T(y=-h+r2h)rotate(90)RotEx(grad=a+spiel,center=true,cut=sign(r),fn=max(12,is_undef(fn)?abs(kreisbogen(r,a+spiel)/fs):fn*2))T(r)children();
if(grad!=180)MKlon(l/2-r2,mx=1)RotEx(grad=a2+spiel,center=false,cut=sign(r2),fn=max(12,is_undef(fn)?abs(kreisbogen(r2,a2+spiel)/fs):fn))T(r2)children();
if(base)R(90)linear_extrude(abs(base),convexity=5)MKlon(l/2,mx=1)children();    

}
    else{
        rand=0;
        points=concat(
        [[l/2,base]]
        ,[[-l/2,base]]
        ,Kreis(r2,grad=a2,rand=rand,t=[-l/2+r2,0],rot=-90,center=false,fn=max(12,is_undef(fn)?kreisbogen(r2,a2)/fs:fn),sek=true)
        ,Kreis(r,grad=a,rand=rand,t=[0,-h+r2h],rot=-90,fn=max(12,is_undef(fn)?kreisbogen(r,a)/fs:fn*2),sek=true)// Scheitelbogen
        ,Kreis(r2,grad=a2,rand=rand,t=[l/2-r2,0],rot=90-a2,center=false,fn=max(12,is_undef(fn)?kreisbogen(r2,a2)/fs:fn),sek=true)
        );
        polygon(points);
    }
}



module DRing(d=4,id=20,r=.5,l=0,grad=180,fn=fn,center=true,name=$info,help=$helpM){
    $info=false;
    $d=d;
    r=is_list(r)?r:[r,d/2];
   translate(center?[0,0]:[0,d/2+r[0]+l])union(){
    if($children){
        DBogen(fn=fn/2,grad=grad,x=(id+d)+r[0]*2,rad2=max(r[1],.0001))children();
        //RotEx(180,fn=fn/2)T((id+d)/2+r)children();
        T(y=-l)MKlon(tx=id/2)rotate(-90)RotEx(90,fn=fn/8)T(d/2+r[0])children();
        T(y=-d/2-r[0]-l)R(90,0,-90)linear_extrude(id,center=true)children();
        if(l)MKlon((id+d)/2+r[0])R(90)linear_extrude(l,center=false)children(); 
    }
    else{
    //RotEx(180,fn=fn/2)T((id+d)/2+r[0]) circle(d=d,$fn=fn);
     DBogen(fn=fn/2,grad=grad,x=(id+d)+r[0]*2,rad2=max(r[1],.0001))circle(d=d,$fn=fn);   
    T(y=-l)MKlon(tx=id/2)rotate(-90)RotEx(90,fn=fn/8)T(d/2+r[0])circle(d=d,$fn=fn);
    if(l)MKlon((id+d)/2+r[0])R(90)linear_extrude(l,center=false) circle(d=d,$fn=fn);
    T(y=-d/2-r[0]-l)R(90,0,-90) linear_extrude(id,center=true) circle(d=d,$fn=fn);
        
    }
  if(name)%T(y=-d-r[0]-l-$vpd/100)Caliper(id,messpunkt=0);
  }    
  if(name)echo(str(is_string(name)?"<H3>":"",name," DRing dist=",id+r[0]*2+d,"mm innen h=",l+2*r[0]+id/2,"mm"));   
HelpTxt("DRing",[
  "d",d,
  "id",id,
  "r",r,
  "l",l,
  "grad",grad,
  "fn",fn,
  "centre",center,
  "name",name]
   ,help);    
}


module Nut(e=2,es=10,a=6,b=6,base=1,h=1,s,center=true,shift=0,winkel,grad,name=$info,help=$helpM){
  grad=is_undef(winkel)?grad:winkel;
  s=is_undef(s)?e*es:s;
  es=is_undef(s)?es:s/e;
  b=is_undef(grad)?b:2*(h*tan(90+grad))+es-a;  
    
    
    points=[[s,base],[s,0],[0,0],[0,base],
for(i=[0:e-1])each[
    [b/2+i*es,base],    
    [es/2-a/2+shift+i*es,h+base],
    [es/2+a/2+shift+i*es,h+base],
    [(es-b/2)+i*es,base]]
    ];
    path=[[for(i=[0:len(points)-1])i]];
     //   echo (points,path);
    

 translate(center?[-s/2,-base]:[0,0])   polygon(points,path,convexity=10);
    winkel1=atan(h/(es/2-a/2-b/2+shift));
    winkel2=atan(h/(es/2-a/2-b/2-shift));
    
   InfoTxt("Nut",concat(["winkel",str(winkel1,shift?str(" /",winkel2):"","°"), "Länge",s,"Abstand",es],grad?["b",b]:[]),name); 
     //  b<0?str("<font color=red ><b>",b,"</font>"):b
   HelpTxt("Nut",[
   "e",e,
   "es",es,
   "a",a,
   "b",b,
   "base",base,
   "h",h,
   "s",s,
   "center",center,
   "shift",shift,
   "grad",grad,
   "name",name],
   help);  
}


// SicherungsRing
module SRing(e=4,id=3.5,od=10,h=.8,rand=n(3),reduction=.5,schlitz=-17,help=$helpM){
$info=false;
intersection(){
    LinEx(h,.2,scale=1.05)Rund(0.3)difference(){
       Kreis(od/2);
       Rund(0.5) Stern(e,od/2-rand,id/2-reduction-1,mod=100,delta=schlitz);
       rotate(180+180/e)intersection_for(i=[0:e-1])rotate(i*360/e)T(reduction)Kreis(id/2,fn=e*15);
    }
    Pille(h,d=od,rad=.3,center=false);
}
HelpTxt("SRing",[
"e",e,
"id",id,
"od",od,
"h",h,
"rand",rand,
"reduction",reduction,
"schlitz",schlitz,]
,help);
}


module Bevel(z=0,r=.5,on=!$preview,grad=45,fillet=0,fn=12,messpunkt=messpunkt,help=$helpM){
  
    diff=fillet?sin(grad)*r:tan(grad)*r;
 

    if(on)difference(){
    children();
    minkowski(convexity=5){
        difference(){
            Tz(z>0?500+z-diff:-500+z+diff) cube(1000,true);
            children();
        }  
        if(!fillet)R(z>0?0:180)Kegel(d1=0,d2=r*2,fn=fn,grad=grad,name=false);
        else Tz(z>0?r:-r)R(z>0?180:0)RotEx(cut=1,fn=fn)Kehle(2D=true,rad=r,fn2=fn);    
    }
}else
children();

if (messpunkt){       
%Grid(e=[2,2,1],es=is_bool(messpunkt)?10:messpunkt,name=false)Tz(z)if(!fillet)color("orange",alpha=.75){
    R(z>0?180:0)Kegel(d2=0,d1=r*2,fn=fn,grad=grad,name=false);
    R(z>0?0:180)cylinder(.5,r=r*1,$fn=fn);
}
        else color("green",alpha=.75)R(z>0?180:0)Tz(-r+diff)RotEx(cut=1,fn=fn)Kehle(2D=true,rad=r,fn2=fn,spiel=.5);

%Tz(z)if(!fillet)color("orange",alpha=.75){
    R(z>0?180:0)Kegel(d2=0,d1=r*2,fn=fn,grad=grad,name=false);
    R(z>0?0:180)cylinder(.5,r=r*1,$fn=fn);
}
        else color("green",alpha=.75)R(z>0?180:0)Tz(-r+diff)RotEx(cut=1,fn=fn)Kehle(2D=true,rad=r,fn2=fn,spiel=0.5);             
}           
HelpTxt("Bevel",[     
     "z",z, 
     "r",r,
     "on",on,
     "grad",grad,
     "fillet",fillet,
     "fn",fn,
     "messpunkt",messpunkt]
    ,help); 
 
}

module SpiralCut(layer=l(1),h=12,x=.025,ir=1,or=5,winkel,name=$info,help=$helpM){
 
 winkel=is_undef(winkel)? 360-360/PHI:winkel ;
 cuts=ceil(h/layer)-1;   
 
 for(i=[0:cuts]){
     rotate(i*winkel)T(-x/2,ir,i*layer)cube([x,or-ir,layer]);   
    }
    
InfoTxt("SpiralCut",["Winkel",winkel,"Layer",layer,"Cuts",cuts],name);
 
HelpTxt("SpiralCut",[
 "layer",layer,
   "h",h,
   "x",x,
   "ir",ir,
   "or",or,
   "winkel",winkel,
   "name",name],
    help);

}


module Buchtung(size=[10,5],l=10,r=2.5,rmin=0,center=true,fn=15,fn2=fn,phase=360,deltaPhi=-90,help=$helpM){
    
    size=is_list(size)?size:[size,size];
    rmin=is_list(rmin)?rmin:[rmin,rmin,rmin,rmin];
    r=is_list(r)?r:[r,r,r,r];
    
    for (i=[0:fn-1]){
        j=i+1;
        zscale=l/fn;
        rscale=r-rmin;
        $info=0;
        translate(center?[0,0,-l/2]:[0,0,0]+size/2)hull(){
        Tz(i*zscale)linear_extrude(minVal,scale=0)Quad(size,r=(1+sin(i*phase/fn+deltaPhi))*rscale/2+rmin,fn=fn2);
        Tz(j*zscale+minVal)linear_extrude(minVal,scale=0)Quad(size,r=(1+sin(j*phase/fn+deltaPhi))*rscale/2+rmin,fn=fn2);
        }
    }    
HelpTxt("Buchtung",[
    "size",size,
    "l=",l,
    "r=",r,
    "rmin=",rmin,
    "fn=",fn,
    "fn2=",fn2,
    "phase=",phase,
    "deltaPhi=",deltaPhi],
     help);
}


module CyclGetriebe(z=20,modul=1.5,w=45,h=4,h2=.5,grad=45,achse=3.5,achsegrad=60,light=false,lock=false,center=true,lRand=n(2),d=0,rot=0,linear=false,preview=true,spiel=0.075,fn=fn,name=$info,help=$helpM){
    $info=false;
    center=is_bool(center)?center?1:0:center;
    preview=$preview?preview:true;
    linear=linear==true?1:linear;
    r=z/4*modul;
    mitteR=(r-modul/2)/2+achse/4;
    rand=r-achse/2-modul/2-lRand*2;
    
    if(!linear){T(center?0:z/4*modul)T(y=center>1?z/4*modul:0)rotate(rot)difference(){
        LinEx(h=h,h2=h2,$d=z/2*modul,mantelwinkel=w,slices=preview?(h-1)*2:2,grad=d>r*2?-grad:grad)
        if($preview&&!preview) Kreis(d=d>r*2?d:$d,rand=d>r*2?d/2-r:r-d/2);
        else render()CycloidZahn(modul=modul,z=z/2,d=d,spiel=spiel,fn=fn);
      if(achse)  Tz(-.01)LinEx(h=h+.02,h2=h2,$d=achse,grad=-achsegrad)circle(d=$d);
        if(light)Tz(-0.01)Polar(light)T(mitteR)LinEx(h=h+.02,h2=h2,$r=rand,grad=-60)T(-mitteR)Rund(min(rand/light,rand/2-0.1),fn=18)Kreis(r=mitteR,rand=rand,grad=min(360/light-15,320),grad2=max(360/light-40,10),rcenter=true,fn=z/light);
            if(lock)LinEx(h=h,h2=h2,$r=1.65,grad=-60)WStern(help=0,r=$r);
    }
    InfoTxt("CyclGetriebe",["Wälzradius",z/4*modul],name);
    }
    
 if (linear)T(0)intersection(){M(skewzx=-tan(w))T(0,-linear)LinEx(h,.5,$r=linear,grad=[90,45],grad2=[90,45])T(0,linear)CycloidZahn(z=z/2,modul=modul,linear=linear,center=center,spiel=spiel);
}
    //Color()T(mitteR,0,4)circle(d=rand);

HelpTxt("CyclGetriebe",[
    "z",z,
"modul",modul,
"w",w,
"h",h,
"h2",h2,
"grad",grad,
"achse",achse,
"achsegrad",achsegrad,
"light",light,
"lock",lock,
"center",center,
"lRand",lRand,
"d",d,
"rot",rot,
"linear",linear,
"preview",preview,
"spiel",spiel,
"fn",fn,
"name",$info]
,help);

}


module CycloidZahn(modul=1,z=10,d=0,linear=false,center=false,spiel=+0.05,fn=fn,kreisDivisor=3.50,name=$info,help=$helpM){
  //if(is_undef(UB)) echo(str("<H1><font color=red> include ub.scad> "));
      
  z1=z%1?floor(z)+0.4999999:z;
  z=z%1?floor(z)+0.5:z;
  l=modul*PI*z-spiel*2;
  r=modul*z/2;//Wälzkreis
  spielwinkel=spiel/(r*2*PI)*360;
  rot=90/z;
    kreis=Umkreis(z*2,z*modul/2+modul/kreisDivisor+(d>r*2?spiel:-spiel));
    $info=false;
  if(!linear)Polar(z%1?2:1,end=z%1?180+rot:360,r=z%1?0:180/(z*4))
  Rund(modul/10,fn=18){
    intersection (){
     rotate(-spielwinkel)    Cycloid(modul=modul,z=z1,d=d,fn=fn);
     rotate(rot+spielwinkel) Cycloid(modul=modul,z=z1,d=d,fn=fn);
      if(d<r*2)rotate(-rot/2)  circle(r=kreis,$fn=z*2);
         else  Kreis(d=d+10,rand=(d/2+5-kreis)+Umkreis(z*2,modul/3.5*2),rot=z%1?-rot/2:rot/2,fn=z*2);
    }
    rotate(180/z)intersection (){
     rotate(-spielwinkel)   Cycloid(modul=modul,z=z1,d=d,fn=fn);
     rotate(rot+spielwinkel)   Cycloid(modul=modul,z=z1,d=d,fn=fn);
      if(d<r*2) rotate(-rot/2)circle(r=kreis,$fn=z*2);
       else  Kreis(d=d+10,rand=(d/2+5-kreis)+Umkreis(z*2,modul/3.5*2),rot=z%1?-rot/2:rot/2,fn=z*2);
    } 
  }
  

  
  if(linear){
  T(center?-l/2:0)Rund(modul/10,fn=18)intersection(){
    T(2.5*-modul*PI/4)  Klon(tx=modul*PI/4) intersection(){
        T(-modul*PI/4-spiel*2) Cycloid(modul=modul,z=z1+2,d=d,linear=linear,fn=fn);
        T(0)Cycloid(modul=modul,z=z1+2,d=d,linear=linear,fn=fn);
    }
   T(0,-(linear==true?1:linear)) square([l,(linear==true?1:linear)+modul/3.5]);
  }

  }
  
InfoTxt("CycloidZahn",["Zähne=",z*2,linear?str(" Länge=",l):str(" Wälzkreis r=",r)," spiel",spiel],name);  
HelpTxt("CycloidZahnrad",["modul",modul,"z",z," d",d," linear",linear,"center",center,"spiel",spiel,"fn",fn,"kreisDivisor",kreisDivisor,"name",name],help);
}



module Anschluss(h=10,d1=10,d2=15,rad=5,rad2,grad=30,r1,r2,center=true,fn=fn,fn2=36,grad2=0,x0=0,wand,2D=false,name=$info,help=$helpM){
    
    center=is_bool(center)?center?1:0:center;
    rad2=is_undef(rad2)?is_list(rad)?rad[1]:rad:rad2;
    rad=is_list(rad)?rad[0]:rad;
    r1=is_undef(r1)?d1/2:r1;
    r2=is_undef(r2)?d2/2:r2;
    l1=is_list(h)?h[0]:h/2;
    l2=is_list(h)?h[1]:h/2;
    grad2=is_list(grad2)?grad2:[grad2,grad2];
    $helpM=false;
   
   if (!wand){ 
    if(2D)SBogen(extrude=sign(r2-r1)*(center?center==1?(r1+r2)/2:r2:r1),grad=abs(grad),dist=r2-r1,l1=l1,l2=l2,r1=rad,r2=rad2,center=center,fn=fn2,grad2=grad2,name=name,x0=x0,messpunkt=false);
    else
    RotEx(fn=fn)
        SBogen(extrude=sign(r2-r1)*(center?center==1?(r1+r2)/2:r2:r1),grad=abs(grad),dist=r2-r1,l1=l1,l2=l2,r1=rad,r2=rad2,center=center,fn=fn2,grad2=grad2,name=name,x0=x0,messpunkt=false);
       
    /*if(r1<r2)Tz(center?(l1+l2)/2:l1+l2)RotEx(fn=fn) SBogen(extrude=r2,grad=abs(grad),dist=r2-r1,l1=l1,l2=l2,r1=rad,r2=rad2,center=+1,fn=fn2,grad2=grad2,name=name,x0=x0,messpunkt=false);
    else Tz(center?(l1+l2)/2:l1+l2) R(180)RotEx(fn=fn)        SBogen(extrude=r2,grad=grad,dist=r2-r1,l1=l2,l2=l1,r1=rad2,r2=rad,center=+0,fn=fn2,grad2=[-grad2[1],-grad2[0]],name=name,x0=x0,messpunkt=false);
     */  
   } else difference(){
        if (wand<0)Anschluss(h=h,r1=r1-wand,r2=r2-wand,rad=rad+(r2>r1?wand:-wand),rad2=rad2+(r2>r1?-wand:wand),grad=grad,center=center,fn=fn,fn2=fn2,grad2=grad2,x0=x0,2D=2D,name=0,help=0);  
        Anschluss(h=h,r1=r1,r2=r2,rad=rad,rad2=rad2,grad=grad,center=center,fn=fn,fn2=fn2,grad2=grad2,x0=x0,2D=2D,name=name,help=0);
        if (wand>0)  Anschluss(h=h,r1=r1-wand,r2=r2-wand,rad=rad+(r2>r1?wand:-wand),rad2=rad2+(r2>r1?-wand:wand),grad=grad,center=center,fn=fn,fn2=fn2,grad2=grad2,x0=x0,2D=2D,name=0,help=0);  
      
   }  
    

  HelpTxt("Anschluss",[
   "h",h,
   "d1",d1,
   "d2",d2,
   "rad",rad,
   "rad2",rad2,
   "grad",grad,
   "r1",r1,
   "r2",r2,
   "center",center,
   "fn",fn,
   "fn2",fn2,
   "grad2",grad2,
   "x0",x0,
   "wand",wand,
   "2D",2D,
   "name",name]
   ,help);
}


//union(){
//r=1;
// r2=1;   
//    grad=70;
//    h=undef;
//    mitte=2;
//    extrude=+9.34;
//    xCenter=-1;
//polygon([for(i=[0:27])vollwelle(fn=5,l=18,grad=grad,h=h,r=r,r2=r2,mitte=mitte,xCenter=xCenter,grad2=50,extrude=extrude)[i]]);
//T(0,0,-0.1)color("green")Vollwelle(fn=5,l=18,grad=grad,h=h,r=r,mitte=mitte,r2=r2,xCenter=xCenter,grad2=+50,extrude=extrude);  
//T(0,2.4)color("red")square([8.68,1],center=0);
//*T(extrude-h,1)color("red")square([h,1],center=0);    
//*T(5,4)square([r2-sin(90-grad)*r2,1]);
//*T(5+6.5,1)square([r-sin(90-grad)*r,1]);
//    
//}


function vollwelle(r=1,r2,grad=+60,grad2=+0,h=0,l,extrude=+5,center=true,xCenter=1,fn=12,x0=0,mitte=0,g2End=[1,1])=
let(
    fn=is_list(fn)?fn:[fn,fn],
    grad=is_list(grad)?grad:[grad,grad],
    grad2=is_list(grad2)?[max(grad2[0],-grad[0]),max(grad2[1],-grad[1])]:[max(grad2,-grad[0]),max(grad2,-grad[0])],
    sc=1,// scaling r center
    r2=is_undef(r2)?r:r2,
    
    w=grad[0]-90,//del=echo(w,grad[0]-90),
    wOben=(2*grad[1]-180)/2,
    hR=r-sin(90-grad[0])*r,
    hRO=r-sin(90-grad[1])*r,
    hR2=r2-sin(90-grad[0])*r2,
    hR2O=r2-sin(90-grad[1])*r2,
    h=max(hR+hR2,hRO+hR2O,h),
    hDiv=h-(hR+hR2),
    hDivOben=h-(hRO+hR2O),
    //hDiv=is_undef(h)?0:w>0?h-(sin(w)*r+sin(w)*r2):h-((sin(w)*r+sin(w)*r2))*0,
    y=2*cos(w)*r*sc+(hDiv*-tan(w)*2),
    yOben=2*cos(wOben)*r*sc+(hDivOben*-tan(wOben)*2),
    y2Oben=2*cos(wOben)*r2,
    y2=2*cos(w)*r2,
    
    x=  sin(w)*r+hDiv*1,
    x2= sin(w)*r2 ,
    l1=is_undef(l)?y/2+y2/2+sin(grad2[0])*r2+mitte/2:is_list(l)?is_undef(l[0])?y/2+y2/2+sin(grad2[0])*r2+mitte/2:l[0]:l/2,
    l2=is_undef(l)?yOben/2+y2/2+sin(grad2[1])*r2+mitte/2:is_list(l)?is_undef(l[1])?yOben/2+y2/2+sin(grad2[1])*r2+mitte/2:l[1]:l/2,
    extrude=xCenter==0?extrude-hDiv/2
                       :xCenter>0?extrude-x-r
                                   :xCenter<-1?xCenter<-2?extrude+x2+cos(grad2[1])*r2
                                                          :extrude+x2+cos(grad2[0])*r2
                                               :extrude+x2+r2,
   
    trans=[+0,center?0:l1],// all points translation
    g2End=is_list(g2End)?g2End:[g2End,g2End],
    yKL1=l2-(yOben/2+y2Oben/2+mitte/2+sin(grad2[1])*r2),// Abstand Kreisende bis l2
    yKL0=l1+(-y/2-y2/2-mitte/2-sin(grad2[0])*r2),// Abstand Kreisende bis l1
    g2EndX0=g2End[0]?+yKL0*tan(grad2[0]):0,// End Punkt unten winkel verlängerung
    g2EndX1=g2End[1]?yKL1*tan(grad2[1]):0// End Punkt oben winkel verlängerung
    )
concat(

    [[extrude-x2-cos(grad2[1])*r2+g2EndX1,l2]]+[trans]//oben Kreis verl.
    ,Kreis(r=r2,rand=0,rot=-90+grad2[1],center=false,grad=-grad[1]-grad2[1],t=[extrude-x2,yOben/2+y2Oben/2+mitte/2]+trans,fn=fn[0])//oben
    ,Kreis(r=r,r2=r*sc,rand=0,rot=90-grad[1],grad=grad[1],t=[extrude+x,mitte/2]+trans,fn=fn[1],center=false)//mitte oben
    ,Kreis(r=r,r2=r*sc,rand=0,rot=90,grad=grad[0],t=[extrude+x,-mitte/2]+trans,fn=fn[1],center=false)//mitte unten
    ,Kreis(r=r2,rand=0,rot=grad[0]-90,center=false,grad=-grad[0]-grad2[0],t=[extrude-x2,-y/2-y2/2-mitte/2]+trans,fn=fn[0])  //unten 
   
    ,[[extrude-x2-cos(grad2[0])*r2+g2EndX0,-l1]]+[trans]//unten Kreis verl.
    ,[[x0,-l1]]+[trans]//unten
    ,[[x0,l2]]+[trans]//oben

    );
 

module Vollwelle(r=1,r2,grad=+60,grad2=+0,h,l,extrude=+5,center=true,xCenter=0,fn=12,x0=0,mitte=0,g2End=[1,1],help=$helpM,name=$info){
    
    // calc for geometry is done by function -- values here are only for console
    fn=is_list(fn)?fn:[fn,fn];
    //grad=is_list(grad)?is_undef(h)?echo(str("<h2><font color=red>Vollwelle define h"))[grad[0],grad[0]]:grad:[grad,grad];
    
    grad=is_list(grad)?grad:[grad,grad];
    grad2=is_list(grad2)?grad2:[grad2,grad2];
    sc=1;// scaling r center
    r2=is_undef(r2)?r:r2;
    w=(2*grad[0]-180)/2;
    wOben=(2*grad[1]-180)/2;
//    echo(w);
 //   hDiv=is_undef(h)?0:w>0?h-(sin(w)*r+sin(w)*r2):h+(sin(w)*r-sin(w)*r2);
    hR=r-sin(90-grad[0])*r;
    hR2=r2-sin(90-grad[0])*r2;
    hRO=r-sin(90-grad[1])*r;
    hR2O=r2-sin(90-grad[1])*r2;    
    h=is_undef(h)?max(hR+hR2,hRO+hR2O):h;
    hDiv=h-(hR+hR2);
    
    y=2*cos(w)*r*sc+(hDiv*-tan(w)*2);
    yOben=2*cos(wOben)*r*sc+(hDiv*-tan(wOben)*2);
    y2=2*cos(w)*r2; 
    
    x=  sin(w)*r+hDiv ; 
    x2= sin(w)*r2 +0; 
    l1=is_undef(l)?y/2+y2/2+sin(grad2[0])*r2+mitte/2:is_list(l)?is_undef(l[0])?y/2+y2/2+sin(grad2[0])*r2+mitte/2:l[0]:l/2;
    l2=is_undef(l)?yOben/2+y2/2+sin(grad2[1])*r2+mitte/2:is_list(l)?is_undef(l[1])?yOben/2+y2/2+sin(grad2[1])*r2+mitte/2:l[1]:l/2;
    
    Echo(str(name," Vollwelle h ist minimal= ",h),color="green",condition=name&&h==(hR+hR2));
    
    Echo(str(name," Vollwelle h zu klein! min=",(hR+hR2)),color="red",condition=h<(hR+hR2));
    
    
    Echo("Vollwelle use Number for xCenter",color="red",condition=is_bool(xCenter));
    //xCenter=is_bool(xCenter)?0:xCenter;
    extrudeUnchanged=extrude;
    extrude=xCenter==0?extrude-hDiv/2:xCenter>0?extrude-x-r:xCenter<-1?xCenter<-2?extrude+x2+cos(grad2[1])*r2:extrude+x2+cos(grad2[0])*r2:extrude+x2+r2;
    points=concat(
    
    //[[x0,-y/2-y2/2-sin(grad2[0])*r2-mitte/2+0]],//unten
    [[extrude-x2-cos(grad2[0])*r2,-l1]],//unten Kreis verl.
    [[x0,-l1]],//unten
    //[[x0,y/2+y2/2+sin(grad2[1])*r2+mitte/2]],//oben
    [[x0,l2]],//oben
    [[extrude-x2-cos(grad2[1])*r2,l2]],//oben Kreis verl.
    
    Kreis(r=r2,rand=0,rot=-90+grad2[1],center=false,grad=-grad[1]-grad2[1],t=[extrude-x2,yOben/2+y2/2+mitte/2],fn=fn[0]),//oben
    Kreis(r=r,r2=r*sc,rand=0,rot=90-grad[1],grad=grad[1],t=[extrude+x,mitte/2],fn=fn[1],center=false),//mitte oben
    Kreis(r=r,r2=r*sc,rand=0,rot=90,grad=grad[0]*1,t=[extrude+x,-mitte/2],fn=fn[1],center=false),//mitte unten
    Kreis(r=r2,rand=0,rot=grad[0]-90,center=false,grad=-grad[0]-grad2[0],t=[extrude-x2,-y/2-y2/2-mitte/2],fn=fn[0])  //unten  
    );
    
    //translate([0,center?0:l1])//(y2+y)/2+sin(grad2[0])*r2+mitte/2])
    //polygon(points,convexity=5);
    polygon(vollwelle(r=r,r2=r2,grad=grad,grad2=grad2,h=h,l=l,extrude=extrudeUnchanged,center=center,xCenter=xCenter,fn=fn,x0=x0,mitte=mitte,g2End=g2End));
    
    minimum=[extrude-x2-r2*(grad2[0]<0?cos(grad2[0]):1),extrude-x2-r2*(grad2[1]<0?cos(grad2[1]):1)];
    maximum=[extrude+x+r,extrude+x+r];
    
    InfoTxt("Vollwelle",[str("min=",grad2[0]==grad2[1]?
        grad2[0]<0?extrude-x2-r2*cos(grad2[0]):extrude-x2-r2
    :str(extrude-x2-r2*(grad2[0]<0?cos(grad2[0]):1),"/",extrude-x2-r2*(grad2[1]<0?cos(grad2[1]):1)),
   "(×2∅=",grad2[0]==grad2[1]?
        grad2[0]<0?2*(extrude-x2-r2*cos(grad2[0])):2*(extrude-x2-r2)
    :str(2*(extrude-x2-r2*(grad2[0]<0?cos(grad2[0]):1)),"/",2*(extrude-x2-r2*(grad2[1]<0?cos(grad2[1]):1))),
    "mm) — max=",extrude+x+r," (×2∅=",(extrude+x+r)*2,"mm)- Y länge=",l1+l2,"(",l1,"/",l2,")",//,y+y2+sin(grad2[0])*r2+sin(grad2[1])*r2+mitte,
    "mm Wellenhöhe="),grad2[0]==grad2[1]?maximum[0]-minimum[0]:maximum-minimum],info=name);
    
    HelpTxt("Vollwelle",[
    "r",r,
    "r2",r2,
    "grad",grad,
    "grad2",grad2,
    "h",h,
    "l",l,
    "extrude",extrude,
    "center",center,
    "xCenter",xCenter,
    "fn",fn,
    "x0",x0,
    "mitte",mitte,
    "g2End",g2End,
    "name",name]
    ,help); 
    
}


module SQ(size=[10,10],fn=[10,2],diff=[0.0001,0.0001,0.0001,0.0001],center=true,help=$helpM){
    
    x=is_list(size)?size[0]:size;
    y=is_list(size)?size[1]:size;
    fnx=is_list(fn)?fn[0]:fn;
    fny=is_list(fn)?fn[1]:fn;
    diff=is_list(diff)?diff:[diff,diff,diff,diff];
    
    points=[
    for(i=[0:fnx])[-x/2+x/fnx*i,-y/2+i%2*-diff[0]],
    for(i=[0:fny])[x/2+i%2*diff[1],-y/2+y/fny*i],    
    for(i=[0:fnx])[x/2-x/fnx*i,y/2+i%2*diff[2]],
    for(i=[0:fny])[-x/2-i%2*diff[3],y/2-y/fny*i],

    ] ;
    
   // echo(points);
    path=[[for(i=[0:len(points)-1])i]];
    //echo (path);
   translate(center?[0,0]:[x/2,y/2]) polygon(points,path);
    
HelpTxt("SQ",["size",[x,y],"fn",[fnx,fny],"diff",diff,"center",center] ,help);   
}

/*
union(){ // Gear TEST
    z=6;
rot=+0.5;

Cycloid(linear=+2,option=+0);
T(rot*PI*z-PI/4,z/2)rotate(-rot*360-90)Cycloid(option=+0,z=z,l=+0.00,d=1);
}
*/


module Cycloid (modul=1,z=5,fn=36,option=+0,l=0,d=0,linear=false,name=$info,help=$helpM,zahn){
    z=is_undef(zahn)?z:zahn;
    r=modul*z/2;
    rCav=r;
    e=z*2;

    linear=is_bool(linear)?linear==true?modul:false:linear;
    //r=modul*e;
    fn2=fn*abs(e);
    r2=r/(e)-l;
    r2Cav=r2;   
    step1=360/fn2;
    step2=step1*e; 
    step2Cav=-step1*(e-1);   
   // delta=+180;


if(linear){
    if(name) echo(str(is_string(name)?"<H3>":"",name," Zahnstangenlänge=",r*PI*2," Zahnabschnitt=",r*PI*2/z));
    box=[[PI*2*r,-linear],[0,-linear]];
    pointsEpi=[for(i=[0:fn2])[PI*2*r*i/fn2+r2*-sin(i*step2),r2-r2*cos(i*step2)]];
    pointsHyp=[for(i=[0:fn2])[PI*2*r*i/fn2+r2Cav*-sin(i*step2),-r2-r2Cav*-cos(i*step2)]];    
    if(option==1)color("pink")polygon(concat(box,pointsEpi));
    if(option==-1)color("cyan")polygon(concat(box,pointsHyp)); 
    points=[for(z=[0:2:e-2])each[for(i=[fn*z:fn*(z+1)])pointsEpi[i]
,for(i=[fn*(z+1):fn*(z+2)])pointsHyp[i]]];     
    if(!option)color("orange")polygon(concat(box,points));   
}

  
if(!linear){
    
  if(d) InfoTxt("Cycloid",["ZahnkreisRadius",str(r,"mm"),"fn Kreis rot",str(180/e,"°"),"d",d,"fn",max(d*3,fn)],name);
     else InfoTxt("Cycloid",["ZahnkreisRadius",str(r,"mm")],name);
 
   
 pointsEX=[for(i=[0:fn2])
    let(iw=i%fn2)
    [
    (r+r2)*cos(iw*step1)-r2*cos(iw*(step2+step1)),
    (r+r2)*sin(iw*step1)-r2*sin(iw*(step2+step1))
    ]
 ];
 pointsCAV=[for(i=[0:fn2])
    let(iw=i%fn2)
    [
    (rCav-r2Cav)*cos(iw*step1)+r2Cav*cos(iw*step2Cav),
    (rCav-r2Cav)*sin(iw*step1)+r2Cav*sin(iw*step2Cav)
    ]
 ]; 
 
if(option==1)color("pink")polygon(pointsEX,convexity=5);
if(option==-1)color("cyan")polygon(pointsCAV,convexity=5);    

points=[for(z=[0:2:e-1])each[for(i=[fn*z:fn*(z+1)])pointsEX[i],
for(i=[fn*(z+1):fn*(z+2)])pointsCAV[i]
    ]
    //,pointsEX[+0]
    ]; 
//if(!option)color("orange")rotate(180/e-90)polygon(points,convexity=5); 
pointsRand=Kreis(r=d/2,rand=0,fn=max(d*3,fn),rot=180+(d>r*2?90/z:-90/z));

if(!option)color("orange")rotate(-180/e)
    polygon(d?concat(pointsRand,points):points
   ,paths=
    d?[[for(i=[0:len(pointsRand)-1])i],
    [for(i=[len(pointsRand):len(points)-1+len(pointsRand)])i]]:
    [[for(i=[0:len(points)-1])i]]
    ,convexity=5);
    
}
HelpTxt("Cycloid",["modul",modul,"z",z,"fn",fn,"option",option,"l",l,"d",d],help);
}

module WKreis(e=12,d1=1,d2,grad=180,r,diff,fn=24,name=$info,help=$helpM){
    
    d2=is_undef(d2)?d1:d2;
    winkel=360/(e*2);
    
    grad1=grad+winkel; // konvex
    grad2=grad-winkel; // konkav
    
    diff=is_undef(diff)?0:diff;
    

    sek1=sin(grad1/2)*d1;
    sek2=sin(grad2/2)*d2;
        
    r=is_undef(r)?Umkreis(e*2,((sek1+sek2)/4)/tan(winkel/2))+(d2>d1?pow(abs(d1/d2-1),+7):0):r; //WIP
    diff1=-d1/2*cos(grad1/2)+diff;
    diff2=d2/2*cos(grad2/2)-diff;    
    
    rEck=Umkreis(e*2,r);
    r1=Kathete(r,sin(grad1/2)*d1/2)+diff1;
    r2=Kathete(r,sin(grad2/2)*d2/2)+diff2;
    umfang=PI*r*2;
    umfang1=PI*(r1)*2;
    umfang2=PI*(r2)*2;
    umfangEck=e*(d1+d2);
    
    
    wk=[for(i=[0:e-1])each concat(
    Kreis(r=-d2/2,rot=-90-winkel/2+i*winkel*2,rand=0,grad=-grad2,sek=true,t=RotLang(-winkel/2+i*winkel*2,r2),fn=fn)
    ,Kreis(r=d1/2,rot=-90+winkel/2+i*winkel*2,rand=0,grad=grad1,sek=true,t=RotLang(winkel/2+i*winkel*2,r1),fn=fn)
    )];

   rotate(winkel/2-90) polygon(wk,convexity=5);

if(name){echo(str(is_string(name)?"<H3>":"",name," Wkreis länge=",umfangEck,"mm - Umfang(r=",r,")=",umfang,"mm Grad=",grad1,"°/",grad2,"°"));
   
    echo(str(is_string(name)?"<H3>":"",name," WK Außen r=",r1+d1/2," OD=",2*r1+d1," — Umfang=",umfang1,"mm Kreismitte=",r1));
    echo(str(is_string(name)?"<H3>":"",name," WK Innen r=",r2-d2/2," ID=",2*r2-d2," — Umfang=",umfang2,"mm Kreismitte=",r2));
}
HelpTxt("Wkreis",[
    "e",e,
    "d1",d1,
    "d2",d2,
    "grad",grad,
    "r",r,
    "diff",diff,
    "fn",fn,
    "name",name],
help);
    
}


module Pin(l=10,d=5,cut=true,mitte=true,grad=60,lippe=0.4,spiel=.1,name=$info,help=$helpM){
$info=false;
    rdiff=lippe+spiel;
cut=is_list(cut)?cut:[cut,cut];    
pol=[is_bool(cut[0])?round(d):cut[0],is_bool(cut[1])?round(d):cut[1]];

l=is_num(l)?[l/2,l/2]:l;    
 
cuth=[min(d,l[0]*1.8),min(d,l[1]*1.8)];
   
hkomplett=l[0]+l[1]+2*tan(grad)*rdiff; 
 
mirror([0,0,1])difference(){
    union(){
        cylinder(l[0],d=d);
        Tz(l[0])Kegel(d+rdiff*2,d,grad=grad);
        Tz(l[0])R(180)Kegel(d+rdiff*2,d-1,grad=40);
      if(mitte) Kegel(d+rdiff*2,d-1,grad=45);
    }
  if(cut[0])  Tz(l[0]+0.2)Polar(pol[0],d-1)LinEx(cuth[0],min(cuth[0]/2.5,+1.0),0,grad=45,$d=d,center=true)Tri(h=d,top=+1,center=1,grad=45,r=0.3,fn=24);
   linear_extrude(200,center=true,convexity=3)Kreis(r=d,rand=d/2-rdiff+spiel);
}    
difference(){
    union(){
        cylinder(l[1],d=d);
        Tz(l[1])Kegel(d+rdiff*2,d,grad=grad);
        Tz(l[1])R(180)Kegel(d+rdiff*2,d-1,grad=40);
      if(mitte) Kegel(d+rdiff*2,d-1,grad=45);
    }
  if(cut[1])  Tz(l[1]+0.2)Polar(pol[1],d-1)LinEx(cuth[1],min(cuth[1]/2.5,1),0,grad=45,$d=d,center=true)Tri(h=d,top=+1,center=1,grad=45,r=0.3,fn=24);
   linear_extrude(200,center=true,convexity=3)Kreis(r=d,rand=d/2-rdiff+spiel);
}

//if(achse)cylinder(h=achse,d=d+rdiff*2,center=true);

if(name)echo(str(is_string(name)?"<H3>":"",name," Pin l=",l[0]+l[1]," reale höhe=",hkomplett,"mm halb=",l,"/",[l[0]+tan(grad)*rdiff,l[1]+tan(grad)*rdiff]," plus= ",2*tan(grad)*rdiff,"/",tan(grad)*rdiff));

HelpTxt("Pin",["l",l,"d",d,"cut",cut,"mitte",mitte,"grad",grad,"lippe",lippe,"spiel",spiel,"name",name],help);

}



// WIP!!
module Kextrude (r1=10,r2,grad=60,rad=1,breit=5,center=1,fn=fn,help=$helpM)rotate(center?-grad/2:0){
   $fn=fn;
    r2=is_undef(r2)?r1+breit:r2;
    breit=r2-r1;
    
    rad=is_list(rad)?rad:[rad,rad,rad,rad];
        
    if (rad[0]>breit/2)Echo(color="red","Kextrude Eckradius zu groß für Breite!");
    MO(!$children);
    
   rotate_extrude(angle=grad)T(r1)mirror([1,0])children();

    
union(){  
    $helpM=0;
    $info=0;  
   rotate_extrude(angle=grad)T(r2)children();
    
   T(r1+rad[2])rotate(180)rotate_extrude(angle=90)T(rad[2])children();
   T(r2-rad[3])rotate_extrude(angle=-90)T(rad[3])children(); 
   T(r2-rad[3],-rad[2])R(90,0,-90)linear_extrude (r2-r1-rad[2]-rad[3])children(); 
    
 rotate(grad){
   T(r1+rad[0])rotate(90)rotate_extrude(angle=90)T(rad[0])children();
   T(r2-rad[1])rotate(90)rotate_extrude(angle=-90)T(rad[1])children();
   T(r1+rad[0],+rad[0])R(90,0,90)linear_extrude (r2-r1-rad[0]-rad[1])children();
     
 }
} 

HelpTxt("Kextrude",["r1",r1,"r2",r2,"grad",grad,"rad",rad,"breit",breit,"center",center,"fn",fn],help);

}


module Klammer(l=10,grad=250,d=4,rad2=5,offen=+25,breite=2.5,fn=fn,help=$helpM){
    $x=breite;
    w2=offen/2-90+grad/2;
    l=is_list(l)?l:[l,l];
    
 if($children){   
  RotEx(grad,center=true,fn=fn)T(d/2)children();  //centerring
  union(){ //arme
    $helpM=0;
    $info=0;
    MKlon(mz=0,my=1){
        rotate((grad-180.01)/2)T(0,rad2+breite+d/2)rotate(270-w2){
            RotEx(w2,fn=fn/2)T(rad2+breite)mirror([1,0])children();//Bogen
            T(rad2)union(){
                R(90)linear_extrude(height=$idx?l[0]:l[1])T(breite)mirror([1,0])children(); // Arm grade
                T(+breite/2,$idx?-l[0]:-l[1])rotate(180) RotEx(cut=true,grad=180,fn=fn/4)T(-breite/2)children(); //Endstück
            }
        }
    }
  }
  }else union(){
      $info=0;
      $helpM=0;
     Kreis(grad=grad,center=true,r=d/2,rand=-breite,fn=fn); 
     MKlon(mz=0,my=1){
         rotate((grad-180.01)/2)T(0,rad2+breite+d/2)rotate(180){
             Kreis(grad=w2,fn=fn/2,center=false,r=rad2,rand=-breite);
            rotate(-w2)T(0,rad2){ square([$idx?l[0]:l[1],breite]);
             T($idx?l[0]:l[1],breite/2)Kreis(grad=180,fn=fn/4,center=false,r=breite/2,rand=0);
            }
         }
         
     } 
      
  } 
  
  
  
HelpTxt("Klammer",[
  "l",l,
  "grad",grad,
  "d",d,
  "rad2",rad2,
  "offen",offen,
  "breite",breite,
  "fn",fn]
  ,help);

}


module Welle(e=3,grad=200,r=5,r2,center=3,rand=2,fn=fn,overlap=0,name=$info,help=$helpM){
    
    r2=is_undef(r2)?r:r2;
    $x=rand;    
    w=(grad-180)/2;
    y=2*cos(w)*r;
    y2=2*cos(w)*abs(r2);        
    
    T(0,center?center>1?center>2?y2/2:-y/2:0:y2)Linear(es=y+y2,e=e,x=0,y=1,center=center)union(){

     if(!$children){
         T(sin(w)*r,y/2)  Kreis(grad=grad+overlap,r=r,fn=fn,rand=rand,rcenter=true,sek=true);
         T(-sin(w)*r2,-y2/2)  Kreis(grad=grad+overlap,fn=fn,r=-r2,rand=rand,rcenter=true,sek=true);   
     }
     else {
         
         T(sin(w)*r,y/2)  RotEx(grad=grad+overlap,fn=fn,center=true)T(r)children();
         union(){
             $info=0;
             $helpM=0;
         T(-sin(w)*r2,-y2/2)RotEx(grad=grad+overlap,fn=fn,center=true)T(-r2)children(); 
         }  
         
     }
    }
 InfoTxt("Welle",["Wellenenhöhe r/r2=",str(r+sin(w)*r,"/",-r2-sin(w)*r2),"Abstand r/r2=",str(y,"/",y2),"Länge=",e*(y+y2)],name);  
HelpTxt("Welle",[
     "e",e,"
    grad",grad," 
    r",r," 
   r2",r2," 
    center",center," 
    rand",rand," 
    fn",fn,"
    overlap",overlap," 
    name",name] 
    ,help);    
}



module Pille(
l=10,
d=+5,
rad,
rad2,
r,
center=true,
fn=fn,
fn2=fn/4,
loch=false,
grad=360,
2D=false,
name=$info,
help=$helpM
){
r=is_undef(r)?d/2:r;
rad=is_undef(rad)?2*r<l?r*[1,1]:l/2*[1,1]:is_list(rad)?rad*sign(r):[rad,rad]*sign(r);
rad2=is_undef(rad2)?!is_undef(rad[1])?rad[1]:r<l?r:l-rad[0]:rad2*sign(r);
d=is_undef(r)?abs(d):abs(r*2);
deltaRx=max(0,rad[0]-d/2);
deltaRy=Kathete(rad[0],deltaRx);
ausgleich=rad[0]-deltaRy;
rgrad=asin(deltaRy/rad[0]);

deltaRx2=max(0,rad2-d/2);
deltaRy2=Kathete(rad2,deltaRx2);
ausgleich2=rad2-deltaRy2;
grad2=asin(deltaRy2/rad2);

if(l+ausgleich+ausgleich2-rad[0]-rad2<0) echo(str("<font color=red><b>Pille zu kurz! ",l-rad[0]+ausgleich-rad2+ausgleich2));

points=concat([
if(!loch)[0,0],
if(!loch)[0,l]],
rad2==0?[[d/2,l]]:Kreis(r=rad2,rand=0,grad=grad2,t=[d/2-rad2,l-rad2+ausgleich2],fn=fn2,center=false,rot=90-grad2),
rad[0]==0?[[d/2,0]]:Kreis(r=rad[0],rand=0,grad=rgrad,t=[d/2-rad[0],rad[0]-ausgleich],fn=fn2,center=false,rot=90)

);

if(!2D)if(rgrad==90&&grad2==90)Tz(center?-l/2:0)RotEx(grad=grad,fn=fn)polygon(points);
    else Tz(center?-l/2:0)RotEx(grad=grad,fn=fn)polygon(clampToX0(points));
if(2D)T(0,center?-l/2:0)polygon(points);    

  InfoTxt("Pille",["Länge",l,"Rundung",str(rad[0],"/",rad2,str(rad[0]>d/2?" Spitz":rad[0]==d/2?" Rund":" Flach","/",rad2>d/2?"Spitz":rad2==d/2?"Rund":"Flach")),"Durchmesser",d,"Radius",d/2,"Grad",str(grad,"°")],name);    
     
  HelpTxt("Pille",["l",l,"d",d,"fn",fn,"fn2",fn2,"center",center,"name",name,"rad",rad,"rad2",rad2,"loch",loch,"grad",grad,"2D",2D,],help);
}



module Row(e=15,dist=2,step=.1,d=+1,cut=.25,dir=+1,center=true,name=$info,help=$helpM){
    
    /*  Row will recursivly create a Row of objects with changing size (d+e*step) 
   /    by keeping the gap equal
 */
    
    $d=d;
    $r=d/2;
    $info=e>1?0:$info;
    $helpM=e>1?0:$helpM;
    $idx=e-1;
    cut=is_num(cut)?cut:cut==true?0.02:false;
    if(e>1)T(d+dist+step/2) 
    if($children)Row(e=e-1,d=d+step,dist=dist,step=step,cut=cut,dir=dir<2?sign(dir*-1):dir,center=center,name=name)children();
     else Row(e=e-1,d=d+step,dist=dist,step=step,cut=cut,dir=dir<2?sign(dir*-1):dir,center=center,name=name);  
    
    if(!$children)cylinder(100,d=$d,$fn=24,center=center);
    if($children)children();
    if(cut) T(-cut/2,dir>0?dir>1?0:0:-1000,center?-500:0)color(alpha=0.0)cube([cut,1000,1000]);
    if(e==1&&name)echo(str(is_string(name)?"<H3>":"",name," Row's last d=",$d,(cut?str(" Cut is ",cut):""))); 
        
    HelpTxt("Row",[
    "e",e," 
    dist",dist," 
    step",step," 
    d",d," 
    cut",cut," 
    dir",dir," 
    center",center," 
    name",name], 
    help);
    
    if(help)echo("Row will recursivly create a Row of objects with changing size $d=(d+e*step) by keeping the gap (dist) equal");
}


module PCBcase(
pcb=[20,40,1],/*[breite×länge×höhe]*/
h=20,/*höhe*/
wand,/*Wandstärke */
r2=3,/*Innenradius*/
rC=2,/*Eckradius*/
rS=2,/*Kantenradius*/
spiel=0.2,
kabel,/*Kabelloch[b,h]*/
kanal,
kpos=[0,0],
tasche=5,
deckel=false,
dummy=1,
name=$info,
clip=true,
help=$helpM
){
 
  $info=false; 
  rS=abs(rS);
  rC=max(rS,abs(rC));  
  wand=max(rC-rC/sqrt(2)+rS/sqrt(2),rS,is_undef(wand)?0:wand-spiel); 
  kabel=is_num(kabel)?[kabel,kabel/1.618]:kabel;
  spiel=abs(spiel);
  $helpM=0; 
  size=[pcb[0]+(wand+spiel)*2,pcb[1]+(wand+spiel)*2,h];
  kabelrundung=1; // rundungsradius Kabellochecken  
  //  %translate([0,0,h/2])cube(size,true);
  //if(name&&!$children)echo(str("<H2>Case size=",size));
  if(!deckel)InfoTxt("Case",[$children?"Inside":"size",$children?pcb+[0,0,h-tasche-wand]:size,"pcb headroom",str(h-tasche-wand,"mm")],name);
  else InfoTxt("Case",["Deckeldicke",str(tasche-pcb[2]-spiel,"mm")],name);    
  assert(is_list(pcb),"No pcb size");




if(deckel){ // for render

        
    difference(){
    linear_extrude(tasche-pcb[2]-spiel,convexity=5)offset(.5,$fn=24)square([pcb[0]-1,pcb[1]-1],true);
    translate([0,0,+1.5])linear_extrude(50,convexity=5)square([pcb[0]-2,pcb[1]-2],true);
}

if(clip)Tz((tasche-pcb[2])/2){//clip positiv
    MKlon(pcb[0]/2)R(90)LinEx(pcb.y*.75-spiel*2,center=true,end=true)Vollwelle(r=.5-spiel,extrude=0,xCenter=-1,fn=4,x0=-.1);
    MKlon(tx=0,ty=pcb[1]/2)R(90,0,90)LinEx(pcb.x*.75-spiel*2,center=true,end=true)Vollwelle(r=.5-spiel,extrude=0,xCenter=-1,fn=4,x0=-.1);
    }
   


if(kanal)intersection(){
    if($children)children();
        else minkowski(){
          translate([0,0,h/2])cube([pcb[0]-rS*2-(rC-rS)*2+wand*2+spiel*2,pcb[1]-rS*2-(rC-rS)*2+wand*2+spiel*2,h-rS*2],true);
          sphere(rS,$fn=36);
          cylinder(minVal,r=rC-rS,$fn=72);
        }
    union(){
        translate([pcb[0]/2,kpos[0]-kanal/2+spiel,0])
        cube([wand+150,kanal-spiel*2,tasche-spiel-(deckel<2?kpos[1]<0?-kpos[1]:0:pcb[2])],center=false);
    }
    
}



}

//PCB dummy
if(dummy&&$preview)color([0.6,0.6,0.2,0.5])translate([0,0,tasche-pcb[2]])linear_extrude(pcb[2],convexity=5)square([pcb[0],pcb[1]],true);
    
if(!deckel||$preview||deckel==2)color(alpha=deckel==1?0.5:1){
    difference(){
     if(!$children)   minkowski(){
          translate([0,0,h/2])cube([pcb[0]-rS*2-(rC-rS)*2+wand*2+spiel*2,pcb[1]-rS*2-(rC-rS)*2+wand*2+spiel*2,h-rS*2],true);
          sphere(rS,$fn=36);
          cylinder(minVal,r=rC-rS,$fn=72);
        }
     else children();   
       translate([0,0,h/2-wand-2.5])minkowski(){
           cube([pcb[0]-r2*2-1,pcb[1]-r2*2-1,h-r2*2+5],true);
           sphere(r2,$fn=36);
           
       }
    if(kabel)color([0.7,0.7,0.8])translate([pcb[0]/2-.5-r2,kpos[0],kpos[1]+tasche+kabel[1]/2])rotate([90,0,90])linear_extrude(500,convexity=5)offset(kabelrundung,$fn=24)square(kabel-[kabelrundung*2,kabelrundung*2],true); //Kabelloch
    if(kanal)translate([50,kpos[0],0])cube([100,kanal,tasche*2],true);    

    
    linear_extrude(tasche*2,center=true,convexity=5)offset(.5+spiel,$fn=24)square([pcb[0]-1,pcb[1]-1],true);
    
    if($children)color([.5,0.4,0.5])rotate([180])cylinder(100,d=500,$fn=6);
        
    if(clip)Tz((tasche-pcb[2])/2){ //clip negativ
        MKlon(pcb.x/2+spiel)R(90)LinEx(pcb.y*.75,center=true,end=true)Vollwelle(r=.5,extrude=0,xCenter=-1,fn=4,x0=-1);
        MKlon(tx=0,ty=pcb.y/2+spiel)R(90,0,90)LinEx(pcb.x*.75,center=true,end=true)Vollwelle(r=.5,extrude=0,xCenter=-1,fn=4,x0=-1);
    }

   }

}
if(!deckel&&$preview)color(alpha=0.5){ // only view deckel in preview if deckel=0
    difference(){
    linear_extrude(tasche-pcb[2]-spiel,convexity=5)offset(.5,$fn=24)square([pcb[0]-1,pcb[1]-1],true);
    translate([0,0,+1.5])linear_extrude(50,convexity=5)square([pcb[0]-2,pcb[1]-2],true);
    }

    if(clip) Tz((tasche-pcb[2])/2){//clip positiv
        MKlon(pcb[0]/2)R(90)LinEx(pcb.y*.75-spiel*2,center=true,end=true)Vollwelle(r=.5-spiel,extrude=0,xCenter=-1,fn=4,x0=-.1);
        //Pille(pcb[1]*.75-spiel*2,d=1-spiel*2,fn=12,fn2=12,name=0);
        MKlon(tx=0,ty=pcb[1]/2)R(90,0,90)LinEx(pcb.x*.75-spiel*2,center=true,end=true)Vollwelle(r=.5-spiel,extrude=0,xCenter=-1,fn=4,x0=-.1);
        //Pille(pcb[0]*.75-spiel*2,d=1-spiel*2,fn=12,fn2=12,name=0);
    }

    if(kanal)intersection(){
        if($children)children();
            else minkowski(){
              translate([0,0,h/2])cube([pcb[0]-rS*2-(rC-rS)*2+wand*2+spiel*2,pcb[1]-rS*2-(rC-rS)*2+wand*2+spiel*2,h-rS*2],true);
              sphere(rS,$fn=36);
              cylinder(minVal,r=rC-rS,$fn=72);
            }
            
        union(){
            translate([pcb[0]/2,kpos[0]-kanal/2+spiel,0])
            cube([wand+150,kanal-spiel*2,tasche-spiel-(deckel<2?kpos[1]<0?-kpos[1]:0:pcb[2])],center=false);
        }    
        
    }
}
HelpTxt("PCBcase",[
  
"pcb",str(pcb,"/*Platine[Breite×Länge×Höhe]*/")," 
h",str(h,"/*Höhe*/"),"
wand",str(wand,"/*Wandstärke */")," 
r2",str(r2,"/*Innenradius*/")," 
rC",str(rC,"/*Eckradius*/")," 
rS",str(rS,"/*Kantenradius*/")," 
spiel",str(spiel,"/*Deckelspiel*/")," 
kabel",str(kabel,"/*Kabelloch[b,h]*/"),"
kanal",str(kanal,"/*Kabelkanal breite*/"),"
kpos",str(kpos,"/*Kabelposition[y,z]*/"),"
tasche",str(tasche,"/*Taschen h für Platine*/"),"
deckel",str(deckel,"/*render Deckel option 0-2*/"),"
dummy",str(dummy,"/*show PCB */"),"
name",name,"
clip",clip
],help);

}


module Seg7(n=8,h=10,b=1,spiel=n(1),l,center=false,rund,name=$info,help=$helpM){
    spiel=spiel/sqrt(2);
    l=is_undef(h)?l:h/2-b/2-spiel*2;
    y=l/2;
    x=b/2;
    y2=y-x;
    
    /*
    num=[for(n)each
    if(n==0)[1,1,1,1,1,0,1]
    else if(n==1) [0,1,0,1,0,0,0]
    else if(n==2) [1,0,0,1,1,1,1]
    else if(n==3) [0,1,0,1,1,1,1]
    else if(n==4) [0,1,1,1,0,1,0]
    else if(n==5) [0,1,1,0,1,1,1]
    else if(n==6) [1,1,1,0,1,1,1]  
    else if(n==7) [0,1,0,1,0,0,1]
    else if(n==8) [1,1,1,1,1,1,1]
    else if(n==9) [0,1,1,1,1,1,1]
    else if(is_list(n))n   
    ];
    */
    codetable=[
     [1,1,1,1,1,0,1]
    ,[0,1,0,1,0,0,0]
    ,[1,0,0,1,1,1,1]
    ,[0,1,0,1,1,1,1]
    ,[0,1,1,1,0,1,0]
    ,[0,1,1,0,1,1,1]
    ,[1,1,1,0,1,1,1]  
    ,[0,1,0,1,0,0,1]
    ,[1,1,1,1,1,1,1]
    ,[0,1,1,1,1,1,1]
    ];
    num=is_list(n)?n:codetable[n];
    
    points=[[0,y],[x,y2],[x,-y2],[0,-y],[-x,-y2],[-x,y2]];

  T(center?0:l/2+b/2+spiel,center?0:l+b/2+spiel*2){
    Grid(es=l+spiel*2,name=0)if(num[$idx[0]+$idx[1]*2])Rund(is_undef(rund)?0:rund?rund:b/2-minVal)polygon(points);
        
    Grid(es=l+spiel*2,e=[1,3,1],name=0)rotate(90)if(num[4+$idx[1]])Rund(is_undef(rund)?0:rund?rund:b/2-minVal)polygon(points);
  }
  if(name)echo(str(is_string(name)?"<H3>":"",name," Seg7 Höhe=",l*2+b+spiel*4,"mm Breite=",l+b+spiel*2,"mm"));
      
  HelpTxt("Seg7",["n",n,"h",h,"b",b,"spiel",spiel*sqrt(2),"l",l,"center",center,"rund",rund,",name",name],help);
}


module Zylinder(h=20,r=10,d,fn,fnh,grad=360,grad2=89,f=10,f2=5,f3=0,a=.5,a3=0,fz=0,az=0,deltaFz=0,deltaF=0,deltaF2=0,deltaF3=0,twist=0,winkelF3=0,scale=+1,sphere=0,lz,altFaces=1,center=false,lambda,name=$info,help=$helpM){
    a=is_undef(a)?0:a;
    r=is_undef(d)?is_undef(r)?0:
                            r:
                d/2;    
    lambda=is_list(lambda)?lambda:[lambda,lambda];
    f=is_undef(lambda[0])?is_undef(f)?0:
                          f:
        round(PI*2*r/lambda[0]);
    f2=is_undef(lambda[1])?is_undef(f2)?0:
                            f2:
        round(h/lambda[1]*2)/2;    
    fn=max(is_undef(fn)?f*2:fn,3);
    fnh=max(is_undef(fnh)?f2*2:fnh,1);

    stepRot=grad/fn;
    stepH=h/fnh;
InfoTxt("Zylinder",["f",f,"f2",f2,"a",a,"lamda f",(2*PI*r)/f,"λ-f2",h/f2,"λ-f3",(2*PI*r)/f3,"λ-fz",h/fz,"r",str(r+a+a3+az,"/",r-a-a3-az),"d",str((r+a+a3+az)*2,"/",(r-a-a3-az)*2)],name);    
points=[for(z=[0:fnh],rot=[0:fn])RotLang(
    rot=rot*stepRot+twist*z/fnh+winkelF3*sin(rot*stepRot*f3+deltaF3),
    l=(1+(scale-1)*z/fnh)*(a*cos(rot*stepRot*f+deltaF)*cos(z*f2*360/fnh+deltaF2)+az*sin(z*fz*360/fnh+deltaFz)),
    lz=lz,
    z=sphere?undef:z*stepH,
    e=z*grad2/fnh
    )+
RotLang(
    rot=rot*stepRot+twist*z/fnh,
    l=(1+(scale-1)*z/fnh)*(r+a3*cos(rot*stepRot*f3)),
    lz=h,
    z=sphere?undef:0,//z*stepH,
    e=z*grad2/fnh
    )

];
//echo(points);

faces=[
if(altFaces==0)each[for(i=[-1:len(points)-fn-2])[i,i+1,i+2+fn,i+fn+1]],//0
if(altFaces==1)each[for(i=[0:1:len(points)-fn-3])each[                 //1
        if(i%2)[i,i+fn+2,i+fn+1]else [i,i+1,i+fn+1] ,
        if(i%2)[i+0,i+1,i+fn+2] else [i+1,i+fn+2,i+fn+1] ,
        //if(i<len(points)-fn-4)[i+1,i+fn+3,i+fn+2],
        //if(i<len(points)-fn-4)[i+1,i+2,i+fn+3]
    ]],
if(altFaces==2)each[for(j=[0:fnh-1])for(i=[0:fn+0])[j*(fn+1)+i,j*(fn+1)+i+1,(j+1)*(fn+1)+i+1,(j+1)*(fn+1)+i]],// fn fnh  2
if(altFaces==3)each[for(i=[0:len(points)-fn-3])each[[i,i+1,i+fn+1],[i+1+fn,i+1,i+fn+2]]],//3
if(altFaces==4)each[for(i=[-1:len(points)-fn-1])[i+fn-1,i,i+fn,i+fn+0]],// nur für 360grad 4
if(altFaces==5)each[for(i=[0:1:len(points)-fn-1])each[// nur für 360grad 5
        [i,i+fn+0,i+fn-1], [i,i+1,i+fn+0,i+fn-1] ,
        //[i+0,i+1,i+fn+1], [i+1,i+fn+1,i+fn+0]
        ]],
];

faces2=[[for(i=[fn+0:-1:+0])i],[for(i=[len(points)-fn-1:len(points)-1])i]];//top bottom

translate([0,0,center?-h/2:0])polyhedron(points,concat(faces2,faces),convexity=15);

HelpTxt("Zylinder",["h",h,"r",r,"d",d,"fn",fn,"fnh",fnh,"grad",grad,"grad2",grad2,"f",f,"f2",f2,"f3",f3,"a",a,"a3",a3,"fz",fz,"az",az,"deltaFz",deltaFz,"deltaF",deltaF,"deltaF2",deltaF2,"deltaF3",deltaF3,"twist",twist,"winkelF3",winkelF3,"scale",scale,"sphere",sphere,"lz",lz,"altFaces",altFaces,"center",center,"lambda",lambda,"name",name],help);

}

module ZylinderOLD(h=10,r=10,fn=150,fnh=150,grad=360,grad2=84,f=10,f2=10,f3=0,a=.5,a3=0,fz=0,az=0,deltaFz=0,deltaF=90,deltaF2=0,deltaF3=0,twist=0,scale=+1,sphere=0,lz,help=$helpM){
    stepRot=grad/fn;
    stepH=h/fnh;
points=[for(z=[0:fnh],rot=[0:fn])RotLang(
    rot=rot*stepRot+twist*z/fnh,
    l=(1+(scale-1)*z/fnh)*(r+a3*sin(rot*stepRot*f3+deltaF3)+a*sin(rot*stepRot*f+deltaF)*cos(z*f2*360/fnh+deltaF2)+az*sin(z*fz*360/fnh+deltaFz)),
    lz=lz,
    z=sphere?undef:z*stepH,
    e=z*grad2/fnh
    )];


faces=[for(i=[0:len(points)-fn-2])[i,i+1,i+2+fn,i+fn+1]];
    faces2=[[for(i=[fn-1:-1:+0])i],[for(i=[len(points)-fn:len(points)-1])i]];
  
//faces=[for(i=[0:len(points)-fn-2])each[[i,i+1,i+fn],[i+1,i+1+fn,i+fn]]];    
polyhedron(points,concat(faces2,faces),convexity=15);
HelpTxt("Zylinder",["h=",h,",r=",r,",fn=",fn,",fnh=",fnh,", grad=",grad,",grad2=",grad2,",f=",f,",f2=",f2,", f3=",f3, ",a=",a," a3=",a3," ,fz=",fz,",az=",az,",deltaFz=",deltaFz," ,deltaF=",deltaF," ,deltaF2=",deltaF2," ,deltaF3=",deltaF3,", twist=",twist,",scale=",scale,",sphere=",sphere,",lz=",lz],help); 
}


module Ccube(size=20,c=2,c2,center=true,sphere=false,grad=0,help=$helpM){
    c2=is_undef(c2)?0.5773*c:c2;//Eulerkonst?
    s=is_list(size)?size:[size,size,size];
    scaleS=max(s[0]-c,s[1]-c,s[2]-c);
    
    //sc=[Hypotenuse(s[0],s[2])-c,Hypotenuse(s[0],s[0])-c,Hypotenuse(s[2],s[0])-c];
   sc1=[Hypotenuse(s[0]-c,s[0]-c)/2+Hypotenuse(s[1]-c,s[1]-c)/2,Hypotenuse(s[0]-c,s[0]-c)/2+Hypotenuse(s[1]-c,s[1]-c)/2,5000];
   sc2=[Hypotenuse(s[2]-c,s[2]-c)/2+Hypotenuse(s[0]-c,s[0]-c)/2,5000,Hypotenuse(s[0]-c,s[0]-c)/2+Hypotenuse(s[2]-c,s[2]-c)/2];    
   sc3=[5000,Hypotenuse(s[2]-c,s[2]-c)/2+Hypotenuse(s[1]-c,s[1]-c)/2,Hypotenuse(s[1]-c,s[1]-c)/2+Hypotenuse(s[2]-c,s[2]-c)/2];     
    
    
    sce=[2*norm(s-[c,c,c])-c2,1*norm(s-[c,c,c])-c2,2*norm(s-[c,c,c])-c2
    ];
    
    
    
  translate(center?[0,0,0]:s/2)intersection(){
      cube(s,center=true);
      rotate([0,0,45])cube(sc1,center=true);
      rotate([0,45,0])cube(sc2,center=true);
      rotate([45,0,0])cube(sc3,center=true);
      

     Color()rotate([0,0,45])R(grad+90-54.74)cube(sce,center=true);
     Color()rotate([0,0,-45])R(grad+90-54.74)cube(sce,center=true);
     Color()rotate([0,0,135])R(grad+90-54.74)cube(sce,center=true);
     Color()rotate([0,0,-135])R(grad+90-54.74)cube(sce,center=true);
     if(sphere)Color(0.1) scale([1/scaleS*s[0],1/scaleS*s[1],1/scaleS*s[2]])sphere(norm(s/2)-c-sphere);
 
  } 
 HelpTxt("Ccube",[
  "size",size,
  "c",c,
  "c2",c2,
  "center",center,
  "sphere",sphere,
  "grad",grad],help);
}


module Flower(e=8,n=15,r=10,r2=0,min=5,fn=720,name=$info,help=$helpM){
points=[for(f=[+0:fn])let(i=f*360/fn)RotLang(i,r2+max(min-r2,(r-r2)*pow(abs(sin(e*.5*i)),2/n)))];

polygon(points,convexity=5);

if(help)echo(str("<H3><font color=",helpMColor,">Help Flower(e=",e,",n=",n,",r=",r,",r2=",r2,", min=",min," ,fn=",fn,",name=",name,",help=$helpM);"));
}
module FlowerOLD(e=8,n=15,r=10,r2=5,fn=720,name=$info,help=$helpM){
points=[for(f=[+0:fn])let(i=f*360/fn)RotLang(i,max(r2,r*pow(abs(sin(e*.5*i)),2/n)))];

polygon(points,convexity=5);

if(help)echo(str("<H3><font color=",helpMColor,">Help Flower(e=",e,",n=",n,",r=",r,",r2=",r2,", fn=",fn,",name=",name,",help=$helpM);"));
}

module Superellipse(n=4,r=10,n2,r2,n3,n31,n32,r3,fn=fn,fnz,name=$info,help=$helpM){
    r2=is_undef(r2)?r:r2;
    n11=is_list(n)?n[0]:n;
    n12=is_list(n)?n[1]:n;
    n13=is_list(n)?n[2]:n;
    n14=is_list(n)?n[3]:n;
    n2=is_undef(n2)?n:n2;
    n21=is_list(n2)?n2[0]:n2;
    n22=is_list(n2)?n2[1]:n2;
    n23=is_list(n2)?n2[2]:n2;
    n24=is_list(n2)?n2[3]:n2;    
   
    n3=is_undef(n3)?is_list(n)?n[0]:n:n3;
    n31=is_undef(n31)?n3:n31;
    n32=is_undef(n32)?n3:n32;
    fnz=is_undef(fnz)?fn:fnz;
  if(name)echo(str(is_string(name)?"<H3>":"",name," Superellipse n=[",n11,",",n12,",",n13,",",n14,"] ",is_undef(r3)?"is 2D":"is elipsoid 3D"));  
  
  if(is_undef(r3))  
    polygon([for(f=[0:fn])let(i=f%fn*360/fn)each[
    if(i<=90)[r*pow(sin(i),2/n11),r2*pow(cos(i),2/n21)],
    if(i>90&&i<=180)[r*pow(abs(sin(i)),2/n12),-r2*pow(abs(cos(i)),2/n22)],
    if(i>180&&i<=270)[-r*pow(abs(sin(i)),2/n13),-r2*pow(abs(cos(i)),2/n23)],
    if(i>270&&i)[-r*pow(abs(sin(i)),2/n14),r2*pow(abs(cos(i)),2/n24)],    
    ]
    ]);
  else{
   points=[for(fz=[0:fnz],f=[0:fn])
       let(i=f%fn*360/fn,j=fz*180/fnz)
    each[
    
    if(i<=90&&j<=90)[r*pow(sin(i),2/n11)*pow(sin(j),2/n31),r2*pow(cos(i),2/n21)*pow(sin(j),2/n32),r3*pow(cos(j),2/n3)],
    if(i>90&&i<=180&&j<=90)[r*pow(abs(sin(i)),2/n12)*pow(sin(j),2/n31),-r2*pow(abs(cos(i)),2/n22)*pow(sin(j),2/n32),r3*pow(cos(j),2/n3)],
    if(i>180&&i<=270&&j<=90)[-r*pow(abs(sin(i)),2/n13)*pow(sin(j),2/n31),-r2*pow(abs(cos(i)),2/n23)*pow(sin(j),2/n32),r3*pow(cos(j),2/n3)],
    if(i>270&&i&&j<=90)[-r*pow(abs(sin(i)),2/n14)*pow(sin(j),2/n31),r2*pow(abs(cos(i)),2/n24)*pow(sin(j),2/n32),r3*pow(cos(j),2/n3)],
       
    if(i<=90&&j>90)[r*pow(sin(i),2/n11)*pow(sin(j),2/n31),r2*pow(cos(i),2/n21)*pow(sin(j),2/n32),-r3*pow(abs(cos(j)),2/n3)],
    if(i>90&&i<=180&&j>90)[r*pow(abs(sin(i)),2/n12)*pow(sin(j),2/n31),-r2*pow(abs(cos(i)),2/n22)*pow(sin(j),2/n32),-r3*pow(abs(cos(j)),2/n3)],
    if(i>180&&i<=270&&j>90)[-r*pow(abs(sin(i)),2/n13)*pow(sin(j),2/n31),-r2*pow(abs(cos(i)),2/n23)*pow(sin(j),2/n32),-r3*pow(abs(cos(j)),2/n3)],
    if(i>270&&i&&j>90)[-r*pow(abs(sin(i)),2/n14)*pow(sin(j),2/n31),r2*pow(abs(cos(i)),2/n24)*pow(sin(j),2/n32),-r3*pow(abs(cos(j)),2/n3)],   
    
      
    ]
    ];   
      
  
    faces=[for(i=[0:len(points)-fn -3])[i+1,i,i+fn+1,i+2+fn]];
    //faces2=[[for(i=[0:fn-1])i],[for(i=[len(points)-fn:len(points)-1])i]];  
    
   polyhedron(points,faces,convexity=5);   
      
  }
    
 
 HelpTxt("Superellipse",["n",n,"r",r,"n2",n2,"r2",r2,"n3",n3,"n31",n31,"n32",n32,"r3",r3,"fn",fn,"fnz",fnz,"name",name],help); 
}


module WaveEx(grad=0,h=50,r=5,ry,f=0,fy,a=1,ay,fv=0,fvy,tf=0,trx=20,try,tfy=0,tfv=0,tfvy=0,ta=1,tay,fn=fn,fn2=fn,rot=0,scale=1,scaley,close=true,p=0,n=$info,help=$helpM){
    ay=is_undef(ay)?a:ay;
    fy=is_undef(fy)?f:fy;
    ry=is_undef(ry)?r:ry;
    scaley=is_undef(scaley)?scale:scaley;
    fvy=is_undef(fvy)?fv:fvy;
    try=is_undef(try)?trx:try;
    tay=is_undef(tay)?ta:tay;
    close=grad>=360?p?true:false:close;
    
    
    twist=0;
    rotate=rot;
    
    pointsLin=!grad?[for(i=[0:fn],j=[0:fn2])concat(Kreis(rot=rotate+twist/fn*i,fn=fn2,rand=0,r=(1+(scale-1)/fn*i)*(r+sin(i*f*360/fn+fv)*a),r2=(1+(scaley-1)/fn*i)*(ry+sin(i*fy*360/fn+fvy)*ay),t=[trx+ta*sin(i*tf*360/fn+tfv),try+tay*cos(i*tfy*360/fn+tfvy)])[j],[i*h/fn])]:0;
    
    
    function RotEx(rot=grad,punkte=Kreis(rot=rotate+twist/fn,fn=fn2,rand=0,r=(1+(scale-1)/fn)*(r+sin(0*f*360/fn+fv)*a),r2=(1+(scaley-1)/fn)*(ry+sin(0*fy*360/fn+fvy)*ay),t=[0,0]),verschieb=trx,verschiebY=try,p=-p,detail=fn*grad/360)=[for(rotation=[detail:-1:0])for(i=[0:len(punkte)-1])
    concat(
    (punkte[i][0]+cos(f*rotation*grad/detail+fv)*a*cos(i*360/fn2)+verschieb)*sin(rotation*grad/detail)+sin(tfv+rotation*grad/detail*(tf+1))*ta,
    punkte[i][1]+cos(fy*rotation*grad/detail+fvy)*-ay*sin(i*360/fn2)+rotation/detail*p*grad/360+sin(tfvy+rotation*grad/detail*(tfy+0))*tay,
    (punkte[i][0]+cos(f*rotation*grad/detail+fv)*a*cos(i*360/fn2)+verschiebY)*cos(rotation*grad/detail)+cos(tfv+rotation*grad/detail*(tf+1))*ta
    )
    ];
    pointsRot=RotEx(rot=grad);
 
    points=grad?pointsRot:pointsLin;

    //pointsMod=[for(i=[0:len(points)-1])[points[i][0]*1.0,points[i][1]*1,points[i][2]*1]];

   //faces1=[for(i=[0:len(points)-fn2-3])each[[i,i+1,i+fn2+1],[i+1,i+fn2+2,i+fn2+1]]];// Triangle faces×2
   bottom=[[for(i=[0:fn2-1])(fn2-1)-i]];
   top =[[for(i=[len(points)-fn2:len(points)])i]];
   faces2=[for(i=[0:len(points)-fn2-3])[i,i+1,i+fn2+2,i+fn2+1]];// Quad face version
   
   rotate(grad?[-90,0,-90-(360-grad)/2]:[0,0,0])polyhedron(points=points,faces=close?concat(faces2,bottom,top):faces2,convexity=5); 
  
  if(help){ echo(str("<H3><font color=",helpMColor,">Help WaveEx(grad=",grad,",h=",h,",r=",r,",ry=",ry,",f=",f,",fy=",fy,",a=",a,",ay=",ay,",fv=",fv,",fvy=",fvy,", tf=",tf,",trx=",trx,",try=",try,",tfy=",tfy,",tfv=",tfv,",tfvy=",tfvy,",ta=",ta,",tay=",tay,", fn=",fn,",fn2=",fn2,",rot=",rot,",scale=",scale,",scaley=",scaley,",close=",close,",p=",p,",n=",n,",help=$helpM)"));
      
    echo(str("<b><small><font color=",helpMColor,">r=radius, f=frequenz, fv=freqverschiebung, a=amplitude, trx=translatetRadiusX, p=steigung")); 
  }

}


module WStern(f=5,r=1.65,a=.25,r2,fn=fn,fv=0,name=$info,help=$helpM){
   
    step=360/fn;
    a=is_undef(r2)?a:(r2-r)/2;
    r=is_undef(r2)?r:r+a;
    points=[for(i=[0:fn])let(i=i%fn)[(r+a*cos(f*i*step+fv))*sin(i*step),(r+a*cos(f*i*step+fv))*cos(i*step)]];
       
    
    polygon(points);  
  InfoTxt("WStern",["OD",(r+a)*2,"ID",(r-a)*2],name);  
  HelpTxt("WStern",["f",f,"r",r,"a",a,"r2",r2,"fn",fn,"fv",fv,"name",name],help);
  
}


module REcke(h=5,r=5,rad=.5,rad2,single=0,grad=90,fn=fn,help=$helpM){
rad2=is_undef(rad2)?rad:rad2;
   radius=TangentenP(180-grad,r,r); 
   radius2=TangentenP(180-grad,r+Hypotenuse(rad,rad),r-rad);
    
 difference(){
  if(grad==90)T(-rad,-rad)cube([r+rad,rad+r,h]);
      else translate([-rad*tan(90-grad/2),-rad]) rotate_extrude(angle=grad,convexity=5)square([radius2,h]);
  translate(RotLang(90-grad/2,radius))rotate(grad/2+180)Strebe(angle=200-grad,h=h,single=single,2D=0,rad=rad,rad2=rad2,d=2*r,help=0,n=0,fn=fn);
 }   
if(help)echo(str("<H3><font color='",helpMColor,"' <b>Help REcke(h=",h,",r=",r,",rad=",rad,",rad2=",rad2,",single=",single,",grad=",grad," ,fn=",fn," ,help=$helpM")); 
 if(grad!=90)echo("<H1><font color=red> WIP grad!=90");   
}



module SBogen(dist=10,r1=10,r2,grad=45,l1=15,l2,center=1,fn=fn,messpunkt=false,2D=0,extrude=false,grad2=0,x0=0,name=$info,help=$helpM,spiel=0){
    center=is_bool(center)?center?1:0:sign(center);
    r2=!is_undef(r2)?r2:r1;
    l2=!is_undef(l2)?l2:l1;
    2D=2D==true?1:2D;
    grad2=is_list(grad2)?grad2:[grad2,grad2];
    extrudeTrue=extrude;
    extrude=is_bool(extrude)?0:extrude;
    gradN=grad; // detect negativ grad
    grad=abs(grad);// negativ grad done by mirror
    y=(grad>0?1:-1)*(abs(dist)/tan(grad)+r1*tan(grad/2)+r2*tan(grad/2));
    
    yrest=y-abs(sin(grad))*r1-abs(sin(grad))*r2;//y ohne Kreisstücke
    distrest=dist-r2-r1+cos(grad)*r1+cos(grad)*r2;//dist ohne Kreisstücke
        
    l2m=Hypotenuse(distrest,yrest)/2+minVal;// Mittelstück
 
    dist=grad>0?dist:-dist;
    
   
 if(grad&&!extrudeTrue)mirror(gradN<0?[1,0]:[0,0])translate(center?[0,0,0]:[dist/2,l1]){
    translate([dist/2,y/2,0])T(-r2)rotate(grad2[1])T(r2)Bogen(rad=r2,grad=grad+grad2[1],center=false,l1=l2-y/2,l2=l2m,help=0,name=0,messpunkt=messpunkt,2D=2D,fn=fn,d=2D,ueberlapp=spiel)
    if($children)children();
        else circle($fn=fn);
  T(-dist/2,-y/2) mirror([1,0,0])rotate(180)T(r1)rotate(-grad2[0])T(-r1)Bogen(rad=r1,grad=-grad-grad2[0],center=false,l1=l1-y/2,l2=l2m,help=0,name=0,messpunkt=messpunkt,2D=2D,fn=fn,d=2D,ueberlapp=spiel)
    if($children)children();
        else circle($fn=fn);
 }
 
 if(!grad&&!extrudeTrue) //0 grad Grade
     if(!2D)T(0,center?0:l1+l2)R(90)linear_extrude(l1+l2,convexity=5,center=center?true:false)
         if($children)children();
         else circle($fn=fn);
 else T(center?0:-2D/2) square([2D,l1+l2],center?true:false);
     
 grad2Y=[-l1+y/2+r1*sin(grad2[0]),l2-y/2-r2*sin(grad2[1])]; // Abstand Kreisende zu Punkt l1/l2
 
 grad2X=[r1-r1*cos(grad2[0])-tan(grad2[0])*grad2Y[0],-r2+r2*cos(grad2[1])-tan(grad2[1])*grad2Y[1]];// Versatz der Punkte durch grad2
 
 
 
 if(extrudeTrue){
     
     points=center?center==1?concat(//center=1
     [[x0,l2]],[[extrude+abs(dist)/2+grad2X[1],l2+0]],
     Kreis(r=-r2,rand=0,grad=abs(grad)+grad2[1],rot=-90-grad2[1],center=false,fn=fn,t=[abs(dist)/2+extrude-r2,y/2]), // ok
     Kreis(r=-r1,rand=0,grad=-abs(grad)-grad2[0],fn=fn,rot=90+abs(grad),center=false,t=[-abs(dist)/2+extrude+r1,-y/2]),  // ok   
     [[extrude-abs(dist)/2+grad2X[0],-l1]],     
     [[x0,-l1]]
     ): concat(//center==-1||>1
     [[x0,0]],[[extrude+grad2X[1],0]],
     Kreis(r=-r2,rand=0,grad=abs(grad)+grad2[1],rot=-90-grad2[1],center=false,fn=fn,t=[extrude-r2,y/2-l2]), // ok
     Kreis(r=-r1,rand=0,grad=-abs(grad)-grad2[0],fn=fn,rot=90+abs(grad),center=false,t=[extrude+r1-abs(dist),-y/2-l2]),  // ok   
     [[extrude-abs(dist)+grad2X[0],-l2-l1]],     
     [[x0,-l2-l1]]     
     ):
     concat(//center==0
     [[x0,l2+l1]],[[extrude+abs(dist)+grad2X[1],l2+l1]],
     Kreis(r=-r2,rand=0,grad=abs(grad)+grad2[1],rot=-90-grad2[1],center=false,fn=fn,t=[abs(dist)+extrude-r2,y/2+l1]), // ok
     Kreis(r=-r1,rand=0,grad=-abs(grad)-grad2[0],fn=fn,rot=90+abs(grad),center=false,t=[extrude+r1,-y/2+l1]),  // ok   
     [[extrude+grad2X[0],0]],     
     [[x0,0]]     
     );
     
  if(dist>0&&gradN>0)  polygon(points,convexity=5);
  if(dist<0||gradN<0)mirror([1,0])  polygon(points,convexity=5);    
  
 }
    
    KreisCenterR1=[[-abs(dist)/2+extrude+r1,-y/2],[extrude+r1-abs(dist),-y/2-l2],[extrude+r1,-y/2+l1]];
    KreisCenterR2=[[abs(dist)/2+extrude-r2,y/2],[extrude-r2,y/2-l2],[abs(dist)+extrude-r2,y/2+l1]];
 
 selectKC=center?center>0?0:
                            1:
                   2;
 if(messpunkt&&is_num(extrude)){
     Pivot(KreisCenterR1[selectKC]);
     Pivot(KreisCenterR2[selectKC]);
 //echo(KreisCenterR1,KreisCenterR2);
 }
 
 
    endPunkte=center?center==1?[extrude-abs(dist/2)+grad2X[0],extrude+abs(dist/2)+grad2X[1]]:[extrude-abs(dist)+grad2X[0],extrude+grad2X[1]]:[extrude+grad2X[0],extrude+abs(dist)+grad2X[1]];
       
    InfoTxt(parent_module(search(["Anschluss"],parentList(0))[0]?search(["Anschluss"],parentList(0))[0]:1),["ext",str(endPunkte[0],"/",endPunkte[1])," 2×=",str(2*endPunkte[0],"/",2*endPunkte[1]),"Kreiscenter",str(KreisCenterR1[selectKC],"/",KreisCenterR2[selectKC])
    ],name);

    //Warnings    
   Echo(str(name," SBogen has no 2D-Object"),color=Hexstring([1,0.5,0]),size=4,condition=!$children&&!2D&&!extrudeTrue);
   Echo(str(name," SBogen width is determined by var 2D=",2D,"mm"),color=Hexstring([1,0.5,0]),size=4,condition=2D&&!extrudeTrue);       
   
   Echo(str(name," SBogen r1/r2 to big  middle <0"),condition=l2m<0);
   Echo(str(name," SBogen radius 1 negative"),condition=r1<0);
   Echo(str(name," SBogen radius 2 negative"),condition=r2<0);    
   Echo(str(name," SBogen r1/r2 to big or angle or dist to short"),condition=grad!=0&&r1-cos(grad)*r1+r2-cos(grad)*r2>abs(dist));
   Echo(str(name," SBogen angle to small/ l1+l2 to short"),condition=l1-y/2<0||l2-y/2<0);
   //Help    
   HelpTxt("SBogen",["dist",dist,"r1",r1,"r2",r2,"grad",grad,"l1",l1,"l2",l2,"center",center,"fn",fn,"messpunkt",messpunkt,"2D",2D,"extrude",extrude,"grad2",grad2,"x0",x0,"spiel",spiel," ,name=",name],help); 

}








module Tri90(grad,a=25,b=25,c,r=0,messpunkt=0,tang=true,fn=fn,name=$info,help=$helpM){
 
  if (is_list(r)&&!tang)Echo("Tri90 Winkelfehler r is list & tang=false!",color="red");  
    
 b=is_undef(grad)?is_undef(c)?b:sqrt(pow(c,2)-pow(a,2)):tan(grad)*a;
 grad=atan(b/a);
 r1=is_list(r)?is_undef(r[0])?0:r[0]:r;   
 r2=is_list(r)?is_undef(r[1])?0:r[1]:r;
 r3=is_list(r)?is_undef(r[2])?0:r[2]:r; 
    
 gradB=90-grad;   
    
 wA=90+grad;  
 wB=90+gradB;
 wC=90; 
 a=tang?a:a+RotLang(90+grad/2,TangentenP(wB,r2))[0];
 btang=b+RotLang(+0-gradB/2,TangentenP(wA,r1))[1];
    
 tA=[0,tang?b:btang]-RotLang(+0-gradB/2,TangentenP(wA,r1,r1));   
 tB=[a,0]-RotLang(90+grad/2,TangentenP(wB,r2,r2)); 
 tC=RotLang(45,TangentenP(wC,r3,r3));
    
if(messpunkt){
            Col(6)union(){ // mittelpunkte
            Pivot(tA,active=[1,0,0,1,1],size=messpunkt);
            Pivot(tB,active=[1,0,0,1,1],size=messpunkt);   
            Pivot(tC,active=[1,0,0,1,1],size=messpunkt);
        }
            union(){ // tangentenpunkte
            Pivot([0,0],active=[1,0,0,1,1,1],txt="C",size=messpunkt);
            Pivot([0,b],active=[1,0,0,1,1],size=messpunkt);   
            Pivot([a,0],active=[1,0,0,1,1],size=messpunkt);
        }          

}

 points=concat(
    
 r3==0?[[0,0]]:Kreis(rot=180,grad=wC,fn=fn,rand=0,r=r3,t=tC,center=false),
 r1==0?[[0,b]]:Kreis(rot=270,grad=wA,fn=fn,rand=0,r=r1,t=tA,center=false),    
 r2==0?[[a,0]]:Kreis(rot=+180-wB,grad=wB,fn=fn,rand=0,r=r2,t=tB,center=false) 
 
);

 polygon(points,convexity=5);  
   
InfoTxt("Tri90",["a",str(a," b=",b," c=",Hypotenuse(a,b),"mm",r?str(" true a=",tB[0]+r2," b=",tA[1]+r1," c=",norm(tA-tB)+r1+r2):""," grad α=",grad,"° grad β=",gradB,"° γ=90° Höhe c=",a*sin(gradB))],name);
HelpTxt("Tri90",["grad",grad,"a",a,"b",b,"c",c,"r",r,"messpunkt",messpunkt,"tang",tang,"fn",fn,"name",name],help);     
    
}



module Tri(grad=60,l=20,l2,h=0,r=0,messpunkt=0,center=+0,top=0,tang=1,fn=fn,name=$info,help=$helpM){
    
  l22=is_undef(l2)?l:l2;  //wip
 
 w1=180-grad;  //Supplementwinkel 
 w2=(360-w1)/2;
 w3=(360-w1)/2; 
 
 rot=w2/2;   
 
 r1=is_list(r)?is_undef(r[0])?0:
                        r[0]:
            r;   
 r2=is_list(r)?is_undef(r[1])?0:
                        r[1]:
            r;
 r3=is_list(r)?is_undef(r[2])?0:
                           r[2]:
            r;    
  
 
 l2=h?1/cos(grad/2)*(!tang?h+TangentenP(w1,r1):h):l22;   
 l3=h?1/cos(grad/2)*(!tang?h+TangentenP(w1,r1):h):l; 
 
 hc=h?h:l*cos(grad/2);   
    
 t1=[TangentenP(w1,r1,r1),0];   
 t2=RotLang(90-grad/2,l2)-RotLang(90-w2/2,TangentenP(w2,r2,r2));
 t3=RotLang(90+grad/2,l3)-RotLang(90+w3/2,TangentenP(w3,r3,r3));
    
points=concat(
        Kreis(rand=0,r=r1,grad=w1,t=t1,rot=180,fn=fn/3),
        Kreis(rand=0,r=r2,rot=-rot,grad=w2,t=t2,fn=fn/3),    
        Kreis(rand=0,r=r3,rot=rot,grad=w3,t=t3,fn=fn/3)    
);
    
    
    rotate(top?0:180)translate([center?
                //-2*Kathete(l2,hc)/(2*sin(grad)):top? // center Umkreis
                -(tang?hc+TangentenP(w1,r1):hc+2*TangentenP(w1,r1))/2:top? // center h
                        tang?
                        0:-TangentenP(w1,r1)
                  :tang?-hc:h?-hc-TangentenP(w1,r1):-hc,0,0]){//Basis
        polygon(points,convexity=5);
        if(messpunkt){
            union(){//TangentenP
                Pivot(active=[1,1,0,1],size=messpunkt);
                translate(RotLang(90-grad/2,l2))rotate(90+w2/2)Pivot(active=[1,0,1,1],size=messpunkt);
                translate(RotLang(90+grad/2,l3))rotate(90-w3/2)Pivot(active=[1,0,1,1],size=messpunkt);
            }
            
            Col(6)union(){ // mittelpunkte
                Pivot(t1,active=[1,0,0,1],size=messpunkt);
                Pivot(t2,active=[1,0,0,1],size=messpunkt);   
                Pivot(t3,active=[1,0,0,1],size=messpunkt);
            }

        }
    }
   
 InfoTxt("Tri",["reale Höhe=",tang?hc-TangentenP(w1,r1):hc,"h",tang?hc:hc+TangentenP(w1,r1),"Basis",2*Kathete(l2,tang?hc:hc+TangentenP(w1,r1)),"Umkreis r",2*Kathete(l2,hc)/(2*sin(grad))],name);
 HelpTxt("Tri",["grad",grad,"l",l,"l2",l2,"h",h,"r",r,",messpunkt",messpunkt,",center=",center,"top",top,"tang",tang,"fn",fn,",name",name],help);    
 
}


module Caliper(l=20,in=1,s=$vpd/15,center=true,messpunkt=true,translate=[0,0,0],end=1,h=1.1,render=false,l2,txt,help=$helpM){
    
    txt=is_undef(txt)?str(l,"mm "):txt;
    center=is_bool(center)?center?1:0:center;
    textl=in>1?s/3:s/4*(len(str(txt)));// end=0 use own def
    line=s/20;
    //l2=is_undef(l2)?s:ls;
    
    
    if($preview||render)translate(translate)translate(in>1?center?[0,0]:[0,l/2]:center?[0,0]:[l/2,0]){
      if(end==1&&h)Col(5){
        rotate(in?in==2?90:in==3?-90:180:0)linear_extrude(h,center=true)Mklon(tx=l/2,mz=0)polygon([[max(-5,-l/3),0],[0,s],[0,0]]);
        rotate(in?in==2?90:in==3?-90:180:0)linear_extrude(h,center=true)Mklon(tx=-l/2,mz=0)polygon([[max(-5,-l/3),0],[0,-s],[0,0]]);
        
        Text(h=h+.1,text=txt,center=true,size=s/4);
        }
     else if(end==2&&h)Col(3)union(){
        rotate(in?in==2?90:in==3?-90:180:0)MKlon(tx=l/2)T(-(l-textl)/4,0)cube([(l-textl)/2,line,h],center=true);
        rotate(in?in==2?90:in==3?-90:180:0)MKlon(tx=l/2)T(-line/2)cube([line,s,h],center=true);    
        translate([(l<textl+1&&in<2)?l/2+textl/2+1:0,l<textl+1&&in>1?l/2+textl/2+1:0,0])Text(h=h+.1,text=txt,center=true,size=s/4);
         if(l<textl+1)
             if(in<2)translate([.5,0])square([l+.5,line],true);
                else translate([0,.5])square([line,l+.5],true);
         
        }
        else Col(1)union(){
            s=s==$vpd/15?5:s;
            line=s/20;
            l2=is_undef(l2)?s:ls;
            textl=in>1?s/3:s/4*len(txt);
            // text line
        rotate(in?in==2?90:in==3?-90:180:0)MKlon(tx=l/2)T(-(l-textl)/4,0)square([(l-textl)/2,line],center=true);
            //End lines
        rotate(in?in==2?90:in==3?-90:180:0){MKlon(tx=l/2){
           T(+line/2) square([line,l2],center=true);
            Pfeil([0,min(l/3,s/2)],b=[line,s],center=[-1,1]);
        }    
         translate([l<textl+s?l/2+textl/2+1:0,0])rotate(in>1?-90:180) Text(h=0,text=txt,center=true,size=s/4);
        // verbindung text ausserhalb
        if(l<textl+s) translate([.5,0])square([l+.5,line],true);
        }
        // verlängerungen translate auf 0
       if(translate.y)MKlon(tx=l/2) mirror([0,translate.y>0?1:0,0])square([line,abs(translate.y)],false);
       if(translate.x)MKlon(ty=l/2) mirror([translate.x>0?1:0,0,0])square([abs(translate.x),line],false);    
       //if(translate.x) mirror([translate.x>0?1:0,0,0])T(l/2,-line/2)square([abs(translate.x),line],false);

        }
    }
 Echo("Caliper will render",color="warning",condition=render);  
if(h&&end)    
Pivot(messpunkt=messpunkt,p0=translate,active=[1,1,1,1,norm(translate)]);
    
    HelpTxt("Caliper",[
    "l",l,
    "in",in,
    "s",s,
    "center",center,
    "messpunkt",messpunkt,
    "translate",translate,
    "end",end,
    "h",h,
    "render",render,
    "l2",l2,
    "txt",txt]
    ,help);
}



module Kreis(r=10,rand=0,grad=360,grad2,fn=fn,center=true,sek=false,r2=0,rand2,rcenter=0,rot=0,t=[0,0],name=$info,help=$helpM,d,b){
    r=is_undef(d)?r:d/2;
    d=2*r;
    grad=is_undef(b)?grad:r==0?0:b/(2*PI*r)*360;
    b=2*r*PI*grad/360;
    
   polygon(Kreis(r=r,rand=rand,grad=grad,grad2=grad2,fn=fn,center=center,sek=sek,r2=r2,rand2=rand2,rcenter=rcenter,rot=rot,t=t),convexity=5);
   
    
    HelpTxt("Kreis",["r",r,"rand",rand,"grad",grad,"grad2",grad2,"fn",fn,"center",center,"sek",sek,"r2",r2,"rand2",rand2,"rcenter",rcenter,"rot",rot,"t",t,"name",name,"d",d,", b",b],help);
    
    if(name){
        if(!rcenter){
        if(rand>0)echo(str(name," Kreis id=",2*(r-abs(rand))," od=",2*r));
        if(rand<0)echo(str(name," Kreis id=",2*r," od=",2*(r+abs(rand)))); 
        }
        else if(rand)echo(str(name," Kreis id=",2*r-abs(rand)," od=",2*r+abs(rand)));   
    }
}


module ZigZag(e=5,es=0,x=50,y=7,mod=2,delta=+0,base=2,shift=0,center=true,n=$info,help=$helpM){
   x=es?e*es:x; 
   es=es?es:x/e;
  T(center?-x/2:0)  polygon(ZigZag(e=e,x=x,y=y,mod=mod,delta=delta,base=base,shift=shift),convexity=5);
 abst=x/e;
 h=y-base;   
 if(n)echo(str(n," ZigZag Winkel=",atan((abst/2+shift)/h),"°+",atan((abst/2-shift)/h),"°=",atan((abst/2+shift)/h)+atan((abst/2-shift)/h),"° Spitzenabstand=",abst,"mm Zackenhöhe=",h,"mm <font color=red>‼ use Nut(a=0,b=0);")); 
 if(help){
    echo(str("<H3><font color='",helpMColor,"' <b>Help ZigZag(e=",e,",es=",es,",x=",x,",y=",y,",mod=",mod,",delta=",delta,",base=",base,",shift=",shift,",center=",center,",n=",n,",help=$helpM)")); 
 }    
}

module SCT(a=90){
    echo(str("<H3>Winkel=",a," sin=",sin(a)," cos=",cos(a)," tan=",tan(a)));
    echo(str("<H3>Winkel=",a," asin=",asin(a)," acos=",acos(a)," atan=",atan(a)));    
}







module RStern(e=3,r1=30,r2=10,rad1=5,rad2=+30,l,grad=0,rand=0,os=0,randh=2,r=0,fn=fn,messpunkt=messpunkt,infillh,spiel=-.002,name=$info,help=$helpM){
    $helpM=0;
    $info=0;
    r1=r?TangentenP(grad,rad1,r):r1;

    winkel1=180-grad;
    spitzenabstand=2*r1*sin(180/e);
    winkel3=180-(2*((180-360/e)/2-winkel1/2));
    schenkelA= spitzenabstand/2/sin(winkel3/2);
    winkel3h=Kathete(schenkelA,spitzenabstand/2);
    spitzenabsth=Kathete(r1,spitzenabstand/2);
    r2=r?spitzenabsth-winkel3h:r2;

    //infillh=$children?infillh:infillh?infillh:1;
    infillh=$children?infillh:is_undef(infillh)?0:infillh;
    //rand=$children?rand:grad<180?rand:rand?rand:1;
    
    // Winkelberechnung ZackenStern
    abstandR1=2*r1*sin(180/e);
    abstandR2=2*r2*sin(180/e);
    hoeheR1=r1-Kathete(r2,abstandR2/2);
    hypR1=Hypotenuse(abstandR2/2,hoeheR1);
    gradR1=2*acos(hoeheR1/hypR1);
    gradR2=2*asin((abstandR1/2)/hypR1);
  
        // RStern variablen
    grad=grad?grad:180-gradR1;
    g2=(grad-360/e);
    
    // Abstand Rundungen Zacken
    
    c1=sin(abs(grad)/2)*rad1*2;//  Sekante 1
    w11=abs(grad)/2;          //  Schenkelwinkel1
    w31=180-abs(grad);        //  Scheitelwinkel1
    a1=(c1/sin(w31/2))/2;    
    hc1=grad!=180?Kathete(a1,c1/2):0;  // Sekante1 tangenten center
    hSek1=Kathete(rad1,c1/2); //center Sekante1
    
    c2=sin(abs(g2)/2)*rad2*2;//  Sekante 2
    w12=abs(g2)/2;          //  Schenkelwinkel2
    w32=180-abs(g2);        //  Scheitelwinkel2
    a2=(c2/sin(w32/2))/2;    
    hc2=g2!=180?Kathete(a2,c2/2):0;  // Sekante2 tangenten center
    hSek2=Kathete(rad2,c2/2); //center Sekante2    
    
 
    
    // RStern l variable

    lCalcA=[r1-TangentenP(grad,rad1,rad1),0]+RotLang(90+grad/2,rad1);
    lCalcB=g2<0?
    RotLang(-90+180/e,-r2+TangentenP(g2,rad2,rad2))-RotLang(-90+180/e-abs(g2)/2,rad2):
    RotLang(-90+180/e,-r2-TangentenP(g2,rad2,rad2))+RotLang(-90+180/e+abs(g2)/2,rad2)
    ;

    l=is_undef(l)?norm(lCalcA-lCalcB)/2-spiel/2:l;
    //color("cyan")translate(lCalcA)Pivot();//Ende Bogen 1
    //color("magenta")translate(lCalcB)Pivot();//Ende Bogen 2
    
    
  if($children||!(grad<180))union(){
    Polar(e,r1,name=0)Bogen(grad=grad,rad=rad1,l=l,help=0,name=0,tcenter=1,fn=fn,messpunkt=messpunkt,ueberlapp=spiel)T(os){
        children();
        if(grad>=180)T(rand/2,randh/2)square([abs(rand),randh],true);
      }
      
    Polar(e,-r2,r=e%2?0:180/e,re=0,name=0)Bogen(grad=g2,rad=rad2,l=l,help=0,name=0,tcenter=true,fn=fn,messpunkt=messpunkt,ueberlapp=spiel)T(-os){
        R(0,180)children();
        if(grad>=180)T(-rand/2,randh/2)square([abs(rand),randh],true);
        }

  }
/*  old Sternfill
   if(grad<180){
   if(infillh)linear_extrude(infillh,convexity=5)offset(os,$fn=fn)Rund(rad1,rad2,fn=fn)Stern(e,r1,r2);
   if(rand)linear_extrude(randh,convexity=5)Rand(rand)offset(os,$fn=fn)Rund(rad1,rad2,fn=fn)Stern(e,r1,r2); 
   }
*/
  if(grad<=180){
   if(infillh)linear_extrude(infillh,convexity=5)offset(os,$fn=fn)RSternFill(e=e,r1=r1-TangentenP(grad,-rad1,-rad1),r2=TangentenP(g2,rad2,r2+rad2),d1=rad1*2,d2=rad2*2,fn=fn,grad1=grad,grad2=g2,help=false);
       
   if(rand)linear_extrude(randh,convexity=5)Rand(rand)offset(os,$fn=fn)RSternFill(e=e,r1=r1-TangentenP(grad,-rad1,-rad1),r2=TangentenP(g2,rad2,r2+rad2),d1=rad1*2,d2=rad2*2,fn=fn,grad1=grad,grad2=g2,help=false);
       
   if(infillh==0)offset(os,$fn=fn)RSternFill(e=e,r1=r1-TangentenP(grad,-rad1,-rad1),r2=TangentenP(g2,rad2,r2+rad2),d1=rad1*2,d2=rad2*2,fn=fn,grad1=grad,grad2=g2,help=false);   
   }
   
  if(grad>180){
   if(infillh)linear_extrude(infillh,convexity=5)offset(os,$fn=fn)RSternFill(e=e,r1=r1+TangentenP(grad,-rad1,-rad1),r2=TangentenP(g2,rad2,r2+rad2),d1=rad1*2,d2=rad2*2,fn=fn,grad1=grad,grad2=g2,help=false);
       
   if(rand)linear_extrude(randh,convexity=5)Rand(rand)offset(os,$fn=fn)RSternFill(e=e,r1=r1+TangentenP(grad,-rad1,-rad1),r2=TangentenP(g2,rad2,r2+rad2),d1=rad1*2,d2=rad2*2,fn=fn,grad1=grad,grad2=g2,help=false);
       
   if(infillh==0)offset(os,$fn=fn)RSternFill(e=e,r1=r1+TangentenP(grad,-rad1,-rad1),r2=TangentenP(g2,rad2,r2+rad2),d1=rad1*2,d2=rad2*2,fn=fn,grad1=grad,grad2=g2,help=false);   
   }   
 
  MO(!$children,warn=true);
   
  HelpTxt("RStern",["e",e,"r1",r1,"r2",r2,"rad1",rad1,"rad2",rad2,"l",l,"grad",grad,"rand",rand,"os",os,"randh",randh,"fn",fn,"messpunkt",messpunkt,"infillh",infillh,"spiel",spiel,"name",name],help);
   
  InfoTxt("RStern",["Grad",str(grad,"°"),"Grad2",str(g2,"°"),"Spitzenwinkel",str(gradR1,"°/",gradR2,"°"),"r1 bis Rundung",
      //  r1-hc1-hSek1+rad1
    r1-TangentenP(grad,-rad1,0)+2*rad1
    ,"r2 bis Rundung",
    //r2+hc2+hSek2-rad2
    str(TangentenP(g2,rad2,r2)
    ,"mm")],name);       
      
}

module RSternFill(
  
e=8,  //elements
d1=2,  // diameter nipples(convex) 
d2,  // diameter nipples(concave)
r1=5,  // radius 1
r2,  //radius 2
grad1=180, // angle nipples 1
grad2, // angle nipples 2
fn=fn,
messpunkt=false,
help=$helpM
){
winkel=360/(e*2);



    //grad1=is_undef(grad)?grad1:grad; // konvex
    grad2=is_undef(grad2)?grad1-winkel*2:grad2; // konkav
    d2=is_undef(d2)?d1:d2;
        

    sekD1X=sin(grad1/2)*d1/2;
    sekD1Y=cos(grad1/2)*d1/2;     
    sekD2X=sin(grad2/2)*d2/2;
    sekD2Y=-cos(grad2/2)*d2/2;
    r=norm([sekD1X,r1+sekD1Y]);//connectionpoint radius
    r2=is_undef(r2)?Kathete(r,sekD2X)-sekD2Y:r2;
  if(messpunkt)rotate(-90){
      Pivot(p0=[sekD1X,r1+sekD1Y],txt="D1",active=[0,0,0,1,0,1]);    
      rotate(-winkel) Pivot(p0=[-sekD2X,r2+sekD2Y],txt="D2",active=[0,0,0,1,0,1]);
      //Tz(.1)Color()circle(r,$fn=200);
  }
    

    
    wk=[for(i=[0:e-1]) each concat(
    Kreis(r=-d2/2,rot=-90-winkel/2+i*winkel*2,rand=0,grad=-grad2,sek=true,t=RotLang(-winkel/2+i*winkel*2,r2),fn=fn)
    ,Kreis(r=d1/2,rot=-90+winkel/2+i*winkel*2,rand=0,grad=grad1,sek=true,t=RotLang(winkel/2+i*winkel*2,r1),fn=fn)
    )];

  rotate(winkel/2-90)polygon(wk,convexity=5);
    
if(help)echo(str("<H3> <font color=",helpMColor,">Help RSternFill(e=",e,",r1=",r1,", r2=",r2," ,d1=",d1," ,d2=",d2, ",grad1=",grad1," ,grad2=",grad2," ,fn=",fn,", messpunkt=",messpunkt," help=$helpM);"));
}



module GewindeV3(
dn=5,
h=10,
kern=0,//Kerndurchmesser
p=1,//Steigung
w=0,//Windungen
profil=+0.00, //varianz gangbreite
gh=0.56,//Ganghöhe
g=1,//Gänge
name=$info,
fn=36,
help=$helpM
){
    //http://www.iso-gewinde.at
r=dn/2;
gh=gh?gh:(dn-kern)/2;
kern=gh?2*(r-gh):kern;    

p=p?p:(w/360)/h;
w=p?(h/p)*360:w;
winkel=2*atan((p/2)/gh);

if(name)echo(str(is_string(name)?"<H3>":"",name," GewindeV3 dn∅=",dn,"mm Steigung=",p,"mm/U Kern=",kern,"mm Gangtiefe=",gh,"mm Winkel~",winkel-23,"°(",winkel,"°)"));

    difference(){
       if($children) children();
        Col(6)linear_extrude(height=h,twist=-w,convexity=10,$fn=fn){
   if(g>1) Rund((r-gh/2)*+0.5)Polar(g)T(gh/2)scale([1,1.00+profil])circle(r-gh/2,$fn=fn);
   if(g==1)T(gh/2)scale([1,1.00+profil])circle(r-gh/2,$fn=fn);
            
        }
    }
 if(help)echo(str("<H3> <font color=",helpMColor,">Help GewindeV3(dn=",dn,",h=",h,",kern=",kern,",p=",p,",w=",w,", profil=",profil,",gh=",gh,",g=",g,",name=",name,",fn=",fn,",help=$helpM);"));   
    
}


module LinEx2(bh=5,h=1,slices=10,s=1,ds=+0.010,dh=+0,fs=1,fh=0.780,twist=0,hsum=0,startSlices=0,fn=fn,name=$info,help=$helpM){
    $helpM=0;
    $info=0;
    s=is_list(s)?s:[s,s];
  hsum=hsum?hsum:h;
    startSlices=startSlices?startSlices:slices;
    if(slices-1)rotate(-twist*h)Tz(h)scale([s[0],s[1],1])LinEx2(bh=bh,slices=slices-1,s=s*fs-[ds,ds],h=h*fh-dh,ds=ds,dh=dh,hsum=hsum+h*fh-dh,fs=fs,fh=fh,name=name,startSlices=startSlices,twist=twist,fn=fn,help=help)children();
  rotate(-twist*bh)Tz(bh)linear_extrude(h+minVal,twist=twist*(h+minVal),scale=s,convexity=5,$fn=fn)children();
  if(slices==startSlices){
      linear_extrude(bh+minVal,twist=twist*bh,convexity=5,$fn=fn)children();
  MO(!$children);

  }
 
 if(!(slices-1)){
     InfoTxt("LinEx2",["Höhe",hsum+minVal+bh,"Twist",(hsum+bh)*twist],name);
     HelpTxt("LinEx2",["bh",bh,"h",h,"slices",slices,"s",s,"ds",ds,"dh",dh,"fs",fs,"fh",fh,"twist",twist,"hsum",hsum,"startSlices",startSlices,"fn",fn,"name",name],help);
 }

}

module Surface(x=20,y,zBase=5,deltaZ=.25,res=6,waves=false,
rand=true,seed=42,randsize=1,randSizeY,freqX=1,freqY,ampX=1,waveSkewX=+0,ampY,waveSkewY,ampRoundX=0,rfX=+1,ampRoundY,rfY,versch=[0,0],name=$info,abs=false,exp=1,expY,sinDelta=0,sinDeltaY,mult=false,help=$helpM){

if(help){
    echo(str("<font color='",helpMColor,"', size=3><b>Help Surface"));
    echo(str("<font color='",helpMColor,"', size=2> Surface(x=",x,",y=",y,", zBase=",zBase," // mm size "));
    echo(str("<font color='",helpMColor,"', size=2> deltaZ=",deltaZ,", res=",res," // random change +− and resolution points/mm "));
    echo(str("<font color='#5500aa', size=2> waves=",waves,", rand=",rand,", // pattern waves and/or random"));
    echo(str("<font color='#5500aa', size=2> seed=",seed,", randsize=",randsize,",randSizeY=",randSizeY,", //random seed, random size y strech"));
    echo(str("<font color='#5500aa', size=2> freqX=",freqX,", freqY=",freqY,", ampX=",ampX,",waveSkewX=",waveSkewX,", ampY=",ampY,", waveSkewY=",waveSkewY,", // wave frequenz and amplitude XY"));
    echo(str("<font color='#5500aa', size=2> ampRoundX=",ampRoundX,", rfX=",rfX,",ampRoundY=",ampRoundY,",rfY=",rfY,", // rounded Waveform ⇒ coarse, roundig factor"));
    echo(str("<font color='#5500aa', size=2> versch=",versch,", name=",name,", abs=",abs,", exp=",exp,", expY=",expY,", sinDelta=",sinDelta,", sinDeltaY=",sinDeltaY,"mult=",mult,",); // move wave pattern  show info and abs values, exponent, move sin center waves only"));
}

y=is_undef(y)?x:y;
randSizeY=is_undef(randSizeY)?1/randsize:1/randSizeY;
freqY=is_undef(freqY)?freqX:freqY;
ampY=is_undef(ampY)?ampX:ampY;
waveSkewY=is_undef(waveSkewY)?waveSkewX:waveSkewY;
ampRoundY=is_undef(ampRoundY)?ampRoundX:ampRoundY;
rfY=is_undef(rfY)?rfX:rfY;
expY=is_undef(expY)?exp:expY;
sinDeltaY=is_undef(sinDeltaY)?sinDelta:sinDeltaY;

    
if(name)echo();
if(name&&waves)echo(str(name," Surface λ X/Y=",10/freqX,"/",10/freqY," mm - λ¼=",10/freqX/4,"/",10/freqY/4," mm"));
    
rowl=x; //frame x values
rowly=y;//frame y values

resolution=1/res;//[10,5,2.5,1,0.5,0.25,0.125]
//randSizeY=1/randSizeY;

   
random=rands(-deltaZ,deltaZ,((rowl+1)*(rowly+1)*randSizeY)/min(randsize,1),seed);

/*
z1=0;
z2=0.5; 
alternate=[for(h=[0:y+1])for(i=[0:x+0])h%2?i%2?deltaZ:deltaZ/2:i%2?deltaZ/2:deltaZ];
alternate3=[for(h=[0:y+1])for(i=[0:x+0])h%4?i%3?z1:z2:i%2?z2:z1];   
function alternate2(x,y,z1=0.0,z2=0.5)=x%2?y%2?z1:z2:z2;
//
points0alternativ=[
for(x=[-rowl/2+versch[0]:resolution:rowl/2+versch[0]])
    for(y=[-rowly/2+versch[1]:resolution:rowly/2+versch[1]])
        [x,y,
    //alternate2((x+(rowl/2)),(y+(rowly/2)))]
    //alternate[(x+rowl/2)+(rowl+0.5)*(y+rowly/2)]] 
    alternate3[(x+rowl/2)+(rowl+0)*(y+rowly/2)]] 
    ];
    
*/
    
points0=[
for(x=[-rowl/2+versch[0]:resolution:rowl/2+versch[0]])
    for(y=[-rowly/2+versch[1]:resolution:rowly/2+versch[1]])
        [x,y,
    (rand?random[randSizeY*(round((y+rowly/2-versch[1])/randsize)+round((x+rowl/2-versch[0])/randsize)*rowly)]:0)
    +(waves?abs?
    pow(ampY*abs(sinDeltaY+sin(y*36*freqY+x*36*freqX*waveSkewY)),expY)
    *(mult?pow(ampX*abs(sinDelta+sin(x*36*freqX+y*36*waveSkewX*freqY)),exp):1)
    +(mult?0:pow(ampX*abs(sinDelta+sin(x*36*freqX+y*36*waveSkewX*freqY)),exp))
    +ampRoundX*round(rfX*abs(sin(x*36*freqX+y*36*waveSkewX*freqY)))
    +ampRoundY*round(rfY*abs(sin(y*36*freqY+x*36*freqX*waveSkewY)))
    :
    pow(ampY*(sinDeltaY+sin(y*36*freqY+x*36*freqX*waveSkewY)),expY)
    *(mult?pow(ampX*(sinDelta+sin(x*36*freqX+y*36*waveSkewX*freqY)),exp):1)
    +(mult?0:pow(ampX*(sinDelta+sin(x*36*freqX+y*36*waveSkewX*freqY)),exp))
    +ampRoundX*round(rfX*sin(x*36*freqX+y*36*waveSkewX*freqY))
    +ampRoundY*round(rfY*sin(y*36*freqY+x*36*freqX*waveSkewY))
    //+amplitude4*sin((y*0+x*1)*freqY)
    //+amplitude3*cos((y-x)*freqY)
    :0)]
    ];


resx=rowl*res;// /resolution;
resy=rowly*res;// /resolution;

faces0=[
    for(row=[+0:resx-1])
        for(i=[row*resy-1:(row+1)*resy-2])
            [i+1+row,i+row+2,i+row+3+resy,i+row+2+resy]
        ];
        

points1=[
[-rowl/2+versch[0],-rowly/2+versch[1],-zBase],
[-rowl/2+versch[0],rowly/2+versch[1],-zBase],
[rowl/2+versch[0],-rowly/2+versch[1],-zBase],
[rowl/2+versch[0],rowly/2+versch[1],-zBase],
];
        
end0=len(points0);
faces1=[[end0+3,end0+1,end0+0,end0+2]];
fpointssideA=[for(i=[resy:-1:0])i];
fpointssideB=[for(i=[0:resy+1:resx*(resy+1)])i];
fpointssideC=[for(i=[(resy+1)*(resx+1)-1:-resy-1:resy])i]; 
fpointssideD=[for(i=[len(points0)-resy-1:len(points0)-1])i];    

    
faces2=[concat(fpointssideA,[end0+0,end0+1])];    
faces3=[concat(fpointssideB,[end0+2,end0+0])];
faces4=[concat(fpointssideC,[end0+1,end0+3])];
faces5=[concat(fpointssideD,[end0+3,end0+2])];



points=concat(points0,points1);
faces=concat(faces0,faces1,faces2,faces3,faces4,faces5);


 translate(-versch)Col(6)polyhedron(points,faces,convexity=5);
    
}



module Cring(
id=20,
grad=230,
h=15,
rand=3,
rad=1,
end=1,
txt=undef,
tWeite,
tSize=5,
center=true,
fn=fn,
fn2=36,
help=$helpM
){
center=center==true?1:center==false?0:center;    
tWeite=is_undef(tWeite)?tSize*0.9:tWeite;
    
Tz(center>0?-h/2:0)rotate(center?-grad/2:0){
  rad=min(rad,h/2,rand/2);  
    
    difference(){
        rotate_extrude(angle=grad,$fn=fn,convexity=5)T(id/2)Quad(rand,h,r=rad,center=false,fn=fn2,help=0,name=0);
       if(txt!=undef)Tz(h/2-tSize/2)difference(){
          for(i=[0:len(txt)-1])rotate(grad/2+i*atan(tWeite/(id/2+rand))-(len(txt)-1)/2*atan(tWeite/(id/2+rand)))T(id/2+rand)R(90,0,90)Text(text=txt[i],h=1,cx=true,cz=true,size=tSize);
            Col(4)  cylinder(100,d=id+rand*2-n(1),center=true,$fn=fn);
      }
    }
    if(end==1){    
    T(id/2+rand/2)Pille(l=h,d=rand,rad=rad,center=false,fn=fn2,fn2=fn2/4,name=0);
    rotate(grad)T(id/2+rand/2)Pille(l=h,d=rand,rad=rad,center=false,fn=fn2,fn2=fn2/4,name=0);
    }
    if(end==2){    
    T(id/2+rand/2,0,h/2)R(90)Tz(-rad)Prisma(c1=0,x1=rand,z=rad*2,y1=h,s=rad*2,fnS=fn2,name=0,help=0);
    rotate(grad)T(id/2+rand/2,0,h/2)R(90)Tz(-rad)Prisma(c1=0,x1=rand,z=rad*2,y1=h,s=rad*2,fnS=fn2,name=0,help=0);
    }
}
if(help)
        echo(str("<H3><font color=",helpMColor,">Help Cring(
 id=", id ,",
 grad=",grad ,",
 h=",h,",
 rand=",rand ,",
 rad=",rad ,",
 end=", end ,",
 txt=",txt ,",
 tWeite=",tWeite ,",
 tSize=", tSize,",
 center=", center ,",
 fn=", fn,",
 fn2=",fn2 ,",
 help=$helpM
"));

}



module Stern(e=5,r1=10,r2=5,mod=2,delta=+0,center=1,name=$info,help=$helpM){
    
    star=
    let(schritt=360/(e*mod))
    [for(i=[0:e*mod])i%mod<mod/2+round(delta)?[sin(i*schritt)*r1,cos(i*schritt)*r1]:[sin(i*schritt)*r2,cos(i*schritt)*r2]];
    
    
    abstandR1=2*r1*sin(360/(e*mod));
    abstandR2=2*r2*sin(360/(e*mod));
    hoeheR1=r1-Kathete(r2,abstandR2/2);
    hypR1=Hypotenuse(abstandR2/2,hoeheR1);
    gradR1=2*acos(hoeheR1/hypR1);
    gradR2=2*asin((abstandR1/2)/hypR1);
    sWinkel=360/(e*mod);
    deltaSoll=(floor((mod-1)/2));
    
    rotate((center==-1?180/e:0)-90+(center?sWinkel/4*(mod-(mod%2?1:2))+delta*sWinkel/2:+0))polygon(points=star,convexity=5);
    
    if(name&&delta!=-deltaSoll)Echo(str("Delta für Spitze r1=",-deltaSoll),color="green");
    if(name&&mod==2&&delta==0)echo(str(name," Stern Spitzenabstand r1=",abstandR1," Abstand r2=",abstandR2," Flanke=",hypR1," Winkel r1 =",delta==-deltaSoll?gradR1:gradR1-(sWinkel*(deltaSoll+delta)),"° Winkel r2 =",mod==2?gradR2:undef,"° Schrittwinkel=",sWinkel,"°"));   
    else if (name)echo(str(name," Stern Flanke=",hypR1," Winkel r1 =",delta==-deltaSoll?gradR1:gradR1-(sWinkel*(deltaSoll+delta)),"° Schrittwinkel=",sWinkel,"°"));
    HelpTxt("Stern",["e",e,"r1",r1,"r2",r2,"mod",mod,"delta",delta,"center",center,"name",name],help);
  
}


module Disphenoid(h=15,l=25,b=20,r=1,tx=0,ty=0,tz=0,fn=36,help=$helpM){
    
   points=[
    [-l/2+r,b/2-r+ty,0],
    [-l/2+r,-b/2+r+ty,0],
    [l/2-r,0,h/2-r+tz],
    [l/2-r,0,-h/2+r+tz],
    ];
    
    
    faces=[
    [1,0,2],
    [0,1,3],
    [2,3,1],
    [3,2,0],
    ];



    minkowski(){
        polyhedron(points,faces,convexity=5);
        sphere(r,$fn=fn);
    }
    if(help)echo(str("<H3> <font color=",helpMColor,">Help Disphenoid(
        h=",h," ,
        l=",l,
        " ,b=",b,
        " ,r=",r,
        " ,tx=",tx,
        " ,ty=",ty,
        " ,tz=",tz,
        "help=$helpM);"));
}


module Quad(x=20,y,r,r1,r2,r3,r4,grad=90,grad2=90,fn=fn,center=true,name=$info,messpunkt=false,basisX=0,trueX=false,centerX,help=$helpM){
    
    basisX=is_bool(basisX)?basisX?1:0:is_undef(centerX)?basisX:is_bool(centerX)?centerX?1:0:centerX;
    
    y=is_undef(y)?is_list(x)?x[1]:x:y;
    xNum=is_list(x)?x[0]:x;
    rundung=runden(min(xNum,y)/PHI/2,2);
    r=is_undef(r)?[rundung,rundung,rundung,rundung]:is_list(r)?r:[r,r,r,r];

    r1=is_num(r[0])?r[0]:is_num(r1)?r1:rundung;
    r2=is_num(r[1])?r[1]:is_num(r2)?r2:rundung;
    r3=is_num(r[2])?r[2]:is_num(r3)?r3:rundung;
    r4=is_num(r[3])?r[3]:is_num(r4)?r4:rundung;
    
       
    rf1=1/sin(grad);
    rf2=1/sin(grad2);
    shiftX1=tan(grad-90)*y-r1*2*tan(grad-90);
    shiftX2=tan(grad2-90)*y-r2*2*tan(grad2-90);
    shiftX3=tan(grad-90)*y-r3*2*tan(grad-90);
    shiftX4=tan(grad2-90)*y-r4*2*tan(grad2-90);
    


    // konstante x basis mit Rundung (tangetial punkte) / trueX= reale breite
    bx1L=r3-r3*rf1+shiftX3/2;
    bx1R=r4-r4*rf2-shiftX4/2; 
    bx2L=r1-r1*rf1-shiftX1/2;
    bx2R=r2-r2*rf2+shiftX4/2;
 
    bxL=sign(basisX)*tan(90-grad2)*(y/2);
    bxR=-sign(basisX)*tan(90-grad)*(y/2);    
    x=is_list(x)?trueX?basisX==-1?x[0]-bx2L-bx2R:x[0]-bx1L-bx1R:x[0]-bxL-bxR:trueX?basisX==-1?x-bx2L-bx2R:x-bx1L-bx1R:x-bxL-bxR; 
    trueX1=x+bx1L+bx1R; // real x1 breite
    trueX2=x+bx2L+bx2R; // real x2 breite
    
    p1=-x/2+shiftX1/2-r1*1/tan(grad);
    p2=x/2+shiftX2/2-r2*1/tan(grad2);
    p3=-x/2-shiftX3/2+r3*1/tan(grad);
    p4=x/2-shiftX4/2+r4*1/tan(grad2);
    x1=abs(p3)+abs(p4);   
    x2=abs(p1)+abs(p2);
    
    cTrans=center?
         [basisX==1?-p3+(p3-p4)/2:basisX==-1?-p1+(p1-p2)/2:0,sign(basisX)*y/2]
        :[x/2+shiftX3/2-r3*1/tan(grad),y/2];
     
        
    k1=Kreis(rand=0,r=r1,t=[-x/2+r1*rf1+shiftX1/2,y/2-r1]+cTrans,grad=180-grad,rot=225+45-(180-grad)/2,fn=fn/4);
    k2=Kreis(rand=0,r=r2,t=[x/2-r2*rf2+shiftX2/2,y/2-r2]+cTrans,grad=grad2,rot=-45+45-(180-grad2)/2,fn=fn/4);
    k3=Kreis(rand=0,r=r3,t=[-x/2+r3*rf1-shiftX3/2,-y/2+r3]+cTrans,grad=grad,rot=-225+45-(180-grad)/2,fn=fn/4);
    k4=Kreis(rand=0,r=r4,t=[x/2-r4*rf2-shiftX4/2,-y/2+r4]+cTrans,grad=180-grad2,rot=-315+45-(180-grad2)/2,fn=fn/4);
 
 union(){
     polygon(concat(k1,k2,k4,k3),convexity=5);
     if(messpunkt){
         Pivot([p1,y/2]+cTrans,active=[1,0,0,1,1],size=messpunkt);
         Pivot([p2,y/2]+cTrans,active=[1,0,0,1,1],size=messpunkt);
         Pivot([p3,-y/2]+cTrans,active=[1,0,0,1,1],size=messpunkt);
         Pivot([p4,-y/2]+cTrans,active=[1,0,0,1,1],size=messpunkt);
     }
     
 }
    
  if(r1+r2>abs(trueX2)||r3+r4>abs(trueX1))Echo("Quad x too small or r too big",color="red");  
  if(r1+r1*sin(90-grad)+r3+r3*sin(grad-90)>abs(y)||r2+r2*sin(grad2-90)+r4+r4*sin(90-grad2)>abs(y))Echo("Quad y too small or r too big",color="red");
      
  InfoTxt("Quad",["TangentsizeX1",x1,"sizeX2",x2,"real",str(trueX1,"/",trueX2),"r",r],name);
      
  HelpTxt("Quad",["x",x,"y",y,"r",r,"grad",grad,"grad2",grad2,"fn",fn,"center",center,"name",name,"messpunkt",messpunkt,"trueX",trueX,"centerX",centerX],help);
}


module Linse(dia=10,r=7.07107,name=$info,messpunkt=true,help=$helpM){

InfoTxt("Linse",["Dicke",dick,"Kreisgrad",str(grad,"°")],name);

tx=Kathete(r,dia/2);
grad=2*asin((dia/2)/r);    
dick=2*(r-tx);


   polygon(concat(Kreis(rand=0,r=r,grad=grad,t=[tx,0],rot=180),Kreis(rand=0,r=r,grad=grad,t=[-tx,0]))); 
  if(messpunkt){
      Pivot([tx,0],active=[1,0,0,1,0],size=messpunkt);
      Pivot([0,dia/2],active=[1,0,0,1,1],size=messpunkt);
      Pivot([-tx,0],active=[1,0,0,1,1],size=messpunkt);
      
  }
 HelpTxt("Linse",[
 "dia",dia,
 "r",r,
 "name",name,
 "messpunkt=",messpunkt],
  help);
}

module VorterantQ(size=20,ofs=.5,n=$info){
s=Umkreis(4,size/2-ofs);

k1=Kreis(s,rand=0,grad=90);   
versch=[for(i=[0:len(k1)])[-Inkreis(4,s),0]]; 
offset= [for(i=[0:len(k1)])[ofs*sin(45+i*90/len(k1)),ofs*cos(45+i*90/len(k1))]];
function offsetvert(fn=12)= [for(i=[0:fn])[ofs*sin(-45+i*90/fn),ofs*cos(-45+i*90/fn)+Inkreis(4,s)]];    
linse=concat(k1+versch+offset,-offsetvert(),-k1-versch-offset,offsetvert());
polygon(linse);

if(n)echo(str(n," VQ Radius=",s,"mm - Verschoben um",Inkreis(4,s)-ofs,"mm")); 

}


module GewindeV2(dn=10,s,w=0,g=1,winkel=+60,rot2=0,r1=0,kern,fn=1,detail=fn,spiel=spiel,n=$info,tz=0,preset=0,h=10,translate=[0,0,0],rotate=[0,0,0],d=0,gd=0,r=0,center=true,help=$helpM,p=1.5,endMod=true){

s=is_undef(s)?p:s;//Steigung
p=s;    

 r1=r1?r1:p/sin(winkel/2)/2-0.01;   //overlap preventing
  rh=Kathete(r1,p/2);  //Gangtiefe
       
  
spiel=rot2==0?spiel:0;                  // spiel only for symetrische 
dn=$children?dn+spiel*2:dn;
kern=!is_undef(kern)?kern:dn-2*rh+spiel;

     
function profil(rot=0)=
 0?    vollwelle(fn=1,extrude=-1,x0=+0,h=1,xCenter=1,r=0.2,r2=0.5,l=p-.1) // test vollwelle
   : Kreis(r=r1,rand=+0,fn=fn,grad=winkel,sek=winkel==360?1:0,rot=rot2+180);


function RotEx(rot=0,punkte=profil(rot=60),verschieb=dn/2,steigung=1,detail=detail)=[for(rotation=[0:detail*rot/360])for(i=[0:len(punkte)-1])
    concat((punkte[i][0]+verschieb)*sin(rotation*360/detail),punkte[i][1]+rotation/detail*steigung,(punkte[i][0]+verschieb)*cos(rotation*360/detail))
];


function faces(punkte=RotEx(),fn=len(profil())-1)=[
for(i=[0:fn-2])[0,i+1,i+2],
for(i=[0:len(punkte)-2-fn])[fn+1+i,1+i,+i],
for(i=[0:len(punkte)-2-fn])[fn+i,fn+1+i,+i],
for(i=[1:fn])[len(punkte)-i+0,len(punkte)-i-1,len(punkte)-1]    
];
echo("<H2><font color=red>‼ using old GewindeV2 ‼");
 if(d||gd||r){GewindeV1(d=d,s=s,w=w?w:5,g=g,tz=tz,gd=gd?gd:1.75,fn=fn==1?3:fn,r=r)children();//Kompatibilität
     echo("<H2><font color=red>‼ using old GewindeV1 ‼");
 }
 else if(false)R(90)polyhedron(RotEx(rot=100,steigung=p),faces(punkte=RotEx(rot=100)),convexity=15);   //test for polyhedron only   
 else if(preset==0){
    w=w?w:h/p*360;
     add=center?p/2:0;
    difference(){
        if($children)children();
        translate(translate)rotate(rotate)Tz(-add+tz)intersection(){
           union(){
              Col(6) Polar(g,n=0) difference(){
              R(90)polyhedron(RotEx(rot=w,steigung=p),faces(punkte=RotEx(rot=w)),convexity=15);
                  if(endMod)Tz(h)rotate(-90+w%360-w%(360/detail))T(dn/2)cylinder(p,d=rh*2-spiel,center=true,$fn=4);
                  if(endMod)rotate(-90)T(dn/2)cylinder(p,d=rh*2-spiel,center=true,$fn=4);    
              }
          if(rot2==0)Col(9) Tz(-p/2) rotate(-90)cylinder(w/360*p+p,d=kern,center=false,$fn=detail);   
           }
          if(rot2==0)Col(8) rotate(-90)cylinder(2*w/360*p+p,d=dn-spiel,center=true,$fn=detail);
       }
    } 
    
if(help&&!preset)echo(str("Help Gewinde(dn=",dn,",s=",s,",w=",w,",g=",g,",winkel=",winkel,",rot2=",rot2,", r1=",r1,",kern=",kern,",fn=",fn,",detail=",detail,",spiel=",spiel,",n=",n,",tz=",tz,", preset=",preset,",h=",h,",translate=",translate,",rotate=",rotate,",d=",d,",gd=",gd,",r=",r,",center=",center,",help=$helpM, p=",p,", endMod=",endMod,");"));
    
 
    
if(n)echo(str("Gangtiefe=",rh,"mm - Gangflanke(r1)=",r1,"mm - Steigung=",p,"mm - Höhe=",w/360*p,"mm+",p)); 
if(n)echo(str("<H2>",n,rot2==0?$children?" Innen": " Aussen":" Undefiniertes","gewinde ∅=",dn-spiel," (",dn,") Kern=",kern));
 if(winkel==360)echo(str("<H2><font color=red> ∅ Diameter Warning!"));
 }

else if(preset==1){// ½ Zoll Gewinde
  if($children)  GewindeV2(dn=20.95,w=w,h=h,kern=19,winkel=55,p=1.814286,preset=0,fn=1,translate=translate,rotate=rotate)children();
   if(!$children)  GewindeV2(dn=20.95,w=w,h=h,winkel=55,p=1.814286,preset=0,fn=1,translate=translate,rotate=rotate,help=help);  
    
    echo(str("<H2><b> ½ Zoll Gewinde </b>"));
}

else if(preset==2){// ¾ Zoll Gewinde
  if($children)  GewindeV2(dn=26.44,w=w,h=h,kern=24.5,winkel=55,p=1.814286,preset=0,fn=1,translate=translate,rotate=rotate)children();
   if(!$children)  GewindeV2(dn=26.44,w=w,h=h,winkel=55,p=1.814286,preset=0,fn=1,translate=translate,rotate=rotate);  
    
    echo(str("<H2><b> ¾ Zoll Gewinde </b>"));
}

else if(preset=="M3"){// M3 Gewinde
  if($children)  GewindeV2(dn=3,w=w,h=h,p=.5,preset=0,fn=1,translate=translate,rotate=rotate)children();
   if(!$children)  GewindeV2(dn=3,w=w,h=h,p=.5,preset=0,fn=1,translate=translate,rotate=rotate);  
    
    echo(str("<H2><b> M3 Gewinde </b>"));
}
else if(preset=="M6"){// M6 Gewinde
  if($children)  GewindeV2(dn=6,w=w,h=h,p=1,preset=0,fn=1,translate=translate,rotate=rotate)children();
   if(!$children)  GewindeV2(dn=6,w=w,h=h,p=1,preset=0,fn=1,translate=translate,rotate=rotate);  
    
    echo(str("<H2><b> M6 Gewinde </b>"));
}

}


module Rand(rand=n(1),center=false,fn=fn,delta=false,chamfer=false,help=$helpM){
    
if(!center){ 
    if(rand>0)difference(){
          offset(r=delta?undef:rand,delta=rand,$fn=fn,chamfer=chamfer?true:false)children();
          union(){
            $helpM=0;
            $info=0;
            children();
          }
        }
    if(rand<0)difference(){
          children();
          union(){
            $helpM=0;
            $info=0;
            offset(r=delta?undef:rand,delta=rand,$fn=fn,chamfer=chamfer?true:false)children();
          }
        }
    }
    
if(center)
       difference(){
      offset(r=delta?undef:abs(rand),$fn=fn,delta=abs(rand),chamfer=chamfer?true:false)offset(r=delta?undef:-abs(rand/2),$fn=fn,delta=-abs(rand/2),chamfer=chamfer?true:false)children();
      union(){
          $helpM=0;
          $info=0;
         offset(r=delta?undef:-abs(rand),$fn=fn,delta=-abs(rand),chamfer=chamfer?true:false) offset(r=delta?undef:abs(rand/2),$fn=fn,delta=abs(rand/2),chamfer=chamfer?true:false)children();
      }
    }     
    
    MO(!$children);
    
    HelpTxt("Rand",["rand",rand,"center",center,"fn",fn,"delta",delta,"chamfer",chamfer],help);
}






module Laser3D(h=4,layer=10,var=0.002,name=$info,on=-1){

  if(on==1)for (i=[0:h/layer:h]){
        c=i/h;
  T(z=i/h*var) color([c,c,c]) projection(cut=true)T(z=-i)children();
    }
   
   if(on==-1) for(i=[+0.0:h/layer:h]){
       
        color([i/h,i/h,i/h])T(z=i*+0.01) intersection(){
          T(-500,-500,i) cube([1000,1000,layer]);
          T(z=-i*0.000)  children();
          }
      } 
      
    if(on==0) children();     
    
    T(z=-.48)color([0,0,0])cube([1000,1000,1],true);
    
    MO(!$children);
    InfoTxt("Laser3D",["color resolution=",str(h/layer,"mm")],name);  
    
}



module Ellipse(x=2,y=2,z=0,fn=36,help=$helpM){
    
   for (i=[0:360/fn:359]){
    j=i+360/fn;   
    if($children)  hull(){
           T(sin(i)*x,cos(i)*y,cos(i)*z)rotate(-i)children();   
           T(sin(j)*x,cos(j)*y,cos(j)*z)rotate(-j)children();   
       }
     if(!$children)hull(){
           T(sin(i)*x,cos(i)*y,cos(i)*z)rotate(-i)circle($fn=36);   
           T(sin(j)*x,cos(j)*y,cos(j)*z)rotate(-j)circle($fn=36);   
       }  
       
   }
  MO(!$children);
  if(help)echo(str("<H3><font color='",helpMColor,"'>Help Ellipse(x=",x,",y=",y,",z=",z,",fn=",fn,",help=$helpM);"));
}



module WStrebe(grad=45,grad2,h=20,d=2,d2=0,rad=3,rad2=0,sc=0,angle=360,spiel=spiel,fn=fn,2D=false,center=true,rot=0,help=$helpM){
    
    rad2=rad2?rad2:rad;
    d2=d2?d2:d;
    grad2=is_undef(grad2)?grad:grad2;
    
  if(!2D)R(0,center?0:grad)Tz(center?0:h/2){
      
  rotate(rot)R(180)Halb(1)Tz(-h/2)R(0,-grad2) Strebe(rad=rad2,rad2=rad,d=d2,d2=d,h=h,grad=grad2,single=false,n=0,help=0,2D=0,sc=sc,angle=angle,spiel=spiel,fn=fn); //oben
  Tz(.1)Halb(1)Tz(-h/2-.1)R(0,-grad) Strebe(rad=rad,rad2=rad2,d=d,d2=d2,h=h,grad=grad,single=false,n=0,help=0,2D=0,sc=sc,angle=angle,spiel=spiel,fn=fn);//unten 
  }
  
  
  
  if(2D)R(0,0,center?0:-grad)T(0,center?0:h/2){
  mirror([0,1,0])Halb(1,y=1,2D=true)T(0,-h/2)R(0,0,grad2) Strebe(rad=rad2,d=d2,d2=d,h=h,grad=grad2,single=false,n=0,help=0,2D=2D,sc=sc,angle=angle,spiel=spiel,fn=fn);    
  Halb(1,y=1,2D=true)T(0,-h/2)R(0,0,grad) Strebe(rad=rad,d=d,d2=d2,h=h,grad=grad,single=false,n=0,help=0,2D=2D,sc=sc,angle=angle,spiel=spiel,fn=fn);//unten
  }
 if(help){
    echo(str("<H3><font color='",helpMColor,"' <b>Help WStrebe(grad=",grad,",grad2=",grad2,",h=",h,",d=",d,",d2=",d2,",rad=",rad,",rad2=",rad2," ,sc=",sc,",angle=",angle,",spiel=",spiel,",fn=",fn,",2D=",2D,",center=",center,",rot=",rot,",help=$helpM)")); 
    }  
}



module Strebe(h=20,d=5,d2,rad=4,rad2,sc=0,grad=0,skew=0,single=false,angle=360,spiel=spiel,fn=fn,fn2=fn/4,center=false,name=$info,2D=false,help=$helpM){
    
    rad2=is_undef(rad2)?is_list(rad)?rad[1]:
                            rad:
                   rad2;
    rad=is_list(rad)?rad[0]:rad;
    d2=is_undef(d2)?d:d2;
    skew=skew?skew:tan(grad);
    grad=atan(skew);
    sc=sc?sc:d/(d*cos(grad));
    winkel=atan((single?(h-rad):(h-rad-rad2))/(d2/2-d/2));
    grad1=winkel>0?180-winkel:abs(winkel);//90;//VerbindugsWinkel unten
    grad2=180-grad1;//VerbindugsWinkel oben    
    assert(h>(rad+rad2),"Strebe too short for rad"); 

   if(!2D&&parent_module($parent_modules-1)!="Rundrum")  M(skew,0)Tz(center?-h/2:0)scale([sc,1,1]){
      rotate(-angle/2)rotate_extrude(angle=angle,convexity=5,$fn=fn)Strebe(skew=0,h=h,d=d,d2=d2,rad=rad,rad2=rad2,sc=1,grad=0,single=single,spiel=spiel,fn2=fn2,name=0,2D=2,help=false);
      

    }
    if(name)echo(str("Strebe ",name," Neigungs ∡=",atan(skew),"° center∡",single||rad!=rad2?"~":"=",winkel,"° Scale=",sc," dSkew=",d,"/",d*sc*cos(grad),"-",d2,"/",d2*sc*cos(grad),"mm Parent=",parentList())); 
    
       
 
if (2D||parent_module($parent_modules-1)=="Rundrum")M(skewyx=skew)T(0,center?-h/2:0){
       if(grad1>90) echo(str("<H2><font color='red'>Strebe ∅",d,"mm is d=",(d/2-rad+sin(grad1)*rad)*2));
    if(grad2>90) echo(str("<H2><font color='red'>Strebe ∅",d2,"mm is d2=",(d2/2-rad2+sin(grad2)*rad2)*2));
   
    scale([sc,1])polygon(concat(
    2D==2?[[0,h+spiel]]:single?[[-d2/2,h]]:Kreis(fn=fn2,rand=0,r=rad2,grad=-grad2,rot=+grad2,center=false,sek=true,t=[-d2/2-abs(sin(winkel))*rad2,h-rad2]),
    2D==2?[[+0,h+spiel]]:[[single?-d2/2:-d2/2-rad2,h+spiel]],
    [[single?d2/2:d2/2+rad2,h+spiel]],
    single?[[d2/2,h]]:Kreis(fn=fn2,rand=0,r=rad2,grad=-grad2,rot=0,center=false,sek=true,t=[d2/2+abs(sin(winkel))*rad2,h-rad2]),
    Kreis(fn=fn2,rand=0,r=rad,grad=-grad1,rot=grad1-180,center=false,sek=true,t=[d/2+abs(sin(winkel))*rad,rad]),
    [[d/2+rad,0-spiel]],
    2D==2?[[0,-spiel]]:[[-d/2-rad,0-spiel]],
    2D==2?[[+0,0]]:Kreis(fn=fn2,rand=0,r=rad,grad=-grad1,rot=180,center=false,sek=true,t=[-d/2-abs(sin(winkel))*rad,rad]))
    ,convexity=5)
    ; 
}
HelpTxt("Strebe",["h",h,"d",d,"d2",d2,"rad",rad,"rad2",rad2,"sc",sc,"grad",grad,"skew",skew,"single",single,"angle",angle,"spiel",spiel,"fn",fn,"fn2",fn2,"name",name,"2D",str(2D,"/*2 for halb*/")],help); 
    
        
}


module Bezier(
p0=[+0,+10,0],
p1=[15,-5,0],
p2=[15,+5,0],
p3=[0,-10,0],
w=1,//weighting
max=1.0,
min=+0.0,
fn=50,
ex,//extrude X
pabs=false, //p1/p2 absolut/relativ p0/p3
messpunkt=5,
mpRot,
twist=0,
name=$info,
help=$helpM

){
   mpRot=is_undef(mpRot)?search(["RotEx"],parentList())[0]?true:
                            mpRot:
                    mpRot;
    //echo(search(["RotEx"],parentList())[0],parentList());
  twist=v3(twist);
  messpunkt=$info?messpunkt:0;
  p0=v3(p0);
  p3=v3(p3);  
  p1=v3(pabs?p1*w:v3(p1)*w+p0);  
  p2=v3(pabs?p2*w:v3(p2)*w+p3); 


    if($children){
        $helpM=0;
        $info=0; 
        step=((max-min)/fn);
        for (t=[min:step:max-step]){
            
            $rot=vektorWinkel(Bezier(t,p0,p1,p2,p3),Bezier(t+step,p0,p1,p2,p3))+twist/max*t;
            
            $idx=t;
             hull(){
                translate(Bezier(t,p0,p1,p2,p3))rotate($rot)children();
                union(){
                    $idx=t+step;
                    $rot=vektorWinkel(Bezier(t+step,p0,p1,p2,p3),Bezier(t+step*2,p0,p1,p2,p3))+twist/max*(t+step);
                    translate(Bezier(t+step,p0,p1,p2,p3))rotate($rot)children();
                }
             }   
            
        }
    
}
    if(!$children){
    if (is_undef(ex)) polygon([for (t=[min:((max-min)/fn):(max+(max-min)/fn)])Bezier(t,
            [p0[0],p0[1]],
            [p1[0],p1[1]],        
            [p2[0],p2[1]],       
            [p3[0],p3[1]]        
        )]);
        
    else polygon(concat([[0,p0[1]]],[for (t=[min:((max-min)/fn):(max+(max-min)/fn)])Bezier(t,
            [p0[0]+ex,p0[1]],
            [p1[0]+ex,p1[1]],        
            [p2[0]+ex,p2[1]], 
            [p3[0]+ex,p3[1]]        
        )],[[0,p3[1]]]));        
        
 
    }
    
    if(messpunkt){
        ex=is_undef(ex)?0:ex;
        Pivot(mpRot?[p0[0]+ex,0,p0[1]]:p0+[ex,0,0],messpunkt,txt="p0");
        Pivot(mpRot?[p1[0]+ex,0,p1[1]]:p1+[ex,0,0],messpunkt/2,txt="p1");
        Pivot(mpRot?[p2[0]+ex,0,p2[1]]:p2+[ex,0,0],messpunkt/2,txt="p2");
        Pivot(mpRot?[p3[0]+ex,0,p3[1]]:p3+[ex,0,0],messpunkt,txt="p3");
        %Line(mpRot?[p0[0]+ex,0,p0[1]]:p0+[ex,0,0],mpRot?[p1[0]+ex,0,p1[1]]:p1+[ex,0,0],d=0.15,center=true);
        %Line(mpRot?[p3[0]+ex,0,p3[1]]:p3+[ex,0,0],mpRot?[p2[0]+ex,0,p2[1]]:p2+[ex,0,0],d=.15,center=true);
        
        }
    
    if(name&&!$children)Echo("No Bezier object using polygon!",color="green");

HelpTxt("Bezier",[   
"p0",p0,",
p1",p1,",
p2",p2,",
p3",p3,",
w",w,",/*weighting*/
max",max,",
min",min,",
fn",fn,",
ex",ex,",/*extrude X*/
pabs",pabs,", /*p1/p2 absolut/relativ p0/p3*/
messpunkt",messpunkt,",
mpRot",mpRot,",
twist",twist,"
name",name]
,help);

}


module Line(p0=[0,0,0],p1=[10,10,0],d=.5,center=false,2D=false){
  p0=p0[2]==undef?concat(p0,[0]):p0;
  p1=p1[2]==undef?concat(p1,[0]):p1;
p1t=p1-p0;    
    
x= p1t[0]; y = p1t[1]; z = p1t[2]; // point coordinates of end of cylinder
 
length = norm([x,y,z]);  // radial distance
b = acos(z/length); // inclination angle
c = atan2(y,x);     // azimuthal angle

if(2D)translate(p0)rotate([0,b-90,c])translate([0,center?0:-d/2,0]) square([center?length*2:length,d],center=center?true:false);
else translate(p0)rotate([0, b, c])
    cylinder(h=center?length*2:length,d=d,$fn=8,center=center?true:false);
      
        
}

module LineORG(p0=[0,0,0], p1=[10,10,0], d=.5,center=true) { //from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks 
  
  p0=p0[2]==undef?concat(p0,[0]):p0;
  p1=p1[2]==undef?concat(p1,[0]):p1;
    
 // Find the unitary vector with direction v. Fails if v=[0,0,0].
function unit(v) = norm(v)>0 ? v/norm(v) : undef; 
// Find the transpose of a rectangular matrix
function transpose(m) = // m is any rectangular matrix of objects
  [ for(j=[0:len(m[0])-1]) [ for(i=[0:len(m)-1]) m[i][j] ] ];
// The identity matrix with dimension n
function identity(n) = [for(i=[0:n-1]) [for(j=[0:n-1]) i==j ? 1 : 0] ];

// computes the rotation with minimum angle that brings a to b
// the code fails if a and b are opposed to each other
function rotate_from_to(a,b) = 
    let( axis = unit(cross(a,b)) )
    axis*axis >= 0.99 ? 
        transpose([unit(b), axis, cross(axis, unit(b))]) * 
            [unit(a), axis, cross(axis, unit(a))] : 
        identity(3);   

    v = p1-p0;
    translate(p0)
        // rotate the cylinder so its z axis is brought to direction v
        multmatrix(rotate_from_to([0,0,1],v))
            cylinder(d=d, h=center?norm(v)*2:norm(v), $fn=12,center=center);
}


module Pivot(p0=[0,0,0],size=pivotSize,active=[1,1,1,1,1,1],messpunkt=messpunkt,txt,rot=0,help=false){
    p0=is_num(p0)?[p0,0]:p0;
    size=is_undef(size)?pivotSize:is_bool(size)?pivotSize:size;
    size2=size/+5;
if(messpunkt&&$preview)translate(p0)%union(){
        
      if(active[3])rotate(rot)  color("blue")cylinder(size,d1=.5*size2,d2=0,center=false,$fn=4);
      if(active[2])rotate(rot)  color("green")rotate([-90,0,0])cylinder(size,d1=.5*size2,d2=0,center=false,$fn=4);
      if(active[1])rotate(rot)  color("red")rotate([0,90,0])cylinder(size,d1=.5*size2,d2=0,center=false,$fn=4);   
       if(active[0]) color("yellow")sphere(d=size2*.6,$fn=12);
       //Text
       if(active[4]) color("grey")rotate($vpr)
          //linear_extrude(.1,$fn=1)
       text(text=str(p0," ",rot?str(rot,"°"):"","   "),size=size2,halign="right",valign="top",font="Bahnschrift:style=light",$fn=1);    
       
       if(txt&&active[5])%color("lightgrey")rotate($vpr)translate([0,size/15])//linear_extrude(.1,$fn=1)
         Tz(0.1) text(text=str(txt,"   "),size=size2,font="Bahnschrift:style=light",halign="right",valign="bottom",$fn=1);
     
     HelpTxt("Pivot",[
         "p0",p0,
        "size",size,
        "active",active,
        "messpunkt",messpunkt,
        "txt",txt,
        "rot",rot]
        ,help); 
    }
}


module LinEx(h=5,h2=0,h22,scale=0.85,scale2,twist,twistcap=1,slices,$d,$r=5,grad,grad2,mantelwinkel=0,center=false,rotCenter=false,end=0,fn=12,name=$info,help=$helpM,n){



end=is_bool(end)?end?[1,1]:[0,0]:is_list(end)?end:[end,end];   
name=is_undef(n)?name:n;
twistcap=is_list(twistcap)?twistcap:[twistcap,twistcap];    
$r=is_undef($d)?$r:$d/2;
$d=2*$r;
h22=abs(is_undef(h22)?is_list(h2)?h2[1]:h2:h22);
h2=abs(is_list(h2)?h2[0]:h2);    
hc=h-h2-h22;      

scale2=is_undef(grad2)?
    is_undef(grad)?
    is_undef(scale2)?h22?scale:1:scale2
    :is_list(grad)?is_list($r)?[($r[0]-(h22/tan(grad[0])))/($r[0]),($r[1]-(h22/tan(grad[1])))/($r[1])]:[($r-(h22/tan(grad[0])))/($r),($r-(h22/tan(grad[1])))/($r)]:($r-(h22/tan(grad)))/($r)
    :is_list(grad2)?
        is_list($r)?[($r[0]-(h22/tan(grad2[0])))/($r[0]),($r[1]-(h22/tan(grad2[1])))/($r[1])]:[($r-(h22/tan(grad2[0])))/($r),($r-(h22/tan(grad2[1])))/($r)]:($r-(h22/tan(grad2)))/($r);
scale=h2?is_undef(grad)?scale:
    is_list(grad)?
        is_list($r)?[($r[0]-(h2/tan(grad[0])))/($r[0]),($r[1]-(h2/tan(grad[1])))/($r[1])]:[($r-(h2/tan(grad[0])))/($r),($r-(h2/tan(grad[1])))/($r)]:($r-(h2/tan(grad)))/($r):1;    
    


grad=h2?is_list(scale)?
        is_list($r)?[atan(h2/($r[0]-$r[0]*scale[0])),atan(h2/($r[1]-$r[1]*scale[1]))]:[atan(h2/($r-$r*scale[0])),atan(h2/($r-$r*scale[1]))]
    :atan(h2/($r-$r*scale)):0;
    
grad2=h22?is_list(scale2)?is_list($r)?[atan(h22/($r[0]-$r[0]*scale2[0])),atan(h22/($r[1]-$r[1]*scale2[1]))]:[atan(h22/($r-$r*scale2[0])),atan(h22/($r-$r*scale2[1]))]:atan(h22/($r-$r*scale2)):0;

mantelwinkel=is_undef(twist)?mantelwinkel:atan(twist*PI*$d/360/hc);    
twist=is_undef(twist)?mantelwinkel?360*tan(mantelwinkel)*hc/(2*PI*$r):0:twist;   
slices=is_undef(slices)?$preview?twist?fn:1:round(min(abs(twist)/hc*10,hc/l(2))):slices;
    

rotate(center?0:rotCenter?-twist/2:-twist/2+(twistcap[0]&&hc?-twist/hc*h2:0))
    T(z=center?-h/2:0){
    //Mklon(tz=h/2-h2,rz=-twist/2)linear_extrude(h2,scale=scale,twist=twistcap?twist/(h-h2*2)*h2:0,convexity=5)children();
    union(){
    $helpM=0;
    $info=0;     
    //capoben
    if(h22)T(z=h-h22)rotate(-twist/2)linear_extrude(h22,scale=scale2,twist=twistcap[1]?twist/(hc)*h22:0,convexity=5,slices=slices/hc*h22)children();
    
    //capunten
    if(h2)Tz(h2)rotate(twist/2)mirror([0,0,1])linear_extrude(h2,scale=scale,twist=twistcap[0]?-twist/(hc)*h2:0,convexity=5,slices=slices/hc*h2)children();
    }
    $helpM=help?help:0;
    $info=name?name:0;     
    //center
    Tz(h2)rotate(twist/2)linear_extrude(hc,scale=1,convexity=5,twist=twist,slices=slices,center=false)children();
    
    
    if(end[0]){
        $helpM=0;
        $info=0; 
     rotate(twist/2+(twistcap[0]?twist/(hc)*h2:0))rotate(sign(end[0])>+0?[-90,0,-90]:[-90,0,0]) RotEx(cut=true,grad=180,fn=fn)scale(scale)rotate(sign(end[0])>0?90:0)children();
        }
     if(end[1]){
        $helpM=0;
        $info=0; 
         Tz(h)rotate(-twist/2-(twistcap[1]?twist/(hc)*h22:0))rotate(sign(end[1])>+0?[-90,0,-90]:[-90,0,0])RotEx(cut=true,grad=-180,fn=fn)
        scale(scale2)rotate(sign(end[1])>0?90:0)children();
     }

    }
    MO(!$children);
    
    InfoTxt("LinEx",["core h",str(hc,"mm - twist per mm=",twist/(hc),"°, Fase für $d= ",$d,"mm ist ",grad,"°/",grad2,"° d=",$d*scale,"/",$d*scale2,"mm - r=",$r*scale,"/",$r*scale2,"mm Mantelwinkel für $d/$r=",$d,"/",$r,"mm⇒ ",mantelwinkel,"° twist=",twist,"° slices=",slices)],name); 
    
    Echo(str(name," LinEx Höhe center=",hc,"mm"),color="red",condition=hc<0);
    
    if(is_list(grad2)?$r*tan(min(grad2[0],grad2[1]))<(is_list($r)?[h22,h22]:h22)&&min(grad2[0],grad2[1])<90&&min(grad2[0],grad2[1])>0:$r*tan(grad2)<(is_list($r)?[h22,h22]:h22)&&grad2<90&&grad2>0)Echo(str(name," LinEx Höhe h22=",h22," mm zu groß oder winkel/$r zu klein min=",atan(h22/$r),"° max=",is_list(grad2)?$r*tan(min(grad2[0],grad2[1])):$r*tan(grad2),"mm"),color="red");
        
    if(is_list(grad)?$r*tan(min(grad[0],grad[1]))<(is_list($r)?[h2,h2]:h2)&&min(grad[0],grad[1])<90&&min(grad[0],grad[1])>0:$r*tan(grad)<h2&&grad<90&&grad>0)Echo(str(name," LinEx Höhe h2=",h2," mm zu groß oder winkel/$r zu klein min=",atan(h2/$r),"° max=",$r*tan(grad),"mm"),color="red");    
    
    HelpTxt("LinEx",["h",h,"h2",h2,"h22",h22,"scale",scale,"scale2",scale2,"twist",twist,"twistcap",twistcap,"slices",slices,"$d",$d,"grad",grad,"grad2",grad2,", mantelwinkel",mantelwinkel,"center",center,"rotCenter",rotCenter,"end",end,"fn",fn,"name",name],help);  
    
}


module Achsenklammer(abst=10,achse=3.5,einschnitt=1,h=3,rand=n(2),achsenh=0,fn=fn,help=$helpM){
    
    achse=is_list(achse)?achse:[achse,achse];
    achsenh=is_list(achsenh)?achsenh:[achsenh,achsenh];
    if (achsenh[0])linear_extrude(achsenh[0]+h,convexity=5)T(-abst/2)circle(d=achse[0]+(achsenh[0]<0?.1:0),$fn=fn);
    if (achsenh[1])linear_extrude(achsenh[1]+h,convexity=5)T(abst/2)circle(d=achse[1]+(achsenh[1]<0?0.1:0),$fn=fn);
    
    linear_extrude(h,convexity=5)
    difference(){
        union(){
            //if(achse[0]==achse[1])T((achse[1]-achse[0])/4)Halb(2D=1,y=1)Ring(0,(achse[0]+achse[1])/2+rand*2,abst,cd=0,2D=1,name=0,fn=fn,help=0); else
            T((achse[1]-achse[0])/4)Kreis(d=(achse[0]+achse[1])/2+rand*2+abst,grad=180,rand=0,help=0,name=0,rot=-90);
            T(abst/2)circle(d=achse[1]+rand*2,$fn=fn);
            T(-abst/2)circle(d=achse[0]+rand*2,$fn=fn);
        }
        T(-(achse[1]-achse[0])/4)hull(){
            T(y=-einschnitt*(achse[0]+achse[1])/2)circle(d=abst-((achse[0]+achse[1])/2+rand*2),$fn=fn);
            T(y=einschnitt*(achse[0]+achse[1])/2)circle(d=abst-((achse[0]+achse[1])/2+rand*2),$fn=fn);
        }
        if(achsenh[0]<=0) T(-abst/2)circle(d=achse[0],$fn=fn);
        if(achsenh[1]<=0) T( abst/2)circle(d=achse[1],$fn=fn);
    }
    HelpTxt("Achsenklammer",["abst",abst,"achse",achse,"einschnitt",einschnitt,"h",h,"rand",rand,"achsenh",achsenh,"fn",fn],help);
}

module Rund(or=+0,ir,chamfer=false,fn=fn) {
    ir=is_undef(ir)?is_list(or)?or[1]:or:ir;
    or=is_list(or)?or[0]:or;
    chamfer=chamfer?true:false;
   if(!chamfer)offset(r = or,$fn=fn)offset(r = -or,$fn=fn)
               offset(r = -ir,$fn=fn)offset(r = ir,$fn=fn) 
       children();
     
   
   if(chamfer)offset(delta = or,chamfer=chamfer)offset(delta = -or,chamfer=chamfer)
              offset(delta = -ir,chamfer=chamfer)offset(delta = ir,chamfer=chamfer) 
       children();
MO(!$children);
}




module Ttorus(r=20,twist=360,angle=360,pitch=0,scale=1,fn=fn,help=$helpM){
    
    scale=is_list(scale)?scale:[scale,scale,scale];
    
   for (i=[0:fn-1]){//(i=[0:360/fn:angle-.005]){
    step=angle/fn;
    j=i+1;//j=i+360/fn; 
    $info=i?0:$info;
    $helpM=i?0:$helpM; 
    $idx=i;  
   Color(i/fn) hull(){
        rotate(i*step)translate([r,0,i*pitch/360*step]) rotate([0,i*twist/360*step,0])scale([1,1,1]+(scale-[1,1,1])/fn*(i))children();
        rotate(j*step)translate([r,0,j*pitch/360*step]) rotate([0,j*twist/360*step,0])union(){
            $info=false;
            $helpM=false;
            $idx=j;
            scale([1,1,1]+(scale-[1,1,1])/fn*(j))children();
        }
    }  
   } 
    
MO(!$children);
    
HelpTxt("Ttorus",["
    r",r,
"twist",twist,
"angle",angle,
"pitch",pitch,
"scale",scale,
"fn=",fn],help);    
}



module Kontaktwinkel(winkel=60,d=10,center=true,2D=0,inv=false,name=$info){
grad=-winkel+90;
h=sin(grad)*d/2;
b=sqrt(pow(d/2,2)-pow(h,2));    

  if(!2D){
      if(!inv) intersection(){
            children();
            T(z=center?0:-h)cylinder(center?h*2:1000,d=1000,center=center,$fn=6);
            }
      if(inv) intersection(){
            children();
            difference(){
               cube(1000,center=true);
               T(z=center?0:-h)cylinder(center?h*2:1000,d=1000,center=center,$fn=6);
            }
        } 
    }
  if(2D){
      if(!inv)intersection(){
          children();
          T(center?0:-500,center?0:-h)square([1000,center?h*2:1000],center=center);
          }
      if(inv)intersection(){
          children();
          difference(){
              square(1000);
              T(center?0:-500,center?0:-h)square([1000,center?h*2:1000],center=center);
          }
      }         
          
    }   
    
MO(!$children);
if(name)echo(str("Kontaktwinkel ",n," ∅=",d,"-",winkel,"°- Höhe= ",h," Breite= ",b*2));
}



module Rundrum(x=+40,y,r=10,eck=4,twist=0,grad=90,grad2=90,spiel=0.005,fn=fn,name=$info,help=$helpM){
    // WIP
    r1=is_list(r)?r[0]:r;
    r2=is_list(r)?r[1]:r;
    r3=is_list(r)?r[2]:r;
    r4=is_list(r)?r[3]:r;
    r=is_list(r)?r[0]:r;
    y=is_list(x)?x[1]:is_undef(y)?x:y;
    x=is_list(x)?x[0]:x;
        
    //grad2=grad-20;// WIP
    shift=tan(grad-90)*y;
    grad=grad?grad:shift>0?atan(shift/y):-atan(-shift/y);
    shiftx=shift-r*2*tan(grad-90);
    shiftx2=tan(grad2-90)*y-r*2*tan(grad2-90);
    shiftYLang=Hypotenuse(shiftx,y-2*r);
    shiftYLang2=Hypotenuse(shiftx2,y-2*r);
    if(eck==4&&grad!=90&&name)echo(str(name," Rundrum grad=",grad,"° ShiftX=",shiftx,"mm (+-",shiftx/2,"mm) Lot(x)=",x*sin(grad),"mm"));
    //rx=r?r*(r/(sin(grad)*r)):0;
    function rx(r=r,grad=grad)=r*1/sin(grad);
    

if(eck==4&&twist==0)
    if(grad==90&&grad2==90){
        //Ecken
        T(-x/2+r1,y/2-r1)rotate(90)RotEx(90,fn=fn/4,cut=true)T(r1)children();// R1
        union(){
        $info=false;
        $helpM=false;
        T(x/2-r2,y/2-r2)RotEx(90,fn=fn/4,cut=true)T(r2)children();// R2
        T(-x/2+r3,-y/2+r3)rotate(180)RotEx(90,fn=fn/4,cut=true)T(r3)children();// R3
        T(x/2-r4,-y/2+r4)rotate(-90)RotEx(90,fn=fn/4,cut=true)T(r4)children();// R4
        //Graden
        //X
        T((r1-r2)/2,y/2)R(90,0,90)linear_extrude(x-r1-r2+spiel,center=true,convexity=5)children();
        T((r3-r4)/2,-y/2)R(90,0,-90)linear_extrude(x-r3-r4+spiel,center=true,convexity=5)children();
        //Y
        T(-x/2,(r3-r1)/2)R(90,0,180)linear_extrude(y-r1-r3+spiel,center=true,convexity=5)children();
        T(x/2,(r4-r2)/2)R(90,0,+0)linear_extrude(y-r2-r4+spiel,center=true,convexity=5)children();        
        }
        
    }
else T(-shiftx/2*0){
    //plus x    
    T(x/2-rx(r2,grad2)+shiftx2/2,y/2-r2)rotate(90-grad2)rotate_extrude(angle=grad2,convexity=5,$fn=0,$fa = grad2/(fn/4), $fs = 0.1)Ecke(r2)children();
    union(){
        $helpM=0;
    $info=0;
    T(x/2-rx(r4,grad2)-shiftx2/2,-y/2+r4)rotate(-90)rotate_extrude(angle=180-grad2,convexity=5,$fn=0,$fa = (180-grad2)/(fn/4), $fs = 0.1)Ecke(r4)children(); 
    //minus x   
    T(-x/2+rx(r1)+shiftx/2,y/2-r1)rotate(90)rotate_extrude(angle=180-grad,convexity=5,$fn=0,$fa = (180-grad)/(fn/4), $fs = 0.1)Ecke(r1)children();
    T(-x/2+rx(r3)-shiftx/2,-y/2+r3)rotate(-90)rotate_extrude(angle=-grad,convexity=5,$fn=0,$fa = grad/(fn/4), $fs = 0.1)Ecke(r3)children();  


    //linear x -+   
    T(+x/2-rx((r2+r4)/2,grad2)+shiftx2/2,y/2-r)rotate(90-grad2)T(+r)R(90,0,0)Tz(-spiel/2)linear_extrude(shiftYLang2+spiel,convexity=5,center=false,$fn=fn)children();
    T(-x/2+rx(r1/2+r3/2)-shiftx/2,-y/2+r)rotate(90-grad)T(-r)R(90,0,180)Tz(-spiel/2)linear_extrude(shiftYLang+spiel,convexity=5,center=false,$fn=fn)children();
 
    //linear y -+    
    T(-x/2+rx()+shiftx/2-spiel/2,y/2+0)R(90,0,90)linear_extrude(x-rx(r1)-rx(r2,grad=grad2)+spiel+shiftx2/2-shiftx/2,convexity=5,center=false,$fn=fn)children();
    T(+x/2-rx(grad=grad2)+spiel/2-shiftx2/2,-y/2)R(90,0,-90)linear_extrude(x-rx()-rx(grad=grad2)+spiel-shiftx2/2+shiftx/2,convexity=5,center=false,$fn=fn)children(); 
    }   
    if(2*r>x||2*r>y){
        echo();
            echo(str("<font color='red' size=10>››»!!!«‹‹ ",name," Rundrum WARNUNG !!! Radius zu groß !!!</font>"));
        echo();
        
    }

    if(name) if((2*r==x||2*r==y)&&x!=y)echo(str(name," Rundrum Halbkreis"));
    if(name)  if(2*r==x&&2*r==y)echo(str(name," Rundrum Vollkreis"));
       
    }
  else{
    for(i=[0:360/eck:359.9]){
        $helpM=i?0:$helpM;
        $info=i?0:$info;
        rotate(i)T(Umkreis(eck,x-r))rotate(-180/eck)rotate_extrude(angle=360/eck,$fn=fn,convexity=5)intersection(){
            T(r)rotate((i/(360/eck))*(twist/eck))children();
            translate([0,-150])square(300);
        }
        union(){
            $helpM=0;
            $info=0;
            rotate(i+180/eck)T(x) R(90)linear_extrude(2*Kathete(Umkreis(eck,x-r),x-r)+spiel,center=true,twist=twist/eck,$fn=fn,convexity=5)rotate(+twist/eck+(i/(360/eck))*(twist/eck))children();
        }
    }
    
  }
MO(!$children);

    module Ecke(r=r){
        render()intersection(){
            T(r)children();
            translate([0,-150])square(300);
        }
    }
  
if(help)echo(str("<H3> <font color=",helpMColor,">Help Rundrum(x=",x,",y=",y,",r=",r,",eck=",eck,",twist=",twist,",grad=",grad,", spiel=",spiel,",fn=",fn,",name=",name,",help=$helpM);"));    
}


module Tring(spiel=+0,angle=153,r=5.0,xd=+0.0,h=1.75,top=n(2.5),base=n(4),name=0){
    
   T(0,0,-spiel/2) scale([1.005,1,1]){rotate(-angle/2-180)rotate_extrude(angle=angle)T(r)Trapez(h=h+spiel,x1=base+spiel,x2=top+spiel,x2d=xd,d=+1+spiel,name=name);
   T(0,0,1.25)rotate((360-angle)/2)T(r)R(90)linear_extrude(1,scale=0.7)T(0,-1.25)Trapez(h=h+spiel,x1=base+spiel,x2=top+spiel,x2d=xd,d=+1+spiel,name=name);
   T(0,0,1.25)rotate((360-angle)/-2)T(r)R(90)mirror([0,0,1])linear_extrude(1,scale=0.7)T(0,-1.25)Trapez(h=h+spiel,x1=base+spiel,x2=top+spiel,x2d=xd,d=+1+spiel,name=name);    
   }
}



module Trapez (h=2.5,x1=6,x2=3.0,d=1,x2d=0,fn=36,rad,name=$info,help=$helpM){
  d=is_undef(rad)?d:rad*2;
    
  punkte=[
    [-x2/2+d/2+x2d,h-d/2],
    [x2/2-d/2+x2d,h-d/2],
    [x1/2-d/2,d/2],
    [-x1/2+d/2,d/2],    
  ];  
  if(d) minkowski(){
       polygon(punkte);
      circle(d=d,$fn=fn);
   }
  if(!d)polygon(punkte);
      //v=((x1+d)-(x2-d))/2/h;
      v=((x1+d)-(x2+d))/2/(h-d);
   if(name)echo(str(name," Trapez Steigung= ",v*100,"%-",atan(v),"°")); 
   HelpTxt("Trapez",["h",h,"x1",x1,"x2",x2,"d",d,"x2d",x2d,"fn",fn,"rad",rad],help);    
}


module Prisma(x1=12,y1,z=6,c1=5,s=1,x2,y2,x2d=0,y2d=0,c2=0,vC=[0,0,1],cRot=0,fnC=fn,fnS=36,name=$info,center=false,help=$helpM){
   s=abs(s); 
    helpX1=x1;
    helpY1=y1;
    helpX2=x2;
    helpY2=y2;    
    helpZ=z;
    x=is_list(x1)?x1[0]:x1;
    y=is_list(x1)?x1[1]:is_undef(y1)?x1:y1;
    z=is_undef(x1[2])?z:x1[2];
    
    cylinderh=c1?minVal:0;
    
    x1=c1-s>0?vC[1]?max(x-cylinderh-s,minVal):max(x-c1,minVal):max(x-s,minVal);
    y1=c1-s>0?vC[0]?max(y-cylinderh-s,minVal):max(y-c1,minVal):max(y-s,minVal);
    
    h=vC[0]||vC[1]?c1?max(z-c1,minVal):max(z-s,minVal):c2?minVal:z-s-cylinderh;
    //h=z-s-cylinderh;
    
    cylinderd2=c2?c2:c1;
    
    y2=is_list(x2)?c1-s>0?vC[0]?max(x2[1]-cylinderh-s,minVal):max(x2[1]-c1,minVal):max(x2[1]-s,minVal)
                  :is_undef(y2)?y1:c1-s>0?vC[0]?max(y2-cylinderh-s,minVal):max(y2-c1,minVal):max(y2-s,minVal);    
    x2=is_undef(x2)?x1
                   :is_list(x2)?c1-s>0?vC[1]?max(x2[0]-cylinderh-s,minVal):max(x2[0]-c1,minVal):max(x2[0]-s,minVal):c1-s>0?vC[1]?max(x2-cylinderh-s,minVal):max(x2-c1,minVal):max(x2-s,minVal);
        

CubePoints = [
  [-x1/2,-y1/2,  0 ],  //0
  [ x1/2,-y1/2,  0 ],  //1
  [ x1/2, y1/2,  0 ],  //2
  [-x1/2, y1/2,  0 ],  //3
  [-x2/2+x2d,-y2/2+y2d,  h ],  //4
  [ x2/2+x2d,-y2/2+y2d,  h ],  //5
  [ x2/2+x2d, y2/2+y2d,  h ],  //6
  [-x2/2+x2d, y2/2+y2d,  h ]]; //7
  
CubeFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
  
    translate([0,0,vC[0]||vC[1]?c1?c1/2:s/2:s/2+minVal/2-(center?z/2:0)])minkowski(){
        polyhedron( CubePoints, CubeFaces,convexity=5 );
        rotate(a=90,v=vC)rotate(cRot)cylinder(c2?max(z-s-minVal,minVal):minVal,d1=c1-s,d2=cylinderd2-s,center=c2?false:true,$fn=fnC);
        sphere(d=s,$fn=fnS);
    }
   vx=((x1+s)-(x2+s))/2/(z-s);
   vy=((y1+s)-(y2+s))/2/(z-s); 
   if(name)echo(str(name," Prisma SteigungX/Y= ",vx*100,"/",vy*100,"% – grad=",atan(vx),"/",atan(vy),"°")); 
    if(s>z){echo(" <H1><font color='red'>  »»» ",name," Prisma s>z!««« </font> ");
    echo(); }
    if(s>c1&&c1){echo(str(" <b><font color='red'>  »»» ",name," Prisma s>c1! ⇒ C-Rundung = s ««« </font></b> "));
    echo(); } 
    
    if(help)
        echo(str("<H3><font color=",helpMColor,"> HelpPrisma(x1=",helpX1,",y1=",helpY1,",z=",z,", c1=",c1,",s=",s,", x2=",helpX2,",y2=",helpY2,", x2d=",x2d,",y2d=",y2d,",c2=",c2,", vC=",vC,", cRot=",cRot,", fnC=",fnC,",fnS=",fnS,",name=",name," ,center=",center,",help=$helpM);"));
}

module Sichel(h=1,start=55,max=270,dia=33,radius=30,delta=-1,step=5,2D=false,fn=36,help=$helpM){
  if(!2D) for (i=[start:step:max]){
       j=i+step;
       hull(){
           rotate(i) T(radius+delta*i/max*dia/2)cylinder(h,d=i/max*dia,$fn=fn);
           rotate(j) T(radius+delta*j/max*dia/2)cylinder(h,d=j/max*dia,$fn=fn);
       }
    }
  if(2D) for (i=[start:step:max]){
       j=i+step;
       hull(){
           rotate(i) T(radius+delta*i/max*dia/2)circle(d=i/max*dia,$fn=fn);
           rotate(j) T(radius+delta*j/max*dia/2)circle(d=j/max*dia,$fn=fn);
       }
    }   
  
 if(help)
        echo(str("<H3><font color=",helpMColor,"> Help Sichel(",
", h=",h,
", start=",start,
", max=",max,
", dia=",dia,
", radius=",radius,
", delta=",delta,
", step=",step,
", 2D=",2D,
", fn=",fn,
", help=$helpM")); 

}


module Balg(sizex=16,sizey=16,z=10.0,kerb=6.9,rand=-0.5){
   //Y Falz
   T(z=z+z/2)difference(){
       cube([sizex,sizey,z],true);
       Klon(tx=50-kerb/2+sizex/2)rotate(45) Mklon(tz=-minVal)Kegel(fn=4,d1=Hypotenuse(100,100),d2=Hypotenuse(100-kerb,100-kerb),name=0);
       Mklon(ty=sizey/2+50-kerb/2,mz=0)difference(){
           rotate(45)Mklon(tz=-minVal)Kegel(fn=4,d1=Hypotenuse(100,100),d2=Hypotenuse(100-kerb,100-kerb),name=0);
           Mklon(tx=sizex/2+59.0+rand,mz=0)T(0,-54.4)  Mklon(tz=-minVal,rz=+0)rotate(+0)Kegel(fn=4,d1=Hypotenuse(100,100),d2=Hypotenuse(100-kerb,100-kerb),v=1.4,name=0);
       }
    }
    
   //X falz 
 T(z=z/2)difference(){
     cube([sizex,sizey,z],true);
     Mklon(ty=sizey/2+50-kerb/2,mz=0)rotate(45)Mklon(tz=-minVal)Kegel(fn=4,d1=Hypotenuse(100,100),d2=Hypotenuse(100-kerb,100-kerb),name=0);      
     Mklon(tx=50-kerb/2+sizex/2,mz=0) difference(){
         rotate(45) Mklon(tz=-minVal)Kegel(fn=4,d1=Hypotenuse(100,100),d2=Hypotenuse(100-kerb,100-kerb),name=0);
         Mklon(ty=(sizey/2+59+rand)/1+0,mz=0) T(-54.4)  Mklon(tz=-minVal,rz=+0)rotate(+0)Kegel(fn=4,d1=Hypotenuse(100,100),d2=Hypotenuse(100-kerb,100-kerb),v=1.4,name=0);
     }
 }
}

module Area(a=10,aInnen=0,rInnen=0,h=0,n=$info){
    
   //a=PI*pow(r,2);
   rInnen=aInnen?sqrt(aInnen/PI):rInnen;
    aInnen=aInnen?aInnen:PI*pow(rInnen,2);
   rAussen=sqrt((aInnen+a)/PI); 
    
   if(!h) difference(){
        circle(rAussen);
        circle(rInnen);
    }
   if(h) linear_extrude (h,convexity=5)difference(){
        circle(rAussen);
        circle(rInnen);
    }    
    
    
    if(n)echo(str(n," Durchmesseraussen=",2*rAussen," Innen=",rInnen*2," Fläche=",a," Innen:",aInnen));
    
    
}


module Spirale(grad=400*1,diff=2,radius=10,rand=n(2),n=$info,detail,fn=fn,exp=1,center=false,hull=true,end=2,old=false,help=$helpM){
   detail=fn;//compatibility
   advance=grad/detail; 
    $d=rand;
    
 
points=!$children?center?[
    for(i=[0:fn])RotLang(i*-grad/fn,diff/2/360*grad+radius-rand/2-pow(i*(diff/360*grad)/(fn),exp)),
    for(i=[fn:-1:0])RotLang(i*-grad/fn,diff/2/360*grad+radius+rand/2-pow(i*(diff/360*grad)/(fn),exp))]
    :[// center=false
for(i=[0:fn])RotLang(i*-grad/fn,radius-rand/2-pow(i*(diff/360*grad)/(fn),exp)),
for(i=[fn:-1:0])RotLang(i*-grad/fn,radius+rand/2-pow(i*(diff/360*grad)/(fn),exp))]
    :[0];// $children=true ⇒ deactivate point calculation


if(!$children&&!old)rotate(center?-grad/2:0)union(){
    rotate(-90) polygon(points);
   if(end>0) rotate(0)T((center?diff/2/360*grad:0)+radius-pow(0*diff,exp))circle(d=rand,$fn=36);
   if(end<0||end==2) rotate(grad)T((center?diff/2/360*grad:0)+radius-pow(grad/360*diff,exp))circle(d=rand,$fn=36);
    
}

if(!$children&&old)// compatibility old version
    for(i=[center?-grad/2:0:advance:(center?grad/2:grad)-minVal]){
    j=i+advance;    
        hull(){
        rotate(i)T(radius-pow(i/360*diff,exp))circle(d=rand,$fn=36);
        rotate(j)T(radius-pow(j/360*diff,exp))circle(d=rand,$fn=36); 
        }           
    }
    
if ($children)    for(i=[center?-grad/2:0:advance:(center?grad/2:grad)-minVal]){
    j=i+advance;    
      if(hull)  hull(){
        rotate(i)T(radius-pow(i/360*diff,exp))children();
        rotate(j)T(radius-pow(j/360*diff,exp))children(); 
        } 
      else rotate(i)T(radius-pow(i/360*diff,exp))children();
            
            
    }
 
    lang=(radius*PI+((radius-diff)*PI))/360*grad;
 if(n)echo(str(n," Spirale Länge ca.",lang));
     
 if(help)
        echo(str("<H3><font color=",helpMColor,"> Help Spirale(
 grad=",grad,", 
 diff=",diff,", 
 radius=",radius,",
 rand=",rand,", 
 n=",n,", 
 //detail=",detail,",
 fn=",fn,", 
 exp=",exp,",
 center=",center,", 
 hull=",hull,", 
 end=",end,",
 old=",old,", 
 help=$helpM);"));
}



module ReuleauxIntersect(h=2,rU=5,2D=false){
        
teilradius=rU/(sqrt(3)/3);
rI=teilradius-rU;
if(2D)union()
        {
            Polar(3,n=0)intersection(){
                T(rU)circle(r=rU);
                rotate(120)T(rU)circle(r=rU);        
                }
                
            difference(){        
                circle(r=rU*0.521);    
                Polar(3,rU,n=0)circle(r=rI);
            }
        }        
if(!2D)linear_extrude(height=h,convexity=10,center=true){
    union()
        {
            Polar(3,n=0)intersection(){
                T(rU)circle(r=rU);
                rotate(120)T(rU)circle(r=rU);        
                }
                
            difference(){        
                circle(r=rU*0.521);    
                Polar(3,rU,n=0)circle(r=rI);
            }
        }
    }    
}


module Box(x=8,y=8,z=5,d2=0,c=3.5,s=1.5,eck=4,fnC=36,fnS=24,help=$helpM){
    d2=d2?d2:x;
  T(z=s/2+(z-s)/2)  minkowski(){
        if(eck==4)cube([c>s?x-c:x-s,c>s?y-c:y-s,z-s-.01],center=true);
            else cylinder(h=z-s-.01,d1=c>s?x-c:x-s,d2=c>s?d2-c:d2-s,$fn=eck,center=true);
      if(c>s)cylinder(.01,d=c-s,center=true,$fn=fnC);
        sphere(d=s,$fn=fnS);
    }
    
    if(help)
        echo(str("<H3><font color='",helpMColor,"' <b>Help Box(x=",x,",y=",y,",z=",z,",d2=",d2,",c=",c,",s=",s,",eck=",eck,",fnC=",fnC,",fnS=",fnS,",help=$helpM);"));
}


module Bogendreieck(rU=5,vari=-1,fn=fn,n=$info){//-1  vari minus mehr bauch weniger ecken
    rU=rU;
teilradius=rU/(sqrt(3)/3);
rI=teilradius-rU; 
segment=sqrt(pow(rU,2)-pow(rU/2,2)); 
hoheh= sqrt(pow(teilradius+vari,2)-pow(segment,2));
verschieb= hoheh-rU/2;
    
if(n)echo(str(n," Bogendreieck Teilradius Abweichung von Reuleauxoptimum= ",vari));

     intersection_for(i = [0,120,240]){
         rotate(i)T(verschieb)circle (r=teilradius+vari,$fn=fn);  
    }
}


module Reuleaux(rU=5,n=$info,fn=fn){
  r=rU/(sqrt(3)/3); 
  intersection_for (i=[0,120,240])
                {
                  rotate(i)T(rU)  circle(r=r,$fn=fn);

                } 
  if(n)echo(str(n," Reuleaux rU=",rU," r=",r));              
}


module Tugel(
dia=40,
loch=+24.72,
scaleKugel=1,
scaleTorus=1,
rand,
name=$info,
help=$helpM
){
    
    
    Halb()scale([1,1,scaleTorus])Torus(dia=dia,d=rand?rand:dia/2-loch/2,name=name);
    Halb(1)scale([1,1,scaleKugel])Kugelmantel(d=dia,rand=rand?rand:dia/2-loch/2);
    
    HelpTxt("Tugel",[
    "dia",dia,
    "loch",loch,
    "scaleKugel",scaleKugel,
    "scaleTorus",scaleTorus,
    "rand",rand,
    "name",name,],help);
}




module Vorterantrotor(h=40,twist=360,scale=1,zahn=0,rU=10,achsloch=4,ripple=0,caps=2,caps2=0,capdia=6.5,capdia2=0,screw=1.40,screw2=0,screwrot=60,n=1)
{
    
 capdia2=capdia2?capdia2:capdia;
 caps2=caps2?caps2:caps;
    
 r=rU/(sqrt(3)/3);  
s= h/(rU*PI*2*(twist/360));
    rI=r-rU;
 if(n)echo(str("»»» »»» ",n," Vorterantkreis ∅= ",2*rU,"mm - Teilradius= ",r,"mm Innen∅=",rI*2,"mm  Steigung= ",s*100,"%"," Winkel= ",atan(s),"°" ));  
 if(zahn)
 {
     
     
     Col(3)T(z=h+2*caps)stirnrad(modul=1.5, zahnzahl=zahn, hoehe=1.5, bohrung=achsloch, eingriffswinkel = 20, schraegungswinkel = 0);
 }
 difference()
 {   
        T(z=caps)union()
        {
           if (caps)T(z=h)rotate(-twist) hull()//Endcap oben
            { 
                intersection_for (i=[0,120,240])
                {
                  rotate(i)T(rU)  cylinder(0.01,r=r);

                }
                T(z=caps2){
                    if(!screw2)cylinder(0.01,d=capdia2);
                    if(screw2)rotate(screwrot)intersection_for (i=[0,120,240])
                {
                  rotate(i)T(rU*screw2)  cylinder(0.01,r=r);

                }}
            }
                      T(z=0) hull()//Endcap unten
            { 
               T(z=-0.01) intersection_for (i=[0,120,240])
                {
                  rotate(i)T(rU)  cylinder(0.01,r=r);

                }
                T(z=-caps){
                    if(!screw)cylinder(0.01,d=capdia);
                    if(screw)rotate(screwrot)intersection_for (i=[0,120,240])
                {
                  rotate(i)T(rU*screw)  cylinder(0.01,r=r);

                }}
            } 
            
            
            
         linear_extrude(h,twist=twist,scale=scale,convexity=5)//Läufer
            difference()
            {
                intersection_for (i=[0,120,240])
                {
                  rotate(i)T(rU)  circle(r=r);

                }
                circle(d=achsloch);//centerloch
            }
            
        }
        if(ripple)cylinder(200,d=6,center=true);//center
       if(ripple) Linear(e=50,s=73,x=0,z=1)Torus(+2,2.8,fn2=6,n=0,fn=50);//center ripple
       cylinder(200,d=achsloch,center=true);//center   
       
    }
    
    
} 


module Kassette(r1=2,r2,size=20,h=0,gon=3,fn=fn,fn2=36,r=+0,grad=90,grad2=90,spiel=0.003,mitte=true,sizey=0,basis=1,2D=false,name=$info,help=$helpM)
{
  r2=is_undef(r2)?r1:r2;  
 if(help){
    echo(str("<font color='",helpMColor,"', size=3><b> HELP Kassette(r1=",r1,",r2=",r2,",size=",size,",h=0,gon=",gon,", fn=",fn,",fn2=",fn2,",r=",r,",grad=",grad,",spiel=",spiel,",mitte=",mitte,",sizey=",sizey,", basis=",basis,",2D=",2D,",name=",name,",help=help)"));
    echo("<font color='#5500aa', size=2> r1 r2 size — radius unten, oben und durchmesser");
    echo("<font color='#5500aa', size=2> h gon fn fn2 r — höhenzusatz, ecken, fn, fn2 des profils und eckradius"); 
    echo("<font color='#5500aa', size=2> spiel mitten sizey n— , spielüberlappung Innenpolygon, mitten loch bei gon=2 und y-weite bei gon=4, n=name für Info"); 
 }   
sizey=sizey?sizey:size;

    r1I=min(r1,size/2-2*r2);//unten innen radius when mitte=1
    points=concat(
        Kreis(r=r1,grad=-90,fn=fn2/4,rand=0,rot=-90,center=false,t=[size/2+r1,r1]), //r1 unten
        [[r1+size/2,-basis]], //unten aussen
        [[0,-basis]],//unten mitte
        [mitte?[0,r1+r2+h]:[0,0]],  //oben mitte
        mitte?[[size/2-r2,r1+r2+h]]:Kreis(r=r1I,grad=-90,fn=fn2/4,rand=0,rot=+180,center=false,t=[size/2-r2*2-r1I,r1I]),
        Kreis(r=r2,rot=mitte?0:-90,grad=mitte?90:180,fn=mitte?fn2/4:fn2/2,rand=0,center=false,t=[size/2-r2,h+r1])// r2 oben
        );
 

    if(2D)polygon(points,convexity=5);
    else{
    
    if(gon>2)
      Rundrum(eck=gon,r=r,x=(size-r2*2)/(gon==4?1:2),y=(sizey-r2*2),fn=fn,grad=grad,grad2=grad2,help=0,name=name)intersection(){
        T(-size/2+r2)polygon(points,convexity=5);
         if(mitte) translate([-r,-250])square(500);
      }
    
    if(gon<3)RotEx(help=0,fn=fn)polygon(points,convexity=5);

    if(mitte&&gon>2){
          if(gon!=4)translate([0,0,-basis])rotate(gon==4?45:0)linear_extrude(basis+h+r2+r1,convexity=5)
            Rund(r,fn=fn)circle(r=Umkreis(gon,(size-r2*2))/2+spiel,$fn=gon);
       if(gon==4)translate([0,0,-basis])linear_extrude(basis+h+r2+r1,convexity=5)offset(spiel)Quad(x=size-r2*2,y=sizey-r2*2,grad=grad,grad2=grad2,r=r,help=0,name=0,fn=fn);
      }
    }
if(name)echo(str(is_bool(name)?"":"<H3>",name," Kassette - Höhe=",h+r1+r2,"mm (+",basis," basis)"));
    if(h<0)echo(str("<H2><font color=red>",name," Kassette h=",h,"mm ⇒ NEGATIV!"));

}


module Drehpunkt(x=0,rz=0,rx=0,ry=0,y=0,z=0,messpunkt=messpunkt,help=$helpM)
{
    y=is_list(x)?x[1]:y;
    z=is_undef(x[2])?z:x[2];
    x=is_list(x)?x[0]:x;
    
    translate([x,y,z])rotate([rx,ry,rz])translate([-x,-y,-z])children();
    if(messpunkt)
    {
        if(rz)%color("blue")translate([x,y,z])cylinder(20,d=.5,center=true,$fn=12);
        if(ry)%color("green")translate([x,y,z])rotate([0,0,rz])rotate([90,0,0])cylinder(20,d=.5,center=true,$fn=12);
        if(rx)%color("red")translate([x,y,z])rotate([rx,ry,rz])rotate([0,90,0])cylinder(20,d=.5,center=true,$fn=12);   
        %color("yellow")translate([x,y,z])sphere(d=1,$fn=12);
    }
    MO(!$children);
    
    HelpTxt("Drehpunkt",[
    "x",x,
    "rz",rz,
    "rx",rx,
    "ry",ry,
    "y",y,
    "z",z,
    "messpunkt",messpunkt],
    help);

}


module Rohr(grad=90,rad=5,d=8,l,l1=10,l2=12,fn=fn,fn2=fn,rand=n(2),name=$info,center=true,messpunkt=messpunkt,help=$helpM)
{
    Bogen(grad=grad,rad=rad,l=l,l1=l1,l2=l2,fn=fn,name=name,help=0,center=center,messpunkt=messpunkt)polygon(Kreis(r=d/2,rand=rand,fn=fn2));
    
    HelpTxt(titel="Rohr",string=["grad",grad,"rad",rad,"d",d,"l",l,"l1",l1,"l2",l2,"fn",fn,"fn2",fn2,"rand",rand,"name",name,"center",center,"messpunkt",messpunkt],help=help);
    InfoTxt(name="Rohr",string=concat(rand>0?["ID",d-rand*2]:["OD",d-rand*2],["d",d]),info=name);

}



module Kugelmantel(d=20,rand=n(2),fn=fn,help=$helpM)
{
    difference()
    {
        sphere(d=d,$fn=fn);
        sphere(d=d-2*rand,$fn=fn);
        
    }
    
 if(help)echo(str("<H3> <font color=",helpMColor,">Help Kugelmantel (
   d=",d,
    " ,rand=",rand, 
    " ,fn=",fn,
    " ,help=$helpM);"));
}
    

module Kegelmantel(d=10,d2=5,v=1,rand=n(2),loch=4.5,grad=0,h=0,center=false,fn=fn,name=$info,help=$helpM)
{
    v=grad?tan(grad):v;
  translate([0,0,center?d>d2?(d2-d)/4*v:(d-d2)/4*v:0])  difference()
    {
        Kegel(d1=d,d2=d2,v=v,h=h,name=name,fn=fn);
       //T(z=-.001) Kegel(d1=d-2*rand,d2=0,v=v,n=0);
       if(d2<d)T(z=-rand*v) Kegel(d1=d,d2=0,v=v,name=0,fn=fn);
       if(d<d2)T(z=-d2/2*v+((d2-d)/2*v)+rand*v) Kegel(d1=0,d2=d2,v=v,name=0,fn=fn); 
        cylinder(1000,d=loch,center=true,$fn=fn);
    }
   if(name)echo(str(name," Kegelmantelwandstärke=", sin(atan(v))*rand));
   if(help)echo(str("<H3> <font color=",helpMColor,">Help Kegelmantel (",
    "d=",d,
    " ,d2=",d2,
    " ,v=",v,
   " ,rand=",rand,
   " ,loch=",loch,
   " ,grad=",grad,
   " ,h=",h,
   " ,center=",center,
   " ,fn=",fn,
   " ,name",name,
   " ,help=$helpM"));
    
}




module Gardena(l=+10,r=8.5,ir=4.5,help=$helpM)
{
 HelpTxt("Gardena",["l",l,"r",r,"ir",ir],help);  
    T(z=1)Kehle(rad=1,dia=19.8,fn2=24);
    rotate_extrude(convexity=5,$fn=fn)Rund(.5,fn=24)
    {
        
        //T(8-1.5,23.5)circle(r=1.5);//16 mm rund ende
        T(ir,22.5)Quad(8-ir,2.5,r=[1,2,0,0],center=false,fn=24);//Top
        difference()//Dichtungsnut
        {
        T(ir,15)square([8-ir,7.5]);
        //T(8.0,20.5)circle(d=3.2);  //Dichtnut
        T(8.0,20.5)rotate(90)Quad(3.2,4.5,help=0,grad=101,grad2=79,r=1.40,fn=24);   
        }
        
        difference()//Kehle
        {
            T(ir)square([9.9-ir,15]);
            //%T(5)square([4.9,15]);
            T(17.5,11.50)circle(r=10,$fn=72);
            polygon([[+0,0],[+0,30],[r,0]]);
            
        }
        
        T(6.20,15.0)Halb(2D=true,x=1)rotate(45/2)circle(2.5,$fn=8);//Fase Dichtung
        
       //T(5,15)square([8.5-5,1]);//17mmDichtrand
        
        
        T(r)square([15-r,1]);//30mmRand
        T(r)square([9.9-r,5]);//20mmRand
        difference()
        {
         T(r)mirror([0,1])square([15-r,l]);//30mmKörper
          polygon([[+0,-15],[0,0],[+7+r,-25+r]]);
          polygon([[+13,-10],[+16,-5],[+20,-20]]);  
            
        }
     
        
    }
}


module Kehle(rad=2.5,dia,l=20,angle=360,grad=0,a=90,ax=90,fn=fn,fn2=fn,r2=0,spiel=spiel,center=false,help=$helpM,2D=false,end=false,fase=false,fillet)
{
    fillet=is_list(fillet)?fillet:[fillet,fillet];
    fase=is_bool(fase)?fase?1:0:fase;
    end=is_bool(end)?end?1:0:end;
    angle=grad?grad:angle;
    spiel=is_list(spiel)?spiel:[spiel,spiel];
    center=center?true:false;
    
	if(is_undef(dia)&&l&&!2D){
        difference(){
            linear_extrude(height=l,$fn=fn,convexity=5,center=center)
            {
                difference()
                {
                   translate([-spiel[0],-spiel[1]]) square([sin(-90+ax)*rad+rad+spiel[0],sin(a-90)*rad+rad+spiel[1]]);
                    T(rad,rad)rotate(r2)circle(rad,$fn=fn2);
                }
            }
        if(fase)T(x=rad,y=rad)Tz(center?-l/2:0)Kegel(d2=0,d1=Hypotenuse(rad+spiel[0],rad+spiel[1])*2,fn=fn2);
        if(fase>1)T(x=rad,y=rad)Tz(center?l/2:l)R(180)Kegel(d2=0,d1=Hypotenuse(rad+spiel[0],rad+spiel[1])*2,fn=fn2);
        }
        
    if(is_num(fillet[0]))intersection(){
        Tz(center?-l/2:0)R(45,90)T(0,-fillet[0])RotEx(90,cut=true,fn=fn/360*90)T(fillet[0])rotate(-45)Kehle(2D=true,a=ax,ax=a,fn2=fn2,rad=rad,spiel=spiel); 
        T(-spiel[0],-spiel[1],-500)cube([rad+spiel[0],rad+spiel[1],600]);
    }
    if(is_num(fillet[1]))intersection(){
       Tz(center?l/2:l)R(-45,-90)T(0,-fillet[1])RotEx(90,cut=true,fn=fn/360*90)T(fillet[1])rotate(-45)Kehle(2D=true,a=a,ax=ax,fn2=fn2,rad=rad,spiel=spiel); 
        T(-spiel[0],-spiel[1],l-100)cube([rad+spiel[0],rad+spiel[1],600]);
    }
    
        
        
        
       if(end==2)R(x=-90)T(y=center?0:-l/2) MKlon(ty=l/2)RotEx(grad=90,cut=1,fn=fn)Kehle(a=a,ax=ax,rad=rad,spiel=spiel,2D=true,fn2=fn2);
       if(end==-2)R(x=-90)T(y=center?0:-l/2) MKlon(ty=l/2)R(90,0,90)RotEx(grad=90,cut=1,fn=fn)Kehle(a=ax,ax=a,rad=rad,spiel=spiel,2D=true,fn2=fn2);    
       if(end==1)Tz(center?-l/2:0)R(-90)RotEx(grad=90,cut=1,fn=fn)Kehle(a=a,ax=ax,rad=rad,spiel=spiel,2D=true,fn2=fn2);     
    }
    
    if(2D)difference(){
           translate([-spiel[0],-spiel[1]]) square([sin(-90+ax)*rad+rad+spiel[0],sin(a-90)*rad+rad+spiel[1]]);
            T(rad,rad)rotate(r2)circle(rad,$fn=fn2);
        }
	
	if(!is_undef(dia)&&!2D){	rotate(center?-180-angle/2:0)difference(){
        rotate_extrude(angle=angle,$fn=fn,convexity=5)
            difference()
            {
                T(dia/2)translate([-spiel[0],-spiel[1]])square([sin(-90+ax)*rad+rad+spiel[0],sin(a-90)*rad+rad+spiel[1]]);
                T(dia/2)T(rad,rad)rotate(r2)circle(rad,$fn=fn2);
                if(dia>-rad*2)T(-50,-25)square(50);
            }
          if(fase&&angle)T(dia/2+rad,z=rad)R(-90*sign(dia))Kegel(d2=0,d1=Hypotenuse(rad+spiel[0],rad+spiel[1])*2,fn=fn2);
          if(fase>1&&angle)rotate(angle)T(dia/2+rad,z=rad)R(90*sign(dia))Kegel(d2=0,d1=Hypotenuse(rad+spiel[0],rad+spiel[1])*2,fn=fn2);    
        }


	
	if(angle)rotate(center?-180-angle/2:0){
         if(is_num(fillet[0]))intersection(){// fillet[0]
            T(dia/2,minVal*sign(dia))R(45,0,-90)T(0,-fillet[0])rotate(dia<0?[0,0,90]:[0])RotEx(90,cut=true,fn=fn/360*90)T(fillet[0])rotate(-45)Kehle(2D=true,a=a,ax=ax,fn2=fn2,rad=rad,spiel=spiel); 
            RotEx()T(dia/2)translate([-spiel[0],-spiel[1]])square([rad+spiel[0],rad+spiel[1]]);
    }
        if(is_num(fillet[1]))intersection(){// fillet[1]
            rotate(angle)T(dia/2,-minVal*sign(dia))rotate([135,0,90])T(0,-fillet[1])R(z=dia<0?90:0)RotEx(90,cut=true,fn=fn/360*90)T(fillet[1])rotate(-45)Kehle(2D=true,a=ax,ax=a,fn2=fn2,rad=rad,spiel=spiel); 
            RotEx()T(dia/2)translate([-spiel[0],-spiel[1]])square([rad+spiel[0],rad+spiel[1]]);       
    }   
        
     if(end>0) T(dia/2,+minVal*sign(dia)) rotate(dia<0?0:-90) RotEx(grad=90,cut=1,fn=fn)Kehle(a=a,ax=ax,rad=rad,spiel=spiel,2D=true,fn2=fn2);
      if(end==2) rotate(angle)T(dia/2,-minVal*sign(dia))rotate(dia<0?-90:0) RotEx(grad=90,cut=1,fn=fn)Kehle(a=a,ax=ax,rad=rad,spiel=spiel,2D=true,fn2=fn2); 
     if(end<0) T(dia/2,minVal*sign(dia)) rotate(-90) R(-90,dia<0?-180:-90)RotEx(grad=90,cut=1,fn=fn)Kehle(a=ax,ax=a,rad=rad,spiel=spiel,2D=true,fn2=fn2);
      if(end==-2) rotate(angle)T(dia/2,-minVal*sign(dia))R(dia<0?-180:90)R(y=90) RotEx(grad=90,cut=1,fn=fn)Kehle(a=ax,ax=a,rad=rad,spiel=spiel,2D=true,fn2=fn2);          
    
        
    }
    }
 if(help){
    echo(str("<H3><font color='",helpMColor,"' <b>Help Kehle(rad=",rad,",dia=",dia,",l=",l,",angle=",angle,",grad=",grad,",a=",a,",ax=",ax,", fn=",fn,",fn2=",fn2,",r2=",r2,",spiel=",spiel,",center=",center,",help=$helpM, 2D=",2D, ", end=",end," ,fase=",fase," ,fillet=",fillet,");"));
 } 
		
	
}



module Sinuskoerper
(
h=10,
d=33,
rand=2,
randamp=1,
amp=1.5,
w=4,
randw=4,
detail=3,
vers=0,
fill=0,
2D=0,
twist=0,
scale=1
)
{
 if(!2D)linear_extrude(h,convexity=5,twist=twist,scale=scale)for (i=[0:detail:359.9])
        
    {
        j=i+detail;
        hull()
        {
            rotate(i) T(d/2+amp*sin(i*w))circle(d=rand+randamp*sin((i+vers)*randw),$fn=36);
            rotate(j) T(d/2+amp*sin(j*w))circle(d=rand+randamp*sin((j+vers)*randw),$fn=36);
            if(fill)circle(d=d/2,$fn=36);
            
        }
        
    }
 if(2D)for (i=[0:detail:359.9])
        
    {
        j=i+detail;
        hull()
        {
           rotate(i) T(d/2+amp*sin(i*w))circle(d=rand+randamp*sin((i+vers)*randw),$fn=36);
           rotate(j) T(d/2+amp*sin(j*w))circle(d=rand+randamp*sin((j+vers)*randw),$fn=36);
            if(fill)circle(d=d/2,$fn=36);
        }
        
    }    
}




module Achshalter
(
laenge=30,
achse=+5,
schraube=3,
mutter=5.5,
schraubenabstand=15,
hoehe=8,
fn=fn
)

difference()
{
    union()
    {
        minkowski()
        {
        T(-8+laenge/2-achse/2)cube([laenge+16+achse-schraube,achse+0,hoehe-1],center=true);
            cylinder(1,d=schraube,$fn=fn,center=true);
        }
        cylinder(hoehe,d=achse+10,$fn=fn,center=true);
    }
    T(0)cube([15+achse+schraubenabstand,2,hoehe+1],center=true);//Schlitz
    cylinder(50,d=achse,center=true,$fn=fn);//Motorachse
    R(90)T(z=-10)Twins(20,l=schraubenabstand+achse,d=schraube+2*spiel,center=1);//Schraubenlöcher
    T(-(schraubenabstand+achse)/2,-achse/2)Linear(s=schraubenabstand+achse)R(90)cylinder(5,d=Umkreis(6,mutter+spiel*2),$fn=6);
    //Inkreis(d=mutter+spiel*2);} depreciated
}


module Dreieck(h=10,ha=10,ha2=0,s=1,n=$info,c=0,2D=0,grad=0)
{
   s=grad?tan(grad/2)*2*(sqrt(3)/2):s;  
  //echo(*2);atan(((ha/(sqrt(3)/2)*s)/2)/ha)
    
    
  r=(sqrt(3)/3)*ha/(sqrt(3)/2);
  r2=(sqrt(3)/3)*(ha2?ha2:ha)/(sqrt(3)/2);
 if(!2D)T(c?h/2:0,z=c?ha/2-r:ha-r) R(0,-90) scale([1,s,1])cylinder(h=h,r1=r,r2=r2,$fn=3); 
 if(2D)T(x=c?ha/2-r:ha-r) R(0,0) scale([1,s,1])circle(r=r,$fn=3);    
    
    
   if(n)echo(str("»»» »»» ",n," Dreieck Höhe= ", ha," Breite= ",ha/(sqrt(3)/2)*s," Winkel= ",2*atan(s/2/(sqrt(3)/2))            )); 
}




module GewindeV1(d=20,s=1.5,w=5,g=1,fn=3,r=0,gd=1.75,detail=5,tz=0,n=$info)//depreciated
{
  
    
    difference()
    {
        children();
        color("orange")translate([0,0,tz])for (i=[0:detail:w*360])
            {
                j=i+detail;
                hull()
                {
                    R(z=i)Polar(g,(d-gd)/2,n=0)T(z=i/(360/s))R(90)R(z=r)cylinder(.1,d=gd,$fn=fn);
                    R(z=j)Polar(g,(d-gd)/2,n=0)T(z=j/(360/s))R(90)R(z=r)cylinder(.1,d=gd,$fn=fn);
                }
      
            }
    }
   
    if(n)echo(str("»»» »»» ",n," Gewinde aussen∅= ",d,"mm — Center∅= ",d-gd,"mm"));
    if(r||(fn!=3&&fn!=6)) echo ("<font color='red' size=8> !!! Check Aussendurchmesser !!!</font> ");   
    
}



module Bogen(grad=90,rad=5,l,l1=10,l2=12,fn=fn,center=true,tcenter=false,name=$info,d=3,fn2=fn,ueberlapp=0,help=$helpM,messpunkt=messpunkt,2D=false)
{
    $helpM=0;
    $info=0;
    l1=is_undef(l)?l1-ueberlapp:is_list(l)?l[0]-ueberlapp:l-ueberlapp;
    l2=is_undef(l)?l2-ueberlapp:is_list(l)?l[1]-ueberlapp:l-ueberlapp;
    
    c=sin(abs(grad)/2)*rad*2;//  Sekante 
    w1=abs(grad)/2;          //  Schenkelwinkel
    w3=180-abs(grad);        //  Scheitelwinkel
    a=(c/sin(w3/2))/2;    
    hc=grad!=180?Kathete(a,c/2):0;  // Sekante tangenten center
    hSek=Kathete(rad,c/2); //center Sekante
    bl=PI*rad/180*grad;//Bogenlänge
    
    mirror([grad<0?1:0,0,0])rotate(center?0:tcenter?-abs(grad)/2:+0)T(tcenter?grad>180?hSek+hc:-hSek-hc:0)rotate(tcenter?abs(grad)/2:0) T(center?0:tcenter?0:-rad){
    if(!2D) T(rad)R(+90,+0)Tz(-l1-ueberlapp){
      color("green")   linear_extrude(l1,convexity=5)
            if ($children)mirror([grad<0?1:0,0,0])children();
            else circle(d=d,$fn=fn2);
     //color("lightgreen",.5)   T(0,0,l1)if(messpunkt&&$preview)R(0,-90,-90)Dreieck(h=l1,ha=pivotSize,grad=5,n=0);//Pivot(active=[1,1,1,0]);        
        }
    else T(rad)R(0,+0)T(0,ueberlapp)color("green")T(-d/2)square([d,l1]);
 
    if(grad)if(!2D) rotate_extrude(angle=-abs(grad)-0,$fa = abs(grad)/fn, $fs = 0.3,$fn=0,convexity=5)intersection(){T(rad)
            if ($children)mirror([grad<0?1:0,0,0])children();
                else circle(d=d,$fn=fn2); 
                translate([0,-500])square(1000);
            }
        else rotate(-90) Kreis(rand=d,grad=abs(grad),center=false,r=rad+d/2,fn=fn,name=0,help=0); 
        
     if (!2D)R(z=-abs(grad)-180) T(-rad,ueberlapp)R(-90,180,0){
         color("darkorange")linear_extrude(l2,convexity=5)
            if ($children)mirror([grad<0?1:0,0,0])children();
            else circle(d=d,$fn=fn2);
        
         //color("orange",0.5)if(messpunkt&&$preview)T(0,0,l2)R(0,-90,-90)Dreieck(h=l2,ha=pivotSize,grad=5,n=0);//Pivot(active=[1,1,1,0]);   
        }
     else R(z=-abs(grad)-180) T(-rad,ueberlapp) color("darkorange")T(-d/2)square([d,l2]);
            
    union(){//messpunkt
       color("yellow") Pivot(active=[1,0,0,1],messpunkt=messpunkt); 
       if(grad!=180)color("blue")mirror([0,grad<0?1:0,0]) translate(RotLang(90+grad/2,hc+hSek))Pivot(active=[1,0,0,1],messpunkt=messpunkt); 
       if(grad>180)color("lightblue")mirror([0,grad<0?1:0,0]) translate(RotLang(90+grad/2,-hc-hSek))Pivot(active=[1,0,0,1],messpunkt=messpunkt);     
    }  
    }

    
  if(name&&!$children)echo(str("»»» »»» ",name," Bogen ",grad,"° Durchmesser= ",d,"mm — Innenmaß= ",2*max(rad,d/2)-d,"mm Außenmaß= ",2*max(rad,d/2)+d));
      
  if(name)echo(str(name," Bogen ",grad,"° Radius=",rad,"mm Sekantenradius= ",hSek,"mm — Tangentenschnittpunkt=",hSek+hc,"mm TsSekhöhe=",hc,"mm Kreisstücklänge=",bl," inkl l=",bl+l1+l2,"mm"));
      
  if(!$children&&name&&!2D)Echo("Bogen missing Object! using circle",color="warning");
  
  if(help)echo(str("<font color=",helpMColor," size=3><b>Help Bogen(grad=",grad,",rad=",rad,",l=",l,",l1=",l1,",l2=",l2,",fn=",fn,",center=",center,",tcenter=",tcenter,",name=",name,",d=",d,",fn2=",fn2,",ueberlapp=",ueberlapp,",help=$helpM, messpunkt=",messpunkt,", 2D=",2D,")"));
    
}


module BogenOrg(grad=90,rad=5,d=3,l1=10,l2=12,n=$info,fn=fn,fn2=fn,ueberlapp=-0.001,help=$helpM)//depreciated
{
      color("green")T(rad,ueberlapp)R(-90)cylinder(l1+0.0,d=d,$fn=fn); 
      rotate(-grad/2)Torus(rad,d,a=-grad,n=0,fn=fn2,fn2=fn);
      color("orange")R(z=-grad-180) T(-rad,ueberlapp)R(-90,180,0)cylinder(l2+0.0,d=d,$fn=fn);
  if(n)echo(str("»»» »»» ",n," Bogen ",grad,"° Durchmesser= ",d,"mm — Innenmaß= ",2*max(rad,d/2)-d,"mm Außenmaß= ",2*max(rad,d/2)+d));
      
  if(!$children)Echo("Bogen missing Object! using circle",color="warning");
  
  if(help)echo(str("<font color=",helpMColor," size=3><b>Help Bogen(grad=90,rad=5,d=3,l1=10,l2=12,n=$info,fn=fn,fn2=fn,ueberlapp=-0.001,help=$helpM)"));
}

module Imprint(txt1=1,radius=20,abstand=7,rotz=-2,h=l(2),rotx=0,roty=0,stauchx=0,stauchy=0,txt0=" ",txt2=" ",size=5,font="Bahnschrift:style=bold",name=$info)
{
    str1=str(txt0,txt1,txt2);
    InfoTxt("Imprint",["string",str1],name);
difference(){
    if($children)children();
    for (i=[0:1:len(str1)-1])
    {
       // if(name)echo(str1[i]);
        rotate([0,0,i*abstand])
        translate([0,-radius,0])
        rotate([rotx,roty,rotz])
        linear_extrude(h*2,center=true,convexity=10){
          rotate([stauchx,stauchy,0])
            translate([+0,-0.2])
            mirror([0,1,0])
            text(str1[i],size=size,$fn=45,halign="center",valign="baseline",font=font);
        }
    }
}
}


module W5(kurv=15,arms=3,detail=.3,h=50,tz=+0,start=0.7,end=13.7,topdiameter=1,topenddiameter=1,bottomenddiameter=+2,inv=0)
{

    Polar(e=arms)for (i=[start:detail:end])
    {
        
        
        j=i+detail;
        hull()
        {
            R(z=i*kurv)T(i,0,tz*-2*h/(2*PI*(i)))R(inv*180)cylinder(h/(2*PI*(i)),d1=n(topenddiameter)+i/end*n(bottomenddiameter),d2=n(topdiameter),$fn=fn);
            R(z=j*kurv)T(j,0,tz*-2*h/(2*PI*(j)))R(inv*180)cylinder(h/(2*PI*(j)),d1=n(topenddiameter)+j/end*n(bottomenddiameter),d2=n(topdiameter),$fn=fn);
        }
    }
 

}

fonts=[
"Bahnschrift",
"Alef",
"Amiri",
"Arial",
"Caladea",
"Calibri",
"David CLM",
"David libre",
"Deja Vu Sans",
"Ebrima",
"Echolon",
"Forelle",
"Frank Ruehl CLM",
"Frank Ruhl Hofshi",
"Franklin Gothic Medium",
"Gabrielle",
"Gabriola",
"Gadugi",
"Gentium Basic",
"Gentium Book Basic",
"Georgia",
"Impact",
"Ink Free",
"Liberation Mono",
"Liberation Sans",
"Liberation Sans Narrow",
"Liberation Serif",
"Linux Biolinum G",
"Linux Libertine Display G",
"Linux Libertine G",
"Lucida Console",
"Noto Sans",
"OpenSymbol",
"Palatino Linotype",
"Politics Head",
"Reem Kufi",
"Rubik",
"SamsungImagination",
"Segoe Print",
"Segoe Script",
"Segoe UI",
"SimSun",
"Sitka Banner",
"Sitka Display",
"Sitka Heading",
"Sitka Small",
"Sitka Subheading",
"Sitka Subheading",
"Sitka Text",
"Source Code Pro",
"Source Sans Pro",
"Source Serif Pro",
"Tahoma",
"Times New Roman",
"Trebuchet MS",
"Unispace",
"Verdana",
"Yu Gothic",
"Yu Gothic UI",
"cinnamon cake",
"gotische",
"Webdings","Wingdings","EmojiOne Color",
];

styles=[

"Condensed",
"Condensed Oblique",
"Condensed Bold",
"Condensed Bold Oblique",
"Condensed Bold Italic",
"SemiCondensed",
"SemiLight Condensed",
"SemiLight SemiCondensed",
"SemiBold SemiCondensed",
"SemiBold Condensed",
"Light Condensed",
"Light SemiCondensed",
"SemiLight",
"Light",
"ExtraLight",
"Light Italic",
"Bold",
"Bold SemiCondensed",
"Semibold",
"Semibold Italic",
"Bold Italic",
"Bold Oblique",
"Black",
"Black Italic",
"Book",
"Regular",
"Italic",
"Medium",
"Oblique",
];


module Text(text="»«",size=5,h,cx,cy,cz,center=0,spacing=1,fn=24,radius=0,rot=[0,0,0],font="Bahnschrift:style=bold",style,help=$helpM,name)
{
    h=is_undef(h)?size:h;
    cx=center?is_undef(cx)?1:cx:is_undef(cx)?0:cx;
    cy=center?is_undef(cy)?1:cy:is_undef(cy)?0:cy;
    cz=center?is_undef(cz)?1:cz:is_undef(cz)?0:cz;
   
    font=is_num(font)?fonts[font]:font;
    style=is_string(style)?style:styles[style];
    fontstr=is_undef(style)?font:str(font,":style=",style);
 
 if(is_num(text)||text)if(!radius){   
    if(h)    
    rotate(rot)translate([0,0,cz?-abs(h)/2:h<0?h:0]) linear_extrude(abs(h),convexity=10){
    text(str(text),size=size,halign=cx?"center":"left",valign=cy?"center":"baseline",font=fontstr,spacing=spacing,$fn=fn);
    }
    else rotate(rot)translate([0,0,cz?-h/2:0])text(str(text),size=size,halign=cx?"center":"left",valign=cy?"center":"baseline",spacing=spacing,font=fontstr,$fn=fn); 
    }
else for(i=[0:len(str(text))-1])rotate(center?gradB((size*spacing)/2*(len(str(text))-1),radius):0)rotate(gradB(size*spacing,radius)*-i)
    if(h)    
    translate([0,radius,0])rotate(rot)Tz(cz?-abs(h)/2:h<0?h:0) linear_extrude(abs(h),convexity=10){
    text(str(text)[i],size=size,halign=true?"center":"left",valign=cy?"center":"baseline",font=fontstr,$fn=fn);
    }
    else  translate([0,radius,cz?-h/2:0])rotate(rot)text(str(text)[i],size=size,halign=true?"center":"left",valign=cy?"center":"baseline",font=fontstr,$fn=fn); 
    
    
 if(name)echo(str("<b>",name," Text font=",font," — style=",style));   
        
 if(help)echo(str("<font color=",helpMColor," size=3><b>Help Text(",
"text=&quot;",text,"&quot;",
", size=",size,
", h=",h,"/*0 for 2D*/",
", cx=",cx,
", cy=",cy,
", cz=",cz,
", center=",center,
", spacing=",spacing,
", fn=",fn,
", radius=",radius, 
", rot=",rot,
", font=&quot;",font,"&quot;",
 ",style=&quot;",style,"&quot;",
 ",help=$helpM);"));
 
}



module Bitaufnahme(l=10,star=true,help=$helpM)
{
 if(star){
    linear_extrude(l,scale=.95,convexity=5){
        if(star==true||star==1)Rund(1,fn=36)Polar(2)circle(4.6,$fn=3);
        if(star==2)WStern(6,r=3.5,fn=6*10,help=0,r2=3.1);
        }
    if(star==2)T(z=l){
     Tz(-0.30)scale([1,1,0.60]) sphere(d=5.8,$fn=36);
     linear_extrude(1.00,scale=0.56,convexity=5)scale(.95)WStern(6,r=3.5,fn=6*10,help=0,r2=3.1);
        }
   else T(z=l){
     Tz(-0.29)scale([1,1,0.6]) sphere(d=5.3,$fn=36);
     linear_extrude(0.80,scale=0.56,convexity=5)scale(.95)Rund(1,fn=36)Polar(2)circle(4.6,$fn=3);
        
        
    }
 }
 if(!star){hull()
        {
            cylinder(l,d1=Umkreis(6,6.3),d2=Umkreis(6,6.1),$fn=6);
            T(z=l)R(0)sphere(d=Umkreis(6,5.5),$fn=36);
        }
        
       T(z=-.01)color("red")Kegel(d1=Umkreis(6,6.5),d2=Umkreis(6,6.1),v=+43.31,fn=6,name=0); 
    }
    
  HelpTxt("Bitaufnahme",["l",l,"star",star],help);  
}


module Luer(male=true,lock=true,slip=true,rand=n(2),help=$helpM)
{
    
    if(help)echo(str("<H3> <font color=",helpMColor,"><b>Help Luer (",
        "male=",male,
        ", lock=",lock,
        ", slip=",slip,
        ", rand=",rand,
        ", help=$helpM);"        
    ));
    //show=41; 6% nach DIN
    //*R(180)T(z=-73.5)color("red")cylinder(100,d1=0,d2=6,$fn=fn);//Eichzylinder 6%
    //*T(z=+1.0)color("green")cylinder(5.8,d1=4.35,d2=4.0,$fn=fn);//referenz gemessen
    
    d=4.5;
    
    if (male)
    {
        if(slip)
        {
            translate([0,0,lock?0:-1])difference()
            {
                Kegel(d1=lock?d:d+0.06,d2=4,v=+33.3,name=0);
                translate([0,0,-0.01])Kegel(d1=d-rand*2,d2=0,v=+33.3,name=0);
                echo(str("»»»  »»» Luer uses Kegel(d1=",d,",d2=4,v=+33.3);"));
            }
            intersection()
            {
                Ring(1,0.75,5.7,name=0);
                Kegel(d2=4,d1=6.0);
            }
        }
        
        
        if (lock)
        {
         //T(z=6)Gewinde(d=8.85,w=1.4,s=5.5,g=2,gd=Umkreis(4,1.3),fn=5,r=36,tz=-6.4,name=0,new=false)R(180)Ring(6,1.9,10.2,name="Luerlock");// OLD
         intersection(){
            Gewinde(tz=-1.75,dn=8,kern=6.75,innen=true,breite=0.5,winkel=75,g=2,p=5.5,wand=0.75,h=10,new=true,center=+0,cyl=1,name=0); 
            cylinder(6,d=20);
         }  
            difference()
            {
                Ring(0.5,2.5,9.5,name=0);
                translate([0,0,-0.15]) Kegel(d2=4,d1=6.0,name=0);
            }
        }
    }
    
    if (!lock&&!slip)color("orange")cylinder(10,d=10.5,$fn=fn);
    
    if (!male)
    {
      
        T(z=0)rotate(360/5.5*0.5)difference()
        {
        union()
            {
               if(lock)Halb()Gewinde(dn=7.8,p=5.5,g=2,winkel=75,kern=6,grad=200,start=fn/6,name=0,new=true,center=1,tz=+0);// rotate(360/5.5*0.3)Gewinde(d=7.8,w=0.5,s=5.5,g=2,gd=1.2,fn=5,r=36,tz=-0.7,name=0);
               if(slip) cylinder(10,d=6);//Ring  (10,n(2),6,name=0);
            }
            translate([0,0,-0.1])Kegel(d1=4.45,d2=2.0,v=+33.3,name=0);
            //mirror([0,0,1])cylinder(5,d=12);
        
        }
        
    }

}




module Knochen(l=+15,d=3,d2=5,b=0,fn=fn)

{
    f=50/fn*0.3;
    function m(x)=d+pow(1.5,x);
    for(i=[-l:f:+5])
    {
        hull()
        {
        R(i*b)T(z=i)scale([d2/m(i),1,1])R(i*b)cylinder(.01,d=m(i),$fn=fn);
        R((i+f)*b)T(z=i+f)scale([d2/m(i+f),1,1])R((i+f)*b)cylinder(.01,d=m(i+f),$fn=fn);
        }
    }

}

            module Aussenkreis(h=5,d=5.5,eck=6,kreis=0,fn=150,n=1)//misleading depreciated
            {
                echo("!!!!!!!!!!!!!!!!!! Renamed Inkreis");
                Inkreis(h=h,d=d,eck=eck,kreis=kreis,fn=fn,n=n);
                echo("!!!!!!!!!!!!!!!!!! Renamed USE Inkreis");
            }



            module Inkreis(h=5,d=5.5,eck=6,kreis=0,fn=fn,n=$info)//depreciated
            {
                 echo("<font color='red'size=10>!!!!!!!!!!!!!!!!!! Don't use — depreciated!!<font color='blue'size=7> - use functions Inkreis or Umkreis </font></font>");
                if(eck==8){
                    a=d*(sqrt(2)-1);

                    R(z=180/8)cylinder(h,r=a*sqrt(1+(1/sqrt(2))),$fn=kreis?fn:eck);  
                }  
                
                if(eck==6)cylinder(h,d=Umkreis(6,d),$fn=kreis?fn:eck);
                
                if(eck==4)R(z=45)cylinder(h,r=sqrt(2*pow(d/2,2)),$fn=kreis?fn:eck);
                if(eck==3)R(z=0)cylinder(h,r=d,$fn=kreis?fn:eck);
                
                if(n)echo(str("»»» »»» ",n," ",eck,"-eck Inkreis∅= ",d));
            }

module DGlied0(l1=12,l2=12,la=0,d=3,spiel=.5,rand=n(1.5),freiwinkel=20)
{
    Glied(l1,la=la,spiel=spiel,d=d,rand=rand,freiwinkel=freiwinkel);
    mirror([0,1,0])Glied(l2,la=la,spiel=spiel,d=d,rand=rand,freiwinkel=freiwinkel);
}

module DGlied1(l1=12,l2=12,la=0,d=3,spiel=.5,rand=n(1.5),freiwinkel=20)
{
    mirror([+0,1,0])T(0,-l1)Glied(l1,la=la,spiel=spiel,d=d,rand=rand,freiwinkel=freiwinkel);
    T(0,-l2)Glied(l2,la=la,d=d,spiel=spiel,rand=rand,freiwinkel=freiwinkel);
}



/*
Schnitt(center=true,z=3){
Glied(l=31,d=3,la=+0);
rotate(20+180)T(0,-31)Glied(l=31,d=3,la=+0);
}
*/

module Glied(l=12,spiel=0.5,la=+1.5,fn=20,d=3,h=5,rand=n(1.5),freiwinkel=20,name=0,help=$helpM)

{
    hFreiraum=h/2;
    hSteg=h/2-n(1);
    $info=false;
    $helpM=false;
    
    HelpTxt("Glied",[
        "l",l,
    "spiel",spiel,
    "la",la,
    "fn",fn,
    "d",d,
    "h",h,
    "rand",rand,
    "freiwinkel",freiwinkel,
    "name",name],help);
    
    T(y=l,z=h/2)Pille(l=hSteg,d=d+1,rad=.8,fn=fn);//Torus(1.2,1.7,fn=fn,n=name);
        if (messpunkt)
        {
            %color ("blue")translate([0,l,0.1])R(z=180/12)cylinder(5, d1=1,d2=1,$fn=12,center=true);//messachse1
            %color("red")cylinder(5, d1=1,d2=1,$fn=12,center=true);//messachse2
        }
        
        
        T(0,l)//kopfstück
        {
            lkopf=l-(d-.5)/tan(freiwinkel)+la-2;
            
            T(0,-lkopf/2-la,h/2) minkowski()
            {
                cube([d-2*0.8+.25,lkopf-2*0.8,hSteg-2*.8],true);
                sphere(0.8,$fn=fn);
            } 
            cylinder(h,d=d,$fn=48);//Achse!
        }
   difference()
   {
       T(0,0,h/2)hull()//Ringanker
      {
               T(0,l/2+la/2-d/2) minkowski()
        {
            cube([max(d-2*.8-.5,.1),l+la-2*.8-d,h-0.8*2],true);
            sphere(0.8,$fn=fn);
        } 
               T(0,l -d/2 -rand-spiel+la) minkowski()// spitze
        {
            cube([max(d-2*.8-.5,.1),0.1,+0.01],true);
            sphere(0.8,$fn=fn);
        } 

        
      } 
       
        
        
        
        cylinder(500,d=d+2*spiel,$fn=fn,center=true);
        Freiwinkel();
        Tz(h/2)Pille(l=hSteg+n(1),d=d+1+2*spiel,rad=1,fn=fn); 
    }
    
    T(0,0)union()//B ring
    {
        difference()
        { 
            union()
            {
                Ring(h,rand,d+2*spiel,cd=-1,name=name);
                //T(0,3.2)R(z=33)cylinder(5,d=3,$fn=3);
                
            }
            Tz(h/2)cylinder(hSteg+spiel,d=d+rand*2+2*spiel,center=true);//Pille(l=hSteg+n(1),d=d+rand*2+2*spiel +1,rad=1,fn=fn); 
            color("red")Freiwinkel(); 
                         /*     * T(+2.9,-1.40,2.5)R(z=46)minkowski()
                            {
                                cube([5,+5,1.0],true);
                                sphere(1.0,$fn=fn);
                            }
                                
                            *mirror([1,0,0])  T(+2.9,-1.40,2.5)R(z=46)minkowski()
                            {
                                cube([5,+5,1.0],true);
                                sphere(1.0,$fn=fn);
                            }
           */
            
        }
        
        /*T(0,+5.2,2.50)minkowski()
        {
            cube([0.6,+6.0,4],true);
            sphere(.5,$fn=fn);
        }  */
        
    }
   
 module Freiwinkel(w=freiwinkel+90)//Glied only
 T(0,+0.5){
  R(z=+w) T(+0,+25-d/2,h/2)minkowski()
            {
                cube([200,+50-.8*2,hFreiraum-2*.8],true);
                sphere(0.8,$fn=fn);
            }    
  R(z=-w) T(+0,+25-d/2,h/2)minkowski()
            {
                cube([200,+50-.8*2,hFreiraum-2*.8],true);
                sphere(0.8,$fn=fn);
            }      

 }   
    
    
}


module Freiwinkel(w=60,h=1)
 T(0,+1.0){
  R(z=w/2-90) T(-6,+0,2.0)minkowski()
            {
                cube([20,5,h],false);
                sphere(0.8,$fn=fn);
            }    
   R(z=-w/2+90) T(-14,+0,2.0)minkowski()
            {
                cube([20,5,h],false);
                sphere(0.8,$fn=fn);
            }      

 }


module PilleOLD(l=10,d=5,fn=fn,fn2=36,center=true,n=$info,s=0,rad,rad2,loch=false,help=$helpM)
{
 //rotate_extrude()Halb(2D=true)Strebe(h=10,rad=+2,d=-4,2D=true);
    
   // if(rad>d/2-.001||rad2>d/2-.001)echo("<font color=red> Radius limited to d/2");
 rad=is_undef(rad)?d/2:d>0?min(rad,d/2):max(rad,d/2); 
 rad2=is_undef(rad2)?rad:min(rad2,d/2);    
  d=s?s:d>0?max(d,rad*2):min(rad*2,d); //abwärts compabilät
    
 if(!loch)Tz(center?-l/2:0)rotate_extrude(convexity=5,$fn=fn)polygon(concat(
     
    Kreis(rand=0,grad=90,r=rad2,center=false,rot=0,t=[d/2-rad2,l-rad2],fn=fn2/4),
    Kreis(rand=0,grad=90,r=rad,rot=+90,center=false,t=[d/2-rad,rad],fn=fn2/4),     
    [[0,0]],
    [[0,l]]
    
    ),
    //paths=[[for(i=[0:floor(fn/4)])i,for(i=[floor(fn/2)+1:-1:floor(fn/4)+1])i,floor(fn/2)+2,floor(fn/2)+3]],
    convexity=5
    );
 
 //if(fn%4)echo("<font size=7 color=red>FN nicht teilbar durch 4");
 
 if(loch)Tz(center?-l/2:0)rotate_extrude(convexity=5,$fn=fn)polygon(concat(
    Kreis(rand=0,grad=90,r=rad,rot=+90,center=false,t=[d/2-rad,rad],fn=fn2/4),//unten 
    Kreis(rand=0,grad=90,r=rad2,center=false,rot=0,t=[d/2-rad2,l-rad2],fn=fn2/4)//oben
    
    ),
    //paths=[[for(i=[0:floor(fn/4)])i,for(i=[floor(fn/2)+1:-1:floor(fn/4)+1])i]],
    convexity=5 
    );    

    if(n)echo(str("»»» »»» ",n," Pille Länge= ",l," sphere r= ",rad,"/",rad2," Durchmesser=",d));
    if(2*rad>l)echo(str("<H1><font color=red>∅>l ",n," Pille Länge= ",l," sphere∅= ",d)); 
     
  if(help)echo(str("<H3><font color=",helpMColor,">Help Pille(l=",l,", d=",d,", fn=",fn,", fn2=",fn2,", center=",center,",n=",n,", s=",s,", rad=",rad,",rad2=",rad2,", loch=",loch,", help=$helpM);"));
    
}


module Torus(trx=+6,d=4,a=360,fn=fn,fn2=38,r=0,grad=0,dia=0,center=true,end=0,gradEnd=90,trxEnd=0,endRot=0,endspiel=+0,name=$info,help=$helpM)
    rotate(grad?0:-a/2){
    end=is_undef(spheres)?is_bool(end)?end?-1:0:end:spheres;//compatibility
    $d=d;
    $r=d/2;   
    endRot=is_list(endRot)?endRot:[endRot,endRot];
    trx=dia?dia/2-d/2:trx;    
    a=grad?end==-1&&!$children?grad-(asin($r/trx)*2)*sign(grad):grad:end==-1&&!$children?a-(asin($r/trx)*2)*sign(a):a;
    grad=grad?grad:a;    
rotate(end==-1&&!$children?(asin($r/trx))*sign(grad):0){
   translate([0,0,center?0:d/2]) RotEx(grad=a,fn=fn,cut=1,help=false)
                if($children)T(x=trx)R(0,0,r)children();
                else T(x=trx)R(0,0,r)circle(d=d,$fn=fn2);

    if(end&&a!=360&&!trxEnd){
        if($children){
            rotate(a+endspiel*sign(grad))translate([trx,0,center?0:d/2])scale([1,abs(end),1])R(0,endRot[1])RotEx(cut=sign(end*grad),grad=180*sign(end),fn=fn/2,help=false)rotate(endRot[1])children();
            rotate(+0)translate([trx,0,center?0:d/2])rotate(180)scale([1,abs(end),1])R(0,-endRot[0])RotEx(cut=sign(end*grad),grad=180*sign(end),fn=fn/2,help=false)rotate(endRot[0])children();  
        }
        else{
        rotate(a-sign(grad)*minVal)translate([trx,0,center?0:d/2])scale([1,abs(end),1])R(90)Halb(sign(grad)>0?1:0)sphere(d=d,$fn=fn2);
        rotate(sign(grad)*minVal)translate([trx,0,center?0:d/2])scale([1,abs(end),1])R(90)Halb(sign(grad)>0?0:1)sphere(d=d,$fn=fn2);
        }
    }
    
    if(trxEnd)translate([0,0,center?0:d/2]){ // End Ringstück
        if($children){
        T(trx-trxEnd)rotate(gradEnd*sign(-trxEnd)){
            RotEx(grad=gradEnd*sign(trxEnd),cut=+0,fn=fn/360*gradEnd)T(trxEnd)children();
            if(end)translate([trxEnd,0,0])rotate(180)scale([1,abs(end),1])R(0,-endRot[0])RotEx(cut=sign(end*gradEnd),grad=180*sign(gradEnd*end),fn=fn/4,help=false)rotate(endRot[0])children();
            }
       rotate(180+grad)T(-trx+trxEnd)rotate(180){
            RotEx(grad=gradEnd*sign(trxEnd),cut=+0,fn=fn/360*gradEnd)T(trxEnd)children();
            if(end)rotate(gradEnd*sign(trxEnd))translate([trxEnd,0,0])scale([1,abs(end),1])R(0,endRot[1])RotEx(cut=sign(end*gradEnd),grad=180*sign(gradEnd*end),fn=fn/4,help=false)rotate(endRot[1])children();
            } 
        }
        else{
            T(trx-trxEnd)rotate(gradEnd*sign(-trxEnd)){
            RotEx(grad=gradEnd*sign(trxEnd,fn=fn/360*gradEnd),cut=+0)T(trxEnd)circle(d=d,$fn=fn2);
            if(end)translate([trxEnd,0,0])rotate(180)scale([1,abs(end),1])RotEx(cut=sign(end*gradEnd),grad=180*sign(gradEnd*end),fn=fn/8,help=false)circle(d=d,$fn=fn2);
            }
       rotate(180+grad)T(-trx+trxEnd)rotate(180){
            RotEx(grad=gradEnd*sign(trxEnd),cut=+0,fn=fn/360*gradEnd)T(trxEnd)circle(d=d,$fn=fn2);
            if(end)rotate(gradEnd*sign(trxEnd))translate([trxEnd,0,0])scale([1,abs(end),1])RotEx(cut=sign(end*gradEnd),grad=180*sign(gradEnd*end),fn=fn/8,help=false)circle(d=d,$fn=fn2);
            }  
        }    
    }
}
    InfoTxt("Torus",["Innen∅",2*trx-d,"Mitten∅",2*trx,"Aussen∅",2*trx+d],info=name);
    //if(n)echo(str("»»» »»» ",n," Torus Innen∅= ",2*trx-d," Mitten∅= ",2*trx," Aussen∅= ",2*trx+d));
 
    HelpTxt("Torus",["trx",trx,"d",d,"a",a,"fn",fn,"fn2",fn2,",r=",r,", grad=",grad,"dia",dia,"center",center,"end",end,"gradEnd",gradEnd,"trxEnd",trxEnd,"endRot",endRot,"endspiel",endspiel,"name",name,"$d",$d],help);
         
    
}


module Torus2(m=5,trx=10,a=1,rq=1,d=5,w=2,n=$info,new=true)//m=feinheit,trx = abstand mitte,rq = sin verschiebung , a=amplitude, w wellen
{

//if(new&&w==2)rotate(90/w)WaveEx(grad=360,trx=trx-a/2*1,try=trx+a/2*1,f=w,tf=w,fv=0,tfv=0,r=d/2,ta=a/2,a=-rq/2);
if(new)rotate(-90/w)WaveEx(grad=360,trx=trx,try=trx,f=w,tf=-w,fv=0,tfv=180,r=d/2,ta=a,a=rq/2,fn=360/m);    

if(!new)echo("<H3> <font color=red> For Torus2 use 'new=true' (WaveEx)");
if(new)echo("<H4> <font color=green>Torus2 is using WaveEx");    
if(!new)rotate ([0,0,0])for (i=[0:m:360])
    { 

        hull()
        {
        rotate ([0,0,i])translate([trx+(sin(w*i)*a),0,0])rotate([90,0,0])cylinder(.01,d1=sin(w*i)*rq+d,d2=0,$fn=200/m,center=false);
            
        rotate ([0,0,i-m])translate([trx+(sin(w*(i-m))*a),0,0])rotate([90,0,0])cylinder(.01,d1=sin(w*(i-m))*rq+d,$fn=200/m,d2=0,center=false);
        } 
    }
 
  if(n)echo(str("»»» »»» ",n," Torus2 ",w," Wellen"));   

}

module Kegel(d1=undef,d2=0,v=1,grad=0,h=0,r1,r2,fn=fn,center=false,name=$info,help=$helpM)
{
v=grad?tan(grad):v;
d2=h&&(is_num(d1)||is_num(r1))?h/-v*2+(is_num(r1)?2*r1:d1):is_num(r2)?2*r2:d2;
d1=is_undef(d1)&&is_undef(r1)&&h?h/v*2+(is_num(r2)?2*r2:d2):is_num(r1)?r1*2:is_undef(d1)?0:d1;    
cylinder (abs((d1-d2)/2*v),d1=d1,d2=d2,$fn=fn,center=center);
//if(d2>d1)cylinder (abs((d2-d1)/2*v),d1=d1,d2=d2,$fn=fn,center=center);
if(d1==d2)cylinder (h?h:10,d1=d1,d2=d2,$fn=fn,center=center);   
if(!d1&&!d2&&is_undef(r1))color("magenta")%cylinder(5,5,0,$fn=fn,center=center);    

 if(d2<0||d1<0)echo(str("<b><font color=red size=8>‼ negativ ∅ </font>",name,"  Kegel d1=",negRed(d1)," d2=",negRed(d2)));    
 if (name)echo(str(is_string(name)?"<H3>":"",name," Konushöhe=",abs((d1-d2)/2*v)," Steigung= ",v*100," % ",atan(v),"° Spitzenwinkel=",2*(90-atan(v)),"° d2=",negRed(d2)));
     
 if(help)echo(str("<H3><font color='",helpMColor,"' <b>Help Kegel (d1=",d1," ,d2=",d2," ,v=",v," ,grad=",grad," ,h=",h,", r1=",r1," ,r2=",r2,", fn=",fn,", center=",center,", name=",name,",help=$helpM);"));
}

module MK(d1=12,d2=6,v=19.5,fn=fn)
{
//Basis
// Obererdurchmesser
//kegelverjüngung
cylinder ((d1-d2)/2*v,d1=d1,d2=d2,$fn=fn);
 echo(str("»»»››› Konushöhe=",(d1-d2)/2*v));
}


module Stabhalter (l=10,d=3.5)// Replaced with Ring(cd=-1,rand(n(1.5)),durchmesser=In6eck(3.1),fn=6)
{
    
    
    
    translate([+0.0,0,2.165])difference()
    {
        rotate ([0,90,0])rotate ([0,0,30]) cylinder(l,d=d+n(3),$fn=6);
        translate([+0.5,0,0])rotate ([0,90,0])rotate ([0,0,30]) cylinder(l+5,d=d,$fn=6);
    }
    
    echo("Removed!  Verschoben wegen nozzle∅! Use T(z=3.1/2)R(0,90)Inkreis(d=3.1) or Ring(cd=-1,rand(n(1.5)),durchmesser=In6eck(3.1),fn=6)");
}


module Halbrund(h=10,d=3+2*spiel,d2,x=1.0-spiel,doppel=false,name=$info,help=$helpM)
{
   d2=is_undef(d2)?doppel?d-x*2:d-x:d2;
   x=is_undef(d2)?x:doppel?(d-d2)/2:d-d2;    
if(h){difference()
{
  if($children)children();   
  if(!doppel)difference()
    {
        cylinder(d=d,h=h*2,center=true,$fn=36);
        translate([d/2-x, -25, -50])cube([50,50,100],center=false);
    }
  else intersection()
    {
        cylinder(d=d,h=h*2,center=true,$fn=36);
        cube([d2,d+1,100],center=true);
        //translate([-d/2+x-50, -25, -50])cube([50,50,100],center=false);
    } 
    
}
}
else difference(){
 if($children)children(); 
 if(!doppel) difference()
    {
        circle(d=d,$fn=36);
        translate([d/2-x, -25])square([50,50],center=false);
    }
    else intersection(){
        circle(d=d,$fn=36);
        square([d2,d+1],center=true);
    }
}
  if (name)echo(str(is_string(name)?"<H3>":"",name," Halbrund",h?str(" l= ",h): " h=0↦2D"," ∅= ",(d)," Abgeflacht um= ",x," ↦",d2));  
     
 if(help)echo(str("<H3><font color=",helpMColor,">Help Halbrund(",
 " h=",h,
" ,d=",d,
" ,d2=",d2,
" ,x=",x,
" ,doppel=",doppel,
" ,name=",name,
" ,help=$helpM" 
 ,");")); 
    
}

module Twins(h=1,d,d11=10,d12,d21=10,d22,l=20,r=0,fn=fn,center=0,sca=+0,2D=false)
{
    d11=d?d:d11;
    d12=d?d:is_undef(d12)?d11:d12;
    d21=d?d:d21;
    d22=d?d:is_undef(d22)?d21:d22;
    
 if(!2D)   rotate([0,0,center?r:0])translate([center?-l/2:0,0,0]){
    rotate([0,-sca,0])cylinder(h,d11*.5,d12*.5,$fn=fn);
    rotate([0,0,center?0:r])translate([l,0,0])rotate([0,sca,0])cylinder(h,d21*.5,d22*.5,$fn=fn); }
 
 if(2D)   rotate([0,0,center?r:0])translate([center?-l/2:0,0,0]){
    rotate([0,-sca,0])circle(d=d11,$fn=fn);
    rotate([0,0,center?0:r])translate([l,0,0])rotate([0,sca,0])circle(d=d21,$fn=fn); } 
    
    
}



module Riemenscheibe(e=40,radius=25,nockendurchmesser1=2,nockendurchmesser2=2,hoehe=8,name=$info)

{
   if(name)echo(str("Riemenscheibe ",name," Nockenabstand= ",2*PI*radius/e," Nockespitzen= ",(2*PI*(nockendurchmesser1/2+radius))/e));
     
   difference()
   {
        children();
    
      Polar(x=radius,e=e,name=0)translate([00,0,-.005])cylinder(.01+hoehe,d=nockendurchmesser2,center=false,$fn=36);
   }  
    
   Polar(x=radius,e=e,r=180/e,name=0)cylinder(hoehe,d=nockendurchmesser1,center=false,$fn=36);   
     
}


module Servokopf(rot=0,spiel=0,schraube=true,help=$helpM)
{
    // 15 Zacken!
    d2=6+spiel;
    d1=6.1+spiel;
    fn=3;
    
    %Tz(+0){//direction
      Col(5,0.5) rotate(rot)   scale([1,0.5])circle(3.5,$fn=3); 
      Col(6,0.7)  scale([1,0.5])circle(4,$fn=3);
    
    }
    
    difference()
    {
        union()
        {
            children();
            
        }
       rotate(rot) for (i=[0:360/5:359])
        {
         rotate([0,0,i]) translate([0,0,-.1])cylinder(3.25,d1=d1,d2=d2,$fn=fn,center=false);   
            
        }
        
        
    if($children)  translate([0,0,-0.01])cylinder(.5,d1=d1-0.1,d2=d1-2,$fn=36,center=false);//basekone
       // *cylinder(6,d1=d1,d2=d2,$fn=fn,center=true);
      //  *rotate([0,0,360/2*fn])cylinder(6,d1=d1,d2=d2,$fn=fn,center=true);
     if(schraube){
         cylinder(10,d=2,$fn=36); //SchraubenlochNarbe 
         translate([0,0,3.4+1])cylinder(100,d=4.5,$fn=36); //SchraubenKopflochNarbe 
     }
          translate([0,0,-30.01])cylinder(30,d=50,$fn=36); //Servo
      
    }
    
    if(!$children)     translate([0,0,-0.01])cylinder(.5,d1=d1-0.1,d2=d1-2,$fn=36,center=false);//basekone
    
    
 if(help)echo(str("<H3><font color=",helpMColor,">Help Servokopf(
    rot=",rot, 
    " ,spiel=",spiel,
    " ,schraube=",schraube,
    " ,help=$helpM));"));
    
    
}

    
module Servo(r=0,narbe=1)
 {

     cube([12.5,22.5+1.5,23],true);
     translate([+0,0,(-23/2+2.5/2)+16])cube([12.5,32.5,2.5],true);
     color([.8,0.4,.6,1])translate([+0,-5,2.8])cylinder(26.0,d1=12,d2=12,$fn=36,center=true);
       color([.8,0.3,.6,1])translate([+0,+0.7,2.7])cylinder(26.0,d=5.5,$fn=36,center=true);  
     color([.8,0.3,.6,1])translate([+0,+1.4,2.7])cylinder(26.0,d=5.5,$fn=36,center=true);
     color([.8,.8,.6,1])translate([+0,-5,3.5])cylinder(30.0,d=5,$fn=12,center=true);
     if (narbe==1)
         { translate([+0,-5,17.3])rotate([+0,0,r])scale([0.2,1.0,1])cylinder(3,d=35,center=true); // servoarm Oval
             translate([+0,-5,17.3])rotate([+0,0,r])cube([18,4.1,3.0],true);//servoarm
         }
        if (narbe==2)
         { translate([+0,-5,18.2])rotate([+0,0,r])scale([1,1,1])color([.8,.8,.8,0.5])cylinder(6,d=35,center=true); // servoarm Rund        
     
         }
     if (narbe==3)
         {
             color([.8,.8,.8,1])translate([+0,-5,49])cylinder(70,d1=4,d2=4,$fn=36,center=true);//Mitte Drehachse 
         }
     color([.8,0.5,.2,1])translate([+0,-11.8,-3.4])scale([1,0.15,1])cylinder(16,d=12.5,$fn=36,center=true);//cut für kabel
        translate([+0,14,6]) cylinder(10.0,d=1.8,$fn=6,center=true);    //Schraubenlöcher 
         translate([+0,-14,6]) cylinder(10.0,d=1.8,$fn=6,center=true);    //Schraubenlöcher     
 } 


module Glied3(x=15,layer=.15)

{
   function l(x)=layer*x; 
   echo(Glied3Layer=l(1)); 
    difference()
    {
        union()
        {
        
            color("blue")translate([x,0,l(1)]) cylinder(l(13),d1=1.9,d2=1.9,$fn=69,center=false);//Achse
            translate([x,0,l(1)])cylinder(l(5), d1=3.5,d2=2.0,$fn=69,center=false);//unten Sockel
            translate([x,0,l(11)])cylinder(l(3), d1=2,d2=3.5,$fn=69,center=false);//oben Sockel 
        }
         translate([x,+0,0])rotate([0,0,0])cylinder(l(40),d=+0.75,$fn=96,center=true);//achslochloch
    }
    if (messpunkt)
        {
            %color ("blue")translate([x,0,0.1])cylinder(l(40), d1=1,d2=1,$fn=12,center=true);//messachse1
            %color("red")cylinder(l(40), d1=1,d2=1,$fn=12,center=true);//messachse2
        }
   difference()
    {
           hull()
           {
            translate([0,0,0.0])cylinder(l(14),d=4.5,$fn=69,center=false); 
            translate([x,0,0])cylinder(l(+18), d1=+3.5,d2=+3.5,$fn=69,center=false);   
           }

       translate([+0.0,0,l(+1)])rotate([0,6,0])cylinder(l(9),d1=6.1,d2=2.2,$fn=69,center=false);//Kegel ausschnitt unten
       translate([0,0,l(+0)-0.05])rotate([0,0,0])scale([1,1,0.47])sphere(d=5.9,$fn=69);//Kegel ausschnitt untendrunter grade
       color("red")translate([0,0,-0.01])cylinder(5,d=3.00,$fn=69,center=false);//achsloch
      * color("green")translate([0,0,l(11)+.01])cylinder(l(7),d1=+2.0,d2=8.0,$fn=69,center=false);//lagerfläche oben
        translate([0,0,l(+19)-0.05])rotate([0,0,0])scale([1,1,0.47])sphere(d=5.9,$fn=69);//oben Frei
       mirror([0,0,0])translate([x,+0,l(3)])rotate([0,0,0])cylinder(l(5),d1=+6.0,d2=7.0,$fn=96,center=false);//lagerfläche innen unten
       translate([x,+0,l(+8)-0.01])rotate([0,0,0])cylinder(l(6),d1=+7.0,d2=6.0,$fn=96,center=false);//lagerfläche innnen oben
           
       translate([x,+0,0])rotate([0,0,0])cylinder(l(45),d=+0.60,$fn=96,center=true);//achslochloch
   }
   
} 

module Gelenk(l=20,w=0)//ausschnittlänge, winkel
{
    
    scale([1.2,1.2,1.3])rotate([0,0,180])intersection()
    {
        union()
        {
            translate([-l,0,0])Glied3(l);
            translate([ 0,0,0])rotate([0,0,w])Glied3(l+10);
        }
        union()
        {
        translate([0,0,0])rotate([0,0,w])translate([l/2,0,0])resize([l,6,10])cylinder(10,d=5,$fn=3,center=true);
         translate([+0,0,0])cube ([14,11,30],center=true);
        }
       
    }    
}



module Ring(h=5,rand,d=10,r,cd=1,id=6,ir,grad=360,rcenter,center=false,fn=fn,name=$info,2D=0,help=$helpM){
    
    id=is_undef(id)?d-rand*2:id;
    r=is_undef(r)?d/2:r;
    ir=is_undef(ir)?id/2:ir;
    rcenter=is_undef(rcenter)?!abs(cd):rcenter;
    rand=is_undef(rand)?r-ir:rand*sign(cd==0?1:cd);
    if(2D||!h)Kreis(rand=rand,rcenter=rcenter,r=r,grad=grad,fn=fn,rot=90,center=center,name=0,help=0);
        else rotate([h>0?0:180])linear_extrude(abs(h),center=center,convexity=5)Kreis(rand=rand,rcenter=rcenter,r=r,grad=grad,center=center,fn=fn,rot=90,name=0,help=0);
    
if(name)echo(str(is_bool(name)?"":"<b>",name," Ring Aussen∅= ",rcenter?d+abs(rand):rand>0?d:d-rand*2,"mm — Mitte∅= ",rcenter?d:d-rand,"mm — Innen∅= ",rcenter?d-abs(rand):rand>0?d-(rand*2):d,"mm groß und ",2D||!h?"2D":str(h," hoch")));    
 
HelpTxt("Ring",["h",h,
    "rand",rand,
    "d",d,
    "r",r,
    "id",id,
    "ir",ir,
    "cd",cd,
    "rcenter",rcenter,
    "center",center,
    "fn",fn,
    "name",name,
    "2D",2D,],help);


/*if (help) echo(str( "<H3><font color=",helpMColor,">Help Ring",
    "h=",h,
    ", rand=",rand,
    ", d=",d,
    ", r=",r,
    ", id=",id,
    ", ir=",ir,
    ", cd=",cd,
    ", rcenter=",rcenter,
    ", center=",center,
    ", fn=",fn,
    ", name=",name,
    ", 2D=",2D,
    ", help=$helpM);"));*/
}



/*del*/ module RingOLD(h=5,rand=2,d=10,cd=1,center=false,fn=fn,n=$info,2D=0)// marked for deletion
{
if (!2D){
     if(cd==1){difference()//Aussendurchmesser
        {
            cylinder(h,d=d,$fn=fn,center=center);
            cylinder(2*h+1,d=d-2*rand,$fn=fn,center=true);
        }
        if(n)echo(str("»»»  »»» ",n," Ring Aussen∅= ",d,"mm — Mitte∅= ",d-rand,"mm — Innen∅= ",d-(rand*2),"mm groß und ",h," hoch ««« «««"));}
            
     if(cd==0){difference()//Center durchmesser
        {
            cylinder(h,d=d+rand,$fn=fn,center=center);
            cylinder(2*h+1,d=d-rand,$fn=fn,center=true);
        }
        if(n)echo(str("»»»  »»» ",n," Ring Aussen∅= ",d+rand,"mm — Mitte∅= ",d,"mm — Innen∅= ",d-rand,"mm groß und ",h," hoch ««« «««"));}        
            
         
     if(cd==-1){difference()//innen durchmesser
        {
            cylinder(h,d=d+2*rand,$fn=fn,center=center);
            cylinder(2*h+1,d=d,$fn=fn,center=true);
        }
        if(n)echo(str("»»»  »»» ",n," Ring Aussen∅= ",d+2*rand,"mm — Mitte∅= ",d+rand,"mm — Innen∅= ",d,"mm groß und ",h," hoch ««« «««"));}
    }


if (2D){
     if(cd==1){difference()//Aussendurchmesser
        {
            circle(d=d,$fn=fn);
            circle(d=d-2*rand,$fn=fn);
        }
        if(n)echo(str("»»»  »»» ",n," Ring Aussen∅= ",d,"mm — Mitte∅= ",d-rand,"mm — Innen∅= ",d-(rand*2),"mm groß und 2D ««« «««"));}
            
     if(cd==0){difference()//Center durchmesser
        {
            circle(d=d+rand,$fn=fn);
            circle(d=d-rand,$fn=fn);
        }
        if(n)echo(str("»»»  »»» ",n," Ring Aussen∅= ",d+rand,"mm — Mitte∅= ",d,"mm — Innen∅= ",d-rand,"mm groß und 2D ««« «««"));}        
            
         
     if(cd==-1){difference()//innen durchmesser
        {
            circle(d=d+2*rand,$fn=fn);
            circle(d=d,$fn=fn);
        }
        if(n)echo(str("»»»  »»» ",n," Ring Aussen∅= ",d+2*rand,"mm — Mitte∅= ",d+rand,"mm — Innen∅= ",d,"mm groß und 2D ««« «««"));}
    }

         
}

/*del*/ module RingX(layer,rand,durchmesser)//old don't use! 
{
     
  echo("<font color='red'size=10>WARNING - DONT USE , REMOVED -- USE: 'Ring(hoehe=l(layer);'</font>");  
    difference()
        {
            cylinder(l(layer),d=durchmesser,$fn=250,center=false);
            translate([+0,0,-l(.5)])cylinder(l(layer+1),d=durchmesser-rand,$fn=250,center=false);
        }
}




module Servotraeger(SON=1,top=0)
 {
    if(!top)translate([0,+0,+35.4]) difference()
     {
         minkowski()
         {
             translate([-11,+0,-33.9]) cube([29,20,3],center=true);
             cylinder(1,d=5,$fn=36);
         }
        if(SON) #translate([-11,0,-40]) rotate([0,0,-90])Servo(0);
            else translate([-11,0,-40]) rotate([0,0,-90])Servo(0);
          * mirror([0,1,0])translate([-11,-30,-40]) rotate([0,0,-90])Servo();
     }
                              
                *minkowski()//Sockel
                 {
                     translate([+2,+0,-27.4]) cube([15,9,16],center=true);
                     cylinder(1,d=5,$fn=36);
                 }

if (top) difference(){
    if($children)children();
        else cylinder(4,d=20);
    linear_extrude(9,center=true,convexity=5)Rund(1){
        circle(d=11.5+spiel);
        T(6)circle(d=5.5+spiel);
        }
    T(23/2-(11.5+spiel)/2){
        R(180)Prisma(23,11.5+spiel,5,c1=1,s=.5);  //Servo
        R(180)Tz(4.0)Prisma(33,11.5+spiel,100,c1=1,s=.5);  //Servobody unten
     R(180)  Mklon(tx=28/2,mz=0)linear_extrude(5,center=false,convexity=5)Rund(.35)Stern(5,5.9,0.5);//Schraubenlöcher
        
        }
        cylinder(8,d=9);//Servoachse
    }   
        
   }
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
 if(version()[0]<2021)echo("<b><p style=background-color:#dddddd><font color='darkblue'size=4>---—————————————————————————————————————————————---</font>");
 else echo("\n---————————————————————————————————————————---\n");
 
 // for demo Objects (incomplete)
if (show) %color([0.6,+0.0,0.9,0.8]){
if (show==402)Strebe();    
if (show==400)Pivot();    
if (show==100)Trapez();
if (show==67)Tring();    
if (show==66)Prisma();    
if (show==65)Sichel();    
if (show==64)Balg();    
if (show==63)Area();    
if (show==62)Spirale();     
if (show==61)Gelenk();      
if (show==60)Glied();
if (show==59)ReuleauxIntersect(); 
if (show==58)Box();    
if (show==57)Tugel();
if (show==56)Vorterantrotor();
if (show==55)Kassette();   
if (show==54) Sinuskoerper();
if (show==504) Achsenklammer();   
if (show==503) Achshalter();
if (show==52) Freiwinkel();
if (show==51) Dreieck();    
if (show==50) Rohr();
if (show==49)Bogen(grad=90,rad=5,d=3,l1=10,l2=12);
if (show==48)Imprint(txt1="››»»Rundherrummmm»»››",abstand=17.8,radius=20,rotz=-27,h=l(2),rotx=0,roty=0,stauchx=0,stauchy=0,txt0=" ",txt2=" ");
if (show==47)W5(kurv=15,arms=3,detail=.3,h=50,tz=+0,start=0.7,end=13.7,topdiameter=1,bottomenddiameter=+2);//Spiralarm   
if (show==46)Text(text="»DEMO«",size=5,h=0,cx=0,cy=0,cz=0,center=0,radius=0);    
if (show==45)Bitaufnahme();
if (show==44)Knochen();    
if (show==43)Servotraeger(SON=1);
if (show==42)Gardena();    
if (show==41)Luer();
if (show==40)DGlied1();    
if (show==39)DGlied0();
if (show==38)Glied(); 
if (show==37)Kehle(); 
if (show==36)Twins(); 
if (show==35)Pille();
if (show==34)Torus2();    
if (show==33)Torus();
if (show==32)Ring();
if (show==31)MK();
if (show==301)Kegelmantel();
if (show==30)Kegel();
if (show==300)Kugelmantel();    
if (show==202)Halbrund();
if (show==29)Bezier()sphere(2,$fn=12);   
if (show==28)Kontaktwinkel()sphere(d=10);     
if (show==27)Gewinde(); 
if (show==26)Rundrum()circle(5);
if (show==261)Ttorus()scale([2,1,1])sphere(5,$fn=12);    
if (show==25)Drehpunkt(x=15,y=2,z=-8,rx=20,ry=20,rz=20,messpunkt=1)cube(5);
if (show==24)Halb()sphere(20);   
if (show==23)Klon(tx=10,rx=+25)cube(10,true);     
if (show==22)Polar(x=10,y=10)cube(5);    
if (show==21)Linear(es=0.5,s=1.0,e=4,x=90,y=0,z=0,r=0,re=0,center=+1,cx=+0)cube(5);

if (show==4){cube(50,true);Echo("50mm Cube",color="purple");}
if (show==3){cube(20,true);echo("20mm Cube",color="purple");}   
if (show==2){cylinder(10,d=n(1),$fn=36,center=true);echo(str(n(1)," mm ∅ =n(1) cylinder×10mm"),color="purple");}
if (show==1){cube(10,true);echo("10mm Cube",color="purple");}

}
 
 

   
 /*  •••• Archive ••••  
   
   
 140|17 Changelog - beta 4.7
140|17 ADD Text - beta 4.7
141|17 ADD show 
164|17 ADD Bogen CHG Schnitt rotation default - beta 4.9
165|17 ADD Gewinde - beta 5
169|17 CHG Polar - beta 5.01
171|17 ADD Dreieck - beta5.1
179|17 CHG t0↦-t0  - beta5.11
180|17 CHG ADD Freiwinkel  - beta 5.2
182|17 CHG Polar ADD dr - beta 5.21
183|17 CHG Halbrund ADD parameter - beta 5.22
184|17 ADD Achshalter -beta 5.3
185|17 CHG Luer ADD lock ADD !male beta 5.41
187|17 CHG Ring ID OD CD - CHG Pille l corrected! DEL Stabhalter beta 5.5
189|17 CHG Achshalter ADD MutterSpiel - β5.51
202|17 ADD Sinuskoerpe, ADD color - β5.6
208|17 CHG Bogen fn=  -β5.7
211|17 CHG Kegel ADD center - β5.8
213|17 ADD Col for color  - β5.9
216|17 ADD $fn=fn, CHG Dreieck ADD Winkel -β6.0
226|17 ADD Kehle β6.1
232|17 ADD Gardena β6.2
237|17 ADD Kegelmantel β6.3
238|17 ADD Kugelmantel ADD Halb β6.4
240|17 ADD Klon β6.5
241|17 ADD Rohr ADD Drehpunkt β6.6
247|17 CHG Rohr CHG Bogen  β6.7
276|17 CHG Dreieck ADD ha2 β6.8
338|17 CHG Glied - ring dicke auf 1.5n  β6.9


029|18 CHG TEXT ADD font 
058|18 CHG Kehle ADD fn2,r2 β7
060|18 ADD Kassette β7.1
062|18 CHG Linear center β7.2
104|18 ADD Vorterantrotor β7.3
113|18 CHG Vorterantrotor ADD Mklon β7.38
121|18 CHG Torus ADD dia CHG min β7.39
123|18 ADD Tiegel β7.4
135|18 ADD Reuleaux β7.5
138|18 ADD Box ADD ReuleauxIntersectβ7.6
143|18 ADD Bogendreieck
149|18 CHG Schnitt add center ADD Spirale β7.7
161|18 CHG Glied, DGlied  β7.8
173|18 CHG Gardena β7.9
176|18 CHG Ring hoehe=h β8
183|18 CHG Kehle add convexity
191|18 ADD function Hypertenuse β8.1
194|18 ADD Area ADD Balg β8.2
200|18 CHG Box Add d2 β8.3
207|18 CHG Pille CHG Torus Add center β8.4
209|18 ADD Sichel β8.5
212|18 ADD Prisma β8.6
213|18 CHG Kugelmantel rand β8.6
214|18 ADD t3 β8.7
230|18 CHG Ring Add 2D β8.8
235|18 ADD Trapez β8.9
237|18 CHG Trapez x1/x2 β9.0
241|18 ADD Tring add Trapez&Prisma winkelinfo β9.1
244|18 CHG Sinuskoerper Add 2D, linextr Add fill β9.21
245|18 CHG Polar Chg END β9.3
246|18 CHG Halb Add 2D ADD Rundrum β9.4
254|18 CHG Spirale Add children β9.5
267|18 CHG Rundrum Add spiel ADD Kontaktwinkelβ9.6
273|18 CHG Text Add str CHG Gewinde warning β9.7 
278|18 ADD Kathete ADD func Inkreis ADD func Umkreis β9.8
279|18 CHG Rundrum Add eck β9.9
288|18 ADD Ttorus ADD instructions ADD colors/size CHG Col Add $children β10
289|18 CHG Col Add trans β10.1
308|18 CHG Torus Add spheres ADD M β10.3
313|18 ADD Rund β10.4
324|18 ADD Achsenklammer CHG Schnitt debug on β10.5
327|18 ADD LinEx β10.6
331|18 CHG Spirale Add hull switch β10.7
332|18 ADD Bezier CHG add $children CHG Kassette add r CHG Rundrum chg r add intersect β10.9
333|18 CHG Bezier add funct/polygon Pivot ADD Pivot β11
334|18 CHG Bezier add pabs,ex,w β11.1 (chg to v.2018)
335|18 ADD Strebe β11.2
341|18 CHG Bogen fix β11.3
346|18 ADD Elipse β11.4
349|18 CHG LinEx Add twist β11.5
352|18 CHG Kontaktwinkel Add inv CHG ReuleauxIntersect Add 2D β11.6
357|18 ADD Laser3D β11.7 Chg β11.8
360|18 ADD function Kreis() β11.9


001|19 CHG Kreis Add r2 rand2 β12
002|19 Add Kegel/Kegelmantel/Dreieck grad β12.2
006|19 CHG Kegelmantel zversch CHG Kegel d2>d1 β12.3
010|19 CHG Col Add palette β12.4
011|19 CHG Kreis Add center β12.5
012|19 CHG Add switch for basis/prod objects β12.6
025|19 CHG LinEx Add slices β12.7
032|19 ADD KreisXY CHG Bezier detail/fn β12.8
059|19 ADD RotLang β12.9
060|19 CHG Linear chg e/s β13
073|19 CHG Imprint β13.1
075|19 ADD 5gon CHG RotLang β13.2
077|19 CHG Glied3 Gelenk CHG Linear s=0 β13.3
080|19 CHG Kassette add fn2,h chg size, β13.4
080|19 CHG Strebe add fn β13.5
093|19 CHG Col CHG Kassette β13.6
111|19 CHG LinEx ADD Grid CHG Prisma Add warning β13.7
113|19 CHG Bitaufnahme Add Star ADD Rand β13.8
117|19 CHG Ring CHG Achshalter CHG Achsklammer Add fn CHG commented depreciated functions β13.9
124|19 CHG Pille
127|19 CHG Grid
130|19 CHG Kreis Add rot ADD Gewinde2 ADD Tz() β14
132|19 CHG Gewinde2 Ren Gewinde ⇔ GewindeV1 (old version)β14.1
134|19 chg fn=$preview?-render chg vp - CHG Pivot chg size β14.2
135|19 CHG Linear Add n, chg fn, Schnitt warning
138|19 ADD VorterantQ β14.3
141|19 CHG Gewinde Add preset ½zoll chg r1,rh calc β14.4
147|19 CHG Prisma c1=c1-s
148|19 ADD Linse β14.5
150|19 CHG Strebe Add 2D CHG Kreis Add t=[0,0] CHG Kreis⇒KreisOrginal CHG Gewinde fn β14.6
151|19 CHG Kassette Add sizey
152|19 ADD Quad β14.7
157|19 CHG Sichel Add 2D β14.8
159|19 CHG Text font 
168|19 CHG Pille ADD Disphenoid β14.9
169|19 CHG Gewinde β15.0
170|19 CHG Kassette
v2019.5
170|19 CHG Kreis() CHG Linse() β15.1
171|19 ADD Stern()  - cleaned  β15.2
172|19 CHG Kegelmantel
173|19 CHG Pille()
175|19 CHG Servokopf CHG Stern CHG Linse β15.3
176|19 CHG Pille add rad2
180|19 CHG Quad add r CHG Pille ADD Cring β15.4
181|19 CHG Quad CHG Cring
182|19 ADD Surface β15.5
185|19 CHG Kegel Add spitzenwinkel info
187|19 CHG Cring Add fn2
188|19 CHG Twins Add 2D
190|19 CHG Cring 
194|19 CHG Polar Add mitte
203|19 CHG Gewinde ADD LinEx2 CHG Stern β15.6
205|19 CHG Gewinde ADD GewindeV3 chg spiel↦0.2 β15.7
207|19 CHG Surface Add abs
209|19 CHG n() chg nozzle
210|19 CHG Grid β15.8
211|19 CHG Grid Add element Nr CHG Polar
212|19 CHG Gewinde Add translate rotate
219|19 CHG Kassette Add help CHG Surfale Add help ADD helpM β15.9
222|19 CHG Kassette Add n
227|19 CHG Bogen Add Child ADD RStern CHG Pivot Add active ADD SCT β16
228|19 CHG Bogen CHG Rohr CHG RStern
229|19 CHG Stern rot90 CHG RStern ADD TangentenP
230|19 CHG Bogen chg green arm CHG RStern β16.1
236|19 CHG Cring rotate end2
240|19 ADD ZigZag β16.2
241|19 ADD module ZigZag,module Kreis
243|19 CHG Linse CHG Strebe Add grad help β16.4
244|19 CHG ADD WStrebe β16.5
245|19 CHG Kehle CHG Servotraeger CHG Servokopf Add Spiel
247|19 CHG Kehle Add a ax angle CHG Strebe Add center
248|19 CHG Bogen center rot
252|19 CHG Rundrum Add shift help CHG Kassette β16.6
254|19 CHG Quad Add grad, r vector CHG Pivot ADD Caliper β16.7
256|19 CHG Kehle Add 2D
258|19 ADD Tri
259|19 CHG Rundrum CHG Box‼ β16.8
261|19 CHG Kassette grad2, CHG Rundrum fn ADD RotEx β16.9
263|19 CHG T CHG Line CHG Col Add rainbow β17.0
264|19 CHG Line Add 2D  CHG Col Add rainbow2 ADD Color β17.1
265|19 CHG Bogen Add SBogen β17.2
266|19 CHG Bogen fix fn FIX SBogen FIX Luer CHG Kegel Add h CHG Tri Chg center β17.3
267|19 CHG Rand Add delta chamfer
274|19 CHG SBogen CHG LinEx Add scale2 FIX Prisma CHG Caliperβ17.4
278|19 FIX Balg
279|19 FIX Gewinde
280|19 FIX LinEx CHG Color β17.5
283|19 ADD REcke
284|19 CHG Cring
285|19 ADD WStern ADD WaveEx ADD Superellipse ADD Flower CHG RotLang β17.6
291|19 CHG Kassette ADD Ccube
293|19 CHG Polar/Linear/Grid/Col/Color Add $idx CHG RotLang Add lz β17.7
296|19 ADD RotPoints CHG RotLang 
299|19 CHG Stern Add help CHG LinEx CHG WStern
301|19 ADD Seg7 
302|19 CHG Torus Add End β17.8
303|19 CHG CHG Superellipse Add $fn CHG Prisma Fix CHG Kassette Add 2D - cleanups β17.9
305|19 CHG Kassette Add base
308|19 CHG Superellipse Add Superllipsoid β18
309|19 CHG t-t3 tset for render
310|19 CHG LinEx Add $d $r
313|19 CHG helpM↦$helpM FIX RStern l calc FIX RotEx -grad calc fn
314|19 CHG Prisma Add list option CHG WStern ADD name Fix LinEx
315|19 FIX Quad basisX
316|19 CHG Quad add centerX=-1 trueX β18.1
319|19 FIX Prisma help
320|19 ADD PCBcase β18.2
321|19 CHG PCBcase Chg and Add clip 
325|19 CHG TRI ADD Tri90
326|19 CHG Zylinder Add f3
330|19 CHG Flower CHG LinEx Add Mantelwinkel
333|19 CHG LinEx rotate
334|19 CHG Box Add help CHG debug β18.4
336|19 Fix Pille CHG PCBcase
342|19 CHG Zylinder Add altFaces
349|19 ADD Row β18.5
350|19 ADD new Pille2 
351|19 CHG Spirale polygon generation
353|19 CHG Pille Add grad CHG Servokopf
359|19 CHG Rundrum Fix child help/info
360|19 ADD Welle
361|19 ADD Klammer FIX LinEx


008|20 ADD Kextrude
009|20 FIX LinEx scale list info
013|20 FIX Color $idx
017|20 CHG Text h=0↦2D 
018|20 ADD Pin β18.6
023|20 FIX Bezier messpunkt CHG Pivot add txt/vec
024|20 CHG Pin add Achse
026|20 CHG Strebe 
031|20 CHG Welle add overlap CHG Kehle add spiel vektor
053|20 CHG Bitaufnahme β18.7
055|20 CHG Kreis Add d, ADD Wkreis CHG Row β18.8
056|20 FIX Wkreis calc OD/ID CHG Stern Add center 
057|20 ADD RSternFill CHG RStern
058|20 FIX WKreis,RSternFill
060|20 ADD Cycloid
062|20 ADD SQ CHG Cycloid Add linear β18.9
065|20 CHG LinEx Add rotCenter chg name CHG SBogen Add extrude β19.0
068|20 ADD Vollwelle
070|20 CHG Quad
073|20 CHG LinEx slices 
076|20 CHG diverse name info
078|20 ADD Anschluss
080|20 CHG SBogen/Anschluss Add grad2 CHG Vollwelle Add mitte⇒β19.1
083|20 CHG Pin CHG LinEx
088|20 CHG SBogen Add info CHG Grid
101|20 CHG SBogen
112|20 CHG Prisma Add center
113|20 CHG Anschluss Add x0 CHG SBogen Add x0 ⇒β19.2
119|20 ADD Anordnung
123|20 CHG LinEx add grad vector x/y CHG Kreis CHG Cycloid
124|20 ADD CyclGetriebe ⇒ β19.3
131|20 ADD Sekante⇒ β19.31
132|20 CHG Torus ⇒β19.32
134|20 CHG Ttorus
135|20 CHG Achsenklamer Achshöhe CycloidZahn/Getriebe fn
139|20 CHG Prisma nama
140|20 ADD Buchtung CHG Kehle Add end β19.34
148|20 CHG Halbrund Add 2D help CHG Ttorus Add scale β19.35
155|20 ADD Bevel CHG Kassette name CHG Anordnung CHG Schnitt
156|20 CHG CycloidZahn/Gear β19.36
157|20 CHG Bevel Add -z CHG Konus β19.37
163|20 CHG CyclGetriebe d !preview add rot
181|20 CHG Anordnen CHG Kugelmantel Add help
190|20 ADD SRing β19.38
191|20 CHG Bogen Add Info
195|20 CHG Linse Add help CHG CyclGetriebe Chg spiel=.075
209|20 Fix Cring
211|20 CHG Kreis Add b β19.39
215|20 CHG Gardena Dichtungsring
220|20 CHG SBogen Add spiel
221|20 CHG Pille d<h ⇒rad
232|20 CHG Sichel Add help β19.4
236|20 CHG Text Add help
237|20 CHG Kehle fix end ↦ β19.5
237|20 CHG Kehle Add fase
244|20 CHG Quad n⇒name CHG Gewinde kern↦undef↦ β19.51
254|20 FIX n() for negatives β19.52
276|20 FIX Rund ir=0 β19.53
281|20 FIX Kegel name FIX Luer name β19.54
290|20 CHG Schnitt on=2 β19.55
317|20 CHG Anschluss Add Wand CHG SBogen Add neg radius warning β19.61
318|20 CHG REcke Add fn
321|20 CHG Torus end Add gradEnd β19.63
322|20 CHG Bezier ex CHG Text Add 2D
325|20 CHG Text chg center β19.65
328|20 CHG Gewinde Add center Add endMod ADD gw tw twF constβ19.66
330|20 FIX Linear chg for s
338|20 FIX Rand center
343|20 ADD Nut β19.7
344|20 FIX Nut β19.72
346|20 CHG Surface Add exp β19.73
347|20 CHG Surface Add mult
349|20 ADD DRing β19.75 CHG Anordnen c=undef CHG Rundrum CHG MKlon Add $idx
350|20 CHG Caliper Add end=2  β19.76
351|20 ADD DBogen β19.77 CHG RotEx+funcKreis abs(fn)
355|20 CHG Linear s⇒$idx
357|20 CHG Color
361|20 CHG Anordnen

2021

000|21 CHG Klammer l vector CHG Quad r=undef β19.78
005|21 CHG Glied FIX LinEx FIX Schnitt β19.79
007|21 CHG Vollwelle Add h β19.8
011|21 CHG Vollwelle Add l CHG LinEx Add End ADD inch β19.81
013|21 CHG Pille chg rad list FIX Kegelmantel FIX LinEx hc=0 CHG Klon Add $idx CHG LinEx end FIX Kassette name β19.82
016|21 FIX Grid CHG Vollwelle list fn CHG Nut Add grad β19.821
017|21 FIX CycloidZahn β19.822
018|21 FIX Pille β19.83
019|21 FIX SBogen/Bogen
022|21 ADD gradB CHG Quad warning CHG Text help radius β19.84
023|21 ADD funct vollwelle CHG Gewinde test vollwelle
025|21 ADD fonts styles lists CHG Text β19.85
026|21 CHG Text Add rot fix -h CHG Vollwellen grad list FIX Anschluss r1/2 β19.86
027|21 CHG Linear  e first CHG Grid e first Add s
028|21 CHG Vollwelle fix h replaced w. vollwelle() β19.88
029|21 ADD GewindeV4 CHG Gewinde β19.89
030|21 CHG GewindeV4 autocalc warning variables ADD useVersion ADD func gradS CHG Ring method FIX Prisma FIX LinEx β19.90
031|21 CHG Pille Rad2 CHG Sichel Add step CHG DBogen Add spiel CHG Text fn FIX Kegel
040|21 CHG Kegelmantel CHG Gewinde Add konisch β19.94
042|21 CHG vollwelle g2 end Fix grad list,CHG GewindeV4 konisch grad2, FIX Caliper help β19.95
043|21 FIX Bogen n CHG Gewinde Add ISO presets β19.951
045|21 FIX Quad x=list CHG Drehpunkt Add vector help β19.952
046|21 CHG Quad r gerunded CHG LinEx max slices Fix Luer β19.953
051|21 FIX Pille rad2
055|21 CHG Bogen Add l[] CHG Rundrum x[] β19.955
056|21 CHG Gewinde
057|21 FIX Nut console Add Pfeil CHG console colors β19.957
058|21 FIX Linear e=1/0 β19.958  CHG Anordnen es⇔e es=Sehne
059|21 CHG Rund Add vector ADD func radiusS
060|21 ADD func radiusS+grad FIX Quad rundung CHG LinEx warning+h2=0 β19.960
β21.60
062|21 CHG Gewinde add tz in preset chg spiel CHG DRing Add center FIX Kehle bool
063|21 FIX DBogen FIX Gewinde wand
064|21 FIX Gewinde children old Version CHG DRing Add grad
068|21 CHG Ring Add Id CHG Torus Add endRot ADD func Inch FIX Kehle end
069|21 CHG Kehle Add Fillet
070|21 CHG Kehle Add  dia/Fillet CHG Ring Add grad CHG help CHG Bevel Add messpunkt CHG Anordnen Add rot

078|21 CHG Schnitt center bool CHG Color Add color names CHG Pfeil Add d
079|21 CHG Gewinde Add gb
081|21 FIX RStern n
082|21 ADD Rosette
083|21 ADD Scale CHG Rosette Add children Del round
085|21 ADD GT
087|21 FIX LinEx warning CHG WStrebe grad2 undef
089|21 FIX LinEx grad list  CHG GT Add fn FIX SRing h
091|21 ADD Egg ADD HelpTxt ADD InfoTxt CHG GT2 CHG Torus end fn2
092|21 ADD BB FIX DBogen CHG Egg Add breit CHG Anordnen
093|21 ADD $fs CHG DBogen CHG Egg ADD func fs2fn
096|21 CHG BB Add achse center fixes FIX Polar e=0 
098|21 FIX GewindeV3
100|21 CHG Strebe Add fn2
105|21 FIX Infotxt
108|21 ADD Echo FIX HelpTxt InfoTxt for v[2021] CHG Achsenklammer CHG Ring help
111|21 CHG Gewinde helptxt Fix SBogen -grad
118|21 CHG Color Add spread
119|21 FIX LinEx
127|21 CHG Zylinder faces
130|21 CHG Zylinder var
138|21 ADD HexGrid
139|21 CHG Zylinder Add center
142|21 FIX Vollwelle 
148|21 CHG Text add spacing
149|21 ADD HypKehle
151|21 CHG HexGrid es vector ADD PrintBed
164|21 CHG Text spacing
166|21 CHG Text not empty CHG vpt printBed/2
176|21 CHG Pin 
178|21 CHG Rohr
181|21 CHG Cring
194|21 ADD Abzweig FIX Anschluss
215|21 ADD printPos FIX Abzweig
216|21 ADD assert Version
217|21 CHG Zylinder Add lambda
218|21 CHG Pille Add r CHG Abzweig CHG T Add vector
224|21 FIX printPos vpt
235|21 FIX Luer 33.3
237|21 CHG Zylinder lambda
245|21 CHG menue layer nozzle var
260|21 FIX LinEx list $r
268|21 FIX Gewinde Mantel
272|21 FIX removed ,, (test with [2021,9]) some formating regarding version
273|21 FIX formating for v21
276|21 FIX GewindeV4 faces error grad<360
277|21 FIX LinEx vector, del Schnitt convexity, cCube
280|21 FIX Polar 1 with end<360
281|21 FIX Cring bool
283|21 FIX Gewinde winkel
284|21 FIX Kreis ceil(fn) CHG Bevel messpunkt FIX Trapez help
285|21 FIX Ring rot 90
286|21 FIX Anordnen;
287|21 CHG Torus Add endspiel FIX Kreis r=0 b
288|21 FIX Halb
289|21 FIX Pille accuracy issue ADD minVal
290|21 ADD clampToX0 FIX Pille help info FIX Torus grad end
291|21 ADD KreisSeg
292|21 FIX Cycloid points, Cyclgetriebe bool center + info CHG Kreis r=0 rand=0
295|21 FIX HelpTxt,InfoTxt ↦ scad version > 2021
296|21 CHG Vollwelle/ECHO
297|21 CHG Gewindev4 calc dn=undef
298|21 CHG Echo add color characters
299|21 CHG Gewinde g rot CHG GewindeV4 add g autocalc
301|21 CHG Tugel Add rand,help fix name,CHG help info DBogen
305|21 CHG Bezier Add $idx for children ADD vektorWinkel ADD v3
306|21 CHG Echo Add colors CHG Pfeil CHG Anordnen CHG Halbrund CHG Imprint 
307|21 CHG helptext changes CHG Glied ADD GT2Pulley FIX Superellipse FIX LinEx2
208|21 FIX help Diverse 
309|21 CHG Gewinde Add other FIX Zylinder fix ub CHG SBogen ADD parentList
310|21 FIX Anschluss
311|21 FIX Grid ub FIX v3() CHG Bezier CHG parentList CHG SBogen 
312|21 FIX Strebe


*/
