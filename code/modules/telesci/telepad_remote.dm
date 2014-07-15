/obj/item/device/telepadremote
	icon = 'icons/obj/telescience.dmi'
	name = "telepad remote control"
	icon_state = "teleremote2"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 2.0
	origin_tech = "magnets=2;engineering=3;bluespace=2"
	var/obj/machinery/computer/telescience/linked

/obj/item/device/telepadremote/attack_self(mob/user as mob)
	if(!istype(linked))
		user << "\red Connection to telepad failed."
	else
		user.set_machine(linked)
		linked.interact(user)
		return