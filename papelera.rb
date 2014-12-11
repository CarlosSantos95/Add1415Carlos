#!/usr/bin/ruby
# encoding: utf-8

PARAM1= ARGV[0] || ""
PARAM2 = ARGV[1]
PARAM3 = ARGV[2]

RUTA_HOME=`echo $HOME`
RUTA_PAPELERA = RUTA_HOME.chomp!+"/.papelera"

if (File.exist?(RUTA_PAPELERA)==false)
	puts "#{RUTA_PAPELERA}"
  system ("mkdir #{RUTA_PAPELERA}")
  puts "La papelera ha sido creada"
end
	
if PARAM1 == "--help" then
		puts " -r fichero destino =Recupera el fichero"
		puts "--info = Se mostrará un pequeño informe indicando el número de ficheros que hay en la papelera y el número de directorios."
		puts " --clean = Elimina todo el contenido de la papelera de forma definitiva."
		puts " -i = Se mostrará un menú que permitirá seleccionar entre vaciar la papelera o mostrar sus estadísticas."
		puts "file = Nombre del fichero que queremos enviar a la papelera."
		puts "Sin opciones = Se mostrará la forma de uso del script."
elsif PARAM1 == "-r" then
	`mv  #{RUTA_PAPELERA}/#{PARAM2} #{PARAM3}`
	puts "archivo recuperado"
elsif PARAM1 == "--info" then
	MOSTRARF = `find #{RUTA_PAPELERA} -type f | wc -l`
	MOSTRARD = `find #{RUTA_PAPELERA} -type d | wc -l`
	puts "Numero de ficheros :#{MOSTRARF}"		
	puts "Numero de directorios : #{MOSTRARD}"
elsif PARAM1 == "--clean" then
	`rm -r #{RUTA_PAPELERA}/*`
	
		puts "La papelera se ha vaciado"
elsif PARAM1 == "-i" then
	puts "Elige una opcion: 1-Muestra estadísticas  2-Vaciar la papelera"
	OPCION=$stdin.gets.chomp
	if OPCION=="1"
		system("ls -l #{RUTA_PAPELERA}")
	elsif OPCION=="2"
		`rm -r #{RUTA_PAPELERA}/*`
	end
elsif PARAM1 =="" then
	puts " No has escrito ningún parámetro,estos son los paráetros a elegir:
		[--help]	|	[-r file origen [file destino]]	|	[--info]	|	[--clean]	|	[-i]	|	[file origen]"
else 
	if (File.exist?(PARAM1)) then
		`mv #{PARAM1} #{RUTA_PAPELERA}`
		puts "archivo borrado"
	else
		puts "El archivo no existe"
	end
end
