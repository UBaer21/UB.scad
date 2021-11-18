# UB.scad
This [library](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries) is a full 3Dprinting workflow solution for [openSCAD](https://www.openscad.org).
There are a lot of settings available but most is using  pre configuration - so you can start with the template but also just with `include<ub.scad>`

<img src="https://github.com/UBaer21/UB.scad/blob/main/DEMO-UBscad/Examples.png" height="275">

- giving you
  * [parameter](#parameter)
  * [functions](#functions)
  *  tools to [modify](#modifier) objects
  *  to [generate](#generator) 3D objects
  *   [helper](#helper) for viewing
  *   [2D polygones](#polygones)
  *   [basic objects](#objects)
  *    and [products](#products)

🌐**But why would you need it? Best to judge from what you can accomplish - i build this lib to make these [Prints](https://www.prusaprinters.org/social/167780)**

🔥 the console (text output) give you some feedback from the lib and modules.<br> The idea is that you can use this without ever looking at the libraries code (modules) itself.

  use `helpsw=true;` (1-5 or `true` for all) to get a list of available modules <br>
  On the top you see some variables like nozzle or clearance aswell fragments (which will change automatically when rendering like some other variables).
  
  Also every `module Example()` has an internal help, use: `Example(help=true);`<br>Additional there are informations displayed on the console window. When giving a name to module `Example(name="Test");` they are emphasized. For a little suprise put in your name.
  
![](https://github.com/UBaer21/UB.scad/blob/main/DEMO-UBscad/consoleTXT.png)
  
  and switches to show the status
  ![](https://github.com/UBaer21/UB.scad/blob/main/DEMO-UBscad/consoleSchalter.png)
  
# Parameter
`name="myProject";` shows a name 

`nozzle=.4;`     defines the nozzle and walls or perimeters

`layer=.2;`      defines the layer hight

`vp=false;`      if you want a fixed viewport

`anima=false;`   use in animations - for viewing animation the animation view in oscad need to be active) 
* `tset` allows to simulate a value when anima=false and then replaces $t in following variables
* `t`    is $t 
* `t0`   rotation 360 deg
* `t1`   -1 ⇔ 1   ( 0↦1↦0↦-1↦0 )
* `t2`   0  ⇔ 1   ( 0↦1↦0 )
* `t3(wert,grad=360,delta)` allow phase shift in wert × sin($t × grad + delta)  

`bed=true;`      showing a print bed and center at `printPos`

`printBed=[220,220];`  set your print bed size

`hires=false;`   switches higher resolution on

`show=0;`        show objects like a nozzle width cylinder

`spiel=.2;`      define clearance / padding

`$info=false`    disable info text for all active nameless modules

`$helpM=true`    show all active modules help

`helpsw=1`       show the help (1-5)

`useVersion=21.325` will help to mark which version was used for your design and can improve compatibility


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

