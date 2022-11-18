include<ub.scad>; //⇒ v.gd/ubaer or https://github.com/UBaer21/UB.scad
/*[Hidden]*/
designVersion="1.0";
designer="Ulrich Bär";
license="CC0";
useVersion=22.316;//(sites.google.com/site/ulrichbaer)
assert(Version>=useVersion,str("lib version ",Version," detected, install ",useVersion," ub.scad library‼ ⇒http://v.gd/ubaer"));
/*[Basics]*/
nozzle=.2;
bed=false;
pPos=[0,0];
info=true;
name=undef;

/*[]*/


T(printPos){
  
  
}



// version Info
if(designVersion)T(1,-1)color("navy")linear_extrude(.1)Seg7(str(designVersion),h=1,spiel=0.01,b=.05,ratio=0.5,center=true,name=0);