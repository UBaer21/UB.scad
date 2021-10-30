include<ub.scad> 
/*[Hidden]*/
useVersion=21.299;//⇒ v.gd/ubaer
assert(Version>=useVersion,str("lib version ",Version," detected, install ",useVersion," ub.scad library‼ ⇒http://v.gd/ubaer"));
nozzle=.2;
bed=false;

/*[Demo]*/

!Anordnen(option=3,es=20,c=undef,loop=false){
textPos=[0,-2];
objPos=[8];
union(){
    square();T(4)Pfeil(l=4,b=[1,2.5],shift=-0.5);T(objPos+[3])Tz(z=0)Color() square();// moves
    T(textPos)text("T(x=3)",size=2,valign="top");
}
union(){
    square();T(objPos/2+[1])Pfeil([6,2],[1,2],d=3);T(objPos)R(x=0,y=0,z=-45) Color()square();// rotates
    T(textPos)text("R(z=-45)",size=2,valign="top");    
}
union(){
    square();T(4)Pfeil(l=4,b=[1,2.5],shift=-0.5);T(objPos)M(skewyx=1)Color() square();// skews
    T(textPos)text("M(skewyx=1)",size=2,valign="top");     
}
union(){
    square();T(4)Pfeil(l=4,b=[1,2.5],shift=-0.5);T(objPos)Color(.5)square();// colors (hui)
    T(textPos)text("Color(.5)",size=2,valign="top"); 
}

union(){
    MKlon(mx=1,my=1)square([1,2],true);T(4)Pfeil(l=4,b=[1,2.5],shift=-0.5);T(objPos)Color()Rund(.2,.4)MKlon(mx=1,my=1)square([2,1],true);// Rounds
    T(textPos)text("Rund(.2,.4)",size=2,valign="top");
}

union(){
    square(1,true);T(4)Pfeil(l=4,b=[1,2.5],shift=-0.5);T(objPos)Schnitt(true)square(1,true);// cuts in preview
    T(textPos)text("Schnitt()",size=2,valign="top"); 
}

union(){
    square(1,true);T(4)Pfeil(l=4,b=[1,2.5],shift=-0.5);T(objPos)Color()Linear(e=3,es=2)square(1,true);// cuts in preview
    T(textPos)text("Linear(3,2)",size=2,valign="top"); 
}

union(){
    square(1,true);T(4)Pfeil(l=4,b=[1,2.5],shift=-0.5);T(objPos)Color()Polar(5,1.5)square(1,true);// cuts in preview
    T(textPos)text("Polar(5,1.5)",size=2,valign="top"); 
}

union(){
    square(1,true);T(4)Pfeil(l=4,b=[1,2.5],shift=-0.5);T(objPos)Color()Grid(2,1.5)square(1,true);// cuts in preview
    T(textPos)text("Grid(2,1.5)",size=2,valign="top"); 
}
*union(){
    circle(.5);T(4)Pfeil(l=4,b=[1,2.5],shift=-0.5);T(objPos)Color()HexGrid([5,2],1.25,center=false)circle(.5);// cuts in preview
    T(textPos)text("HexGrid(2,1.5)",size=2,valign="top"); 
}
/*


ECHO: "•••• Grid(es=[10,10,10],e=[2,2,1],center=true) ••"
ECHO: "•••• HexGrid ()"
ECHO: "•••• Klon(tx=10,ty=0,tz=0,rx=0,ry=0,rz=0) Objekt ••• Mklon(tx=10,ty=0,tz=0,rx=0,ry=0,rz=0,mx=0,my=0,mz=0) Objekt  ••"
*/
}

union()//•••••••••• Produkt Objekte:   ••••••••••
Anordnen(es=50,option=3,c=undef,loop=false){

Pivot(help=1);//p0=[0,0,0],size=10,active=[1,1,1,1]) ;
Line(help=$helpM);//p0=[0,0,0], p1=[20,20,0], d=2,center=false) ;
//SCT(a=90); //sin cos tan info 
Gardena(help=$helpM);//l=10);
Servotraeger(help=$helpM);//SON=1);
    Servo(help=$helpM);//r=0,narbe=1) ;
Knochen(help=$helpM);//l=+15,d=3,d2=5,b=0,fn=36)   ;
    
Glied(help=$helpM);//l=35,spiel=0.5,la= -0.5,fn=20,d=8,h=10,rand=2);
  union(){
    rotate(90)  DGlied0(l1=12,l2=12,la=-1,rand=.75,d=2) ;
    DGlied1(l1=12,l2=12,la=-1,d=2,rand=.75) ;
  }
  
Luer(help=$helpM);//male=1,lock=1,slip=1) ;
Bitaufnahme(help=$helpM);//l=10,star=true);
  
Imprint(help=$helpM);//txt1="Imprint",radius=10,abstand=29,rotz=-2,h=1.2,rotx=0,roty=0,stauchx=0,stauchy=0,txt0="›",txt2="‹",size=5,font="DejaVusans:style=bold",name=$info)cylinder(1,r=20);
  
Achshalter(help=$helpM);//laenge=30,achse=+5,schraube=3,mutter=5.5,schraubenabstand=15,hoehe=8,fn=fn) ;
Achsenklammer(help=$helpM);//abst=10,achse=3.5,einschnitt=1,h=3,rand=n(2),achsenh=0,fn=72);
  
Vorterantrotor(help=$helpM,rU=5,h=15);//h=40,twist=360,scale=1,zahn=0,rU=10,achsloch=4,ripple=0,caps=2,caps2=0,capdia=6.5,capdia2=0,screw=1.40,screw2=0,screwrot=60,n=1);
  
ReuleauxIntersect(help=$helpM);//h=2,rU=5,2D=false); 
Tugel(help=$helpM);//dia=20,loch=15,scaleKugel=2,scaleTorus=2);

Glied3(help=$helpM);//x=10);
Gelenk(help=$helpM);//l=10,w=0);
 
Balg(help=$helpM);//sizex=16,sizey=16,z=10.0,kerb=6.9,rand=-0.5);
Tring(help=$helpM);//spiel=+0,angle=153,r=5.0,xd=+0.0,h=1.75,top=n(2.5),base=n(4),name=0);
Servokopf(help=$helpM);//rot=0,spiel=0)cylinder(5,d=10);//Objekt
Klon(10)if($idx)Halbrund(h=15,d=8+2*spiel,x=1.5,name=$info);else Halbrund(d=8,x=1,doppel=true)cylinder(4,d=10);///Objekt mikroGetriebemotor Wellenaufnahme 
//depriciate Riemenscheibe(help=$helpM,e=22,radius=15)cylinder(8,d=30);//e=40,radius=25,nockendurchmesser1=2,nockendurchmesser2=2,hoehe=8,name=$info)cylinder(8,r=25);//opt Objekt 
Cring(help=$helpM);//id=20,grad=230,h=15,rand=3,rad=1,end=1,txt=undef,tWeite=15,tSize=5,center=true,fn=fn,fn2=36);

PCBcase(help=$helpM)cube(30,true);
Klammer(help=$helpM);
Pin(help=$helpM);
CyclGetriebe(help=$helpM,light=3,lRand=1);
Buchtung(help=$helpM);
SpiralCut(help=$helpM);
SRing(help=$helpM);
DRing(help=$helpM);//opt polygon
DRing(help=$helpM)circle(1,$fn=5);
GewindeV4(help=$helpM);
BB(help=$helpM); //Ballbearing
union(){
    Abzweig(r1=5,r2=15,help=$helpM);
    cylinder(30,r=5);
    R(90)cylinder(10,r=15);
}
GT2Pulley(help=$helpM);
}


/*

ECHO: "•••• Halb(i=0,x=0,y=0,z=1,2D=0)Objekt      ••"
ECHO: "•••• Drehpunkt(rx=0,ry=0,rz=0,x=0,y=0,z=0,messpunkt=1)Objekt      ••"
ECHO: "•••• Rundrum(x=+40,y=30,r=10,eck=4,twist=0,grad=0,spiel=0.005,fn=fn,n=$info) polygon RStern(help=$helpM)polygon ••"
ECHO: "••••  Kextrude(help=$helpM); ••"
ECHO: "•••• LinEx(help=$helpM) polygon  ••"
ECHO: "•••• LinEx2(bh=5,h=1,slices=10,s=1.00,ds=0.01,dh=0.7,fs=1,fh=1,twist=0,n=$info,fn=fn) ••"
ECHO: "•••• RotEx(grad=360,fn=fn,center=false)  ••"
ECHO: "•••• Rand(rand=n(1),center=false,fn=fn,delta=false,chamfer=false)  ••"
ECHO: "•••• Elipse(x=2,y=2,z=0,fn=36)Object••"
ECHO: "•••• Ttorus(r=20,twist=360,angle=360,fn=fn)3D-Objekt      ••"
ECHO: "•••• Gewinde(help=$helpM)••"
ECHO: "•••• GewindeV3(dn=5,h=10,kern=0,p=1,w=0,profil=0,gh=0.56,g=1,n=$info,fn=36)••"
ECHO: "•••• Kontaktwinkel(winkel=60,d=d,center=true,2D=0,inv=false,n=$info) Objekt  ••"
ECHO: "•••• Bezier(p0=[+0,+10,0],p1=[15,-5,0],p2=[15,+5,0],p3=[0,-10,0],w=1,max=1.0,min=+0.0,fn=50,ex=0,pabs=false,messpunkt=5,n=$info) Objekt •••••"
ECHO: "•••• Laser3D(h=4,layer=10,var=0.002,n=$info,on=-1)3D-Objekt ••"
ECHO: "
•••• Bogen(help=$helpM) opt Polygon   ••
•••• SBogen(help=$helpM) opt Polygon   ••
•••• Row(help=$helpM) opt. Objekt ••
•••• Anordnung(help=$helpM) Objekte ••
•••• Bevel(help=$helpM) Objekt ••
•••• Scale(help=$helpM) Objekt ••

ECHO: 
ECHO: "<h3 style=background-color:#bbddbb><font color='darkgreen'size=5>•••••••••• BasisObjekte:   •••••••••••••</font></h3>"
ECHO: "•• [300] Kugelmantel(d=20,rand=n(2),fn=fn); ••••"
ECHO: "•• [30] Kegel (d1=12,d2=6,v=1,fn=fn,n=$info,center=false,grad=0)  ••• [31]MK(d1=12,d2=6,v=19.5)//v=Steigung ••••"
ECHO: "•• [301] Kegelmantel (d=10,d2=5,v=1,rand=n(2),loch=4.5,grad=0,center=false,fn=fn,n=$info) ••••"
ECHO: "•• [32] Ring(h=5,rand=5,d=20,cd=1,center=false,fn=fn,n=$info,2D=0) cd=1,0,-1  ••••"
ECHO: "•• [33] Torus(trx=10,d=5,a=360,fn=fn,fn2=fn,r=0,n=1,dia=0,center=true,spheres=0)opt polygon ••••"
ECHO: "•• [34] Torus2(m=10,trx=10,a=1,rq=1,d=5,w=2)//m=feinheit,trx = abstand mitte,a = sin verschiebung , rq=mplitude, w wellen •••••"
ECHO: "••  WaveEx(help=$helpM)•••••"
ECHO: "•• [35] Pille(l=10,d=5,fn=fn,fn2=36,center=true,n=1,rad=0,rad2=0,loch=false) •••• "
ECHO: "•• [402] Strebe(skew=0,h=20,d=5,rad=4,rad2=3,sc=0,grad=0,spiel=0.1,fn=fn,center=false,n=$info,2D=false)••••"
ECHO: "•• WStrebe(grad=45,grad2=0,h=20,d=2,rad=3,rad2=0,sc=0,angle=360,spiel=.1,fn=fn,2D=false,center=true,help=helpM) ••••"
ECHO: "•• [36] Twins(h=1,d=0,d11=10,d12=10,d21=10,d22=10,l=20,r=0,fn=60,center=0,sca=+0,2D=false) ••••"
ECHO: "•• [37] Kehle(rad=2.5,dia=0,l=20,angle=360,fn=fn,spiel=spiel,fn2=fn,r2=0)••••"
ECHO: "••  REcke(help=$helpM)••••"
ECHO: "••  HypKehle(help=$helpM)••HypKehleD()••••"
ECHO: "•• [46] Text(text=»«,size=5,h=0,cx=0,cy=0,cz=0,center=0,font=Bahnschrift:style=bold)••••"
ECHO: "•• [47] W5(kurv=15,arms=3,detail=.3,h=50,tz=+0,start=0.7,end=13.7,topdiameter=1,topenddiameter=1,bottomenddiameter=+2)••••"
ECHO: "•• [50] Rohr(grad=90,rad=5,d=8,l1=10,l2=12,fn=fn,fn2=fn,rand=n(2),name=0)••••"
ECHO: "•• [51] Dreieck(h=10,ha=10,ha2=ha,s=1,n=1,c=0,2D=0,grad=0)  s=skaliert  c=center   ••••"
ECHO: "•• [52] Freiwinkel(w=60,h=5)   ••••"
ECHO: "•• [54] Sinuskoerper(h=10,d=33,rand=2,randamp=1,randw=4,amp=1.5,w=4,detail=3,vers=0,fill=0,2D=0,twist=0,scale=1)  amp=Amplitude, w=Wellen, vers=versatz ••••"
ECHO: "•• [55] Kassette(r1=2,r2=2,size=20,h=0,gon=3,fn=fn,fn2=36,r=0,grad=90,grad2=90,spiel=0.001,mitte=true,sizey=0,help=helpM)••••"
ECHO: "•• Surface(multiple,help=helpM)••••"
ECHO: "•• [58] Box(x=8,y=8,z=5,d2=0,c=3.5,s=1.5,eck=4,fnC=36,fnS=24)••••"
ECHO: "•• [62] Spirale(grad=400,diff=2,radius=10,rand=n(2),detail=5,exp=1,hull=true)opt Object••••"
ECHO: "•• [63] Area(a=10,aInnen=0,rInnen=0,h=0,n=$info)••••"
ECHO: "•• [65] Sichel(start=55,max=270,dia=33,radius=30,delta=-1,2D=false)••••"
ECHO: "•• [66] Prisma(x1=12,y1=12,z=6,c1=5,s=1,x2=0,y2=0,x2d=0,y2d=0,c2=0,vC=[0,0,0],cRot=0,fnC=fn,fnS=36,n=$info)••••"
ECHO: "•• Ccube(help=$helpM)••••"
ECHO: 
ECHO: "•• [67] Disphenoid(h=15,l=25,b=20,r=1,ty=0,tz=0,fn=36)••••"
ECHO: "•• Zylinder(help=$helpM)••••"
ECHO: "•• Welle(help=$helpM) opt polygon••••"
ECHO: "•• Anschluss(help=$helpM) ••••"
ECHO: "•• KreisSeg(help=$helpM) ••••"


ECHO: "<h3 style=background-color:#aaaacc><font color='lightblue'size=5>•••••• 2D ••••••</font></h3>"
ECHO: "•• [100] Trapez(h=2.5,x1=6,x2=3.0,d=1,x2d=0,fn=36,n=$info)••••"
ECHO: "•• Tri(grad=60,l=20,h=0,r=0,messpunkt=0,center=+0,top=1,tang=1,fn=fn,n=$info,help=helpM)••••"
ECHO: "•• Tri90(grad,a,b,c,help=$helpM) ••••"
ECHO: "•• Quad((x=20,y=20,r=3,grad=90,grad2=90,fn=36,center=true,centerX=false,n=false,messpunkt=false,help=helpM)••••"
ECHO: "•• VorterantQ(size=20,ofs=.5)••••"
ECHO: "•• Linse(dia=10,r=7.5,n=$info,messpunkt=true)••••"
ECHO: "•• Bogendreieck(rU=5,vari=-1,fn=fn,n=$info) ••• Reuleaux(rU=5,n=$info,fn=fn)••••"
ECHO: "•• Stern(e=5,r1=10,r2=5,mod=2,delta=+0,n=$info)••••"
ECHO: "•• ZigZag(e=5,es=0,x=50,y=5,mod=2,delta=+0,base=2,center=true,n=$info,help=helpM)••••"
ECHO: "
    •• WStern(help=$helpM);
•• Superellipse(help=$helpM);
•• Flower(help=$helpM);
•• Seg7(help=$helpM);
•• WKreis(help=$helpM);
•• RSternFill(help=$helpM);
 •• Cycloid(help=$helpM);
•• SQ(help=$helpM);
•• Vollwelle(help=$helpM);
•• CycloidZahn(help=$helpM);
•• Nut(help=$helpM);
•• DBogen(help=$helpM);(opt polygon)
 •• Pfeil(help=$helpM);
•• Rosette(help=$helpM);
•• GT(help=$helpM);•• Egg(help=$helpM);"

*/