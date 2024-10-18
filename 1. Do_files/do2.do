//* PRESENTACION CIAS-MIDISTRO *//

* 1. Abrir bases: *
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
		
	*- 5.b JUNTOS_19 (menor_19_años): -*
	gen JUNTOS_19 = 1 if flag_menor_19 == 1 & flag_juntos == 1
		replace JUNTOS_19 = . if flag_menor_19 ==0 & flag_juntos == 1
		replace JUNTOS_19 = . if flag_menor_19 ==0 & flag_juntos == 0
		replace JUNTOS_19 = 0 if flag_menor_19 ==1 & flag_juntos == 0
		
//* --- PPT X: Demanda de hogares de cada --- *//
egen hogar_recibe_total = rowtotal(Cuna_mas Pronabec flag_jovenes_prod flag_empleabilidad flag_pvl flag_pca JUNTOS flag_lurawi flag_techo_propio flag_fise Contigo P65)

egen hogar_recibe_Juntos19 = rowtotal(Cuna_mas Pronabec flag_jovenes_prod flag_empleabilidad flag_pvl flag_pca JUNTOS_19 flag_lurawi flag_techo_propio flag_fise Contigo P65)

// 1. JUNTOS MUJER FERTIL //
keep if hogar_recibe_total >0

	* Servicios: 1. Pensión 65 *
	gen P_65 = 0
		replace P_65=1 if flag_adultomayor==1 & flag_p65==1
		tab P_65  // 12.83% de los H tiene un adulto mayor y recibe P65
		
	* Servicios: 2. Contigo *
		gen P_contigo = 0
			replace P_contigo =1 if flag_discapacidad==1 & flag_contigo==1
			tab P_contigo  // 3.77% de los H tiene una persona con discapcidad y recibe contigo
		
	* Servicios: 3. Cunamas *
		gen P_cunamas = 0
			replace P_cunamas =1 if flag_menor_36m==1 & flag_cunamas==1
			tab P_cunamas  // 8.57% de los H tiene una persona menor a 36 meses y recibe cunamas
			
	* Servicios: 4.a Juntos (mujer_fertil) *
		gen P_juntos = 0
			replace P_juntos =1 if flag_mujer_fertil==1 & flag_juntos==1
			tab P_juntos  // 25.85% de los H tiene mujer fertil y recibe juntos
	
	* Servicios: 5. Pronabec *
	gen pronabec1 = 0
		replace pronabec1 =1 if flag_pronabec_22==1 & flag_pronabec==1
		tab pronabec1  // 12.83% de los H tiene un adulto mayor y recibe P65
		
	* Servicios: 6. Techo Propio *
	tab flag_techo_propio
		
	* Servicios: 7. Programa Vaso de Leche *
	tab flag_pvl
		
	* Servicios: 8. Llamaksun Perú - Programa Empleo Temporal *
	tab flag_lurawi
		
	* Servicios: 9. Programa de Complementación Alimentaria - PCA *
	tab flag_pca
		
	* Servicios: 10. Fondo de Inclusión Social Estratégico - FISE *
	tab flag_fise
		
	* Servicios: 11. Jóvenes Productivos *
	tab flag_jovenes_prod
	
	* Servicios: 12. Empleabilidad *
	tab flag_empleabilidad


// 2. JUNTOS MENORES 19 AÑOS //
keep if hogar_recibe_Juntos19 >0

	* Servicios: 1. Pensión 65 *
	gen P_65 = 0
		replace P_65=1 if flag_adultomayor==1 & flag_p65==1
		tab P_65  // 12.83% de los H tiene un adulto mayor y recibe P65
		
	* Servicios: 2. Contigo *
		gen P_contigo = 0
			replace P_contigo =1 if flag_discapacidad==1 & flag_contigo==1
			tab P_contigo  // 3.77% de los H tiene una persona con discapcidad y recibe contigo
		
	* Servicios: 3. Cunamas *
		gen P_cunamas = 0
			replace P_cunamas =1 if flag_menor_36m==1 & flag_cunamas==1
			tab P_cunamas  // 8.57% de los H tiene una persona menor a 36 meses y recibe cunamas

	* Servicios: 4.b Juntos (menor_19_años) *
		gen P_juntos2 = 0
			replace P_juntos2 =1 if flag_menor_19==1 & flag_juntos==1
			tab P_juntos2  // 25.85% de los H tiene mujer fertil y recibe juntos
			
	* Servicios: 5. Pronabec *
	gen pronabec1 = 0
		replace pronabec1 =1 if flag_pronabec_22==1 & flag_pronabec==1
		tab pronabec1  // 12.83% de los H tiene un adulto mayor y recibe P65
		
	* Servicios: 6. Techo Propio *
	tab flag_techo_propio
		
	* Servicios: 7. Programa Vaso de Leche *
	tab flag_pvl
		
	* Servicios: 8. Llamaksun Perú - Programa Empleo Temporal *
	tab flag_lurawi
		
	* Servicios: 9. Programa de Complementación Alimentaria - PCA *
	tab flag_pca
		
	* Servicios: 10. Fondo de Inclusión Social Estratégico - FISE *
	tab flag_fise
		
	* Servicios: 11. Jóvenes Productivos *
	tab flag_jovenes_prod
	
	* Servicios: 12. Empleabilidad *
	tab flag_empleabilidad
