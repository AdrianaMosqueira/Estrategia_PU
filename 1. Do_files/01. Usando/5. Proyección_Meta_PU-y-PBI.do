/*******************************************************************************
PROYECCIONES DE POBREZA URBANA
Referencia: Indicadores Emblemáticos
Fecha de actualización: 04-11-2024
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
/*cd "D:\2024\01. trabajo\02. midis\01. FOCALIZACION\05. Bases de datos\01. proyecciones"*/
cd "C:\Users\apoyo5_dmpmp\Desktop\Adriana_Mo\12. Meta\01. Base de datos"
dir
/*import excel using "DatayResultados_2024.xlsx", sheet("Stata") firstrow clear*/

rename Año Ao
/*rename var5 PUrbana
rename var6 PTotal
rename var7 PBI_porcentaje*/
format PUrbana* %9.3f
format PBI_porcentaje* %9.3f
format PTotal* %9.3f
sort Ao

local PobUrb PUrbana            	// -------> (Modificar)
local iAo = 2010              // -------> (Modificar) Serie: año inicial
local uAo = 2023              // -------> (Modificar) Serie: año final
local pAo = 2030              // -------> (Modificar) Proyección hasta


*******************************************************************************
*** PROYECCIONES
*******************************************************************************/
keep Ao PUrbana           // Mantener solo variable Año e Indicador
drop if Ao < `iAo'      // Filtra serie desde año_ini hasta año_fin declarado

local pproy =`pAo' - `uAo' // Años de proyección
display "`pproy'"
lab var `PobUrb' "Serie"

***Ampliar rango de la BD
tset Ao
tsappend, add(`pproy')

***Generando variables
*ladder `PobUrb'
*gladder `PobUrb'
gen z=log(`PobUrb') // Normalizando la tasa de PU
gen d2020=(Ao==2020) // Variable indicadora "si Ao = 2020, entonces d2020 = 1"
gen d2021=(Ao==2021)
gen d2022=(Ao==2022)

***Modelos
global modelo1 "z Ao" // sin impacto (sin variable control)
global modelo2 "z Ao d2020" // impacto de la pandemia (con variable control)
global modelo3 "z Ao d2020 d2021" // impacto de la pandemia al 2020 y 2021
global modelo4 "z Ao d2020 d2021 d2022" // impacto de la pandemia al 2020, 2021 y 2022

***Proyección
forvalues i=1/4 {           // Por cada modelo
reg ${modelo`i'}			// Regresión
gen `PobUrb'_aux`i'=`PobUrb'      // variable auxiliar para la proyección

	forvalues j=1/`pproy' {  // Por cada año proyectado
	local j = `uAo'+`j'      // ultimo Año + 1 (Sucesivo hasta "pproy" años proyectados)
	lincom _cons+(Ao*`j')    // Y=_cons + bX
	replace `PobUrb'_aux`i'=exp(r(estimate)) if Ao==`j'
	lab var `PobUrb'_aux`i' "${modelo`i'}"
	}
}


***Proyección considerando PBI 
* Crear logaritmos de las variables, si es necesario, para una relación log-lineal
gen log_pobreza = log(pobreza_urbana)
gen log_pib = log(pib_percapita)

* Modelo de regresión
reg log_pobreza Ao log_pib

* Calcular el número de años de proyección
local anios_proyeccion = `proyeccion_ano' - `fin_ano'

* Expande el conjunto de datos para incluir los años de proyección
tsset Ao                     // Configurar como datos de series temporales
tsappend, add(`anios_proyeccion')  // Agregar años hasta la proyección

* Asignar valores proyectados de crecimiento económico (puedes usar una tasa de crecimiento esperada)
gen pib_percapita_proy = .
replace pib_percapita_proy = pib_percapita[_n-1] * 1.02 if Ao > `fin_ano' // Ejemplo de 2% de crecimiento anual

* Aplicar logaritmo al valor proyectado de PIB per cápita
replace log_pib = log(pib_percapita_proy) if Ao > `fin_ano'

* Generar las proyecciones de pobreza urbana
predict log_pobreza_proy, xb   // Obtener el valor ajustado en logaritmo
gen pobreza_urbana_proy = exp(log_pobreza_proy) if Ao > `fin_ano'   // Convertir del logaritmo

* Visualizar los resultados
list Ao pobreza_urbana pobreza_urbana_proy if Ao >= `inicio_ano'