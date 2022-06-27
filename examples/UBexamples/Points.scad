include<ub.scad>//->http://v.gd/ubaer or https://github.com/UBaer21/UB.scad
/*[Hidden]*/
  useVersion=22.185;
  designVersion=1.2;
  $info=true;
  fn=36;
  
/*[ Points ]*/

pointsOcta=octa(10);


// show Points
Points(pointsOcta,hull=false,center=false);

// make Polyhedron
PolyH(pointsOcta);


// move Points

pointsTrans=mPoints(pointsOcta,r=45,t=30,s=2);

PolyH(pointsTrans);


// 2D

points2D =quad();
points2Dtrans=mPoints(points2D,r=45,t=15);

%T(50)union(){
  polygon(points2D);
  polygon(points2Dtrans);
}

// 2D point corner rounding
p1=[
[0,0],
[10,0],
[10,10],
[5,5],
[0,10],
];


%T(80)union(){
Points(p1,hull=true);
T(15)PolyDeg(p1,rad=1,txt=.5);
T(0,15)PolyRund(p1,r=1,ir=2,ofs=0,delta=0,messpunkt=true);
T(15,15)PolyRund(p1,r=1,ir=2,ofs=1,delta=0,messpunkt=true);
T(30,15)PolyRund(p1,r=1,ir=2,ofs=0,delta=1,messpunkt=true);
T(45,15)PolyRund(p1,r=[0.5,0.5,2,3,2],ofs=0,delta=1,messpunkt=true,fn=[0,5,10,10,10],fs=undef);

}

T(80,30){
fn=8;
p2=[for(z=[0:10]) each polyRund([for(p=p1)[p.x,p.y,z]],r=z/5,ofs=z==10?-1:0, fn=fn)];
PolyH(p2,loop=5*(fn+1));

}
// list of points (make sure to flatten with "each"

pointsList= [for (i =[0:15]) each kreis( r= 10 , z= i, fn= 6 ,rand=0)];
T(-20)PolyH(pointsList);

// single point ends 

sPointsList = [
               [0,0,-15],  // bottom end
               for (i=[-10:10] ) each quad(x=10+sin(i*18)*2,z=i,fn=12), // quad points from z = -10 ⇒ 10
               [0,0, 5]  // top end
];
T(-20,-20)PolyH(sPointsList,pointEnd=true,loop=12+4);  // loop = 4 corner arc with 4 points or 4× 3 fraqments + 4 sides between

// translating points 
dist=20;
rot=90;
pointsListTrans= [for (i =[0:5:rot]) each mPoints(
                                                 kreis( r= 10 , rand= 0 , z= 0, fn= 6 )
                                                ,r=[i],t=[0,dist])];

T(-50){
  PolyH(pointsListTrans, loop = 7);
  Points(pointsListTrans,hull=false,start=18*7,loop=7,center=false);
}

//  modified
union(){
  fn=5;

pointsListMOD= [for (i =[0:5:360]) each mPoints(
                                                 mPoints(kreis( r= 10 +sin(i)*5, rand= 0 ,grad= 90,rot=270, z= 0, fn= fn ),r=i)
                                                ,r=[i,0,0],t=[0,20])];

T(-85) {
  PolyH(pointsListMOD, loop = fn+1,end=false);
  Points(pointsListMOD,hull=false,loop=fn+1,start=30*(fn+1),mark=[0,len(pointsListMOD)-1]);
}

}

// path extrude
T(-110)union(){
profile=kreis(d=3,rand=0);
points=pathPoints(profile,path=wStern(r=7,a=1,fn=5*25,rot=90,z=0),open=false);

PolyH(points,loop=len(profile),end=false);

bezierpath=[for(i=[0:.01:1]) ( bezier(i,p0=[-5,0,0]))];
//polygon(bezierpath);
points2=pathPoints(profile,path=bezierpath,open=true);

T(0,15)PolyH(points2,loop=len(profile),end=true);


}


