include<ub.scad>//->http://v.gd/ubaer or https://github.com/UBaer21/UB.scad
/*[Hidden]*/
  useVersion=22.222;
  designVersion=1.0;
  vp=false;
  bed=false;
  $info=true;
  nozzle=.2;
/*[ Knurl ]*/




Zylinder(
h=10, // height
//d=20, // optional centerline diameter (⇒ r)
r=10, //  centerline radius
a=.5,  // Knurl height ± a  so  tips are r+a while grooves are r-a
lambda=4, // Knurl width and height e.g. [3,5] (⇒ f/f2 & fn/fnz)
);



Tz(15)intersection(){ // Grip with knurl
  h=15;
  d=10;
  Zylinder(d=d,lambda=2,h=15);
  Pille(l=h,d=d,rad=1,center=false);
}


T(20,0,25)Zylinder(d=10,lambda=5,a=1,fn=100,fnh=100,h=15); // Wavy knurl

T(20){
  Zylinder(r=-5,scale=0.3);  // Cone
  T(20)intersection(){  // inverted knurl e.g. for insides as difference object
    Zylinder(h=10,r=-4.8,lambda=4);
    cylinder(h=10,r=5);
  }
  T(20,z=20)intersection(){  // sphere
    union(){
      R(0,90)Zylinder(h=5,r=5,lambda=2,sphere=+1,lz=+0);// better printable with lz=number
      R(0,-90)Zylinder(h=5,r=5,lambda=2,sphere=+1,lz=undef);
    }
    sphere(r=5);
  }
  
}


T(0,0,-50){
Knurl(
r=10, // radius zylinder for Knurls
h=9, // height
size=[2.4,3,1], // knurl size&depth
// depth = [-1,1],  // knurl depth ↦ overwrites size.z
delta=[0,1],  // Knurl center translation
alt=0,  // alternate positon for next z level
);

T(20)Knurl(r=2,size=1,scale=2);
T(40)Knurl(r=10,e=[12,4],depth=[1,0,-1,0],delta=[[0,1],[0,0],[0,-1],[0,0]],alt=1);
T(70)Knurl(r=10,size=[2.4,3,[1,-2]],delta=[[-.5,.5],[.5,-.5]],alt=1);


}



Tz(-15)R(45){  // flat knurl  (painful to use)
union(){
  Surface(rand=0,waves=true,freqX=2.5,freqY=2.5,res=1,ampX=.5,zBase=1);
  Surface(rand=0,waves=true,freqX=2.5,freqY=2.5,res=1,ampX=.5,zBase=1,versch=[2,2]);
}
T(21)intersection(){
  Surface(rand=0,waves=true,freqX=2.5,freqY=2.5,res=1,ampX=.5);
  Surface(rand=0,waves=true,freqX=2.5,freqY=2.5,res=1,ampX=.5,versch=[2,2]);
}

T(42)Surface(rand=0,waves=true,freqX=2,freqY=2);
}