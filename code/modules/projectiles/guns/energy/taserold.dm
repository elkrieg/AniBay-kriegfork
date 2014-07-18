
/obj/item/weapon/gun/energy/taser/dual
	name = "taser gun"
	desc = "A small, low capacity gun used for non-lethal takedowns."
	icon = 'icons/obj/animus.dmi'
	icon_state = "tasernew"
	projectile_type = "/obj/item/projectile/energy/tasershot"
	modifystate = "taserold"

	var/tasermode = 1 //1 = stun, 0 = pain

	attack_self(mob/living/user as mob)
		switch(tasermode)
			if(0)
				tasermode = 1
				user << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/energy/tasershot"
				modifystate = "taserold"
			if(1)
				tasermode = 0
				user << "\red [src.name] is now set to pain."
				projectile_type = "/obj/item/projectile/beam/stun"
				modifystate = "tasernew"
		update_icon()

/obj/item/weapon/gun/energy/taser/old
	name = "taser gun"
	desc = "Old version of NT taser. Have less charges, only one mode, but 2 times more powerfull."
	icon = 'icons/obj/animus.dmi'
	icon_state = "taser"
	charge_cost = 200
	projectile_type = "/obj/item/projectile/energy/tasershot/power"

/obj/item/projectile/energy/tasershot
	name = "electrode"
	icon_state = "spark"
	pass_flags = PASSTABLE
	nodamage = 1
	stun = 10
	weaken = 10
	stutter = 10
	damage_type = BURN

/obj/item/projectile/energy/tasershot/power
	name = "electrode"
	icon_state = "spark"
	pass_flags = PASSTABLE
	nodamage = 1
	stun = 15
	weaken = 15
	stutter = 15
	damage_type = BURN


/obj/item/projectile/energy/tasershot/shell
	name = "electrode"
	icon_state = "spark"
	pass_flags = PASSTABLE
	nodamage = 1
	stun = 20
	weaken = 20
	stutter = 20
	damage_type = BURN
