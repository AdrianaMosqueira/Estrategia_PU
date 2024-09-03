/* ***************************************************************
*  	TEMA			: Pobreza Urbana
*  	OBJETO			: Caracterización de variables
*  	AUTOR/A			: EEHP / DMPMP
*  	FECHA			: 20/05/2024
*****************************************************************
	** Indicador	: Personas con empleo informal		
	** Numerador	: ocupinf: Con empleo informal	
	** Denominador	: personas de 14 años a más 
	** Nota			: Factor de expansión: fac500(a)
				
******************************************************************
*	Establecer la ruta 
*****************************************************************/	
	clear all
	cls
	gl ruta		"C:\Users\apoyo3_dmpmp\OneDrive\MIDIS\ENAHO"
	gl input 	"${ruta}\1. Módulos"
	gl output	"${ruta}\3. Resultados"
		
/* ************************************************************** */
	local nombre 2019 2020 2021 2022 2023
	foreach x of local nombre {
	cd 		"${input}"
	
	/*****************************************************************
	*	Parte 1, Tarea 1: 	Importar los datos y módulos
							Filtrar solo aquellas personas que formaban
							parte del hogar encuestado						
	*****************************************************************/
	use "enaho01a-`x'-400",clear
	merge m:1 conglome vivienda hogar ubigeo using "sumaria-`x'",nogen keep(3)
	merge 1:1 conglome vivienda hogar codperso using "enaho01a-`x'-500",nogen keep(3)
	gen 	miembro = 0
	replace miembro = 1 if (p205==2 | p206==1)

	/*****************************************************************
	*	Parte 1, Tarea 2: 	Delimitar la población con discapacidad.
							P401H - Limitaciones para: 
							1) Moverse o caminar, para usar brazos o 
							piernas; y/o
							2) Ver aun usando anteojos; y/o
							3) Hablar o comunicarse aun con lenguaje de 
							señas u otro; y/o
							4) Oir aun usando audifonos; y/o
							5) Entender o aprender, concentrarse y 
							recordar; y/o
							6) Relacionarse con los demás por sus 
							pensamientos, sentimientos, emociones o 
							conductas).
	*****************************************************************/
	gen str15	discapacidad="" 
	foreach 	var of varlist p401h*{
				replace discapacidad="Con discapacidad" if `var'==1 
								 }
	replace 	discapacidad="Sin discapacidad" if missing(discapacidad)
	
	/*****************************************************************
	*	Parte 1, Tarea 3: 	Diferenciar urbano y rural
	*****************************************************************/
	gen str15 residencia = ""
	replace residencia = "Rural" if estrsocial == 6 | estrsocial ==.
	replace residencia = "Urbano" if residencia == "" 
	
	/*****************************************************************
	*	Parte 1, Tarea 4: 	Delimitar los rango etarios
	*****************************************************************/
	gen str15 edad_cat = ""
	replace edad_cat = "5 o menos años" if p208a <= 5
	replace edad_cat = "6-13 años" 	if p208a >= 6 & p208a <= 13
	replace edad_cat = "14-17 años" if p208a >= 14 & p208a <= 17
	replace edad_cat = "18-24 años" if p208a >= 18 & p208a <= 24
	replace edad_cat = "25-35 años" if p208a >= 25 & p208a <= 35
	replace edad_cat = "36-50 años" if p208a >= 36 & p208a <= 50
	replace edad_cat = "51-65 años" if p208a >= 51 & p208a <= 65
	replace edad_cat = "66 o más años" if p208a >= 66
	
	/*****************************************************************
	*	Parte 1, Tarea 5: 	Delimitar la población que pertenece a un
							hogar catalogado como:
							-Pobre (1)
							-Pobre extremo (2)
	*****************************************************************/
	gen 	pobreza_mon="Pobre o Pobre Extremo" if pobreza==1|pobreza==2			
	replace	pobreza_mon="No pobre" if pobreza_mon==""

	/*****************************************************************
	*	Parte 1, Tarea 6: 	Quedarnos con las variables de interés
	*****************************************************************/
	keep 		if miembro==1
	gen 		año=`x'
	
	if (año == 2019) {
	keep	año miembro discapacidad residencia p208a edad_cat pobreza_mon pobreza ocupinf ocu500 fac500 p207 
					 }
	else 			 {
	keep	año miembro discapacidad residencia p208a edad_cat pobreza_mon pobreza ocupinf ocu500 fac500a p207 
					 }
	
	save 		"pobreza_`x'.dta",replace		
}

	/*****************************************************************
	*	Parte 2, Tarea 1: 	Situación de la PEA
							0. 0
							1. Ocupado
							2. Desocupado abierto
							3. Desocupado oculto
							4. No pea
	*****************************************************************/
	local nombre 2019 2020 2021 2022 2023
	foreach x of local nombre {
	use 	"pobreza_`x'.dta",clear
	drop if ocu500==0 
	save 	"pobreza_`x'.dta",replace
 	}

	/*****************************************************************
	*	Parte 2, Tarea 2: 	Situación de informalidad (ocup.principal)
							1. Empleo Informal
							2. Empleo formal			
	*****************************************************************/
	local nombre 2019 2020 2021 2022 2023
	foreach x of local nombre {
	cd 		"${input}"
	use 	"pobreza_`x'.dta",clear
	
	gen trabajo_informal= 1 if ocupinf==1
			
	save 	"pobreza_`x'.dta",replace
 	}
	
	/*****************************************************************
	*	Parte 2, Tarea 3: 	Nos quedamos con los resultados específicos
	*****************************************************************/
	
	local nombre 2019
	foreach x of local nombre {
	cd 		"${input}"
	use 	"pobreza_`x'.dta",clear
	
	collapse 	(sum) trabajo_informal miembro [iw=fac500],by(año p207 discapacidad residencia edad_cat pobreza_mon ocu500)
	rename		miembro pob_total
	rename 		p207 sexo
		
	save 	"pobreza_`x'.dta",replace
 	}	
		
	local nombre 2020 2021 2022 2023
	foreach x of local nombre {
	cd 		"${input}"
	use 	"pobreza_`x'.dta",clear
	
	collapse 	(sum) trabajo_informal miembro [iw=fac500a],by(año p207 discapacidad residencia edad_cat pobreza_mon ocu500)
	rename		miembro pob_total
	rename 		p207 sexo
		
	save 	"pobreza_`x'.dta",replace
 	}	
		
		
	/*****************************************************************
	*	Parte 3, Tarea 1: 	Juntar y exportar los datos
	*****************************************************************/
	local nombre 2020 2021 2022 2023
	foreach x of local nombre {
	cd 		"${input}"
	use 	"pobreza_2019.dta",clear
	append 	using "pobreza_`x'.dta"
	save 	"pobreza_2019.dta",replace
 	}

	export excel "$output\i12. Empleo informal testb.xlsx",firstrow(variables) replace
	
	*****************************************************************
	*	Parte 3, Tarea 2: 	Borrar las bases temporales
	****************************************************************
	local nombre 2020 2021 2022 2023
	foreach x of local nombre {
	cd 		"${input}"
	erase   "pobreza_`x'.dta"
	}	
	erase   "pobreza_2019.dta"


	