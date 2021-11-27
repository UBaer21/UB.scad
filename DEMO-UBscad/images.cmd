REM make image files for Demo
REM modifier,generator,helper,polygons,objects,products,functions

E:\Prog\OpenSCAD2021.10.19\openscad.exe -o modifier.png -D "show=""modifier""" -q --colorscheme "DeepOcean" --imgsize 900,700 --projection o --camera 40,20,0,0,0,0,180 DEMO.scad

E:\Prog\OpenSCAD2021.10.19\openscad.exe -o generator.png -D "show=""generator""" -q --colorscheme "DeepOcean" --imgsize 900,900 --projection o --camera 35,30,0,0,0,0,220 DEMO.scad

E:\Prog\OpenSCAD2021.10.19\openscad.exe -o helper.png -D "show=""helper""" -q --colorscheme "DeepOcean" --imgsize 900,700 --projection o --camera 25,12,0,0,0,0,125 DEMO.scad

E:\Prog\OpenSCAD2021.10.19\openscad.exe -o polygons.png -D "show=""polygons""" -q --colorscheme "DeepOcean" --imgsize 900,900 --projection o --camera 65,60,0,0,0,0,400 DEMO.scad

E:\Prog\OpenSCAD2021.10.19\openscad.exe -o objects.png -D "show=""objects""" -q --colorscheme "DeepOcean" --imgsize 900,900 --projection o --camera 65,60,0,0,0,0,400 DEMO.scad

E:\Prog\OpenSCAD2021.10.19\openscad.exe -o products.png -D "show=""products""" -q --colorscheme "DeepOcean" --imgsize 900,600 --projection o --camera 120,120,0,55,0,25,600 DEMO.scad

E:\Prog\OpenSCAD2021.10.19\openscad.exe -o functions.png -D "show=""functions""" -q --colorscheme "DeepOcean" --imgsize 900,900 --projection o --camera 35,35,0,0,0,0,250 DEMO.scad
