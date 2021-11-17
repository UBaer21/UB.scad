use<ub.scad>

$fn=72;


Anordnen(es=50,cl=0.85,c=0.1){
  PipeBlock();
  Hourglas();
  Knob();
  Junction();
  O5();
  Hex();
  
} // End Anordnen


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
    Halb(1,y=1)Anschluss(d1=d1,d2=d2,wand=wall2,h=[25,30],center=+1);
    Tz(jh)R(90)cylinder(d2,d=jd-wallj*2);
  }
  Tz(jh){
    R(90){
      Tz(8)Ring(d2/2+5,rand=wallj,d=jd);
      Abzweig(d1=jd,d2=d2,fn=fn,rad=5,spiel=.5); // <- slow
      Abzweig(d1=jd,d2=d2-wall2*2,fn=fn,rad=2,inside=true,spiel=.5);// <- slow
    }
  }
  
  Tz(-20)RotEx()Vollwelle(extrude=d1/2,xCenter=-1,x0=d1/2-wall2+.1);
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

module Knob()R(-30)Halb(1,y=1)union(){
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
    Kegel(d1=0,h=h,grad=grad,name="Cone");
    r=tan(grad -90)*(h);// Cone d2 at h
    Tz(h)Kontaktwinkel(baseD=r*2,winkel=180-grad,center=0,centerBase=+1)sphere($r);
  }
  RotEx(cut=true)VarioFill(grad=[-(180-grad),grad]);
}  

