/*/client/proc/admin_observe()
	set category = "Admin"
	set name = "Set Observe"
	if(!holder)
		alert("You are not an admin")
		return

	verbs -= /client/proc/admin_play
	spawn( 1200 )
		verbs += /client/proc/admin_play
	var/rank = holder.rank
	clear_admin_verbs()
	holder.state = 2
	update_admins(rank)
	if(!istype(mob, /mob/dead/observer))
		mob.admin_observing = 1
		mob.adminghostize(1)
	src << "\blue You are now observing"

/client/proc/admin_play()
	set category = "Admin"
	set name = "Set Play"
	if(!holder)
		alert("You are not an admin")
		return
	verbs -= /client/proc/admin_observe
	spawn( 1200 )
		verbs += /client/proc/admin_observe
	var/rank = holder.rank
	clear_admin_verbs()
	holder.state = 1
	update_admins(rank)
	if(istype(mob, /mob/dead/observer))
		mob:reenter_corpse()
	src << "\blue You are now playing"

/mob/proc/adminghostize()
	if(client)
		client.mob = new/mob/dead/observer(src)
	return

/mob/var/admin_observing = 0.0*/