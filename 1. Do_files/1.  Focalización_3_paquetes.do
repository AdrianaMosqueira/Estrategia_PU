// ----- * FOCALIZAR POR PAQUETES: Paquete basico vs Paquete Alivio Pobreza * ----- //
* 2. Por el lado de la Demanda: *

	/* a. Vulnerabilidad: menores a 19 años, adultos mayores a 60 años, personas dicapacitadas, NN menores a 36 meses */
	gen h_vulnerables= flag_menor_19==1 | flag_adultomayor ==1 | flag_discapacidad == 1 | flag_menor_36m ==1
		label values h_vulnerables etiq_vulnerables
				
* 3. Por el lado de la Oferta: SERVICIOS (excepto: SIS, PNVR, BPVVRS)*

	*- 1. CUNA MAS: -*
	gen Cuna_mas = 1 if flag_cunamas == 1 & flag_menor_36m == 1 
		replace Cuna_mas = . if flag_cunamas ==1 & flag_menor_36m == 0
		replace Cuna_mas = . if flag_cunamas ==0 & flag_menor_36m == 0
		replace Cuna_mas = 0 if flag_cunamas ==0 & flag_menor_36m == 1
			
	*- 2. PRONABEC: -*
	gen Pronabec = 1 if flag_pronabec_22 == 1 & flag_pronabec == 1
		replace Pronabec = . if flag_pronabec ==1 & flag_pronabec_22 == 0
		replace Pronabec = . if flag_pronabec ==0 & flag_pronabec_22 == 0
		replace Pronabec = 0 if flag_pronabec ==0 & flag_pronabec_22 == 1
			
	*- 3. Pensión 65: Solo pobreza extrema -*
	gen P65 = 1 if flag_adultomayor == 1 & flag_p65 == 1
		replace P65 = . if flag_adultomayor ==1 & flag_p65 == 0 
		replace P65 = . if flag_adultomayor ==0 & flag_p65 == 0
		replace P65 = 0 if flag_adultomayor ==1 & flag_p65 == 0 
				
	*- 4. Contigo: -*
	gen Contigo = 1 if flag_discapacidad == 1 & flag_contigo == 1
		replace Contigo = . if flag_discapacidad ==0 & flag_contigo == 1
		replace Contigo = . if flag_discapacidad ==0 & flag_contigo == 0
		replace Contigo = 0 if flag_discapacidad ==1 & flag_contigo == 0
		
	*- 5. JUNTOS: -*
	gen JUNTOS = 1 if flag_mujer_fertil == 1 & flag_juntos == 1
		replace JUNTOS = . if flag_mujer_fertil ==0 & flag_juntos == 1
		replace JUNTOS = . if flag_mujer_fertil ==0 & flag_juntos == 0
		replace JUNTOS = 0 if flag_mujer_fertil ==1 & flag_juntos == 0
		
	*- 6. Lurawi: -*
	gen Total = 1 if flag_mujer_fertil == 1 | flag_adultomayor == 1 | flag_discapacidad ==1 | flag_menor_19 ==1
	gen Lurawi = 1 if Total == 1 & flag_lurawi == 1
		replace Lurawi = . if Total == 0 & flag_lurawi == 1
		replace Lurawi = . if Total == 0 & flag_lurawi == 0
		replace Lurawi = 0 if Total == 1 & flag_lurawi == 0
		
	*- 7. PVL: -*
	gen PVL = 1 if Total == 1 & flag_pvl == 1
		replace PVL = . if Total == 0 & flag_pvl == 1
		replace PVL = . if Total == 0 & flag_pvl == 0
		replace PVL = 0 if Total == 1 & flag_pvl == 0

	*- 8. PCA: -*
	gen PCA = 1 if Total == 1 & flag_pca == 1
		replace PCA = . if Total == 0 & flag_pca == 1
		replace PCA = . if Total == 0 & flag_pca == 0
		replace PCA = 0 if Total == 1 & flag_pca == 0
		
	*- 9. Jovenes Productivos: -*
	gen Jov_product = 1 if Total == 1 & flag_jovenes_prod == 1
		replace Jov_product = . if Total == 0 & flag_jovenes_prod == 1
		replace Jov_product = . if Total == 0 & flag_jovenes_prod == 0
		replace Jov_product = 0 if Total == 1 & flag_jovenes_prod == 0
		
	*- 10. PNPE: -*
	gen PNPE = 1 if Total == 1 & flag_empleabilidad == 1
		replace PNPE = . if Total == 0 & flag_empleabilidad == 1
		replace PNPE = . if Total == 0 & flag_empleabilidad == 0
		replace PNPE = 0 if Total == 1 & flag_empleabilidad == 0
			
	*- 11. Techo Propio: -*
	gen TP = 1 if Total == 1 & flag_techo_propio == 1
		replace TP = . if Total == 0 & flag_techo_propio == 1
		replace TP = . if Total == 0 & flag_techo_propio == 0
		replace TP = 0 if Total == 1 & flag_techo_propio == 0
		
	*- 12. FISE: -*
	gen FISE = 1 if Total == 1 & flag_fise == 1
		replace FISE = . if Total == 0 & flag_fise == 1
		replace FISE = . if Total == 0 & flag_fise == 0
		replace FISE = 0 if Total == 1 & flag_fise == 0
		
* 4. Priorización: 
	* Paquete "Alivio a la Pobreza": Todos los servicios + Pobres extremos y 
	gen aliv_pobre = 0
	replace aliv_pobre = 1 if flag_hogar_cse_pobext == 1
	
	* Paquete "Basico": Cuna mas + Pronabec + JP + PNPE + PVL + PCA + Pobres no extremos 
	gen paqt_basico = 0
	replace paqt_basico = 1 if flag_hogar_cse_pobext == 0
	
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
	gen serv_0 = 1 if hogar_recibe == 0  
	replace serv_0 = 0 if hogar_recibe >=1
	
	gen serv_1a4 = 1 if hogar_recibe >=1 & hogar_recibe <5
	replace serv_1a4 = 0 if hogar_recibe==0 
	replace serv_1a4 = 0 if hogar_recibe>=5
	
	gen serv_5a9 = 1 if hogar_recibe >=5 & hogar_recibe <10
	replace serv_5a9 = 0 if hogar_recibe <5 
	replace serv_5a9 = 0 if hogar_recibe >=10
	
	*Variable: menores a 19 años, adultos mayores a 60 años, personas dicapacitadas (# vulnerabilidades)
	// menor_19 + discapacidad, adulto_60 + discapacidad
	egen vulne2 = rowtotal (flag_menor_19 flag_adultomayor flag_discapacidad)
	
	gen v_0 = 1 if vulne2 ==0
	replace v_0 = 0 if vulne2 !=0
	
	gen v_1 = 1 if vulne2 ==1
	replace v_1 = 0 if vulne2 !=1
	
	gen v_2 = 1 if vulne2 ==2
	replace v_2 = 0 if vulne2 !=2
	
	gen v_3 = 1 if vulne2 ==3
	replace v_3 = 0 if vulne2 !=3
		
*7. Otras variables: *
	gen pobre_no_ext = 1 if flag_hogar_cse_pobext == 0
		replace pobre_no_ext = 0 if  flag_hogar_cse_pobext== 1
			
	gen hogar_no_critico = 1 if hogar_critico == 0
		replace hogar_no_critico = 0 if hogar_critico == 1 

*8. Por deciles: *	
	gen decil_pobre_ext = 0 
		replace decil_pobre_ext = 1 if decil == 10 // decil bajo = pobre extremo
		
	gen decil_pobre_NOext = 0 
		replace decil_pobre_NOext = 1 if decil == 1 // decil alto = pobre no extremo
		
* 9. POBREZA EXTREMA & PROPORCION DE HOGAR CRITICO *
	collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico hogar_no_critico flag_hogar_cse_pobext pobre_no_ext serv_0 serv_1a4 serv_5a9 v_0 v_1 v_2 v_3 decil_pobre_ext decil_pobre_NOext, by (ubigeo)
	
	gen pobre_extremo = 1 if flag_hogar_cse_pobext > 0
	replace pobre_extremo = 0 if flag_hogar_cse_pobext == 0
	
	gen proporcion_PE = flag_hogar_cse_pobext/co_hogar
	gen proporcion_HC = hogar_critico/co_hogar 
	gen prop_PE = flag_hogar_cse_pobext/co_hogar

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

	use "C:/Users/apoyo5_dmpmp/Desktop/ADRIANA MO/02. ESTRATEGIA/05. BASE DE DATOS/focalizacion_paquetes",clear
	merge 1:1 departamento provincia distrito using "C:/Users/apoyo5_dmpmp/Desktop/ADRIANA MO/02. ESTRATEGIA/05. BASE DE DATOS/urbano-rural",nogen keep(3)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	