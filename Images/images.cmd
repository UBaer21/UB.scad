@echo off

echo make image files for Demo / README.md
echo modifier,generator,helper,polygons,objects,products,functions
echo      .....--------.....
echo.
echo   creating 1/7 modifier.png
E:\Prog\OpenSCAD2022.02\openscad.exe -o modifier.png -D "show=""modifier""" -q --colorscheme "DeepOcean" --imgsize 900,700 --projection o --camera 40,20,0,0,0,0,180 DEMO.scad

echo   creating 2/7 generator.png
E:\Prog\OpenSCAD2022.02\openscad.exe -o generator.png -D "show=""generator""" -q --colorscheme "DeepOcean" --imgsize 900,1100 --projection o --camera 40,35,0,0,0,0,280 DEMO.scad

echo   creating 3/7 helper.png
E:\Prog\OpenSCAD2022.02\openscad.exe -o helper.png -D "show=""helper""" -q --colorscheme "DeepOcean" --imgsize 900,900 --projection o --camera 25,18,0,0,0,0,152 DEMO.scad

echo   creating 4/7 polygons.png
E:\Prog\OpenSCAD2022.02\openscad.exe -o polygons.png -D "show=""polygons""" -q --colorscheme "DeepOcean" --imgsize 900,1200 --projection o --camera 60,75,0,0,0,0,460 DEMO.scad

echo   creating 5/7 objects.png
E:\Prog\OpenSCAD2022.02\openscad.exe -o objects.png -D "show=""objects""" -q --colorscheme "DeepOcean" --imgsize 900,1000 --projection o --camera 50,50,0,0,0,0,335 DEMO.scad

echo   creating 6/7 products.png
E:\Prog\OpenSCAD2022.02\openscad.exe -o products.png -D "show=""products""" -q --colorscheme "DeepOcean" --imgsize 900,600 --projection o --camera 120,120,0,55,0,25,600 DEMO.scad

echo   creating 7/7 functions.png 
E:\Prog\OpenSCAD2022.02\openscad.exe -o functions.png -D "show=""functions""" -q --colorscheme "DeepOcean" --imgsize 900,900 --projection o --camera 35,35,0,0,0,0,250 DEMO.scad

echo   Finished!