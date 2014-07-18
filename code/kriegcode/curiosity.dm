/obj/machinery/bot/curiosity
	name = "Rover"
	desc = "Programmable research unit on wheels"
	icon_state = "opportunity_c"
	layer = MOB_LAYER
	density = 1
	anchored = 1
	animate_movement=1
	health = 150
	maxhealth = 150
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5
	var/busy = 0
	var/id = 1
	var/full = 0 // count in inner storage
	var/obj/item/device/camera/rovercamera/cam
	var/obj/machinery/computer/curiosity_console/console
	var/list/rec
	var/recording = 0

	var/obj/item/lhand
	var/obj/item/rhand

	var/obj/item/safe // storage inside bot

	New()
		..()
		processing_objects.Add(src)
		cam=new()
		safe = new()

	Del()
		processing_objects.Remove(src)
		..()

	//process()
	//	step(src, pick(cardinal))

	proc/use_energy(var/value)
		return //TODO

	proc/dostep(var/dir)
		switch(dir)
			if("north" || NORTH)
				step(src, NORTH)
				sleep(10)
			if("south" || SOUTH)
				step(src, SOUTH)
				sleep(10)
			if("west" || WEST)
				step(src, WEST)
				sleep(10)
			if("east" || EAST)
				step(src, EAST)
				sleep(10)

	proc/getbotx()
		return src.x

	proc/getboty()
		return src.y

	proc/getbotz()
		return src.z

	proc/getbotdir()
		switch(src.dir)
			if(NORTH)
				return "north"
			if(SOUTH)
				return "south"
			if(WEST)
				return "west"
			if(EAST)
				return "east"

	proc/doturn(var/dir)
		switch(dir)
			if("north")
				src.dir = NORTH
				sleep(10)
			if("south")
				src.dir = SOUTH
				sleep(10)
			if("west")
				src.dir = WEST
				sleep(10)
			if("east")
				src.dir = EAST
				sleep(10)

	proc/dograb()
		var/grabturf = getFrontTurf()
		for(var/obj/item/I in grabturf)
			if(full > 5)
				return
			I.loc = safe
			src.full += 1

	proc/getFrontTurf()
		var/dx = 0
		var/dy = 0
		switch(src.dir)
			if(NORTH)
				dy = 1
			if(SOUTH)
				dy = -1
			if(WEST)
				dx = -1
			if(EAST)
				dx = 1
		var/datturf = locate(src.x+dx,src.y+dy,src.z)
		return datturf


	proc/doput()
		var/purgeturf = getFrontTurf()
		for(var/obj/item/I in safe)
			I.loc = purgeturf
		src.full = 0

	proc/dophotoe(var/x, var/y)
		if(abs(x-src.x) <=5 && abs(y-src.y) <= 5)

			var/photoeturf = locate(x,y,src.z)
			src.cam.makephotoe(photoeturf, src)

	proc/dofindX(var/target)
		for(var/obj/O in view(src,world.view))
			if(O.name == target)
				return O.x
		for(var/mob/M in view(src,world.view))
			if(M.name == target)
				return M.x

	proc/dofindY(var/target)
		for(var/obj/O in view(src,world.view))
			if(O.name == target)
				return O.y
		for(var/mob/M in view(src,world.view))

			if(M.name == target)
				return M.y

	proc/dosay(var/text)
		var/list/listening
		var/message_range = 6
		listening = get_mobs_in_view(message_range, src)
		for(var/mob/M in player_list)
			if (!M.client)
				continue //skip monkeys and leavers
			if (istype(M, /mob/new_player))
				continue
			if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTEARS)) // src.client is so that ghosts don't have to listen to mice
				listening|=M
		for(var/mob/M in listening)
			M << "[src.name] states: [text]"

	proc/dorcd(var/mode)
		if(mode >= 0 && mode <=2)
			if(istype(src, /obj/machinery/bot/curiosity/engi))
				var/obj/machinery/bot/curiosity/engi/B = src
				B.dobuild(mode)

	proc/catchvoice(var/message, /var/mob/M)
		//world << "heard [message] by [M]"
		//world << M
		if(recording == 1)
			rec+=message


	proc/recordvoisestart()
		recording=1

	proc/recordvoisestop()
		recording=0

	proc/recordvoiseget(var/line as num)
		if(recording == 0)
			return rec[line]

	proc/recordvoisegetlength()
		if(recording == 0)
			return rec.len

	proc/ltake(var/name as text)
		if(!lhand)
			for(var/obj/item/I in getFrontTurf())
				if(I.name == name)
					I.loc = src
					lhand = I
					break

	proc/rtake(var/name as text)
		if(!rhand)
			for(var/obj/item/I in getFrontTurf())
				if(I.name == name)
					I.loc = src
					rhand = I
					break

	proc/lract()
		if(rhand && lhand)
			rhand.attackby(lhand)

	proc/rlact()
		if(rhand && lhand)
			lhand.attackby(rhand)

	proc/lput()
		if(lhand)
			lhand.loc = getFrontTurf()
			lhand = null

	proc/rput()
		if(rhand)
			rhand.loc = getFrontTurf()
			rhand = null


/obj/machinery/bot/curiosity/engi
	name = "Engineering Rover"
	desc = "Programmable builder unit on wheels"
	var/obj/item/bot/curiosity_parts/curiosity_equipment/rcd/botrcd

	New()
		..()
		botrcd = new()
		botrcd.chassis = src

	proc/dobuild(var/mode)
		var/trg = src.getFrontTurf()
		for(var/obj/machinery/door/airlock/A in trg)
			trg = A
		botrcd.mode = mode
		botrcd.action(trg)





/obj/machinery/computer/curiosity_console
	name = "Research bot console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	//req_access = list()
	//circuit = ""
	var/hacked = 0
	var/message
	var/datum/CUR_Compiler/Compiler
	var/obj/machinery/bot/curiosity/bot
	var/connected = 0

	New()
		..()
		Compiler = new()
		Compiler.Holder = src
		for(var/obj/machinery/bot/curiosity/B in world)
			bot=B

	attack_hand(user as mob)
		if(..(user))
			return
		src.add_fingerprint(usr)
		showdat(user)


	Topic(href, href_list)
		if(..())
			return
		usr.set_machine(src)
		src.add_fingerprint(usr)
		if(href_list["load"])
			message = input("Code:", "source", null, null)  as message
		if(href_list["run"])
			Compiler.compile(message)
			Compiler.Run(bot)
		if(href_list["connect"])
			var/id = input("bot id to connect") as num
			for(var/obj/machinery/bot/curiosity/B in world)
				if(B.id == id)
					bot=B
					bot.console = src
					connected = 1
					showdat(usr)
					return
				usr << "No any bot with such id found"
		if(href_list["disconnect"])
			if(bot)
				bot.console = null
				bot = null
				connected = 0
				showdat(usr)


	proc/showdat(user as mob)
		var/dat
		if(!connected)
			dat = text("<center>Bot control:<br> <b><A href='?src=\ref[src];connect=[1]'>Connect</A></b></center>")
		else
			dat = text("<center>Bot control:<br> <b><A href='?src=\ref[src];load=[1]'>load</A><br><A href='?src=\ref[src];run=[1]'>run</A><br><A href='?src=\ref[src];disconnect=[1]'>disconnect</A></b></center>")
		user << browse("[dat]", "window=botcontrol;size=200x100")

















/n_Interpreter/CUR_Interpreter
	var/datum/CUR_Compiler/Compiler

	HandleError(runtimeError/e)
//		Compiler.Holder.add_entry(e.ToString(), "Execution Error")

/datum/CUR_Compiler
	var/n_Interpreter/CUR_Interpreter/interpreter
	var/obj/machinery/computer/curiosity_console/Holder	// the console that is running the code
	var/ready = 1 // 1 if ready to run code

	/* -- Compile a raw block of text -- */

	proc/compile(code as message)
		var/n_scriptOptions/nS_Options/options = new()
		var/n_Scanner/nS_Scanner/scanner       = new(code, options)
		var/list/tokens                        = scanner.Scan()
		var/n_Parser/nS_Parser/parser          = new(tokens, options)
		var/node/BlockDefinition/GlobalBlock/program   	 = parser.Parse()

		var/list/returnerrors = list()

		returnerrors += scanner.errors
		returnerrors += parser.errors

		if(returnerrors.len)
			return returnerrors

		interpreter 		= new(program)
		interpreter.persist	= 1
		interpreter.Compiler= src
		return returnerrors

	/* -- Execute the compiled code -- */

	proc/Run(var/obj/machinery/bot/curiosity/bot)
		if(!ready)
			return

		if(!interpreter)
			return

		interpreter.container = src

		interpreter.SetVar("PI"		, 	3.141592653)	// value of pi
		interpreter.SetVar("E" 		, 	2.718281828)	// value of e
		interpreter.SetVar("SQURT2" , 	1.414213562)	// value of the square root of 2
		interpreter.SetVar("FALSE"  , 	0)				// boolean shortcut to 0
		interpreter.SetVar("TRUE"	,	1)				// boolean shortcut to 1

		interpreter.SetVar("NORTH" 	, 	NORTH)			// NORTH (1)
		interpreter.SetVar("SOUTH" 	, 	SOUTH)			// SOUTH (2)
		interpreter.SetVar("EAST" 	, 	EAST)			// EAST  (4)
		interpreter.SetVar("WEST" 	, 	WEST)			// WEST  (8)

		interpreter.SetVar("WALL" 	, 	1)			// NORTH (1)
		interpreter.SetVar("DECONSTUCT" 	, 	0)			// SOUTH (2)
		interpreter.SetVar("AIRLOCK" 	, 	2)			// EAST  (4)

		// Channel macros
		interpreter.SetVar("$common",	1459)
		interpreter.SetVar("$science",	1351)
		interpreter.SetVar("$command",	1353)
		interpreter.SetVar("$medical",	1355)
		interpreter.SetVar("$engineering",1357)
		interpreter.SetVar("$security",	1359)
		interpreter.SetVar("$supply",	1347)


		// Set up the script procs
		interpreter.SetProc("move", "dostep", bot, list("dir"))

		interpreter.SetProc("turn", "doturn", bot, list("dir"))

		interpreter.SetProc("takepic", "dophotoe", bot, list("x", "y"))

		interpreter.SetProc("getX", "getbotx", bot, list())

		interpreter.SetProc("getY", "getboty", bot, list())

		interpreter.SetProc("getZ", "getbotz", bot, list())

		interpreter.SetProc("grab", "dograb", bot, list())

		interpreter.SetProc("put", "doput", bot, list())

		interpreter.SetProc("searchX", "dofindX", bot, list("target"))

		interpreter.SetProc("searchY", "dofindY", bot, list("target"))

		//interpreter.SetProc("print",  /proc/print)

		interpreter.SetProc("sleep", /proc/delay)

		interpreter.SetProc("say", "dosay", bot, list("text"))

		interpreter.SetProc("rcd", "dorcd", bot, list("mode"))

		interpreter.SetProc("getDir", "getbotdir", bot, list())

		interpreter.SetProc("recordVoiseStart", "recordvoisestart", bot, list())

		interpreter.SetProc("recordVoiseStop", "recordvoisestop", bot, list())

		interpreter.SetProc("recordVoiseGetLength", "recordvoisegetlength", bot, list())

		interpreter.SetProc("recordVoiseGetLine", "recordvoiseget", bot, list("line"))

		interpreter.SetProc("Ltake", "ltake", bot, list("name"))

		interpreter.SetProc("Rtake", "rtake", bot, list("name"))

		interpreter.SetProc("LRact", "lract", bot, list())

		interpreter.SetProc("RLact", "rlact", bot, list())

		interpreter.SetProc("Rput", "rput", bot, list())

		interpreter.SetProc("Lput", "lput", bot, list())
		/*
			-> Replaces a string with another string
					@format: replace(string, substring, replacestring)

					@param string: 			the string to search for substrings (best used with $content$ constant)
					@param substring: 		the substring to search for
					@param replacestring: 	the string to replace the substring with

		*/
		interpreter.SetProc("replace", /proc/string_replacetext)

		/*
			-> Locates an element/substring inside of a list or string
					@format: find(haystack, needle, start = 1, end = 0)

					@param haystack:	the container to search
					@param needle:		the element to search for
					@param start:		the position to start in
					@param end:			the position to end in

		*/
		interpreter.SetProc("find", /proc/smartfind)

		/*
			-> Finds the length of a string or list
					@format: length(container)

					@param container: the list or container to measure

		*/
		interpreter.SetProc("length", /proc/smartlength)

		/* -- Clone functions, carried from default BYOND procs --- */

		// vector namespace
		interpreter.SetProc("vector", /proc/n_list)
		interpreter.SetProc("at", /proc/n_listpos)
		interpreter.SetProc("copy", /proc/n_listcopy)
		interpreter.SetProc("push_back", /proc/n_listadd)
		interpreter.SetProc("remove", /proc/n_listremove)
		interpreter.SetProc("cut", /proc/n_listcut)
		interpreter.SetProc("swap", /proc/n_listswap)
		interpreter.SetProc("insert", /proc/n_listinsert)

		interpreter.SetProc("pick", /proc/n_pick)
		interpreter.SetProc("prob", /proc/prob_chance)
		interpreter.SetProc("substr", /proc/docopytext)

		// Donkie~
		// Strings
		interpreter.SetProc("lower", /proc/n_lower)
		interpreter.SetProc("upper", /proc/n_upper)
		interpreter.SetProc("explode", /proc/string_explode)
		interpreter.SetProc("repeat", /proc/n_repeat)
		interpreter.SetProc("reverse", /proc/n_reverse)
		interpreter.SetProc("tonum", /proc/n_str2num)
		interpreter.SetProc("findtext", /proc/n_findtext)
		// Numbers
		interpreter.SetProc("tostring", /proc/n_num2str)
		interpreter.SetProc("sqrt", /proc/n_sqrt)
		interpreter.SetProc("abs", /proc/n_abs)
		interpreter.SetProc("floor", /proc/n_floor)
		interpreter.SetProc("ceil", /proc/n_ceil)
		interpreter.SetProc("round", /proc/n_round)
		interpreter.SetProc("clamp", /proc/n_clamp)
		interpreter.SetProc("inrange", /proc/n_inrange)
		// End of Donkie~
		interpreter.SetProc("inrange", /proc/n_inrange)

		// Run the compiled code
		interpreter.Run()


proc/print(msg as text)
	world << msg


/obj/item/device/camera/rovercamera
	name = "Rover camera"
	icon = 'icons/obj/items.dmi'
	desc = "Advanced camera for taking photoes in extreme conditions"
	icon_state = "camera"

/obj/item/device/camera/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if(!istype(target, /datum/construction/reversible/curiosity))
		..()
	return



/obj/item/device/camera/proc/makephotoe(var/atom/target as mob|obj|turf|area, var/obj/machinery/bot/curiosity/bot, flag)
	if(!on || !pictures_left || ismob(target.loc)) return

	var/x_c = target.x - 1
	var/y_c = target.y + 1
	var/z_c	= target.z

	var/mob/user = new(bot.loc)

	var/icon/temp = icon('icons/effects/96x96.dmi',"")
	var/icon/black = icon('icons/turf/space.dmi', "black")
	var/mobs = ""
	for(var/i = 1; i <= 3; i++)
		for(var/j = 1; j <= 3; j++)
			var/turf/T = locate(x_c, y_c, z_c)
			var/mob/dummy = new(T)	//Go go visibility check dummy
			var/viewer = user
			if(dummy in viewers(world.view, viewer))
				temp.Blend(get_icon(T), ICON_OVERLAY, 32 * (j-1-1), 32 - 32 * (i-1))
			else
				temp.Blend(black, ICON_OVERLAY, 32 * (j-1), 64 - 32 * (i-1))
			mobs += get_mobs(T)
			dummy.loc = null
			dummy = null	//Alas, nameless creature	//garbage collect it instead
			x_c++
		y_c--
		x_c = x_c - 3

	var/obj/item/weapon/photo/P = new/obj/item/weapon/photo()
	P.loc = bot.console.loc
	var/icon/small_img = icon(temp)
	var/icon/ic = icon('icons/obj/items.dmi',"photo")
	small_img.Scale(8, 8)
	ic.Blend(small_img,ICON_OVERLAY, 10, 13)
	P.icon = ic
	P.img = temp
	P.desc = mobs
	P.pixel_x = rand(-10, 10)
	P.pixel_y = rand(-10, 10)
	playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)

	pictures_left--
	desc = "A polaroid camera. It has [pictures_left] photos left."
	icon_state = icon_off
	on = 0
	spawn(64)
		icon_state = icon_on
		on = 1
	user.loc = null
	user = null


/obj/item/bot/curiosity_parts/curiosity_equipment/rcd
	name = "Mounted RCD"
	desc = "An exosuit-mounted Rapid Construction Device. (Can be attached to: Any exosuit)"
	icon_state = "mecha_rcd"
	origin_tech = "materials=4;bluespace=3;magnets=4;powerstorage=4"
	var/equip_cooldown = 10
	var/energy_drain = 250
	construction_time = 1200
	construction_cost = list("metal"=30000,"plasma"=25000,"silver"=20000,"gold"=20000)
	var/mode = 0 //0 - deconstruct, 1 - wall or floor, 2 - airlock.
	var/obj/machinery/bot/curiosity/chassis
	var/disabled = 0 //malf

	proc/action(atom/target)
		if(istype(target,/area/shuttle)||istype(target, /turf/space/transit))//>implying these are ever made -Sieve
			disabled = 1
		else
			disabled = 0
		if(!istype(target, /turf) && !istype(target, /obj/machinery/door/airlock))
			target = get_turf(target)
		playsound(chassis, 'sound/machines/click.ogg', 50, 1)
		switch(mode)
			if(0)
				if (istype(target, /turf/simulated/wall))
					if(disabled) return
					target:ChangeTurf(/turf/simulated/floor/plating)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.use_energy(energy_drain)
				else if (istype(target, /turf/simulated/floor))
					if(disabled) return
					target:ChangeTurf(/turf/space)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.use_energy(energy_drain)
				else if (istype(target, /obj/machinery/door/airlock))
					if(disabled) return
					del(target)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.use_energy(energy_drain)
			if(1)
				if(istype(target, /turf/space))
					if(disabled) return
					target:ChangeTurf(/turf/simulated/floor/plating)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.use_energy(energy_drain*2)
				else if(istype(target, /turf/simulated/floor))
					if(disabled) return
					target:ChangeTurf(/turf/simulated/wall)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.use_energy(energy_drain*2)
			if(2)
				if(istype(target, /turf/simulated/floor))
					if(disabled) return
					var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock(target)
					T.autoclose = 1
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					playsound(target, 'sound/effects/sparks2.ogg', 50, 1)
					chassis.use_energy(energy_drain*2)
		return



proc/n_findtext(var/T1, /var/T2)
	return findtext(T1, T2)


/*/mob/living/say(var/message)
	world << "itsaying"
	..(message)
	world << "4cycle"
	for(var/obj/machinery/bot/curiosity/O in view(3,src))
		world << "fond mob"
		O.catchvoice(message, src)*/