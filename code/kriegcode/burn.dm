/obj/item/weapon/book/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume) // actually its a fixercode
	if(exposed_temperature >=451)
		for(var/mob/M in viewers(5, src))
			M << "\red \the [src] burns up."
			del(src)