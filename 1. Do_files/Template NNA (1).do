/* ***************************************************************
  	TEMA		: NNA
  	OBJETO		: 
  	AUTOR/A		: 
  	FECHA		: 
*****************************************************************
	Indicador	: 		
	Numerador	:	
	Denominador	:	   												
	Nota		:
				
******************************************************************
*	Establecer la ruta 
*****************************************************************/	
	clear all
	cls
	gl ruta		"C:\Users\ee-hp\OneDrive\MIDIS\ENAHO"
	gl input 	"${ruta}\1. Módulos"
	gl output	"${ruta}\3. Resultados"
		
/*****************************************************************
*	Generar un algoritmo aplicable para todos los años
*****************************************************************/
	cd 		"${input}"
	
	/*****************************************************************
	*	Parte 1, Tarea 1: 	Importar los datos y módulos
							Filtrar solo aquellas personas que formaban
							parte del hogar encuestado						
	*****************************************************************/
	use "enaho01a-2023-400",clear
	merge 1:1 conglome vivienda hogar ubigeo codperso using "enaho01a-2023-300",nogen keep(3)
	merge 1:1 conglome vivienda hogar ubigeo codperso using "enaho01a-2023-500",nogen keep(3)
	merge 1:1 conglome vivienda hogar ubigeo codperso using "enaho01b-2023-1",nogen keep(3)
	merge 1:1 conglome vivienda hogar ubigeo codperso using "enaho01b-2023-2",nogen keep(3)
		
	merge m:1 conglome vivienda hogar ubigeo using "enaho01-2023-100",nogen keep(3)
	merge m:1 conglome vivienda hogar ubigeo using "sumaria-`x'",nogen keep(3)
	
	gen 	miembro = 0
	replace miembro = 1 if (p205==2 | p206==1)
	keep if miembro ==1 //representa la población total
	/*****************************************************************
	*	Parte 1, Tarea 2: 	Agrupar la población por grupo etario
	*****************************************************************/
	gen 	edad_cat = ""
	replace edad_cat = "5 o menos años" if p208a <= 5
	replace edad_cat = "6-13 años" 	if p208a >= 6 & p208a <= 13
	replace edad_cat = "14-17 años" if p208a >= 14 & p208a <= 17
	replace edad_cat = "18-24 años" if p208a >= 18 & p208a <= 24
	replace edad_cat = "25-35 años" if p208a >= 25 & p208a <= 35
	replace edad_cat = "36-50 años" if p208a >= 36 & p208a <= 50
	replace edad_cat = "51-65 años" if p208a >= 51 & p208a <= 65
	replace edad_cat = "66 o más años" if p208a >= 66	
	
	/*****************************************************************
	*	Parte 1, Tarea 3: 	Cálculo del indicador o variable
	*****************************************************************/
	
	
	
	
	
	
	
	
	/*****************************************************************
	*	Parte 2, Tarea 1: 	Proyectar los resultados 
							Factores de expansión: factor07 / fac500
	*****************************************************************/	
	
	svyset conglome [pw=factor07], strata(pobrezav)
	svy: tab ///VARIABLE////
	
	/*****************************************************************
	*	Parte 2, Tarea 1: 	Exportar los resultados
							Factores de expansión: factor07 / fac500
	*****************************************************************/
	
	collapse 	(sum) pobreza_mon miembro [iw=factor07],by(pobrezav)	
	export excel "$output\nna_a.xlsx",firstrow(variables) replace

	
	
	