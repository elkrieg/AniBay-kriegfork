/obj/item/bot/curiosity_parts
 	name = "cyriosity parts"
 	icon = 'obj/aibots.dmi'
 	icon_state = "cu0"
 	w_class = 20
 	flags = TABLEPASS | CONDUCT
 	origin_tech = "programming = 2; materials =2"
 	var/list/construction_cost=list("metal"=20000,"glass"=5000)
 	var/construction_time = 100

/obj/item/bot/curiosity_parts/chasis
	name = "Rover chassis"
	icon_state = "r_chassis"
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
	icon_state = "r_head"
	origin_tech = "programming=2;materials=2;biotech=2;engineering=2"
	construction_time = 200
	construction_cost = list("metal"=20000,"glass"=5000)

/obj/item/bot/curiosity_parts/torso
	name="Rover torso"
	desc="A torso part of the Curiosity Rover. Contains power unit, life systems, control systems."
	icon_state = "r_torso"
	origin_tech = "programming=2;materials=2;biotech=2;engineering=2"
	construction_time = 200
	construction_cost = list("metal"=30000,"glass"=5000)


/obj/item/bot/curiosity_parts/left_manipulator
	name="Rover left manipulator"
	desc="A Curiosity Rover left manipulator. Data and power sockets are compatible with most tools."
	icon_state = "r_left_mani"
	origin_tech = "programming=2;materials=2;engineering=2"
	construction_time = 150
	construction_cost = list("metal"=15000)

/obj/item/bot/curiosity_parts/right_manipulator
	name="Rover right manipulator"
	desc="A Curiosity Rover right manipulator. Data and power sockets are compatible with most tools."
	icon_state = "r_right_mani"
	origin_tech = "programming=2;materials=2;engineering=2"
	construction_time = 150
	construction_cost = list("metal"=15000)

/obj/item/bot/curiosity_parts/wheels
	name="Rover wheels"
	desc="A Curiosity rover wheels. Contains somewhat complex servodrives and wheels."
	icon_state = "rover_wh"
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
	steps = list(list("key"=/obj/item/bot/curiosity_parts/torso),//1
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


/datum/design/curiosity_plate
	name = "Circuit Design (Curiosity Rover)"
	desc = "Allows for the construction of a Curiosity Rover."
	id = "c_rover"
	req_tech = list("programming" = 3)
	//build_type = IMPRINTER
	materials = list("$glass" = 2000, "sacid" = 20)
	build_path = "/obj/item/weapon/circuitboard/bot/curiosity/main"

/obj/item/weapon/circuitboard/bot/curiosity/main
	name = "Circuit board (curiosity Rover)"
	build_path = "/obj/item/weapon/circuitboard/bot/curiosity/main"
	origin_tech = "programming=3"

/datum/construction/reversible/curiosity
	result = "/obj/machinery/bot/curiosity"
	steps = list(
					list("key" = /obj/item/weapon/screwdriver,
					 	  "backkey" = /obj/item/weapon/screwdriver,
					 	  "desc" =  "The wiring is adjists"),

					list("key"=/obj/item/weapon/wirecutters,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="The wiring is added"),

					list("key"=/obj/item/weapon/cable_coil,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Central control module is secured"),

					 list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Central control module is installed"),

					 list("key"=/obj/item/weapon/circuitboard/bot/curiosity/main,
					 	  	"backkey"=/obj/item/weapon/crowbar,
					 	  	"desc"="Internal armor is wrenched"),

					 list("key"=/obj/item/weapon/wrench,
					 		"backkey"=/obj/item/weapon/crowbar,
					 		"desc"="Internal armor is installed."),

					 list("key"=/obj/item/weapon/weldingtool,
					 		"backkey"=/obj/item/weapon/wrench,
					 		"desc"="Internal armor is installed."),

					 list("key"=/obj/item/stack/sheet/plasteel,
					 		"backkey"=/obj/item/weapon/weldingtool,
					 		"desc"="Camera Memory is Secured. "),
					 list("key" = /obj/item/weapon/screwdriver,
						 "backkey" = /obj/item/weapon/screwdriver,
						 "desc" = "Camera Memory is installed"),

                     list("key"= /obj/item/device/camera_film,
					 	  "backkey" =/obj/item/weapon/crowbar,
					 	  "desc" = "Photo Camera is secured."),

					list("key"=/obj/item/weapon/screwdriver,
					 		"backkey"=/obj/item/weapon/screwdriver,
					 		"desc"="Photo Camera is installed."),

					list("key"=/obj/item/device/camera,
							"backkey"=/obj/item/weapon/crowbar,
							"desc"="Nothing has been done"),

					)



	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(index, diff, atom/used_atom, mob/user)
		if(!..())
			return 0

		switch(index)
			if(1)
				if(diff==FORWARD)
					user.visible_message("[user] secures  [holder].", "You secured [holder].")
					holder.icon_state = "ro12"
				else
					user.visible_message("[user] unsecures [holder] .", "You unsecured [holder] .")
					holder.icon_state = "ro11"
			if(2)
				if(diff==FORWARD)
					user.visible_message("[user] adjusts the wiring of [holder].", "You adjust the wiring of [holder].")
					holder.icon_state = "ro11"
				else
					user.visible_message("[user] removes the wiring from [holder].", "You remove the wiring from [holder].")
					holder.icon_state = "ro10"
			if(3)
				if(diff==FORWARD)
					user.visible_message("[user] adding wires to [holder].", "You added wires into into [holder].")
					del used_atom
					holder.icon_state = "ro10"
				else
					user.visible_message("[user] remove the wiring from [holder].", "You remove the wiring from [holder].")
					new /obj/item/weapon/cable_coil(get_turf(holder))
					//coil.amount = 4 как заставить это работать???
					holder.icon_state = "ro9"
			if(4)
				if(diff==FORWARD)
					user.visible_message("[user] secures the mainboard.", "You secure the mainboard.")
					holder.icon_state = "ro9"
				else
					user.visible_message("[user] unsecures mainboard from [holder].", "You unsecures mainboard from [holder].")
					holder.icon_state = "ro8"
			if(5)
				if(diff==FORWARD)
					user.visible_message("[user] installs the central controle module  into [holder].", "You install the central control module into [holder].")
					del used_atom
					holder.icon_state = "ro8"
				else
					user.visible_message("[user] removes  the central controle module.", "You removes the central controle module.")
					holder.icon_state = "ro7"
					new /obj/item/weapon/circuitboard/bot/curiosity/main(get_turf(holder))
			if(6)
				if(diff==FORWARD)
					user.visible_message("[user] wrenched internal armor layer.", "You wrenched internal armor layer.")
					holder.icon_state = "ro7"
				else
					user.visible_message("[user] unwrenched internal armor layer from [holder].", "You unwrenched internal armor layer from [holder].")
					holder.icon_state = "ro6"
			if(7)
				if(diff==FORWARD)
					user.visible_message("[user] welded internal armor layer to [holder].", "You secures internal armor layer to [holder].")
					holder.icon_state = "ro6"
				else
					user.visible_message("[user] unwelded internal armor layer from [holder].", "You unwelded internal armor layer.")
					holder.icon_state = "ro5"
			if(8)
				if(diff==FORWARD)
					user.visible_message("[user] installs internal armor layer.", "You installs internal armor layer.")
					holder.icon_state = "ro5"
					del used_atom
				else
					user.visible_message("[user] pries internal armor layer from [holder].", "You prie internal armor layer from [holder].")
					new /obj/item/stack/sheet/plasteel(get_turf(holder))
					holder.icon_state = "ro4"
			if(9)
				if(diff==FORWARD)
					user.visible_message("[user] secures camera memory to [holder].", "You secured camera memory to [holder].")
					holder.icon_state = "ro4"
				else
					user.visible_message("[user] unsecures camera memory.", "You unsecured camera memory.")
					holder.icon_state = "r03"
			if(10)
				if(diff==FORWARD)
					user.visible_message("[user] installs camera memory to [holder].", "You install camera memory to [holder].")
					holder.icon_state = "ro3"
					del used_atom
				else
					user.visible_message("[user] removes camera memory from [holder].", "You removes camera memory from [holder].")
					holder.icon_state = "ro2"
					new /obj/item/device/camera_film(get_turf(holder))
			if(11)
				if(diff==FORWARD)
					user.visible_message("[user] secures camera.", "You secure camera.")
					holder.icon_state = "ro2"
				else
					user.visible_message("[user] unsecures camera from [holder].", "You unsecure camera from [holder].")
					holder.icon_state = "ro1"
			if(12)
				if(diff==FORWARD)
					user.visible_message("[user] installes camera to [holder].", "You installed camera to [holder].")
					holder.icon_state = "ro1"
					del used_atom
				else
					user.visible_message("[user] removes camera from [holder].", "You removed camera from [holder].")
					holder.icon_state = "ro0"
					new /obj/item/device/camera(get_turf(holder))
		return 1

	spawn_result()
		..()
		feedback_inc("bot_cur_created",1)
		return

