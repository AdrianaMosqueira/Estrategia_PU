/*
clear all
cls
gl ruta		"C:/Users/apoyo5_dmpmp/Desktop/Adriana_Mo/05. Bases de datos"
gl input 	"${ruta}\1. Módulos"
gl output	"${ruta}\1. Resultados"
*/
//* FOCALIZACION *//

* 1. Abrir bases: *
clear all
use "C:/Users/apoyo5_dmpmp/Desktop/Adriana_Mo/05. Bases de datos/Hogares_PGH_26072024.dta"
/*use "D:/2024/01. trabajo/02. midis/01. FOCALIZACION/04. Indicadores/Hogares_PGH_26072024.dta"*/ 
/*use "D:/2024/01. trabajo/02. midis/01. FOCALIZACION/04. Indicadores/Listado_228 distritos empradronamiento 2024.dta"*/
/*use "/Users/rominamangacambria/Library/CloudStorage/OneDrive-Personal/DMPM/2. PU/7. Estrategia/3. Criterios de priorización territorial/PGH/Hogares_PGH_26072024.dta"*/


* 2. Por el lado de la Demanda: *
label data "Priorización estrategia"
//describe

	/* a. Vulnerabilidad: menores a 19 años, adultos mayores a 60 años, personas dicapacitadas, NN menores a 36 meses */
	gen h_vulnerables= flag_menor_19==1 | flag_adultomayor_60==1 | flag_discapacidad == 1 | flag_menor_36m ==1
		// label define etiq_vulnerables 0 "No vulenrable" 1 "Vulnerable"
		label values h_vulnerables etiq_vulnerables
		// codebook h_vulnerables
	// label variable h_vulnerables "Hogar clasificado como vulnerable"
		
	/* b. Ingresos: < linea de pobreza: Deciles */
	gen Pobreza_=decil>7 /*(comentario 1)*/
		// label define etiq_pobreza 1 "Pobre extremo" 0 "Pobre No extremo"
		label values Pobreza_ etiq_pobreza
		// codebook Pobreza_
	// label variable Pobreza_ "Hogar considerado en situación de pobreza o pobreza extrema"
	
* 3. Por el lado de la Oferta: SERVICIOS (excepto: SIS, PNVR, BPVVRS)*

	*- 1. CUNA MAS: -*
	gen Cuna_mas = 1 if flag_cunamas == 1 & flag_menor_36m == 1 
		replace Cuna_mas = . if flag_cunamas ==1 & flag_menor_36m == 0
		replace Cuna_mas = . if flag_cunamas ==0 & flag_menor_36m == 0
		replace Cuna_mas = 0 if flag_cunamas ==0 & flag_menor_36m == 1
		// label define etiq_cunamas 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values Cuna_mas etiq_cunamas
		// codebook Cuna_mas
	// label variable Cuna_mas "Servicio Cuna Mas: hogares que les corresponde recibir y reciben o no reciben"
		
	*- 2. PRONABEC: -*
	gen Pronabec = 1 if flag_pronabec_22 == 1 & flag_pronabec == 1
		replace Pronabec = . if flag_pronabec ==1 & flag_pronabec_22 == 0
		replace Pronabec = . if flag_pronabec ==0 & flag_pronabec_22 == 0
		replace Pronabec = 0 if flag_pronabec ==0 & flag_pronabec_22 == 1
		// label define etiq_pronabec 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values Pronabec etiq_pronabec
		// codebook Pronabec
	// label variable Pronabec "Servicio PRONABEC: hogares que les corresponde recibir y reciben o no reciben"
	
	*- 3. Pensión 65: Solo pobreza extrema -*
	gen P65 = 1 if flag_adultomayor_60 == 1 & flag_p65 == 1
		replace P65 = . if flag_adultomayor_60 ==1 & flag_p65 == 0 
		replace P65 = . if flag_adultomayor_60 ==0 & flag_p65 == 0
		replace P65 = 0 if flag_adultomayor_60 ==1 & flag_p65 == 0 
		// label define etiq_adult60 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values P65 etiq_adult60
		// codebook P65
	// label variable P65 "Servicio PENSION 65: hogares que les corresponde recibir y reciben o no reciben"
		
	*- 4. Contigo: -*
	gen Contigo = 1 if flag_discapacidad == 1 & flag_contigo == 1
		replace Contigo = . if flag_discapacidad ==0 & flag_contigo == 1
		replace Contigo = . if flag_discapacidad ==0 & flag_contigo == 0
		replace Contigo = 0 if flag_discapacidad ==1 & flag_contigo == 0
		// label define etiq_discapacidad 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values Contigo etiq_discapacidad
		// codebook Contigo
	// label variable Contigo "Servicio CONTIGO: hogares que les corresponde recibir y reciben o no reciben"
		
	*- 5. JUNTOS: -*
	gen JUNTOS = 1 if flag_mujer_fertil == 1 & flag_juntos == 1
		replace JUNTOS = . if flag_mujer_fertil ==0 & flag_juntos == 1
		replace JUNTOS = . if flag_mujer_fertil ==0 & flag_juntos == 0
		replace JUNTOS = 0 if flag_mujer_fertil ==1 & flag_juntos == 0
		// label define etiq_juntos 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values JUNTOS etiq_juntos
		// codebook JUNTOS
	// label variable JUNTOS "Servicio JUNTOS: hogares que les corresponde recibir y reciben o no reciben"
				
	*- 6. Lurawi: -*
	gen Total = 1 if flag_mujer_fertil == 1 | flag_adultomayor_60 == 1 | flag_discapacidad ==1 | flag_menor_19 ==1
	gen Lurawi = 1 if Total == 1 & flag_lurawi == 1
		replace Lurawi = . if Total == 0 & flag_lurawi == 1
		replace Lurawi = . if Total == 0 & flag_lurawi == 0
		replace Lurawi = 0 if Total == 1 & flag_lurawi == 0
		// label define etiq_lurawi 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values Lurawi etiq_lurawi
		// codebook Lurawi
	// label variable Lurawi "Servicio LURAWI: hogares que les corresponde recibir y reciben o no reciben"
		
	*- 7. PVL: -*
	gen PVL = 1 if Total == 1 & flag_pvl == 1
		replace PVL = . if Total == 0 & flag_pvl == 1
		replace PVL = . if Total == 0 & flag_pvl == 0
		replace PVL = 0 if Total == 1 & flag_pvl == 0
		// label define etiq_pvl 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values PVL etiq_pvl
		// codebook PVL
	// label variable PVL "Servicio Programa Vaso de Leche: hogares que les corresponde recibir y reciben o no reciben"
		
	*- 8. PCA: -*
	gen PCA = 1 if Total == 1 & flag_pca == 1
		replace PCA = . if Total == 0 & flag_pca == 1
		replace PCA = . if Total == 0 & flag_pca == 0
		replace PCA = 0 if Total == 1 & flag_pca == 0
		// label define etiq_pca 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values PCA etiq_pca
		// codebook PCA
	// label variable PCA "Servicio Programa de Complementación Alimentaria: hogares que les corresponde recibir y reciben o no reciben"

	*- 9. Jovenes Productivos: -*
	gen Jov_product = 1 if Total == 1 & flag_jovenes_prod == 1
		replace Jov_product = . if Total == 0 & flag_jovenes_prod == 1
		replace Jov_product = . if Total == 0 & flag_jovenes_prod == 0
		replace Jov_product = 0 if Total == 1 & flag_jovenes_prod == 0
		// label define etiq_jp 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values Jov_product etiq_jp
		// codebook Jov_product
	// label variable Jov_product "Jóvenes Productivos: hogares que les corresponde recibir y reciben o no reciben"

	*- 10. PNPE: -*
	gen PNPE = 1 if Total == 1 & flag_empleabilidad == 1
		replace PNPE = . if Total == 0 & flag_empleabilidad == 1
		replace PNPE = . if Total == 0 & flag_empleabilidad == 0
		replace PNPE = 0 if Total == 1 & flag_empleabilidad == 0
		// label define etiq_PNPE 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values PNPE etiq_PNPE
		// codebook PNPE
	// label variable PNPE "Servicio Programa Nacional para la Empleabilidad: hogares que les corresponde recibir y reciben o no reciben"
		
	*- 11. Techo Propio: -*
	gen TP = 1 if Total == 1 & flag_techo_propio == 1
		replace TP = . if Total == 0 & flag_techo_propio == 1
		replace TP = . if Total == 0 & flag_techo_propio == 0
		replace TP = 0 if Total == 1 & flag_techo_propio == 0
		// label define etiq_TP 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values TP etiq_TP
		// codebook TP
	// label variable TP "Servicio Techo Propio: hogares que les corresponde recibir y reciben o no reciben"

	*- 12. FISE: -*
	gen FISE = 1 if Total == 1 & flag_fise == 1
		replace FISE = . if Total == 0 & flag_fise == 1
		replace FISE = . if Total == 0 & flag_fise == 0
		replace FISE = 0 if Total == 1 & flag_fise == 0
		// label define etiq_FISE 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values FISE etiq_FISE
		// codebook FISE
	// label variable FISE "Servicio Fondo de Inclusión Social Energético Propio: hogares que les corresponde recibir y reciben o no reciben"

* 4. Paquetes identificados: *
	/*Paquete "Alivio a la Pobreza": Todos
	  Paquete "Básico": Cuna Mas, PRONABEC, Jóvenes Porductivos, PNPE (Empleabilidad), PVL, PCA */
	// Excluyendo los hogares considerados pobres no extremos (les corresponde el paquete basico)	
		
	gen JUNTOS_2 = JUNTOS
	replace JUNTOS_2=. if Pobreza_==0  // . para hogares que les corresponde el paquete básico
		
	gen Contigo_2 = Contigo
	replace Contigo_2=. if Pobreza_==0
	
	gen P65_2 = P65
	replace P65_2=. if Pobreza_==0
	
	gen Lurawi_2 = Lurawi
	replace Lurawi_2=. if Pobreza_==0
		
	gen TP_2 = TP
	replace TP_2=. if Pobreza_==0
		
	gen FISE_2 = FISE
	replace FISE_2=. if Pobreza_==0
		
* 5. Priorización: 
	* Paquete "Alivio a la Pobreza": Todos los servicios + Pobres extremos y 
	* Paquete "Basico": Cuna mas + Pronabec + JP + PNPE + PVL + PCA + Pobres no extremos 
		
	/*1. Total de servicios que el hogar debe recibir y efectivamente recibe */		
		egen hogar_recibe = rowtotal(Cuna_mas Pronabec Jov_product PNPE PVL PCA JUNTOS_2 Lurawi_2 TP_2 FISE_2 Contigo_2 P65_2)	
	/*2. Total de servicios que el hogar no debe recibir */
		egen hogar_norecibe = rowmiss(Cuna_mas Pronabec Jov_product PNPE PVL PCA JUNTOS_2 Lurawi_2 TP_2 FISE_2 Contigo_2 P65_2)	
	/*3. Total de servicios que el hogar no recibe y debe recibir */
		gen  serv_deberecib = 12 - hogar_norecibe	
		
* 6. Definición de HOGARES CRITICOS: *
	gen hogar_critico = h_vulnerables
	replace hogar_critico = 0 if hogar_recibe > 0 // tab hogar_critico h_vulnerables
	
	*Variable: ratios de servcios que el hogar debe recibir y efectivamente recibe
	gen serv_0 = 1 if hogar_recibe == 0  
	replace serv_0 = 0 if hogar_recibe >=1
	
	gen serv_1a4 = 1 if hogar_recibe >=1 & hogar_recibe <5
	replace serv_1a4 = 0 if hogar_recibe==0 
	replace serv_1a4 = 0 if hogar_recibe>=5
	
	gen serv_5a9 = 1 if hogar_recibe >=5 & hogar_recibe <10
	replace serv_5a9 = 0 if hogar_recibe <5 
	replace serv_5a9 = 0 if hogar_recibe >=10
	
	/*Variable: ratios de servcios que debe recibir y no recibe
	gen serv_4a6 = 1 if serv_deberecib >3 & serv_deberecib<7
	replace serv_4a6 = 0 if serv_deberecib >6
	
	gen serv_7a9 = 1 if serv_deberecib >6 & serv_deberecib<10
	replace serv_7a9 = 0 if serv_deberecib > 9
	replace serv_7a9 = 0 if serv_deberecib < 7
	
	gen serv_10a12 = 1 if serv_deberecib >9 & serv_deberecib<13
	replace serv_10a12 = 0 if serv_deberecib < 10	*/
	
	*Variable: menores a 19 años, adultos mayores a 60 años, personas dicapacitadas (# vulnerabilidades)
	// menor_19 + discapacidad, adulto_60 + discapacidad
	egen vulne = rowtotal (flag_menor_19 flag_adultomayor_60 flag_discapacidad)
	
	gen v_0 = 1 if vulne ==0
	replace v_0 = 0 if vulne !=0
	
	gen v_1 = 1 if vulne ==1
	replace v_1 = 0 if vulne !=1
	
	gen v_2 = 1 if vulne ==2
	replace v_2 = 0 if vulne !=2
	
	gen v_3 = 1 if vulne ==3
	replace v_3 = 0 if vulne !=3
	
	
*7. Filtrar la base por codigo del ccpp, considerando la cantidad de hogares críticos en situación de pobreza extrema*	
	*collapse (first) departamento provincia distrito ubigeo centropoblado (count) co_hogar (sum) hogar_critico Pobreza_ serv_0 serv_1a4 serv_5a9 v_0 v_1 v_2 v_3, by (ccpp)  

	*tab hogar_critico h_vulnerables
	gen proporcion = hogar_critico/co_hogar
	*hist co_hogar if co_hogar < 2000
	
	gen cant_hogar = 1 if co_hogar >=200
	replace cant_hogar = 0 if co_hogar <200
	label define etiq_200 1 "CCPP +200 hogares" 0 "CCPP -200 hogares"
	label values cant_hogar etiq_200

	gen prop_vul3= v_3/co_hogar
	gen prop_vul2= v_2/co_hogar
	gen prop_vul1= v_1/co_hogar
	
	gen prop_pobreb= Pobreza_/co_hogar  // serv_4a6, serv_7a9, serv_10a12
	
* 8. Agrupación *
gen cobertura = 1 if serv_0 == 1 // cobertura baja
	replace cobertura = 2 if serv_1a4 == 1 // cobertura media
	replace cobertura = 3 if serv_5a9 == 1 // cobertura alta
	label define etiq_cobertura 1 "Cobertura baja" 2 "Cobertura media" 3 "Cobertura alta"
	label values cobertura etiq_cobertura
	
gen num_vulnera = 0 if v_0 == 1 // no vulnerable
		replace num_vulnera = 1 if v_1 == 1 // una vulnerabilidad
		replace num_vulnera = 2 if v_2 == 1 // dos vulnerabilidad
		replace num_vulnera = 3 if v_3 == 1 // tres vulnerabilidad
		label define etiq_numvulnera 0 "No vulnerable" 1 "Vulnerabilidad baja" 2 "Vulenrabilidad media" 3 "Vulnerabilidad alta"
		label values num_vulnera etiq_numvulnera

		
	tab cobertura // cantidad de hogares por nivel de cobertura
	tab num_vulnera	// cantidad de hogares por nivel de vulnerabilidad	
	tab num_vulnera cobertura // cantidad de hogares por nivel de cobertura y vulnerabilidad
	
	table departamento cobertura
	table distrito cobertura num_vulnera if departamento == "MADRE DE DIOS"
	tabout distrito cobertura if departamento == "LIMA" using lima.xls

/* División de CCPP en 4 grupos, considerando CCPP con +200 hogares 
xtile quart = hogar_critico if cant_hogar ==1, nq(4)
list hogar_critico quart, sepby(quart)

xtile quint = hogar_critico if cant_hogar ==1, nq(5)
list hogar_critico quint, sepby(quint)

/* División de CCPP en 4 grupos, considerando CCPP con +200 hogares */
xtile menor200 = hogar_critico if cant_hogar ==0, nq(3)
list hogar_critico menor200, sepby(menor200)
	
* N. Intentando *
	
collapse (first) departamento provincia distrito ubigeo centropoblado (count) co_hogar, by (ccpp)*/
*/

bysort ubigeo ccpp: gen tag = _n == 1

collapse (first) departamento provincia distrito (count) co_hogar (sum) tag hogar_critico Pobreza_ serv_0, by (ubigeo)  
collapse (first) departamento provincia distrito (count) co_hogar (sum) serv_0 serv_1a4 serv_5a9, by (ubigeo)

	gen cant_std = (co_hogar - 2) / (155863 -  2) 
	gen prop = hogar_critico / co_hogar
	gen pr_pob = Pobreza_ / co_hogar
	gen pr_serv = serv_0 / co_hogar

	gen criterios= (cant_std + prop + pr_pob + pr_serv) / 4
	xtile grupos = criterios , nq(6)

/* egen combinada*/
	
