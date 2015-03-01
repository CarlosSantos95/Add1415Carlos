func arreglar(palabra)
{
# Nos aseguramos de que los nombres no contengan caracteres extraños
gsub(/ñ/,"n",palabra);
gsub(/á/,"a",palabra);
gsub(/Á/,"A",palabra);
gsub(/é/,"e",palabra);
gsub(/É/,"E",palabra);
gsub(/í/,"i",palabra);
gsub(/Í/,"I",palabra);
gsub(/ó/,"o",palabra);
gsub(/Ó/,"O",palabra);
gsub(/ú/,"u",palabra);
gsub(/Ú/,"U",palabra);
return(palabra)
}
BEGIN{
fichero="crear.bat" # Éste es el fichero que generamos listo para ejecutarse
FS=";"; # Indicamos cuál es el carácter delimitador de campos
dominio="OU=Formacion Profesional,DC=carlos,DC=com";
print "@echo off" > fichero
print "dsrm \""dominio"\" -exclude -noprompt -subtree -q" > fichero
print "dsadd ou \"OU=Ciclo Formativo Grado Medio,"dominio"\" -q" > fichero
# Departamento
# Informatica y comunicaciones
print "dsadd ou \"OU=1CFGM,OU=Ciclo Formativo Grado Medio,"dominio"\" -q" > fichero
print "dsadd ou \"OU=2CFGM,OU=Ciclo Formativo Grado Medio,"dominio"\" -q" > fichero
print "dsadd ou \"OU=Departamentos,"dominio"\" -q" > fichero
print "dsadd ou \"OU=Informatica y comunicaciones,OU=Departamentos,"dominio"\" -q" > fichero
print "dsadd group \"CN=1INF,OU=1CFGM,OU=Ciclo Formativo Grado Medio,"dominio"\" -q" > fichero
print "dsadd group \"CN=2INF,OU=2CFGM,OU=Ciclo Formativo Grado Medio,"dominio"\" -q" > fichero
print "dsadd group \"CN=PINF,OU=Informatica y comunicaciones,OU=Departamentos,"dominio"\" -q"> fichero
# Construccion y edificacion
print "dsadd ou \"OU=Construccion y edificacion,OU=Departamentos,"dominio"\" -q" > fichero
print "dsadd ou \"OU=Programa de Cualificacion Profesional Inicial,"dominio"\" -q" > fichero
print "dsadd ou \"OU=1PCPI,OU=Programa de Cualificacion Profesional Inicial,"dominio"\" -q" > fichero
print "dsadd ou \"OU=2PCPI,OU=Programa de Cualificacion Profesional Inicial,"dominio"\" -q" > fichero
print "dsadd group \"CN=1CON,OU=1PCPI,OU=Programa de Cualificacion Profesional Inicial,"dominio"\" -q" > fichero
print "dsadd group \"CN=2CON,OU=2PCPI,OU=Programa de Cualificacion Profesional Inicial,"dominio"\" -q" > fichero
print "dsadd group \"CN=PCON,OU=Construccion y edificacion,OU=Departamentos,"dominio"\" -q" > fichero
print "echo Estructura de unidades organizativas creada.\nProcediendo a dar de alta a los usuarios..."
home="C:\\Users\\datos"
print "rd /s /q "home > fichero
print "md "home > fichero
}
/1CFGM/{
unidad="OU=1CFGM,OU=Ciclo Formativo Grado Medio,"dominio
direc="1INF"
grupo="CN=1INF,"unidad
profesores="CLH\\PINF:f"
}
/2CFGM/{
unidad="OU=2CFGM,OU=Ciclo Formativo Grado Medio,"dominio
direc="2INF"
grupo="CN=2INF,"unidad
profesores="CLH\\PINF:f"
}
/1PCPI/{
unidad="OU=1PCPI,OU=Programa de Cualificacion Profesional Inicial,"dominio
direc="1CON"
grupo="CN="direc","unidad
profesores="CLH\\PCON:f"
}
/2PCPI/{
unidad="OU=2PCPI,OU=Programa de Cualificacion Profesional Inicial,"dominio
direc="2CON"
grupo="CN="direc","unidad
profesores="CLH\\PCON:f"
}
/Informatica/{
unidad="OU=Informatica y comunicaciones,OU=Departamentos,"dominio
direc="PINF"
grupo="CN="direc","unidad
profesores=""
}
/Construccion/{
unidad="OU=Construccion y edificacion,OU=Departamentos,"dominio
direc="PCON"
grupo="CN="direc","unidad
profesores=""
}
{
nombre=arreglar($1)
apellido1=arreglar($2)
apellido2=arreglar($3)
# Obtenemos: Félix J. MARCELO WIRNITZER (Para el display)
nombrecompleto=nombre" "toupper(apellido1)" "toupper(apellido2)
# Obtenemos: MARCELO WIRNITZER Félix J. (Para el nombre canónico)
nombreordenado=toupper(apellido1)" "toupper(apellido2)" "nombre
# Obtenemos: fmarwir (Para el login de usuario)
usuario=arreglar(tolower(substr($1,1,1)substr($2,1,3)substr($3,1,3)))
clave=int(1000000*rand());
print "dsadd user -upn "usuario"@carlos.com \"CN="nombreordenado","unidad"\" -samid "usuario" -disabled no -pwd $M"clave"a# -mustchpwd yes -memberof \""grupo"\" -fn \""nombre"\" -ln \""apellido1" "apellido2"\" -display \""nombrecompleto"\" -q" > fichero
print "echo "nombreordenado"\t[OK]" > fichero
carpeta=home"\\"direc"\\"usuario
print "md "carpeta > fichero
print "xcacls "carpeta" /Q /G CLH\\"usuario":f Administrators:f "profesores > fichero
}
END{
print "xcacls "home"\\PCON /Q /G CLH\\PCON:x Administrators:f" > fichero
print "xcacls "home"\\PINF /Q /G CLH\\PINF:x Administrators:f" > fichero
print "xcacls "home"\\1INF /Q /G CLH\\1INF:x Administrators:f" > fichero
print "xcacls "home"\\2INF /Q /G CLH\\2INF:x Administrators:f" > fichero
print "xcacls "home"\\1CON /Q /G CLH\\1INF:x Administrators:f" > fichero
print "xcacls "home"\\2CON /Q /G CLH\\2INF:x Administrators:f" > fichero
}