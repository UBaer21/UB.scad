// Products

//include <ub.scad>; // requires ub.scad https://github.com/UBaer21/UB.scad
pVersion=23.022;
/*change log
23|022 UPD HingBox
/*


/**
\name Hinge Box
HingeBox() creates 2 box halfs with hinges
\param size size [x,y,z]
\param wand wall thickness
\param hinges  number of hinges (optional)
\param lip  overlapping inner lip
\param pip  print in place clearance
\param pattern pattern number [bottom,top]
\param lid  optional for smaller lid heights
\param r1 corner radius (optional)
\param ir1 inner corner radius (optional)
\param r2 edge radius (optional)
\param ir2 inner edge radius (optional)
\param opt  select lower or upper half, 0 for both
\param opener grips to open  -1,0,1 
\param help help
*/

//HingeBox();

module HingeBox(size=[1,1,.5]*25,wand=.8,hinges,lip=true,pip=pip,pattern=[0,0],lid,r1,ir1,r2,ir2,opt=0,opener=false,bottom,name,help){

r1=r1?r1:min(size.xy/4); // corner radius
r2=r2?r2:1.5; // edge radius
ir1=max(.5,r1-wand,is_undef(ir1)?r1-wand:ir1); // inner corner radius
ir2=max(.5,r2-wand,is_undef(ir2)?r2-wand:ir2); // inner edge radius

hinges=hinges?hinges:max(1,round((size.y-r1*2)/((2.75+pip)*2)));

hingeD=5;
hingePin=hingeD/2;
hingePos=[hingeD/2+(pip?pip+.2:spiel),0,size.z/2];
if(!pip)echo(hinge_Hole=hingePin);
seg=hinges*2+1 ;
segL=(size.y-r1*2)/seg-pip;
sizeZ2=lid?lid:size.z/2;
bottom=is_undef(bottom)?wand:bottom;
latchL=min(size.y-(wand+ir1)*2,20);
lippe=[wand/2,is_num(lip)?lip:1.5]; // thickness, height

HelpTxt("HingeBox",["size",size,"wand",wand,"hinges",hinges,"lip",lip,"pip",pip,"pattern",pattern,"lid",lid,"r1",r1,"ir1",ir1,"r2",r2,"ir2",ir2,"opt",opt,"opener",opener,"bottom",bottom,"name",name],help);
InfoTxt("HingeBox",["InsideSize",[each(size.xy-[2,2]*wand),size.z/2+sizeZ2-bottom*2],"HingePos [x,z]",hingePos ],name);
union(){
$info=false;
Tz(!pip&&opt==2?-size.z/2+sizeZ2:0){

if(pip||opt==1)T(hingePos.x)BoxH(opt=1,pattern=pattern[0]);
if(pip||opt==2)Tz(size.z/2-sizeZ2)mirror([1,0])T(hingePos.x)BoxH([each size.xy,sizeZ2*2],opt=2,pattern=pattern[1]);

// Hinge
T(y=-size.y/2+pip/2+r1)Linear(seg,y=1,es=segL+pip)if(pip||(opt==1?!($idx%2):opt==2?$idx%2:false)){

    difference(){
      hull(){
        Tz(hingePos.z)R(-90)
          Pille(segL,d=hingeD,rad=.25,center=false);
        mirror([$idx%2?1:0,0,0])T(hingePos.x,z=($idx%2?r2+size.z/2-sizeZ2:r2))cube([.1,segL,($idx%2?sizeZ2:size.z/2)-r2-.5]);
      }
      if(pip&&$idx%2)Tz(hingePos.z)R(-90)Loch(segL,min(segL/3,hingePin/2.5),d=hingePin,rad=hingePin/4,cuts=0);
       else if(!pip) Tz(hingePos.z)R(90)linear_extrude(size.y*2,center=true,convexity=5)Tdrop(d=hingePin);
   }
}

}

// hingePin
if(pip)Linear(e=max(1,hinges),y=1,es=(segL+pip)*2,center=true)Tz(hingePos.z)R(-90)Loch(segL+pip*2,h2=min((segL+pip*2)/3,(hingePin)/2.5),d=hingePin-pip*2,rad=(hingePin-pip*2)/4,cuts=0,center=true);

}
  module BoxH(size=size,wand=wand,bottom=bottom,opt=0,latchPos=1.5,latchL=latchL,pattern=2,opener=opener,lippe=lippe){
  
  $info=false;
  //echo(size,opt);
    T(size.x/2)difference(){
      union(){
        Prisma(vMult(size,[1,1,.5]),r=r1,rad=r2,deg=[50,0]);
        if (opener){
      gY=size.y/2-r1;
      T(size.x/2-.5)mirror([0,opener==2||opener==-1?opt==1?0:1:opt==1?1:0,0])hull(){
        T(y=spiel,z=size.z/2)mirror([0,0,1])Prisma(4,gY,1,r=1,center=[0,0,0]);
        T(y=spiel,z=max(r2,size.z/2-4))cube([.1,max(gY-4,.5),.1]);
        }
      }
      }
      Tz(bottom)Prisma(size-[1,1,0]*wand*2,r=ir1,rad=ir2,deg=[90,0]);
//Pattern
     if(pattern)intersection(){
      if(pattern==1)HexGrid(e=[floor(size.x/4/sin(60))-1,ceil(size.y/4)+1],es=4)cylinder(.5,d=3,$fn=6,center=true);
      if(pattern==2)rotate(90)HexGrid(e=[floor(size.y/3/sin(60))-1,ceil(size.x/3.0)+1],es=3)Polar(3,rot=30)T(1.5/2-.1)cube([1.5,.5,.5],center=true);
      linear_extrude(100,center=true,convexity=5)Quad(size.xy-(r2+wand)*[2,2],rad=max(ir1-r2,0));
      }
// Latch groove
      if(opt==2){
        Tz(size.z/2-latchPos)R(90)LinEx(latchL-3,end=true,center=true)Vollwelle(.5,xCenter=-1,extrude=size.x/2-wand);
        T(size.x/2-wand -0.01,z=size.z/2+.01)R(-90)Kehle(l=latchL-2,center=true,end=2,rad=wand-n(1),fn2=4);
      }
    }
    
// Grip

    if(opt==2&&wand<1)T(size.x)Tz(size.z/2-latchPos)R(90)LinEx(latchL-2,end=true,center=true)Vollwelle(.5+wand,max(0.2,.5-wand),xCenter=-1,extrude=0,x0=-.1);// groove compensation
    if(!opener){
      if(size.z/2-r2<=8){if(opt==1)T(size.x)Tz(max(size.z/5,r2+1.0))R(90)LinEx(size.y-r1*2-2,end=true,center=true)Vollwelle(.5,xCenter=-1,extrude=0,x0=-.1);
      }
       else Tz(r2/2){
        if(opt==1)T(size.x)Tz(size.z/4)R(90)LinEx(size.y-r1*2 -7,end=true,center=true)Vollwelle(.5,xCenter=-1,extrude=0,x0=-.1);
          T(size.x)Tz(size.z/4)R(90)LinEx(size.y-r1*2-7.01,end=true,center=true)T(0,-3)Vollwelle(.5,xCenter=-1,extrude=0,x0=-.1);
          T(size.x)Tz(size.z/4+3)R(90)LinEx(size.y-r1*2-7,end=false,center=true)Vollwelle(.5,xCenter=-1,extrude=0,x0=-.1);
        }
    }
  //latch
    if(opt==1){
      intersection(){
        T(size.x-wand + (lip?-spiel-.001:0.01))Tz(size.z/2+latchPos-.15)R(90)LinEx(latchL-3,end=true,center=true)Vollwelle(.5-spiel,.5+spiel,xCenter=-1,extrude=0,x0=-wand+.1,l=20);
        T(size.x-wand-spiel)R(0,-90)linear_extrude(max(2,lippe[0]*2),center=true)Quad(size.z/2+2.25,latchL-.5,center=[0,1],rad=1);
        T(size.x-wand,z=size.z -1.99)R(90)cylinder(size.y,d=size.z,$fn=4,center=true);
      }
    }
    
   // lip
   
    if (lip&&opt==1)T(size.x/2,z=size.z/2-0.1){
      Tz(-.1)linear_extrude(lippe[1]+.1,convexity=5) Rand(-lippe[0])Quad(size.xy-(wand+spiel)*[2,2],r=max(0,ir1-spiel));
      Tz(-2)difference(){
        linear_extrude(2,convexity=5)difference(){
        //Rand(-lippe[0]-wand-spiel+.1)
          Quad(size.xy-.1*[2,2],r=r1-.1);
          Quad(size.xy-(lippe[0]+wand+spiel)*[2,2],r=max(0,ir1-lippe[0]-spiel));
        }
        Tz(-.001)Roof()Quad(size.xy-(wand-.1)*[2,2],r=ir1+.1,fn=50);
        }
      }
  }


}