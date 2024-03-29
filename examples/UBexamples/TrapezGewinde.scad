// TrapezGewinde  30° (UB version 23.250)
use<ub.scad>


Schnitt(){
  TR(12);
  Tz(+0.0)TR(12,innen=true);
}



module TR(string,winkel=30,innen=false){
//https://www.gewinde-normen.de/trapez-regelgewinde.html
//https://de.wikipedia.org/wiki/Trapezgewinde

TR=[

["Name","p","dn[2]","flankenD[3]","kernD Auẞen Gew.[4]" ,"kernD Innen Gew.[5]","Innen Gew. aussen dia[6]"],
["Tr8" , 1.5, 8,       7.3,        6.2,                6.5,                  8.3],
["Tr10" , 2, 10, 9.0,7.5,8.0,10.5],
["Tr12" , 3, 12, 10.5,8.5,9.0,12.5],
["Tr14" , 3, 14, 12.5,10.5,11.0,14.5],
["Tr16" , 4, 16, 14.0,11.5,12.0,16.5],
["Tr18" , 4, 18, 16.0,13.5,14.0,18.5],
["Tr20" , 4, 20, 18.0,15.5,16.0,20.5],
["Tr22" , 5, 22, 19.5,16.5,17.0,22.5],
["Tr24" , 5, 24, 21.5,18.5,19.0,24.5],
["Tr26" , 5, 26, 23.5,20.5,21.0,26.5],
["Tr28" , 5, 28, 25.5,22.5,23.0,28.5],
["Tr30" , 6, 30, 27.0,23.0,24.0,31.0],
["Tr32" , 6, 32, 29.0,25.0,26.0,33.0],
["Tr34" , 6, 34, 31.0,27.0,28.0,35.0],
["Tr36" , 6, 36, 33.0,29.0,30.0,37.0],
["Tr38" , 7, 38, 34.5,30.0,31.0,39.0],
["Tr40" , 7, 40, 36.5,32.0,33.0,41.0],
["Tr42" , 7, 42, 38.5,34.0,35.0,43.0],
["Tr44" , 7, 44, 40.5,36.0,37.0,45.0],
["Tr46" , 8, 46, 42.5,37.0,38.0,47.0],
["Tr48" , 8, 48, 44.0,39.0,40.0,49.0],
["Tr50" , 8, 50, 46.0,41.0,42.0,51.0],
["Tr52" , 8, 52, 48.0,43.0,44.0,53.0],
["Tr60" , 9, 60, 55.5,50.0,51.0,61.0],
["Tr70" , 10, 70, 65.0,59.5,60.0,71.0],
["Tr80" , 10, 80, 75.0,69.0,70.0,81.0],
["Tr90" , 12, 90, 84.0,77.0,78.0,91.0],
["Tr100" , 12, 100, 94.0,87.0,88.0,101.0],
["Tr120" , 14, 120, 113.0,104.0,106.0,122.0]
];

  
  line=search(string,TR,index_col_num=2, num_returns_per_match=2)[0];


  dn=innen?TR[line][6]:TR[line][2];


  p=TR[line][1];
  name=TR[line][0];
  flanke=TR[line][3];
  kern= innen?TR[line][5]:TR[line][4];
  gang=(dn-kern)/2;
  fr=(dn+kern)/2/flanke;

  rad1=p/20;

  Gewinde(dn=dn,
  p=p,winkel=winkel,rad1=rad1,
    ratio=fr*1.0, // lower for more clearance
    innen = innen,kern=kern,name=name);
  echo(str("\n\tTrapezgewinde: ",name,"×",p,"\n"));//,name,dn,p);
  
}





