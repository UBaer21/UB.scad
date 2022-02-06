include<ub.scad>//->http://v.gd/ubaer or https://github.com/UBaer21/UB.scad
/*[Hidden]*/
  useVersion=22.046;
  designVersion=1.0;

/*[Basics]*/
  vp=false;
  bed=false;
  pPos=[0,0];
  info=true;
  nozzle=.2;

/*[ Gears ]*/
z=10; // number teeth 
f=3; // teeth width divisior
modul=2; // teeth size
h=5; // height
w=30; // helical teeth skew
achse=3;// arbor

function pitchcircle(z=z)=z*modul/f;

T(printPos){ 
//gear
  CyclGetriebe(h=h,z=z,f=f,modul=modul,linear=false,w=w,achse=achse,help=true);
  %Tz(h/2)color("chartreuse")Kreis(d=pitchcircle(z),rand=.1);
// gears
T(pitchcircle(z)*2){ 
  CyclGetriebe(h=h,z=z,f=f,modul=modul,linear=false,center=false,w=w,achse=achse);
  mirror([1,0])CyclGetriebe(h=h,z=z,f=f,modul=modul,linear=false,center=false,rotZahn=-1,w=w,achse=achse);
  }
// inner teeth
T(pitchcircle(z)*4)rotate(180){ 
  CyclGetriebe(h=h,z=z*3,f=f,modul=modul,linear=false,center=false,d=pitchcircle(z*3)+modul,w=w,achse=achse);
  CyclGetriebe(h=h,z=z,f=f,modul=modul,linear=false,center=false,w=w,achse=achse);
  }
  
// rack
  T(0,-pitchcircle(z)*2){
    CyclGetriebe(h=h,z=z,f=f,modul=modul,linear=modul*2,center=false,w=w,achse=achse);
    CyclGetriebe(h=h,z=z,f=f,modul=modul,center=2,rotZahn=0,w=w,achse=achse);
  }
  
// features

  T(pitchcircle(z)*2,pitchcircle(z)+pitchcircle(z*3)/2)CyclGetriebe(h=h,z=z*3,f=f,lock=5,light=5,modul=modul,w=w,achse=achse);
  
}