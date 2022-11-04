# UB.scad
This [library](https://raw.githubusercontent.com/UBaer21/UB.scad/main/libraries/ub.scad) (right click save as) is a full 3Dprinting workflow solution for [openSCAD](https://www.openscad.org) v.21 and above.
There are a lot of settings available but most is using  pre configuration - so you can start with the [template](https://github.com/UBaer21/UB.scad/blob/main/examples/Template/TempUB.scad) but also just with `include<ub.scad>`. [Some Examples](https://github.com/UBaer21/UB.scad/blob/main/examples/UBexamples)

<img src="https://github.com/UBaer21/UB.scad/blob/main/Images/Examples.png" height="275">

- giving you
  * [parameter](#parameter)
  * [functions](#functions)
  *  tools to [modify](#modifier) objects
  *  to [generate](#generator) 3D objects
  *  [helper](#helper) for viewing
  *  [2D polygones](#polygones)
  *  [basic objects](#objects)
  *  and [products](#products)

🌐**But why would you need it? Best to judge from what you can accomplish - i build this lib to make these [Prints](https://www.prusaprinters.org/social/167780)**

🔥 the console (text output) give you some feedback from the lib and modules.<br> The idea is that you can use this without ever looking at the libraries code (modules) itself.

  use `helpsw=true;` (1-5 or `true` for all) to get a list of available modules <br>
  On the top you see some variables like nozzle or clearance aswell fragments (which will change automatically when rendering like some other variables).
  
  Also every `module Example()` has an internal help, use: `Example(help=true);`<br>Additional there are informations displayed on the console window. When giving a name to module `Example(name="Test");` they are emphasized. For a little suprise put in your name.
  
![](https://github.com/UBaer21/UB.scad/blob/main/Images/consoleTXT.png)
  
  and switches to show the status
  ![](https://github.com/UBaer21/UB.scad/blob/main/Images/consoleSchalter.png)
  
# Parameter
<details><summary>List</summary>

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

`hires=false;`   switches higher resolution on (render only)

`show=0;`        show objects like a nozzle width cylinder

`spiel=.2;`      define clearance / padding

`$info=false`    disable info text for all active nameless modules

`$helpM=true`    show all active modules help

`helpsw=1`       show the help (1-5)

`useVersion=21.325` will help to mark which version was used for your design and can improve compatibility

</details>

# Modifier

![modifier](https://github.com/UBaer21/UB.scad/blob/main/Images/modifier.png)
<details><summary>List</summary>

* `T(x,y,z)` translates
* `R(x,y,z)` rotates
* `M()` skew (multmatrix)
* `Linear()` linear copies
* `Polar()`  polar copies
* `Grid()`   grid copies
* `HexGrud()`interlaced grid copies
* `MKlon()`  mirror clone
* `Klon()`   clone
* `Rund()`   round polygons
* `Scale()`  scale axis±
* `Drehpunkt()` vulcrum for rotations
* `Halb()`   cut Objects half
* `Rand()`   creates border on polygons
* `Row()`    places $d size copies with same space

</details>

# Generator

![3Dmodifier](https://github.com/UBaer21/UB.scad/blob/main/Images/generator.png)

# Helper

![helper](https://github.com/UBaer21/UB.scad/blob/main/Images/helper.png)

# [Polygons](https://github.com/UBaer21/UB.scad/blob/main/examples/UBexamples/Polygons.scad)

<details><summary>Open polygons</summary>

![polygons](https://github.com/UBaer21/UB.scad/blob/main/Images/polygons.png)
</details>

# [Objects](https://github.com/UBaer21/UB.scad/blob/main/examples/UBexamples/Objects.scad)
<details><summary>Open objects</summary>

![objects](https://github.com/UBaer21/UB.scad/blob/main/Images/objects.png)
</details>

# [Products](https://github.com/UBaer21/UB.scad/blob/main/examples/UBexamples/Products.scad)
<details><summary>Open products</summary>

![Products](https://github.com/UBaer21/UB.scad/blob/main/Images/products.png)

* `Gewinde()`       creates a thread inner or outer 
* `DRing()`         D-Ring 
* `BB()`            Ballbearing or roller bearing
* `Glied()`         Hinge
  * `DGlied1()`       double hinge A
  * `DGlied2()`       double hinge B
* `SRing()`         Sicherungsring Retaining ring (push on)
* `Luer()`          [Luer taper](https://en.wikipedia.org/wiki/Luer_taper) female/male
* `Pin()`           Bolt (snap/clip in)
* `Halbrund()`      Half-round arbor
* `Cring()`         C-ring
* `GT2Pulley()`     GT2 Pulley
* `CyclGetriebe()`  Cycloidal gear (inner or outer)
* `Klammer()`       Clamp
* `KBS()`           Klemmbaustein - Construction block ( like LEGO™ )
* `Tugel()`         Half hollow sphere half torus
* `Ąchshalter()`    Shaft/axle/spindle clamp
* `Achsenklammer()` holder for 2 cylinder or roller (spring load)
* `PCBcase()`       makes a Case with lid for PCB (also in existing geometries)
* `Gardena()`       Quick connect garden hose fitting adapter
* `Bitaufnahme()`   Screwdriver hex-bit adapter
* `Knochen()`       Bone shaped structure element / Strut with equal height
* `Servokopf()`     printable Servo head connector ( 15 pointed star )
* `Balg()`          Gaiter (square )
* `SpiralCut()`     cutting geometry for walled spiral prints (e.g for a ring)

</details>

# Functions
<details><summary>List</summary>

![functions](https://github.com/UBaer21/UB.scad/blob/main/Images/functions.png)
* `l(x)` № layer in mm depending on layer=
* `n(x,nozzle)` wall / perimeter depending on nozzle=
* `Inkreis( eck, rU)` inner circle of n-gon
* `Umkreis( eck, rI)` outer circle of n-gon
* `Hypotenuse( a, b)` length 
* `Kathete( hyp, kat)` length
* `Sehne( n, r, a)` length n-eck/alpha winkel 
* `RotLang( rot, l, z, e, lz)` [polar vector] (e=elevation)
* `kreisXY(r=5, grad=0)` [vector]
* `TangentenP(grad, rad, r)` distance tangential point
* `Hexstring(c=[r, g, b])` #hexcolor 
* `RotPoints(grad,points)` rotates points 
* `gradB(b, r)` degree for arc section b 
* `gradS(s, r)` degree for chord s 
* `runden(x, dec=2)` round x at decimal
* `radiusS(n, s, a)` radius for chord s on n-gon or for angle 
* `grad(grad=0,min=0,sec=0,h=0,prozent=0,gon=0,rad=0)` conversion everything in degree  
* `inch(inch)` Inch⇒mm  
* `kreisbogen(r, grad=360)` length of an arc r
* `fs2fn(r, grad=360,fs=fs,minf=3)` 
* `vektorWinkel(p1, p2, twist=0)` rotation  vector3 between two points
* `v3(v)` makes v a vector3 
* `parentList( start=1, n= -1)` list with all modules 
* `teiler( n, div=2)` least divisior 
* `gcode( points, f)` generates gcode in output
* `b( n)` switches bool in num and vica versa (works on vectors too)
* `scaleGrad(grad=45, h=1, r=1)` scale factor for extrusions h of circle(r) to obtain angle grad at sides
* `m( r=[0,0,0], t=[0,0,0] )` mulmatrix vector
* `mPoints(points, r, t, s)` transform (rotate translate scale ) point or points (2D/3D)
* `wall(soll=.5,min=1.25,even=false,nozzle=nozzle)` calculates perimeter for "soll" according to nozzle size
* `vMult(v1=[1],v2=1)` multiplicates vectors v1.x × v2.x …
* `vSum(v,start,end)` addition of vector constituents from start to end
* `pathLength(points,close=false)` calculates the sum length of segments (perimeter) 
* `stringChunk(txt,start,length,string)` extract string parts
* `wall(soll,min,even,line)` create width as multiple of line
* `scene(scenes=2,t=$t)` creates an array of t for animation segments
* `map(val,from=[0,1],to=[0,1],contrain=true)` maps val from ↦ to [low,high]

* Points generating
  
  * `pathPoints(points,path,twist=0,scale=1,open=true)` points along path 
  * `kreis(r=10, rand=+5, grad=360, grad2=+0, fn=fn, center=true, sek=true, r2=0, rand2=0, rcenter=0, rot=0, t=[0,0])` points circle or arc
  * `bezier( t, p0=[0,0], p1=[-20,20], p2=[20,20], p3=[0,0])` single point  for t=[0:.1:1]
  * `tetra( r )` tetrahedron points
  * `5gon(b1=20, l1=15, b2=10, l2=30)` points for a pentagon
  * `zigZag(e=5,x=50,y=5,mod=2,delta=+0,base=2,shift=0)` points
  * `vollwelle()` ⇒ Vollwelle(help=1) points
  * `quad(x, y, r, fn)` Quad polygon points x can be vector [x,y] r can be list
  * `stern(e, r1, r2, mod, delta)` Stern polygon points, mod sets additonal points delta moves between
  * `octa(s)` octahedron points (s can be list)
  * `star(e=5,r1=10,r2=5,grad=[0,0],grad2,radial=false,fn=0,z,angle=360,rot=0)` star points ⇒ Star polygon
  * `superellipse(n=2.5,r=10,z,fn=fn` points for a superellipse
  * `kreisSek(r,grad)` points circle part
  * `naca(l,naca,m,p,t,fn,z)` NACA profile
  * `nut()` points for grooves
  * `involute(r,grad)` points involutes
  * `riemen()` points for two connected circles
  * `sq(size,fn)` points square subdivided
  * `bend(points)` bending points polar
  * `polyRund(points,r,ir,ofs,delta,fn,fs)` offset and round points
  * `revP(points)` reverse points order
  
</details>
