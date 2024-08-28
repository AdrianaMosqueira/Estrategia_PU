use "D:/2024/01. trabajo/02. midis/01. FOCALIZACION/05. Bases de datos/Propuesta3_27082024.dta"

* PROPUESTA 3: POBREZA EXTREMA & PROPORCION DE HOGAR CRITICO *
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
replace vul2 = 1 if prop_v2 >= 0.219

gen cob0 = 0
replace cob0 = 1 if prop_serv0 >= 0.637
/*gen cob1 = 0
replace cob1 = 1 if prop_serv1a9 >= 0.363*/

gen P3 = 1 if pob1 == 1 & vul1 == 1 & cob0 == 1
 replace P3 = 2 if pob1 == 1 & vul1 == 1 & cob0 == 0
 replace P3 = 3 if pob1 == 1 & vul1 == 0 & cob0 == 1 
 replace P3 = 4 if pob1 == 1 & vul1 == 0 & cob0 == 0
 replace P3 = 5 if pob1 == 0 & vul1 == 1 & cob0 == 1 
 replace P3 = 6 if pob1 == 0 & vul1 == 1 & cob0 == 0 
 replace P3 = 7 if pob1 == 0 & vul1 == 0 & cob0 == 1
 replace P3 = 8 if pob1 == 0 & vul1 == 0 & cob0 == 0 
 
bysort P3: sum co_hogar v1 v2 serv0 ser1a9 flag_hogar_cse_pobext prop_v1 prop_v2 prop_serv0 prop_serv1a9
 
 
preserve
collapse (sum) hogar_critico flag_hogar_cse_pobext co_hogar v1 v2 serv0 ser1a9, by (P3)
restore
 