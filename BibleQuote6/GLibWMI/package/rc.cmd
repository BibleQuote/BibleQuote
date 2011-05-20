echo ***********************************************
echo      COMPILANDO RECURSOS de los componentes
echo ***********************************************
del glibwmires.res
brcc32 glibwmires.rc > Errores.txt
type Errores.txt
pause
