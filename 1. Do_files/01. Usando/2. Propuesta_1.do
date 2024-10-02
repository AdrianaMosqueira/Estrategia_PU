//* --- PROPUESTA 1: POBREZA EXTREMA & PROPORCION DE HOGAR CRITICO --- *//

clear all
use "C:/Users/apoyo5_dmpmp/Desktop/Adriana_Mo/05. Bases de datos/02. PGH 17092024/2. BD_inicialLimpia_091724.dta"

collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico hogar_no_critico flag_hogar_cse_pobext aliv_pobre pobre_no_ext paqt_basico serv0 ser1a9 v1 v2 decil_pobre_ext decil_pobre_NOext, by (ubigeo)
	
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

	gen P1 = 1 if corte1 == 1 & corte1a == 0 | corte1a == 1
	replace P1 = 2 if  corte1 == 1 & corte1a == 2
	replace P1 = 3 if  corte1 == 0 & corte1a == 1
	replace P1 = 4 if  corte1 == 0 & corte1a == 0
	replace P1 = 5 if  corte1 == 0 & corte1a == 2
	
	collapse (sum) hogar_critico flag_hogar_cse_pobext co_hogar, by (P1)

	
//* CARACTERIZACIÓN: CCPP *//

* 1. Abrir bases: *
clear all
use "C:/Users/apoyo5_dmpmp/Desktop/ADRIANA MO/02. ESTRATEGIA/02. ESQUEMA DE PROGRESIVIDAD/Hogares_PGH_75var.dta"

collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico hogar_no_critico flag_hogar_cse_pobext pobre_no_ext serv_0 serv_1a4 serv_5a9 serv0 ser1a9 v_0 v_1 v_2 v_3 v1 v2 decil_pobre_ext decil_pobre_NOext, by (ubigeo)

gen tipo_dist = 0
	replace tipo_dist = 1 if co_hogar >= 100

collapse (first) departamento provincia distrito centropoblado (count) co_hogar (sum) hogar_critico hogar_no_critico flag_hogar_cse_pobext pobre_no_ext serv_0 serv_1a4 serv_5a9 serv0 ser1a9 v_0 v_1 v_2 v_3 v1 v2 decil_pobre_ext decil_pobre_NOext, by (ccpp)