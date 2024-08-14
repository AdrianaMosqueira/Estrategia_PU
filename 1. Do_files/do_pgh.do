use "/Users/rominamangacambria/Library/CloudStorage/OneDrive-Personal/DMPM/2. PU/7. Estrategia/3. Criterios de priorización territorial/PGH/Hogares_PGH_26072024.dta"

/*
*collapse (first) departamento provincia distrito (count) co_hogar, by (ubigeo)

merge m:1 ubigeo using "/Users/rominamangacambria/Downloads/Listado_228 distritos empradronamiento 2024.dta"

egen flag_grupos_vul = rowtotal(flag_menor_19 flag_adultomayor_60 flag_discapacidad flag_menor_36m flag_pronabec_22 flag_37_60_meses)

egen flag_programas = rowtotal(flag_juntos flag_p65 flag_cunamas flag_sis flag_techo_propio flag_fise flag_pronabec flag_jovenes_prod flag_empleabilidad flag_lurawi flag_pnvr flag_contigo flag_bpvvrs flag_pvl flag_pca)


egen a= rowtotal (flag_pvl flag_pca)


collapse (count) co_hogar (first) centropoblado ubigeo departamento provincia distrito decil ambito (sum) flag_mujer_fertil flag_menor_19 flag_adultomayor_60 flag_discapacidad flag_menor_36m flag_pronabec_22 flag_juntos flag_p65 flag_cunamas flag_sis flag_techo_propio flag_fise flag_pronabec flag_jovenes_prod flag_empleabilidad flag_lurawi flag_pnvr flag_contigo flag_bpvvrs flag_pvl flag_pca flag_0_12_meses flag_13_24_meses flag_25_36_meses flag_37_60_meses, by (ccpp)

collapse (first) departamento provincia distrito decil ambito (sum) co_hogar flag_mujer_fertil flag_menor_19 flag_adultomayor_60 flag_discapacidad flag_menor_36m flag_pronabec_22 flag_juntos flag_p65 flag_cunamas flag_sis flag_techo_propio flag_fise flag_pronabec flag_jovenes_prod flag_empleabilidad flag_lurawi flag_pnvr flag_contigo flag_bpvvrs flag_pvl flag_pca flag_0_12_meses flag_13_24_meses flag_25_36_meses flag_37_60_meses, by (ubigeo)

gen a=1 if flag_juntos==1 & flag_pronabec_22==1

collapse (first) departamento provincia distrito (count) co_hogar (sum) a, by (ubigeo)
*/

*Priorización 1 (muy básico)
gen sin_cobertura=1
replace sin_cobertura=0 if flag_juntos==0 & flag_p65==0 & flag_cunamas==0 & flag_techo_propio==0 & flag_fise==0 & flag_pronabec==0 & flag_jovenes_prod==0 & flag_empleabilidad==0 & flag_lurawi==0 & flag_pnvr==0 & flag_contigo==0 & flag_bpvvrs==0 & flag_pvl==0 & flag_pca==0

gen vulnerable=0
replace vulnerable=1 if flag_menor_19==1 | flag_adultomayor_60==1 | flag_discapacidad==1 | flag_menor_36m==1 | flag_pronabec_22==1 | flag_37_60_meses==1

gen decil_g=2
replace decil_g=1 if decil > 4

/*
gen precariedad=.
replace precariedad=0 if vulnerable==1 & decil_g==1
replace precariedad=1 if vulnerable==0 & decil_g==1
replace precariedad=2 if vulnerable==1 & decil_g==2
replace precariedad=3 if vulnerable==0 & decil_g==2

gen grupo=.
replace grupo=1 if precariedad==0 & sin_cobertura==0
replace grupo=2 if precariedad==1 & sin_cobertura==0
replace grupo=3 if precariedad==2 & sin_cobertura==0
replace grupo=4 if precariedad==3 & sin_cobertura==0
replace grupo=5 if precariedad==0 & sin_cobertura==1
replace grupo=6 if precariedad==1 & sin_cobertura==1
replace grupo=7 if precariedad==2 & sin_cobertura==1
replace grupo=8 if precariedad==3 & sin_cobertura==1
*/

gen hogar_critico=0
replace hogar_critico=1 if vulnerable==1 & decil_g==1 & sin_cobertura==0

collapse (first) departamento provincia distrito ubigeo centropoblado (count) co_hogar (sum) hogar_critico, by (ccpp)

gen a=hogar_critico/co_hogar

gen tam=1
replace tam=0 if co_hogar<200


** Grupos CCPP grandes

egen combinada=group(a co_hogar)

xtile corte_combinada= combinada, nquantiles(5)

gen b=1

collapse (first) departamento provincia distrito (sum) b co_hogar hogar_critico (mean) a, by(corte_combinada ubigeo)

collapse (first) departamento (sum) b co_hogar hogar_critico (mean) a, by(corte_combinada provincia)

collapse (sum) b co_hogar hogar_critico (mean) a, by(corte_combinada departamento)


/*
*** Grupos CCPP pequeños

keep if tam==0
collapse (first) departamento provincia distrito (sum) co_hogar hogar_critico, by (ubigeo)

collapse (sum) co_hogar hogar_critico, by (provincia departamento)

gen a=hogar_critico/co_hogar

xtile grupos_a = a, nquantiles(3)

**

collapse (sum) co_hogar hogar_critico (mean) a, by(grupos_a)

*keep if tam==1
