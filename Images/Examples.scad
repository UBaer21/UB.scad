use<ub.scad>
//useVersion=25.100; // openSCAD version >= 2025

$fn=72;


T(0,40)Anordnen(es=50,option=2,cl=0.75,c=0.6){
  Auger();
 rotate(50) Wall();
}

Anordnen(es=50,option=2,cl=0.85,c=0.1){
  PipeBlock();
  Hourglas();
  Knob();
  Junction();
  O5();
  Hex();
  
} // End Anordnen


module Wall(){
  SBogen(l1=25,r1=25,r2=5)SBogen(l1=30,l2=15,center=false,use2D=2.5);
}

module Auger(h=75){
  
  Gewinde(dn=20,h=h -9,p=20,kern=12.5,g=2,new=true,rad2=3,cyl=false,tz=10);
  Pille(l=h,center=false,d=12.6,rad=[0,10]);
  Tz(2.5)Pille(5,d=20,rad=1);
  Tz(5)RotEx()VarioFill(dia=12.6,l=[2.5,10]);
}

module Hex(size=7.0)R(180){
  difference(){
    Prisma(25,z=5);
    HexGrid(6,es=size+2)Kassette(gon=6,size=size,r=.25,r1=1,r2=.75);
  }
  
}

module O5(e=5){
  
  LinEx(15,5)Rand(1,center=true)Rund(1,5){
  Polar(e,15)circle(5,$fn=e);
  circle(10);
  }
}


module Junction(jh=15,jd=10,d1=22,d2=30,wallj=1,wall2=2,fn=36)rotate(-90){
  difference(){
    //Halb(1,y=1)Anschluss(d1=d1,d2=d2,wand=wall2,h=[25,30],center=+1);
    rotate(90)RotEx(grad=270)Anschluss(d1=d1,d2=d2,wand=wall2,h=[25,30],center=+1);
    Tz(jh)R(90)cylinder(d2,d=jd-wallj*2);
    Tz(jh)mirror([0,1]) cube(50);
  }
  Tz(jh){
   difference(){ R(90){
      Tz(8)Ring(d2/2+5,rand=wallj,d=jd);
      Abzweig(d1=jd,d2=d2,fn=fn,rad=5,spiel=.5); // <- slow
      Abzweig(d1=jd,d2=d2-wall2*2,fn=fn,rad=2,inside=true,spiel=.5);// <- slow
    }
   mirror([0,1]) cube(50);}
  }
  
Tz(-20) difference(){
   RotEx()Vollwelle(extrude=d1/2,xCenter=-1,r2=3,x0=d1/2-wall2+.1);
   Tz(-5)cube(50);
 }
}



module PipeBlock()union(){
Prisma(10,20,40,c1=5,s=2.5);
Rundrum(10,20,r=2.5)VarioFill(l=[19,30],exp=2.3,spiel=[0,3]);
Tz(30){
  Polar(4,15)R(0,-90,90)Bogen(l=25,d=3,center=+0,rad=5,messpunkt=false);
  MKlon(tx=5)R(0,90)Kehle(dia=3); 
  MKlon(ty=10)R(-90)Kehle(dia=3,rad=1);
  
} 
}

module Knob()T(-10)rotate(-150)R(0)Halb(1,y=1)union(){
 Pille(l=3,d=30,center=false,rad=[0,2]);
 Tz(3){
   Strebe(grad=-20,h=15,d=10,rad=[7,2]);
    Tz(15)T(15*tan(-20)) {
      Pivot(messpunkt=5);
      Pille(d=20,l=5,center=false,rad=2);
    }
 }
}
 



module Hourglas(grad=115,h=15)
union(){
  MKlon(mz=1){
    Kegel(d1=0,h=h,grad=grad,name="Cone",fn=$fn);
    r=tan(grad -90)*(h);// Cone d2 at h
    Tz(h)Kontaktwinkel(baseD=r*2,winkel=180-grad,center=0,centerBase=+1)sphere($r);
  }
  RotEx(cut=true,fn=$fn,$fs=.01)VarioFill(grad=[-(180-grad),grad]);
}  

