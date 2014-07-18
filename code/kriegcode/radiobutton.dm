/obj/machinery/door_control/radio
	var/obj/item/device/assembly/signaler/signaler


/obj/machinery/door_control/radio/attack_hand(mob/user as mob)
	src.add_fingerprint(usr)
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(5)
	icon_state = "doorctrl1"
	add_fingerprint(user)

	if(signaler)
		signaler.signal()

	desiredstate = !desiredstate
	spawn(15)
		if(!(stat & NOPOWER))
			icon_state = "doorctrl0"

/obj/machinery/door_control/radio/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/device/detective_scanner))
		return
	if(istype(W, /obj/item/weapon/screwdriver))
		user << "\red You disassembled button with [W]"
		signaler.loc = loc
		del(src)
		return
	return src.attack_hand(user)