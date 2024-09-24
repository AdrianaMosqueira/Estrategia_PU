//* CARACTERIZACIÓN *//

* 1. Abrir bases: *
clear all
use "C:/Users/apoyo5_dmpmp/Desktop/ADRIANA MO/02. ESTRATEGIA/02. ESQUEMA DE PROGRESIVIDAD/Hogares_PGH_75var.dta"

/*collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico hogar_no_critico flag_hogar_cse_pobext pobre_no_ext, by (ubigeo)

egen hogar_programa = rowtotal( flag_juntos flag_p65 flag_cunamas flag_sis flag_techo_propio flag_fise flag_pronabec_22 flag_jovenes_prod flag_empleabilidad flag_lurawi flag_pnvr flag_contigo flag_bpvvrs flag_pvl flag_pca)*/

//* --- PPT 4: hogares --- *//
	* # centros poblados
	sort ccpp
	egen num_unicos = tag(ccpp)
		count if num_unicos == 1
		*drop num_unicos*
		
	* # distritos
	sort ubigeo
	egen num_unicos = tag(ubigeo)
		count if num_unicos == 1
		*drop num_unicos*

	* # hogares pobreza extrema y no extrema
	 tab flag_hogar_cse_pobext
		
//* --- PPT 5: Demanda de hogares --- *//
keep if hogar_recibe >0
	* Servicios: a. Pensión 65 *
	gen P_65 = 0
		replace P_65=1 if flag_adultomayor==1 & flag_p65==1
		tab P_65  // 12.83% de los H tiene un adulto mayor y recibe P65
		
	* Servicios: b. Contigo *
		gen P_contigo = 0
			replace P_contigo =1 if flag_discapacidad==1 & flag_contigo==1
			tab P_contigo  // 3.77% de los H tiene una persona con discapcidad y recibe contigo
		
	* Servicios: c. Cunamas *
		gen P_cunamas = 0
			replace P_cunamas =1 if flag_menor_36m==1 & flag_cunamas==1
			tab P_cunamas  // 8.57% de los H tiene una persona menor a 36 meses y recibe cunamas
			
	* Servicios: d. Juntos *
		gen P_juntos = 0
			replace P_juntos =1 if flag_mujer_fertil==1 & flag_juntos==1
			tab P_juntos  // 25.85% de los H tiene mujer fertil y recibe juntos	
			
	* % de Hogares con al menos 2 vulnerabilidades *
		egen vulne_des = rowtotal (flag_menor_19 flag_adultomayor flag_discapacidad)
		tab vulne_des

//* --- PPT 7: Caracterización 1 --- *//	
	* Tabla 1: Distribución de hogares por CCPP - rangos *
	collapse (first) departamento provincia distrito centropoblado (count) co_hogar (sum) hogar_critico flag_hogar_cse_pobext serv0 ser1a9 v1 v2, by (ccpp)

	* Tabla 2: Distribución de hogares por distritos - rangos
	collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico flag_hogar_cse_pobext serv0 ser1a9 v1 v2, by (ubigeo)
	
//* --- PPT 8: Caracterización 2 --- *//
gen programas = 1 if hogar_programa > 0
replace programas = 0 if hogar_programa == 0 

collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico flag_hogar_cse_pobext serv0 ser1a9 v1 v2, by (ubigeo)
 
collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico flag_hogar_cse_pobext serv0 ser1a9 v1 v2, by (ubigeo)
gen porcent_PE = flag_hogar_cse_pobext/co_hogar // % de H pobres extremos por distrito
gen porcent_COB = serv0/co_hogar // % de H con baja cobertura por distrito
gen porcent_COB1a9 = ser1a9/co_hogar
gen porcent_HC = hogar_critico/co_hogar


/*collapse (first) departamento provincia distrito (count) co_hogar (sum) hogar_critico hogar_no_critico flag_hogar_cse_pobext pobre_no_ext serv_0 serv_1a4 serv_5a9 v_0 v_1 v_2 v_3, by (ubigeo) */












