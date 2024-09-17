clear all	
	use "C:/Users/apoyo5_dmpmp/Desktop/Adriana_Mo/05. Bases de datos/1. Focalizacion_3_paquetes",clear

// *----- A. PAQUETE BÁSICO: ----- *//

* 1. Cobertura: *
	gen PB_serv0 = 0
		replace PB_serv0 = 1 if flag_hogar_cse_pobext==0 & serv_0==1
	gen PB_serv1a4 = 0
		replace PB_serv1a4 = 1 if flag_hogar_cse_pobext==0 & serv_1a4==1
	gen PB_serv5a9 = 0
		replace PB_serv5a9 = 1 if flag_hogar_cse_pobext==0 & serv_5a9==1	
		
* 3. Decíl: *	
	gen PB_decil1 = 0
		replace PB_decil1 = 1 if flag_hogar_cse_pobext==0 & decil==1
	gen PB_decil10 = 0
		replace PB_decil10 = 1 if flag_hogar_cse_pobext==0 & decil==10	

// *----- B. PAQUETE ALIVIO DE LA POBREZA: ----- *//

* 1. Cobertura: *
	gen PAP_serv0 = 0
		replace PAP_serv0 = 1 if flag_hogar_cse_pobext==1 & serv_0==1
	gen PAP_serv1a4 = 0
		replace PAP_serv1a4 = 1 if flag_hogar_cse_pobext==1 & serv_1a4==1
	gen PAP_serv5a9 = 0
		replace PAP_serv5a9 = 1 if flag_hogar_cse_pobext==1 & serv_5a9==1	
		
* 3. Decíl: *	
	gen PAP_decil1 = 0
		replace PAP_decil1 = 1 if flag_hogar_cse_pobext==1 & decil==1
	gen PAP_decil10 = 0
		replace PAP_decil10 = 1 if flag_hogar_cse_pobext==1 & decil==10	
		
		
* POBREZA EXTREMA & PROPORCION DE HOGAR CRITICO *
	collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico hogar_no_critico flag_hogar_cse_pobext pobre_no_ext decil_pobre_ext decil_pobre_NOext PB_serv0 PB_serv1a4 PB_serv5a9 PB_decil1 PB_decil10 PAP_serv0 PAP_serv1a4 PAP_serv5a9 PAP_decil1 PAP_decil10, by (ubigeo)
	
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

	gen P1 = 1 if corte1 == 1 & corte1a == 0 | corte1a == 1
	replace P1 = 2 if  corte1 == 1 & corte1a == 2
	replace P1 = 3 if  corte1 == 0 & corte1a == 1
	replace P1 = 4 if  corte1 == 0 & corte1a == 0
	replace P1 = 5 if  corte1 == 0 & corte1a == 2

* POBREZA EXTREMA & PROPORCION DE HOGAR CRITICO: Paquete alivio a la pobreza + paquete básico *
	collapse (sum) co_hogar hogar_critico flag_hogar_cse_pobext PB_serv0 PB_serv1a4 PB_serv5a9 PB_decil1 PB_decil10 PAP_serv0 PAP_serv1a4 PAP_serv5a9 PAP_decil1 PAP_decil10, by (P1)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
