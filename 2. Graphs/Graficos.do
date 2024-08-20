/* GRAFICOS */

webuse citytemp
graph bar (sum) co_hogar hogar_critico, over(departamento) blabel(total)
graph bar (sum) co_hogar hogar_critico, over(serv_0, serv_1a4) blabel(total)

/*gen hogar_nocritico = co_hogar - hogar_critico
generate frac = hogar_critico/(hogar_critico + hogar_nocritico)
graph hbar (asis) hogar_critico hogar_nocritico,
	over(departamento, sort(frac) descending) stack percentages
	title("Public and private spending on tertiary education, 1999",
			span position(11) )
	subtitle(" ")
	note("Source: OECD, Education at a Glance 2002", span)*/


	