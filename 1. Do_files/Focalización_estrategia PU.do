clear all
cls
gl ruta		"C:/Users/apoyo5_dmpmp/Desktop/Adriana_Mo/05. Bases de datos"
gl input 	"${ruta}\1. Módulos"
gl output	"${ruta}\1. Resultados"

//* FOCALIZACION *//

* 1. Abrir bases: *
use "C:/Users/apoyo5_dmpmp/Desktop/Adriana_Mo/05. Bases de datos/Hogares_PGH_26072024.dta"
/*use "D:/2024/01. trabajo/02. midis/01. FOCALIZACION/04. Indicadores/Hogares_PGH_26072024.dta"
use "D:/2024/01. trabajo/02. midis/01. FOCALIZACION/04. Indicadores/Listado_228 distritos empradronamiento 2024.dta"*/

* 2. Por el lado de la Demanda: *
label data "Priorización estrategia"
describe

	/* a. Vulnerabilidad: flag_menor_19, flag_adultomayor_60, flag_discapacidad, flag_menor_36m */
	gen flag_menor19=flag_menor_19
		label define etiq_menor_19 0 "No" 1 "Si"
		label values flag_menor19 etiq_menor_19
		codebook flag_menor19
	label variable flag_menor19 "Hogar con al menos un menor de 19 anos"
	
	gen flag_adultomayor60=flag_adultomayor_60
		label define etiq_mayor_60 0 "No" 1 "Si"
		label values flag_adultomayor60 etiq_mayor_60
		codebook flag_adultomayor60
	label variable flag_adultomayor60 "Hogar con al menos un adulto de 60 y más años de edad"
	
	gen flag_discapacidad_=flag_discapacidad
		label define etiq_discap 0 "No" 1 "Si"
		label values flag_discapacidad_ etiq_discap
		codebook flag_discapacidad_
	label variable flag_discapacidad_ "Hogar con al menos un miembro con discapacidad"

	gen flag_menor36m=flag_menor_36m
		label define etiq_menor36m 0 "No" 1 "Si"
		label values flag_menor36m etiq_menor36m
		codebook flag_menor36m
	label variable flag_menor36m "Hogar con al menos un miembro de 36 meses"
	
	/* VULNERABILIDAD */
	gen h_vulnerables= flag_menor_19==1 | flag_adultomayor_60==1 | flag_discapacidad == 1 | flag_menor_36m ==1
		label define etiq_vulnerables 0 "No vulenrable" 1 "Vulnerable"
		label values h_vulnerables etiq_vulnerables
		codebook h_vulnerables
	label variable h_vulnerables "Hogar clasificado como vulnerable"
	
	
	/* b. Ingresos: < linea de pobreza: Deciles */
	gen Pobreza_=decil>5 /*(comentario 1)*/
		label define etiq_pobreza 1 "Pobre extremo" 0 "Pobre No extremo"
		label values Pobreza_ etiq_pobreza
		codebook Pobreza_
	label variable Pobreza_ "Hogar considerado en situación de pobreza o pobreza extrema"

* 3. Por el lado de la Oferta: SERVICIOS (excepto: SIS, PNVR, BPVVRS)*

	/* a. Usuarios de los servicios: */
		*- 1. CUNA MAS: -*
		gen Cuna_mas = 1 if flag_cunamas == 1 & flag_menor_36m == 1 
			replace Cuna_mas = . if flag_cunamas ==1 & flag_menor_36m == 0
			replace Cuna_mas = . if flag_cunamas ==0 & flag_menor_36m == 0
			replace Cuna_mas = 0 if flag_cunamas ==0 & flag_menor_36m == 1
			label define etiq_cunamas 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values Cuna_mas etiq_cunamas
			codebook Cuna_mas
		label variable Cuna_mas "Servicio Cuna Mas: hogares que les corresponde recibir y reciben o no reciben"
		
		*- 2. PRONABEC: -*
		gen Pronabec = 1 if flag_pronabec_22 == 1 & flag_pronabec == 1
			replace Pronabec = . if flag_pronabec ==1 & flag_pronabec_22 == 0
			replace Pronabec = . if flag_pronabec ==0 & flag_pronabec_22 == 0
			replace Pronabec = 0 if flag_pronabec ==0 & flag_pronabec_22 == 1
			label define etiq_pronabec 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values Pronabec etiq_pronabec
			codebook Pronabec
		label variable Pronabec "Servicio PRONABEC: hogares que les corresponde recibir y reciben o no reciben"
		
		*- 3. Pensión 65: Solo pobreza extrema -*
		gen P65 = 1 if flag_adultomayor_60 == 1 & Pobreza_ == 1 & flag_p65 == 1
			replace P65 = . if flag_adultomayor_60 ==1 & Pobreza_ == 0 & flag_p65 == 0 
			replace P65 = . if flag_adultomayor_60 ==1 & Pobreza_ == 0 & flag_p65 == 1
			replace P65 = . if flag_adultomayor_60 ==0 & Pobreza_ == 1 & flag_p65 == 0
			replace P65 = . if flag_adultomayor_60 ==0 & Pobreza_ == 1 & flag_p65 == 1
			replace P65 = . if flag_adultomayor_60 ==0 & Pobreza_ == 0 & flag_p65 == 0
			replace P65 = . if flag_adultomayor_60 ==0 & Pobreza_ == 0 & flag_p65 == 1
			replace P65 = 0 if flag_adultomayor_60 ==1 & Pobreza_ == 1 & flag_p65 == 0 
			label define etiq_adult60 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values P65 etiq_adult60
			codebook P65
		label variable P65 "Servicio PENSION 65: hogares que les corresponde recibir y reciben o no reciben"
		
		*- 4. Contigo: -*
		gen Contigo = 1 if flag_discapacidad == 1 & flag_contigo == 1
			replace Contigo = . if flag_discapacidad ==0 & flag_contigo == 1
			replace Contigo = . if flag_discapacidad ==0 & flag_contigo == 0
			replace Contigo = 0 if flag_discapacidad ==1 & flag_contigo == 0
			label define etiq_discapacidad 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values Contigo etiq_discapacidad
			codebook Contigo
		label variable Contigo "Servicio CONTIGO: hogares que les corresponde recibir y reciben o no reciben"
		
		*- 5. JUNTOS: -*
		gen JUNTOS = 1 if flag_mujer_fertil == 1 & flag_juntos == 1
			replace JUNTOS = . if flag_mujer_fertil ==0 & flag_juntos == 1
			replace JUNTOS = . if flag_mujer_fertil ==0 & flag_juntos == 0
			replace JUNTOS = 0 if flag_mujer_fertil ==1 & flag_juntos == 0
			label define etiq_juntos 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values JUNTOS etiq_juntos
			codebook JUNTOS
		label variable JUNTOS "Servicio JUNTOS: hogares que les corresponde recibir y reciben o no reciben"
				
		*- 6. Lurawi: -*
		gen Total = 1 if flag_mujer_fertil == 1 | flag_adultomayor_60 == 1 | flag_discapacidad ==1 | flag_menor_19 ==1
		gen Lurawi = 1 if Total == 1 & flag_lurawi == 1
			replace Lurawi = . if Total == 0 & flag_lurawi == 1
			replace Lurawi = . if Total == 0 & flag_lurawi == 0
			replace Lurawi = 0 if Total == 1 & flag_lurawi == 0
			label define etiq_lurawi 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values Lurawi etiq_lurawi
			codebook Lurawi
		label variable Lurawi "Servicio LURAWI: hogares que les corresponde recibir y reciben o no reciben"
		
		*- 7. PVL: -*
		gen PVL = 1 if Total == 1 & flag_pvl == 1
			replace PVL = . if Total == 0 & flag_pvl == 1
			replace PVL = . if Total == 0 & flag_pvl == 0
			replace PVL = 0 if Total == 1 & flag_pvl == 0
			label define etiq_pvl 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values PVL etiq_pvl
			codebook PVL
		label variable PVL "Servicio Programa Vaso de Leche: hogares que les corresponde recibir y reciben o no reciben"
		
		*- 8. PCA: -*
		gen PCA = 1 if Total == 1 & flag_pca == 1
			replace PCA = . if Total == 0 & flag_pca == 1
			replace PCA = . if Total == 0 & flag_pca == 0
			replace PCA = 0 if Total == 1 & flag_pca == 0
			label define etiq_pca 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values PCA etiq_pca
			codebook PCA
		label variable PCA "Servicio Programa de Complementación Alimentaria: hogares que les corresponde recibir y reciben o no reciben"

		*- 9. Jovenes Productivos: -*
		gen Jov_product = 1 if Total == 1 & flag_jovenes_prod == 1
			replace Jov_product = . if Total == 0 & flag_jovenes_prod == 1
			replace Jov_product = . if Total == 0 & flag_jovenes_prod == 0
			replace Jov_product = 0 if Total == 1 & flag_jovenes_prod == 0
			label define etiq_jp 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values Jov_product etiq_jp
			codebook Jov_product
		label variable Jov_product "Jóvenes Productivos: hogares que les corresponde recibir y reciben o no reciben"

		*- 10. PNPE: -*
		gen PNPE = 1 if Total == 1 & flag_empleabilidad == 1
			replace PNPE = . if Total == 0 & flag_empleabilidad == 1
			replace PNPE = . if Total == 0 & flag_empleabilidad == 0
			replace PNPE = 0 if Total == 1 & flag_empleabilidad == 0
			label define etiq_PNPE 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values PNPE etiq_PNPE
			codebook PNPE
		label variable PNPE "Servicio Programa Nacional para la Empleabilidad: hogares que les corresponde recibir y reciben o no reciben"
		
		*- 11. Techo Propio: -*
		gen TP = 1 if Total == 1 & flag_techo_propio == 1
			replace TP = . if Total == 0 & flag_techo_propio == 1
			replace TP = . if Total == 0 & flag_techo_propio == 0
			replace TP = 0 if Total == 1 & flag_techo_propio == 0
			label define etiq_TP 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values TP etiq_TP
			codebook TP
		label variable TP "Servicio Techo Propio: hogares que les corresponde recibir y reciben o no reciben"

		*- 12. FISE: -*
		gen FISE = 1 if Total == 1 & flag_fise == 1
			replace FISE = . if Total == 0 & flag_fise == 1
			replace FISE = . if Total == 0 & flag_fise == 0
			replace FISE = 0 if Total == 1 & flag_fise == 0
			label define etiq_FISE 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
			label values FISE etiq_FISE
			codebook FISE
		label variable FISE "Servicio Fondo de Inclusión Social Energético Propio: hogares que les corresponde recibir y reciben o no reciben"

	
	/* b. Paquetes identificados:
		- Paquete "Alivio a la Pobreza": Todos
		- Paquete "Básico": Cuna Mas, PRONABEC, Jóvenes Porductivos, PNPE (Empleabilidad), PVL, PCA */
		gen Pack_AlivPo = Pobreza_==1 /* por modif, con info sobre pobre extremo */
			label define etiq_PAPz 1 "Paquete APz" 0 "Paquete Basico"
			label values Pack_AlivPo etiq_PAPz
			codebook Pack_AlivPo
		label variable Pack_AlivPo "Asignación de paquetes: paquete alivio de la pobreza y paquete básico"

		
		gen JUNTOS_2 = JUNTOS
		replace JUNTOS_2=. if Pack_AlivPo==0
		
		gen Contigo_2 = Contigo
		replace Contigo_2=. if Pack_AlivPo==0
		
		gen P65_2 = P65
		replace P65_2=. if Pack_AlivPo==0
		
		gen Lurawi_2 = Lurawi
		replace Lurawi_2=. if Pack_AlivPo==0
		
		gen TP_2 = TP
		replace TP_2=. if Pack_AlivPo==0
		
		gen FISE_2 = FISE
		replace FISE_2=. if Pack_AlivPo==0
		
		
	/* Priorización: Paquete "Alivio a la Pobreza": Todos */
			
	/* Priorización: Paquete "Alivio a la Pobreza": Todos */
		/*1. Hogares que si deben recibir y efectivamente reciben el servicio*/		
		egen Prob1 = rowtotal(Cuna_mas Pronabec Jov_product PNPE PVL PCA JUNTOS_2 Lurawi_2 TP_2 FISE_2 Contigo_2 P65_2)	
		/*2. Hogares que no les corresponde recibir el servicio*/
		egen Prob2 = rowmiss(Cuna_mas Pronabec Jov_product PNPE PVL PCA JUNTOS_2 Lurawi_2 TP_2 FISE_2 Contigo_2 P65_2)	
		/*3. Hogares que si deben recibir y efectivamente reciben*/
		gen Prob3 = 12 - Prob2	
			
			
		