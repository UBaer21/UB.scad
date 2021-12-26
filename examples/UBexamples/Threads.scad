include<ub.scad> // ub version β22.004

// Threads

Gewinde(preset="M5",h=20);
T(-10)Gewinde(dn=10,p=2,innen=true,h=20);

T(10)Schnitt()Gewinde(dn=10,p=2,kern=8,winkel=30,ratio=1,name="Trapezgewinde");
T(20)Schnitt()Gewinde(dn=10,p=2,kern=8,winkel=30,ratio=1,rund=1,name="Rundgewinde");

T(30)Schnitt(){p=2;
  Gewinde(dn=10,p=p,kern=10 -0.86*p*2,winkel=[30,3],breite=p*0.264,rad2=p*0.125,name="Buttress",start=1);
}
T(20,15)Schnitt()Gewinde(dn=10,p=10,g=3,kern=5,wand=2,winkel=25,rad1=.15,rad2=0.85,h=25,help=1,name="Auger");

T(0,-10)Gewinde(  // Thread module
  p=1,        // Pitch per revolution
  dn=6,       // Diameter nominal
  kern=4.78, //  Core diameter
  breite=0.0383975, // thickness of end rounding
  rad1=0.05,  // rounding radius 1
  rad2=0.1,  //  rounding radius 2
  winkel=60,  // inclusive thread angle e.g 29 for ACME or 55 for BSW
  wand=1,     // wall thickness (⇐ mantel)
  mantel=2.78, // inner or outer shell diameter (↦ wand)
  h=4.5, // height (↦ grad)
  gb=.998261, // thread path height (⇐ p)
  innen=false, // inner or outer thread
  grad=1260,   // degres (⇐ h)
  start=12,    // fragments for primed start
  end=12,     // fragments for primed End
  korrektur=true, // correction of profil angle according to pitch
  profil=false,  // show profile polygon used
  fn2=4, // profile roundingfragments
  fn=36,//  thread fragments per revolution
  cyl=true, // add cylinder (h,d=Kern);
  tz=0,     //  move thread z
  konisch=0, // tapered thread angle
  center=1,  // center thread
  rund=false, // round thread
  ratio=undef,// ratio between threads and space
  spiel=0.15, // clearance for presets only inner threads
  name=undef, // name for info
  help=true  // help
);