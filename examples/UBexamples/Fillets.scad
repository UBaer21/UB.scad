include<ub.scad>//->http://v.gd/ubaer or https://github.com/UBaer21/UB.scad
/*[Hidden]*/
  useVersion=21.363;
  designVersion=1.0;
  vp=false;
  bed=false;
  $info=true;
  nozzle=.2;
/*[ Fillets ]*/
r=3;//[0:3]
$helpM=false;




//VarioFill();
T(0,-20){
R(40)Color(){
  Tz($idx/10)VarioFill([4,5],exp=0.4,help=true);// fillet based on hyperbel
  Tz($idx/10)VarioFill([4,5],chamfer=false);// fillet based on circle 
  Tz($idx/10)VarioFill(4,exp=1.0);// fillet based on hyperbel exp=1⇒ chamfer
  Tz($idx/10)VarioFill(4,exp=1,deg=20);
  Tz($idx/10)VarioFill([4,5],exp=3);
 } 
  
 T(-6){
  Color(0.45,l=0.6) VarioFill([2,5],exp=3,dia=6,grad=75);
   Kegel(d1=6,grad=75);
 }


T(-20)Rundrum(10,8,r=1)VarioFill([2,5]);
}

//Kehle  linear
rotate(180){Kehle(rad=r,help=true);
T(10)Kehle(rad=r,fase=2);   // chamfered bevel removed
T(15)Kehle(rad=r,fillet=+10,spiel=[0.1,1]);  // fillet added
}

//Kehle circular
T(20)Kehle(rad=r,dia=10,spiel=[1,2]);
T(35){
  Color(l=.8)rotate(30)Kehle(rad=r,dia=5,center=true,grad=60,fillet=0);
  Color(0.3,l=.8)rotate(150)Kehle(rad=r,dia=5,center=true,grad=120,fase=2);
  Pille(4,center=false,rad=[0,1]);
  mirror([0,0,1])cylinder(2,d=11);
  
}
T(20,-20)rotate(180){
 T(+9) Kehle(rad=r,dia=10,spiel=[1,2],grad=90,center=true);
 T(-10)Kehle(rad=r,dia=10,spiel=[1,2],end=2,grad=90);
 T(-20)Kehle(rad=r,dia=10,spiel=[1,2],end=-1,grad=90);
 T(-30)Kehle(rad=r,dia=10,spiel=[1,2],end=+0,fillet=true,fase=+2,grad=90);

}

T(40, +20){Buchtung(size=10,help=true,r=r);
T(-12.5)Buchtung(size=[10,2*r],deltaPhi=90,r=r);
T(-25)Buchtung(size=[6,8],rmin=+1,r=r,l=20,phase=180);
}