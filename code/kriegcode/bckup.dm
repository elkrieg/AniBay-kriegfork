/obj/item/bot/curiosity_parts
 	name = "cyriosity parts"
 	icon = 'obj/aibots.dmi'
 	icon_state = "mulebot0"
 	w_class = 20
 	flags = TABLEPASS | CONDUCT
 	origin_tech = "programming = 2; materials =2"
 	var/list/construction_cost=list("metal"=20000,"glass"=5000)
 	var/construction_time = 100

/obj/item/bot/curiosity_parts/chasis
	name = "Rover chassis"
	icon_state = "mulebot0"
	var/datum/construction/construct
	construction_cost = list("metal"=20000)
	flags = FPRINT | CONDUCT

	attackby(obj/item/W as obj, mob/user as mob)
		if(!construct || !construct.action(W, user))
			..()
		return

	attack_hand()
		return

	New()
		..()
		construct = new /datum/construction/bot/curiosity_parts/chassis(src)

/obj/item/bot/curiosity_parts/head
	name="Rover head"
	desc="A head part of the Curiosity Rover. Contains mini-computer, memory, radio systems and voice synthezator."
	icon_state = "mulebot0"
	origin_tech = "programming=2;materials=2;biotech=2;engineering=2"
	construction_time = 200
	construction_cost = list("metal"=20000,"glass"=5000)

/obj/item/bot/curiosity_parts/torso
	name="Rover torso"
	desc="A torso part of the Curiosity Rover. Contains power unit, life systems, control systems."
	icon_state = "mulebot0"
	origin_tech = "programming=2;materials=2;biotech=2;engineering=2"
	construction_time = 200
	construction_cost = list("metal"=30000,"glass"=5000)


/obj/item/bot/curiosity_parts/left_manipulator
	name="Rover left manipulator"
	desc="A Curiosity Rover left manipulator. Data and power sockets are compatible with most tools."
	icon_state = "mulebot0"
	origin_tech = "programming=2;materials=2;engineering=2"
	construction_time = 150
	construction_cost = list("metal"=15000)

/obj/item/bot/curiosity_parts/right_manipulator
	name="Rover right manipulator"
	desc="A Curiosity Rover right manipulator. Data and power sockets are compatible with most tools."
	icon_state = "mulebot0"
	origin_tech = "programming=2;materials=2;engineering=2"
	construction_time = 150
	construction_cost = list("metal"=15000)

/obj/item/bot/curiosity_parts/wheels
	name="Rover wheels"
	desc="A Curiosity rover wheels. Contains somewhat complex servodrives and wheels."
	icon_state = "mulebot0"
	origin_tech = "programming=2;materials=2;engineering=2"
	construction_time = 150
	construction_cost = list("metal"=25000)


/datum/construction/bot/curiosity/custom_action(step, atom/used_atom, mob/user)
	if(istype(used_atom, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/W = used_atom
		if (W.remove_fuel(0, user))
			playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
		else
			return 0
	else if(istype(used_atom, /obj/item/weapon/wrench))
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/weapon/screwdriver))
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/weapon/wirecutters))
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(istype(used_atom, /obj/item/weapon/cable_coil))
		var/obj/item/weapon/cable_coil/C = used_atom
		if(C.amount<4)
			user << ("There's not enough cable to finish the task.")
			return 0
		else
			C.use(4)
			playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
	else if(istype(used_atom, /obj/item/stack))
		var/obj/item/stack/S = used_atom
		if(S.amount < 5)
			user << ("There's not enough material in this stack.")
			return 0
		else
			S.use(5)
	return 1


/datum/construction/bot/curiosity_parts/chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/ripley_torso),//1
					 list("key"=/obj/item/bot/curiosity_parts/head),//2
					 list("key"=/obj/item/bot/curiosity_parts/left_manipulator),//3
					 list("key"=/obj/item/bot/curiosity_parts/right_manipulator),//4
					 list("key"=/obj/item/bot/curiosity_parts/wheels)//5
					)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.overlays += used_atom.icon_state+"+o"
		del used_atom
		return 1

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	spawn_result()
		var/obj/item/bot/curiosity_parts/chasis/const_holder = holder
		const_holder.construct = new /datum/construction/reversible/curiosity(const_holder)
		const_holder.icon = 'icons/obj/aibots.dmi'
		const_holder.icon_state = "mulebot0"
		const_holder.density = 1
		const_holder.overlays.len = 0
		spawn()
			del src
		return

/obj/item/weapon/circuitboard/bot/curiosity
	name = "Circuit board (Rover)"
	build_path = "/obj/machinery/computer/curiosity_console"
	origin_tech = "programming=4;engineering=4"

/datum/construction/reversible/curiosity
	result = "/obj/machinery/bot/curiosity"
	steps = list(
					//1
					list("key"=/obj/item/device/camera,
							"backkey"=/obj/item/weapon/crowbar,
							"desc"="Photo Camera is installed."),
					//2
				  	 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Photo Camera is secured."),
					 //3
					 list("key"= /obj/item/device/camera_film,
					 	  "backkey" =/obj/item/weapon/crowbar,
					 	  "desc" = "Camera Memory is installed"),
				//4
					 list("key" = /obj/item/weapon/screwdriver,
						 "backkey" = /obj/item/weapon/screwdriver,
						 "desc" = "Camera Memory is Secured. "),


					 //5
					 list("key"=/obj/item/stack/sheet/plasteel,
					 		"backkey"=/obj/item/weapon/weldingtool,
					 		"desc"="Internal armor is welded."),
					 //6
					 list("key"=/obj/item/weapon/weldingtool,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="Internal armor is wrenched"),
					 //7
					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Internal armor is installed"),

					 //8
					 list("key"=/obj/item/weapon/circuitboard/bot/curiosity,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Central control module is installed"),
					 //9
					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Central control module is secured"),
					 //10
					 list("key"=/obj/item/weapon/cable_coil,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is added"),
					 //11
					 list("key"=/obj/item/weapon/wirecutters,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is cutted"),
					 //12
					 list("key" = /obj/item/weapon/screwdriver,
					 	  "backkey" = /obj/item/weapon/screwdriver,
					 	  "desc" =  "The Rover is secured and ready to work.")
					)





	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	/*custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0
.
		switch(index)
			if(12)
				user.visible_message("[user] connects [holder] hydraulic systems", "You connect [holder] hydraulic systems.")
				holder.icon_state = "mulebot1"*/


	spawn_result()
		..()
		feedback_inc("bot_cur_created",1)
		return

