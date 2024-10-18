//* --- FOCALIZACION --- *//

* 1. Abrir bases: *
clear all
use "C:/Users/apoyo5_dmpmp/Desktop/Adriana_Mo/05. Bases de datos/02. PGH 17092024/1. PGH_BD_091724.dta"

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
		label values Cuna_mas etiq_cunamas
		
	*- 2. PRONABEC: -*
	gen Pronabec = 1 if flag_pronabec_22 == 1 & flag_pronabec == 1
		replace Pronabec = . if flag_pronabec ==1 & flag_pronabec_22 == 0
		replace Pronabec = . if flag_pronabec ==0 & flag_pronabec_22 == 0
		replace Pronabec = 0 if flag_pronabec ==0 & flag_pronabec_22 == 1
		label values Pronabec etiq_pronabec
	
	*- 3. Pensión 65: Solo pobreza extrema -*
	gen P65 = 1 if flag_adultomayor == 1 & flag_p65 == 1
		replace P65 = . if flag_adultomayor ==1 & flag_p65 == 0 
		replace P65 = . if flag_adultomayor ==0 & flag_p65 == 0
		replace P65 = 0 if flag_adultomayor ==1 & flag_p65 == 0 
		label values P65 etiq_adult60
		
	*- 4. Contigo: -*
	gen Contigo = 1 if flag_discapacidad == 1 & flag_contigo == 1
		replace Contigo = . if flag_discapacidad ==0 & flag_contigo == 1
		replace Contigo = . if flag_discapacidad ==0 & flag_contigo == 0
		replace Contigo = 0 if flag_discapacidad ==1 & flag_contigo == 0
		label values Contigo etiq_discapacidad
		
	*- 5. JUNTOS: -*
	gen JUNTOS = 1 if flag_mujer_fertil == 1 & flag_juntos == 1
		replace JUNTOS = . if flag_mujer_fertil ==0 & flag_juntos == 1
		replace JUNTOS = . if flag_mujer_fertil ==0 & flag_juntos == 0
		replace JUNTOS = 0 if flag_mujer_fertil ==1 & flag_juntos == 0
		label values JUNTOS etiq_juntos
				
	*- 6. Lurawi: -*
	tab flag_lurawi
		
	*- 7. PVL: -*
	tab flag_pvl
				
	*- 8. PCA: -*
	tab flag_pca
	
	*- 9. Jovenes Productivos: -*
	tab flag_jovenes_prod
	
	*- 10. PNPE: -*
	tab flag_empleabilidad
	
	*- 11. Techo Propio: -*
	tab flag_techo_propio
	
	*- 12. FISE: -*
	tab flag_fise
	
* 4. Priorización: *
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
	
	gen Lurawi_2 = flag_lurawi
	replace Lurawi_2=. if flag_hogar_cse_pobext==0
		
	gen TP_2 = flag_techo_propio
	replace TP_2=. if flag_hogar_cse_pobext==0
		
	gen FISE_2 = flag_fise
	replace FISE_2=. if flag_hogar_cse_pobext==0
	
	/*1. Total de servicios que el hogar debe recibir y efectivamente recibe */		
		egen hogar_recibe = rowtotal(Cuna_mas Pronabec flag_jovenes_prod flag_empleabilidad flag_pvl flag_pca JUNTOS_2 Lurawi_2 TP_2 FISE_2 Contigo_2 P65_2)
	/*2. Total de servicios que el hogar no debe recibir */
		egen hogar_norecibe = rowmiss(Cuna_mas Pronabec flag_jovenes_prod flag_empleabilidad flag_pvl flag_pca JUNTOS_2 Lurawi_2 TP_2 FISE_2 Contigo_2 P65_2)	
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
	
	gen serv0 = 1 if hogar_recibe == 0  
	replace serv0 = 0 if hogar_recibe >=1
	
	gen ser1a9 = 1 if hogar_recibe >= 1
	replace ser1a9 = 0 if hogar_recibe == 0
	
	*Variable: menores a 19 años, adultos mayores a 60 años, personas dicapacitadas (# vulnerabilidades)
	// menor_19 + discapacidad, adulto_60 + discapacidad
	egen vulne = rowtotal (flag_menor_19 flag_adultomayor flag_discapacidad)
	
	gen v_0 = 1 if vulne ==0
	replace v_0 = 0 if vulne !=0
	gen v_1 = 1 if vulne ==1
	replace v_1 = 0 if vulne !=1
	gen v_2 = 1 if vulne ==2
	replace v_2 = 0 if vulne !=2
	gen v_3 = 1 if vulne ==3
	replace v_3 = 0 if vulne !=3
	
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
		replace decil_pobre_ext = 1 if decil == 10 & flag_hogar_cse_pobext == 1 // decil bajo = pobre extremo
		
	gen decil_pobre_NOext = 0 
		replace decil_pobre_NOext = 1 if decil == 1 & flag_hogar_cse_pobext == 0 // decil alto = pobre no extremo
		
		
		