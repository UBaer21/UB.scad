# UB.scad
This [library](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries) is a full 3Dprinting workflow solution for [openSCAD](https://www.openscad.org).
- giving you
  * [functions](#functions)
  *  tools to [modify](#modifier) objects
  *  to [generate](#generator) 3D objects
  *   [helper](#helper) for viewing
  *   [2D polygones](#polygones)
  *   [basic objects](#objects)
  *    and [products](#products)

🌐**But why would you need it? Best to judge from what you can accomplish - i build this lib to make these [Prints](https://www.prusaprinters.org/social/167780)**

- the console (text output) give you some feedback from the lib and modules

  use `helpsw=true;` (1-5 or `true` for all) to get an overview <br>
  On the top you see some variables like nozzle or clearance aswell fragments (these change automatically when rendering), switches or for animation
  
  Also every module Example() has an internal help, use: `Example(help=true);` or `$helpM=true;` to activate all active modules help.<br>Additional there are informations displayed on the console window. When giving a name to module `Example(name="Test");` they are emphasized `$info=false;` deactivates all info texts from modules without a name.
  ![](https://github.com/UBaer21/UB.scad/blob/main/DEMO-UBscad/consoleTXT.png)

# Modifier

![modifier](https://github.com/UBaer21/UB.scad/blob/main/DEMO-UBscad/DEMOmodifier.png)

# Generator

![3Dmodifier](https://github.com/UBaer21/UB.scad/blob/main/DEMO-UBscad/DEMOgenerator.png)

# Helper

![helper](https://github.com/UBaer21/UB.scad/blob/main/DEMO-UBscad/DEMOhelper.png)

# Polygons

![polygons](https://github.com/UBaer21/UB.scad/blob/main/DEMO-UBscad/DEMOpolygons.png)

# Objects

![objects](https://github.com/UBaer21/UB.scad/blob/main/DEMO-UBscad/DEMOobjects.png)

# Products

![Products](https://github.com/UBaer21/UB.scad/blob/main/DEMO-UBscad/DEMOproducts.png)

# Functions

![functions](https://github.com/UBaer21/UB.scad/blob/main/DEMO-UBscad/DEMOfunctions.png)
* l(x) № layer in mm depending on layer=
* n(x) wall / perimeter depending on nozzle=
* Inkreis(eck,rU) inner circle of n-gon
* Umkreis(eck,rI) outer circle of n-gon
* Hypotenuse(a,b) length 
* Kathete(hyp,kat) length
* Sehne(n,r,a) length n-eck/alpha winkel 
* RotLang(rot,l,z,e,lz) [vector] (e=elevation)
* Bezier(t,p0=[0,0],p1=[-20,20],p2=[20,20],p3=[0,0]) points   
* Kreis(r=10,rand=+5,grad=360,grad2=+0,fn=fn,center=true,sek=true,r2=0,rand2=0,rcenter=0,rot=0,t=[0,0]) points circle or arc
* KreisXY(r=5,grad=0) [vector]
* 5gon(b1=20,l1=15,b2=10,l2=30) points 
* ZigZag(e=5,x=50,y=5,mod=2,delta=+0,base=2,shift=0) points 
* TangentenP(grad,rad,r) length 
* Hexstring(c=[r,g,b]) #hexcolor 
* RotPoints(grad,points) 
* gradB(b,r) grad zum Bogenstück b 
* gradS(s,r) grad zur Sehne s 
* vollwelle() ⇒ Vollwelle(help=1) points
* runden(x,dec=2) round x at decimal
* radiusS(n,s,a); radius zur Sehne 
* grad(grad=0,min=0,sec=0,h=0,prozent=0,gon=0,rad=0); conversion everything in degree  
* inch(inch); Inch⇒mm  
* kreisbogen(r,grad=360); length of an arc r
* fs2fn(r,grad=360,fs=fs,minf=3); 
* vektorWinkel(p1,p2,twist=0); rotation  vector3 between two points
* v3(v); makes v a vector3 
* parentList() list with all modules 
* teiler(n,div=2) least divisior 
* gcode(points,f) generates gcode in output
* b(n); switches bool in num and vica versa (works on vectors too)

