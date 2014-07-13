#define SAY_MINIMUM_PRESSURE 10
var/list/department_radio_keys = list(
	  ":r" = "right ear",	"#r" = "right ear",		".r" = "right ear",
	  ":l" = "left ear",	"#l" = "left ear",		".l" = "left ear",
	  ":i" = "intercom",	"#i" = "intercom",		".i" = "intercom",
	  ":h" = "department",	"#h" = "department",	".h" = "department",
	  ":c" = "Command",		"#c" = "Command",		".c" = "Command",
	  ":n" = "Science",		"#n" = "Science",		".n" = "Science",
	  ":m" = "Medical",		"#m" = "Medical",		".m" = "Medical",
	  ":e" = "Engineering", "#e" = "Engineering",	".e" = "Engineering",
	  ":s" = "Security",	"#s" = "Security",		".s" = "Security",
	  ":w" = "whisper",		"#w" = "whisper",		".w" = "whisper",
	  ":b" = "binary",		"#b" = "binary",		".b" = "binary",
	  ":a" = "alientalk",	"#a" = "alientalk",		".a" = "alientalk",
	  ":t" = "Syndicate",	"#t" = "Syndicate",		".t" = "Syndicate",
	  ":u" = "Supply",		"#u" = "Supply",		".u" = "Supply",
	  ":g" = "changeling",	"#g" = "changeling",	".g" = "changeling",

	  ":R" = "right ear",	"#R" = "right ear",		".R" = "right ear",
	  ":L" = "left ear",	"#L" = "left ear",		".L" = "left ear",
	  ":I" = "intercom",	"#I" = "intercom",		".I" = "intercom",
	  ":H" = "department",	"#H" = "department",	".H" = "department",
	  ":C" = "Command",		"#C" = "Command",		".C" = "Command",
	  ":N" = "Science",		"#N" = "Science",		".N" = "Science",
	  ":M" = "Medical",		"#M" = "Medical",		".M" = "Medical",
	  ":E" = "Engineering",	"#E" = "Engineering",	".E" = "Engineering",
	  ":S" = "Security",	"#S" = "Security",		".S" = "Security",
	  ":W" = "whisper",		"#W" = "whisper",		".W" = "whisper",
	  ":B" = "binary",		"#B" = "binary",		".B" = "binary",
	  ":A" = "alientalk",	"#A" = "alientalk",		".A" = "alientalk",
	  ":T" = "Syndicate",	"#T" = "Syndicate",		".T" = "Syndicate",
	  ":U" = "Supply",		"#U" = "Supply",		".U" = "Supply",
	  ":G" = "changeling",	"#G" = "changeling",	".G" = "changeling",

	  //kinda localization -- rastaf0
	  //same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	  ":к" = "right ear",	"#к" = "right ear",		".к" = "right ear",
	  ":д" = "left ear",	"#д" = "left ear",		".д" = "left ear",
	  ":ш" = "intercom",	"#ш" = "intercom",		".ш" = "intercom",
	  ":р" = "department",	"#р" = "department",	".р" = "department",
	  ":с" = "Command",		"#с" = "Command",		".с" = "Command",
	  ":т" = "Science",		"#т" = "Science",		".т" = "Science",
	  ":ь" = "Medical",		"#ь" = "Medical",		".ь" = "Medical",
	  ":у" = "Engineering",	"#у" = "Engineering",	".у" = "Engineering",
	  ":ы" = "Security",	"#ы" = "Security",		".ы" = "Security",
	  ":ц" = "whisper",		"#ц" = "whisper",		".ц" = "whisper",
	  ":и" = "binary",		"#и" = "binary",		".и" = "binary",
	  ":ф" = "alientalk",	"#ф" = "alientalk",		".ф" = "alientalk",
	  ":е" = "Syndicate",	"#е" = "Syndicate",		".е" = "Syndicate",
	  ":й" = "Supply",		"#й" = "Supply",		".й" = "Supply",
	  ":п" = "changeling",	"#п" = "changeling",	".п" = "changeling",

	  //Давно не хватало. К тому же, теперь это полностью совместимо с моим парсером. - Rel
	  ":К" = "right hand",	"#К" = "right hand",	".К" = "right hand",
	  ":Д" = "left hand",	"#Д" = "left hand",		".Д" = "left hand",
	  ":Ш" = "intercom",	"#Ш" = "intercom",		".Ш" = "intercom",
	  ":Р" = "department",	"#Р" = "department",	".Р" = "department",
	  ":С" = "Command",		"#С" = "Command",		".С" = "Command",
	  ":Т" = "Science",		"#Т" = "Science",		".Т" = "Science",
	  ":Ь" = "Medical",		"#Ь" = "Medical",		".Ь" = "Medical",
	  ":У" = "Engineering",	"#У" = "Engineering",	".У" = "Engineering",
	  ":Ы" = "Security",	"#Ы" = "Security",		".Ы" = "Security",
	  ":Ц" = "whisper",		"#Ц" = "whisper",		".Ц" = "whisper",
	  ":И" = "binary",		"#И" = "binary",		".И" = "binary",
	  ":Ф" = "alientalk",	"#Ф" = "alientalk",		".Ф" = "alientalk",
	  ":Е" = "Syndicate",	"#Е" = "Syndicate",		".Е" = "Syndicate",
	  ":Й" = "Supply",		"#Й" = "Supply",		".Й" = "Supply",
	  ":П" = "changeling",	"#П" = "changeling",	".П" = "changeling"
)

/mob/living/proc/binarycheck()
	if (istype(src, /mob/living/silicon/pai))
		return
	if (issilicon(src))
		return 1
	if (!ishuman(src))
		return
	var/mob/living/carbon/human/H = src
	if (H.l_ear || H.r_ear)
		var/obj/item/device/radio/headset/dongle
		if(istype(H.l_ear,/obj/item/device/radio/headset))
			dongle = H.l_ear
		else
			dongle = H.r_ear
		if(!istype(dongle)) return
		if(dongle.translate_binary) return 1

/mob/living/proc/hivecheck()
	if (isalien(src)) return 1
	if (!ishuman(src)) return
	var/mob/living/carbon/human/H = src
	if (H.l_ear || H.r_ear)
		var/obj/item/device/radio/headset/dongle
		if(istype(H.l_ear,/obj/item/device/radio/headset))
			dongle = H.l_ear
		else
			dongle = H.r_ear
		if(!istype(dongle)) return
		if(dongle.translate_binary) return 1

/mob/living/say(var/message, var/datum/language/speaking = null, var/verb="говорит", var/alt_name="", var/italics=0, var/message_range = world.view, var/list/used_radios = list(), var/sound/speech_sound, var/sound_vol)

	var/turf/T = get_turf(src)

	//handle nonverbal and sign languages here
	if (speaking)
		if (speaking.flags & NONVERBAL)
			if (prob(30))
				src.custom_emote(1, "[pick(speaking.signlang_verb)].")

		if (speaking.flags & SIGNLANG)
			say_signlang(message, pick(speaking.signlang_verb), speaking)
			return

	//speaking into radios
	if(used_radios.len)
		italics = 1
		message_range = 1

		for(var/mob/living/M in hearers(5, src))
			if(M != src)
				M.show_message("<span class='notice'>[src] говорит в [used_radios.len ? used_radios[1] : "the radio."]</span>")
			if (speech_sound)
				src.playsound_local(get_turf(src), speech_sound, sound_vol * 0.5, 1)

		speech_sound = null	//so we don't play it twice.

	//make sure the air can transmit speech
	var/datum/gas_mixture/environment = T.return_air()
	if(environment)
		var/pressure = environment.return_pressure()
		if(pressure < SAY_MINIMUM_PRESSURE)
			italics = 1
			message_range = 1

			if (speech_sound)
				sound_vol *= 0.5	//muffle the sound a bit, so it's like we're actually talking through contact

	var/list/listening = list()
	var/list/listening_obj = list()

	if(T)
		var/list/hear = hear(message_range, T)
		var/list/hearturfs = list()

		for(var/I in hear)
			if(istype(I, /mob/))
				var/mob/M = I
				listening += M
				hearturfs += M.locs[1]
				for(var/obj/O in M.contents)
					listening_obj |= O
			else if(istype(I, /obj/))
				var/obj/O = I
				hearturfs += O.locs[1]
				listening_obj |= O

		for(var/mob/M in player_list)
			if(M.stat == DEAD && M.client && (M.client.prefs.toggles & CHAT_GHOSTEARS))
				listening |= M
				continue
			if(M.loc && M.locs[1] in hearturfs)
				listening |= M

	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
	spawn(30) del(speech_bubble)

	for(var/mob/M in listening)
		M << speech_bubble
		M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol)

	for(var/obj/O in listening_obj)
		spawn(0)
			if(O) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, message, verb, speaking)

	log_say("[name]/[key] : [message]")

/mob/living/proc/say_signlang(var/message, var/verb="жестикулирует", var/datum/language/language)
	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name
