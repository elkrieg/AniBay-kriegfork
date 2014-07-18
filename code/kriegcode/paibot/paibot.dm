proc/ispaibot(var/mob/M)
	if(istype(M, /mob/living/silicon/paibot))
		return 1

/mob/living/silicon/paibot/Login()
	..()
	regenerate_icons()
	show_laws(0)
	if(mind)	ticker.mode.remove_revolutionary(mind)
	return

/mob/living/silicon/paibot
	name = "Paibot"
	real_name = "Paibot"
	icon = 'icons/mob/paibot.dmi'
	icon_state = "honkbuddy0_work"
	maxHealth = 300
	health = 300
	var/sight_mode = 0
	var/custom_name = ""
	var/obj/machinery/camera/camera = null
	var/obj/screen/cells = null
	var/obj/screen/inv1 = null


/mob/living/silicon/paibot/Life()
	set invisibility = 0
	set background = 1

	if (src.monkeyizing)
		return


	src.blinded = null

	//Status updates, death etc.
	clamp_values()
	handle_regular_status_updates()

	if(client)
		handle_regular_hud_updates()
		update_items()
	if (src.stat != DEAD) //still using power
		use_power()
	update_canmove()



/mob/living/silicon/paibot/proc/clamp_values()

//	SetStunned(min(stunned, 30))
	SetParalysis(min(paralysis, 30))
//	SetWeakened(min(weakened, 20))
	sleeping = 0
	adjustBruteLoss(0)
	adjustToxLoss(0)
	adjustOxyLoss(0)
	adjustFireLoss(0)

/mob/living/silicon/paibot/proc/use_power()
	return


/mob/living/silicon/paibot/proc/handle_regular_status_updates()

	if(src.camera)
		if(src.stat == 2)
			src.camera.status = 0
		else
			src.camera.status = 1

	health = 200 - (getOxyLoss() + getFireLoss() + getBruteLoss())

	if(getOxyLoss() > 50) Paralyse(3)

	if(src.sleeping)
		Paralyse(3)
		src.sleeping--

	if(src.resting)
		Weaken(5)

	if(health < config.health_threshold_dead && src.stat != 2) //die only once
		death()

	if (src.stat != 2) //Alive.
		if (src.paralysis || src.stunned || src.weakened) //Stunned etc.
			src.stat = 1
			if (src.stunned > 0)
				AdjustStunned(-1)
			if (src.weakened > 0)
				AdjustWeakened(-1)
			if (src.paralysis > 0)
				AdjustParalysis(-1)
				src.blinded = 1
			else
				src.blinded = 0

		else	//Not stunned.
			src.stat = 0

	else //Dead.
		src.blinded = 1
		src.stat = 2

	if (src.stuttering) src.stuttering--

	if (src.eye_blind)
		src.eye_blind--
		src.blinded = 1

	if (src.ear_deaf > 0) src.ear_deaf--
	if (src.ear_damage < 25)
		src.ear_damage -= 0.05
		src.ear_damage = max(src.ear_damage, 0)

	src.density = !( src.lying )

	if ((src.sdisabilities & BLIND))
		src.blinded = 1
	if ((src.sdisabilities & DEAF))
		src.ear_deaf = 1

	if (src.eye_blurry > 0)
		src.eye_blurry--
		src.eye_blurry = max(0, src.eye_blurry)

	if (src.druggy > 0)
		src.druggy--
		src.druggy = max(0, src.druggy)

	return 1

/mob/living/silicon/paibot/proc/handle_regular_hud_updates()

	if (src.stat == 2 || XRAY in mutations || src.sight_mode & BORGXRAY)
		src.sight |= SEE_TURFS
		src.sight |= SEE_MOBS
		src.sight |= SEE_OBJS
		src.see_in_dark = 8
		src.see_invisible = SEE_INVISIBLE_MINIMUM
	else if (src.sight_mode & BORGMESON && src.sight_mode & BORGTHERM)
		src.sight |= SEE_TURFS
		src.sight |= SEE_MOBS
		src.see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
	else if (src.sight_mode & BORGMESON)
		src.sight |= SEE_TURFS
		src.see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
	else if (src.sight_mode & BORGTHERM)
		src.sight |= SEE_MOBS
		src.see_in_dark = 8
		src.see_invisible = SEE_INVISIBLE_LEVEL_TWO
	else if (src.stat != 2)
		src.sight &= ~SEE_MOBS
		src.sight &= ~SEE_TURFS
		src.sight &= ~SEE_OBJS
		src.see_in_dark = 8
		src.see_invisible = SEE_INVISIBLE_LEVEL_TWO

	for(var/image/hud in client.images)  //COPIED FROM the human handle_regular_hud_updates() proc
		if(copytext(hud.icon_state,1,4) == "hud") //ugly, but icon comparison is worse, I believe
			client.images.Remove(hud)

	var/obj/item/borg/sight/hud/hud = (locate(/obj/item/borg/sight/hud) in src)
	if(hud && hud.hud)	hud.hud.process_hud(src)

	if (src.healths)
		if (src.stat != 2)
			switch(health)
				if(200 to INFINITY)
					src.healths.icon_state = "health0"
				if(150 to 200)
					src.healths.icon_state = "health1"
				if(100 to 150)
					src.healths.icon_state = "health2"
				if(50 to 100)
					src.healths.icon_state = "health3"
				if(0 to 50)
					src.healths.icon_state = "health4"
				if(config.health_threshold_dead to 0)
					src.healths.icon_state = "health5"
				else
					src.healths.icon_state = "health6"
		else
			src.healths.icon_state = "health7"

	if (src.syndicate && src.client)
		if(ticker.mode.name == "traitor")
			for(var/datum/mind/tra in ticker.mode.traitors)
				if(tra.current)
					var/I = image('icons/mob/mob.dmi', loc = tra.current, icon_state = "traitor")
					src.client.images += I
		if(src.mind)
			if(!src.mind.special_role)
				src.mind.special_role = "traitor"
				ticker.mode.traitors += src.mind


	if(bodytemp)
		switch(src.bodytemperature) //310.055 optimal body temp
			if(335 to INFINITY)
				src.bodytemp.icon_state = "temp2"
			if(320 to 335)
				src.bodytemp.icon_state = "temp1"
			if(300 to 320)
				src.bodytemp.icon_state = "temp0"
			if(260 to 300)
				src.bodytemp.icon_state = "temp-1"
			else
				src.bodytemp.icon_state = "temp-2"


	if(src.pullin)	src.pullin.icon_state = "pull[src.pulling ? 1 : 0]"
//Oxygen and fire does nothing yet!!
//	if (src.oxygen) src.oxygen.icon_state = "oxy[src.oxygen_alert ? 1 : 0]"
//	if (src.fire) src.fire.icon_state = "fire[src.fire_alert ? 1 : 0]"

	client.screen.Remove(global_hud.blurry,global_hud.druggy,global_hud.vimpaired)

	if ((src.blind && src.stat != 2))
		if(src.blinded)
			src.blind.layer = 18
		else
			src.blind.layer = 0
			if (src.disabilities & NEARSIGHTED)
				src.client.screen += global_hud.vimpaired

			if (src.eye_blurry)
				src.client.screen += global_hud.blurry

			if (src.druggy)
				src.client.screen += global_hud.druggy

	if (src.stat != 2)
		if (src.machine)
			if (!( src.machine.check_eye(src) ))
				src.reset_view(null)
		else
			if(client && !client.adminobs)
				reset_view(null)

	return 1

/mob/living/silicon/paibot/proc/update_items()
	return



/mob/living/silicon/paibot/update_canmove()
	if(paralysis || stunned || weakened || buckled) canmove = 0
	else canmove = 1
	return canmove