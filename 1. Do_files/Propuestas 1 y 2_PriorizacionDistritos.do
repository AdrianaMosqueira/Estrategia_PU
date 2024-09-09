//* FOCALIZACION *//

* 1. Abrir bases: *
clear all
use "C:/Users/apoyo5_dmpmp/Desktop/Adriana_Mo/05. Bases de datos/Hogares_PGH_27082024.dta"

* 2. Por el lado de la Demanda: *

	/* a. Vulnerabilidad: menores a 19 años, adultos mayores a 60 años, personas dicapacitadas, NN menores a 36 meses */
	gen h_vulnerables= flag_menor_19==1 | flag_adultomayor ==1 | flag_discapacidad == 1 | flag_menor_36m ==1
		//label define etiq_vulnerables 0 "No vulenrable" 1 "Vulnerable"
		label values h_vulnerables etiq_vulnerables
		// codebook h_vulnerables
	// label variable h_vulnerables "Hogar clasificado como vulnerable"
		
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
	gen P65 = 1 if flag_adultomayor == 1 & flag_p65 == 1
		replace P65 = . if flag_adultomayor ==1 & flag_p65 == 0 
		replace P65 = . if flag_adultomayor ==0 & flag_p65 == 0
		replace P65 = 0 if flag_adultomayor ==1 & flag_p65 == 0 
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
		//label define etiq_juntos 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values JUNTOS etiq_juntos
		// codebook JUNTOS
	// label variable JUNTOS "Servicio JUNTOS: hogares que les corresponde recibir y reciben o no reciben"
				
	*- 6. Lurawi: -*
	gen Total = 1 if flag_mujer_fertil == 1 | flag_adultomayor == 1 | flag_discapacidad ==1 | flag_menor_19 ==1
	gen Lurawi = 1 if Total == 1 & flag_lurawi == 1
		replace Lurawi = . if Total == 0 & flag_lurawi == 1
		replace Lurawi = . if Total == 0 & flag_lurawi == 0
		replace Lurawi = 0 if Total == 1 & flag_lurawi == 0
		//label define etiq_lurawi 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values Lurawi etiq_lurawi
		// codebook Lurawi
	// label variable Lurawi "Servicio LURAWI: hogares que les corresponde recibir y reciben o no reciben"
		
	*- 7. PVL: -*
	gen PVL = 1 if Total == 1 & flag_pvl == 1
		replace PVL = . if Total == 0 & flag_pvl == 1
		replace PVL = . if Total == 0 & flag_pvl == 0
		replace PVL = 0 if Total == 1 & flag_pvl == 0
	//	label define etiq_pvl 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
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
		//label define etiq_jp 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values Jov_product etiq_jp
		// codebook Jov_product
	// label variable Jov_product "Jóvenes Productivos: hogares que les corresponde recibir y reciben o no reciben"

	*- 10. PNPE: -*
	gen PNPE = 1 if Total == 1 & flag_empleabilidad == 1
		replace PNPE = . if Total == 0 & flag_empleabilidad == 1
		replace PNPE = . if Total == 0 & flag_empleabilidad == 0
		replace PNPE = 0 if Total == 1 & flag_empleabilidad == 0
		//label define etiq_PNPE 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
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
		//label define etiq_FISE 1 "Si corresponde y si recibe" 0 "Si corresponde y no recibe"
		label values FISE etiq_FISE
		// codebook FISE
	// label variable FISE "Servicio Fondo de Inclusión Social Energético Propio: hogares que les corresponde recibir y reciben o no reciben"


* 4. Priorización: 
	* Paquete "Alivio a la Pobreza": Todos los servicios + Pobres extremos y 
	* Paquete "Basico": Cuna mas + Pronabec + JP + PNPE + PVL + PCA + Pobres no extremos 
	
	gen JUNTOS_2 = JUNTOS
	replace JUNTOS_2=. if flag_hogar_cse_pobext==0  // . para hogares que les corresponde el paquete básico
		
	gen Contigo_2 = Contigo
	replace Contigo_2=. if flag_hogar_cse_pobext==0
	
	gen P65_2 = P65
	replace P65_2=. if flag_hogar_cse_pobext==0
	
	gen Lurawi_2 = Lurawi
	replace Lurawi_2=. if flag_hogar_cse_pobext==0
		
	gen TP_2 = TP
	replace TP_2=. if flag_hogar_cse_pobext==0
		
	gen FISE_2 = FISE
	replace FISE_2=. if flag_hogar_cse_pobext==0
	/*1. Total de servicios que el hogar debe recibir y efectivamente recibe */		
		egen hogar_recibe = rowtotal(Cuna_mas Pronabec Jov_product PNPE PVL PCA JUNTOS_2 Lurawi_2 TP_2 FISE_2 Contigo_2 P65_2)	
	/*2. Total de servicios que el hogar no debe recibir */
		egen hogar_norecibe = rowmiss(Cuna_mas Pronabec Jov_product PNPE PVL PCA JUNTOS_2 Lurawi_2 TP_2 FISE_2 Contigo_2 P65_2)	
	/*3. Total de servicios que el hogar no recibe y debe recibir */
		gen  serv_deberecib = 12 - hogar_norecibe	
		
* 5. Definición de HOGARES CRITICOS: *
	gen hogar_critico = h_vulnerables
	replace hogar_critico = 0 if hogar_recibe > 0 // tab hogar_critico h_vulnerables
	
* 6. Definición de COBERTURA y VULNERABILIDAD: *

	gen serv0 = 1 if hogar_recibe == 0  
	replace serv0 = 0 if hogar_recibe >=1
	
	gen ser1a9 = 1 if hogar_recibe >= 1
	replace ser1a9 = 0 if hogar_recibe == 0
	
	*Variable: menores a 19 años, adultos mayores a 60 años, personas dicapacitadas (# vulnerabilidades)
	// menor_19 + discapacidad, adulto_60 + discapacidad
	egen vulne = rowtotal (flag_menor_19 flag_adultomayor flag_discapacidad)

	gen v1 = 1 if vulne ==0 | vulne ==1  // 0 o 1 vulnerabilidad por hogar v0
	replace v1 = 0 if vulne==2 | vulne ==3
	
	gen v2 = 1 if vulne ==2 | vulne ==3  // por lo menos 2 vulnerabilidades por hogar v1
	replace v2 = 0 if vulne ==0 | vulne ==1
		
*7. Otras variables: *
	gen pobre_no_ext = 1 if flag_hogar_cse_pobext == 0
		replace pobre_no_ext = 0 if  flag_hogar_cse_pobext== 1
			
	gen hogar_no_critico = 1 if hogar_critico == 0
		replace hogar_no_critico = 0 if hogar_critico == 1 

*8. Por deciles: *	
	gen decil_pobre_ext = 0 
		replace decil_pobre_ext = 1 if decil == 10 & flag_hogar_cse_pobext == 1
		
	gen decil_pobre_NOext = 0 
		replace decil_pobre_NOext = 1 if decil == 1 & flag_hogar_cse_pobext == 0
		
* 8. Intentando *

	* 8.a. PROPUESTA 1: POBREZA EXTREMA & PROPORCION DE HOGAR CRITICO *
	collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico hogar_no_critico flag_hogar_cse_pobext pobre_no_ext serv0 ser1a9 v1 v2 decil_pobre_ext decil_pobre_NOext, by (ubigeo)
	
	gen pobre_extremo = 1 if flag_hogar_cse_pobext > 0
	replace pobre_extremo = 0 if flag_hogar_cse_pobext == 0
	gen proporcion_PE = flag_hogar_cse_pobext/co_hogar

	gen proporcion_HC = hogar_critico/co_hogar 
	gen prop_PE = flag_hogar_cse_pobext/co_hogar

		/*xtile quintiles = proporcion_HC, nq(5)
		bysort quintiles: sum proporcion_HC co_hogar */
 
	gen corte1 = 0 
	replace corte1 = 1 if prop_PE >= 0.413 

	gen corte1a = 0
	replace corte1a = 1 if proporcion_HC >= 0.689
	replace corte1a = 2 if proporcion_HC <= 0.602

	gen P1 = 1 if corte1 == 1 & corte1a == 1
	replace P1 = 2 if  corte1 == 1 & corte1a == 0
	replace P1 = 3 if  corte1 == 0 & corte1a == 1
	replace P1 = 4 if  corte1 == 0 & corte1a == 0
	replace P1 = 5 if  corte1 == 0 & corte1a == 2
	
	/*collapse (sum) hogar_critico flag_hogar_cse_pobext co_hogar, by (P1)*/


	* 8.b. PROPUESTA 2A: POBREZA EXTREMA & VULNERABILIDAD & COBERTURA *
	collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico hogar_no_critico flag_hogar_cse_pobext pobre_no_ext serv0 ser1a9 v1 v2, by (ubigeo)

	/*gen pobre_extremo = 1 if flag_hogar_cse_pobext > 0
		replace pobre_extremo = 0 if flag_hogar_cse_pobext == 0*/

	gen prop_PE = flag_hogar_cse_pobext/co_hogar 
	gen prop_NoPE = pobre_no_ext/co_hogar

	gen prop_v1 = v1/co_hogar
	gen prop_v2 = v2/co_hogar

	gen prop_serv0 = serv0/co_hogar
	gen prop_serv1a9 = ser1a9/co_hogar

	gen pob1 = 0 
	replace pob1 = 1 if prop_PE >= 0.413 
	/*gen pob2 = 0 
	replace pob2 = 1 if prop_NoPE >= 0.587 */

	/*gen vul1 = 0
	replace vul1 = 1 if prop_v1 >= 0.781  // si + del 78,1% de H del distrito registran baja vulne: 0 o 1*/
	gen vul2 = 0
	replace vul2 = 1 if prop_v2 >= 0.219 // vulnerabilidad alta

	gen cob0 = 0
	replace cob0 = 1 if prop_serv0 >= 0.637
	/*gen cob1 = 0
	replace cob1 = 1 if prop_serv1a9 >= 0.363*/

	gen P2 = 1 if pob1 == 1 & vul2 == 1 & cob0 == 1
	 replace P2 = 2 if pob1 == 1 & vul2 == 1 & cob0 == 0 
	 replace P2 = 3 if pob1 == 1 & vul2 == 0 & cob0 == 1 
	 replace P2 = 4 if pob1 == 1 & vul2 == 0 & cob0 == 0
	 replace P2 = 5 if pob1 == 0 & vul2 == 1 & cob0 == 1 
	 replace P2 = 6 if pob1 == 0 & vul2 == 1 & cob0 == 0 
	 replace P2 = 7 if pob1 == 0 & vul2 == 0 & cob0 == 1
	 replace P2 = 8 if pob1 == 0 & vul2 == 0 & cob0 == 0 
	 
	preserve
	collapse (sum) co_hogar hogar_critico flag_hogar_cse_pobext v1 v2 serv0 ser1a9, by (P2)
	restore

	* 8.c. PROPUESTA 2B: POBREZA EXTREMA & COBERTURA & VULNERABILIDAD *

	gen P3 = 1 if pob1 == 1 & cob0 == 1 & vul2 == 1
	 replace P3 = 2 if pob1 == 1 & cob0 == 1 & vul2 == 0 
	 replace P3 = 3 if pob1 == 1 & cob0 == 0 & vul2 == 1 
	 replace P3 = 4 if pob1 == 1 & cob0 == 0 & vul2 == 0
	 replace P3 = 5 if pob1 == 0 & cob0 == 1 & vul2 == 1 
	 replace P3 = 6 if pob1 == 0 & cob0 == 1 & vul2 == 0 
	 replace P3 = 7 if pob1 == 0 & cob0 == 0 & vul2 == 1
	 replace P3 = 8 if pob1 == 0 & cob0 == 0 & vul2 == 0 

	collapse (sum) co_hogar hogar_critico flag_hogar_cse_pobext v1 v2 serv0 ser1a9, by (P3)
	
/* CARACTERIZACÓN */
egen hogar_programa = rowtotal( flag_juntos flag_p65 flag_cunamas flag_sis flag_techo_propio flag_fise flag_pronabec_22 flag_jovenes_prod flag_empleabilidad flag_lurawi flag_pnvr flag_contigo flag_bpvvrs flag_pvl flag_pca)

gen programas = 1 if hogar_programa > 0
replace programas = 0 if hogar_programa == 0 

collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico flag_hogar_cse_pobext serv0 ser1a9 v1 v2, by (ubigeo)
 
collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico flag_hogar_cse_pobext serv0 ser1a9 v1 v2, by (ubigeo)
gen porcent_PE = flag_hogar_cse_pobext/co_hogar // % de H pobres extremos por distrito
gen porcent_COB = serv0/co_hogar // % de H con baja cobertura por distrito
gen porcent_COB1a9 = ser1a9/co_hogar
gen porcent_HC = hogar_critico/co_hogar