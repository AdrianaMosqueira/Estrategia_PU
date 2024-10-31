/*******************************************************************************
PROYECCIONES DE INDICADORES SOCIOECONOMICOS
AUTOR: MIDIS-DGSE-DS-COORDINACION EJE 3,4,5 / Data Analytic
Fecha de actualización: 29-01-2023
*******************************************************************************/

***Escenarios
*El do file genera 3 escenarios (3 modelos)
*Se pueden agregar + escenarios modificando fecha de inicio (ejem: 2013)

       local dt = "`c(current_date)'"
       local m = string(month(td("`dt'")), "%02.0f")
       local d = string(day(td("`dt'")), "%02.0f")
       local y = year(td("`dt'"))
       di "`y' `m' `d'"
       local date = "`y'`m'`d'"

clear all
cd "G:\001 DGSE 2023\01 Proyecciones\Ped8 - Juntos Proy"
dir
import excel using "DatayResultados_2024.xlsx", sheet("Stata") firstrow clear
rename año Ao
format ind* %9.3f
sort Ao

local ind ind1            	// -------> (Modificar)
local iAo=2004              // -------> (Modificar) Serie: año inicial
local uAo=2023              // -------> (Modificar) Serie: año final
local pAo=2030              // -------> (Modificar) Proyección hasta


*******************************************************************************
*** PROYECCIONES
*******************************************************************************/
keep Ao `ind'           // Mantener solo variable Año e Indicador
drop if (Ao<`iAo')      // Filtra serie desde año_ini hasta año_fin declarado

local pproy=`pAo'-`uAo' // Años de proyección
display "`pproy'"
lab var `ind' "Serie"

***Ampliar rango de la BD
tset Ao
tsappend, add(`pproy')

***Generando variables
*ladder `ind'
*gladder `ind'
gen z=log(`ind')
gen d2020=(Ao==2020)
gen d2021=(Ao==2021)
gen d2022=(Ao==2022)

***Modelos
global modelo1 "z Ao"
global modelo2 "z Ao d2020"
global modelo3 "z Ao d2020 d2021"
global modelo4 "z Ao d2020 d2021 d2022"

***Proyección
forvalues i=1/4 {           // Por cada modelo
reg ${modelo`i'}			// Regresión
gen `ind'_aux`i'=`ind'      // variable auxiliar para la proyección

	forvalues j=1/`pproy' {  // Por cada año proyectado
	local j = `uAo'+`j'      // ultimo Año + 1 (Sucesivo hasta "pproy" años proyectados)
	lincom _cons+(Ao*`j')    // Y=_cons + bX
	replace `ind'_aux`i'=exp(r(estimate)) if Ao==`j'
	lab var `ind'_aux`i' "${modelo`i'}"
	}
}







