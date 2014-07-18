#define ACCESS_CRATE_CASH 200

/obj/item/weapon/money
	name = "stack of credits"
	desc = "A pile of 1 credit."
	gender = PLURAL
	icon = 'items.dmi'
	icon_state = "spacecash"
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = 1.0
	var/currency
	var/worth
	var/split = 5
	var/round = 0.01
	var/access = list()
	access = ACCESS_CRATE_CASH

/obj/item/weapon/spacecash
	New() // Just in case
		spawn(1)
			new/obj/item/weapon/money(loc)
			del src

/obj/item/weapon/money/proc/updatedesc()
	name = "stack of [currency]"
	desc = "A pile of [worth] [currency]"

/obj/item/weapon/money/New(var/nloc, var/nworth=1,var/ncurrency  = "credits")
	if(!worth)
		worth = nworth
	if(!currency)
		currency = ncurrency
	split = round(worth/2,round)
	updatedesc()
	return ..(nloc)

/obj/item/weapon/money/c10
	icon_state = "spacecash10"
	access = ACCESS_CRATE_CASH
	desc = "A pile of 10 credits."
	worth = 10

/obj/item/weapon/money/c20
	icon_state = "spacecash20"
	access = ACCESS_CRATE_CASH
	desc = "A pile of 20 credits."
	worth = 20

/obj/item/weapon/money/c50
	icon_state = "spacecash50"
	access = ACCESS_CRATE_CASH
	desc = "A pile of 50 credits."
	worth = 50

/obj/item/weapon/money/c100
	icon_state = "spacecash100"
	access = ACCESS_CRATE_CASH
	desc = "A pile of 100 credits."
	worth = 100

/obj/item/weapon/money/c200
	icon_state = "spacecash200"
	access = ACCESS_CRATE_CASH
	desc = "A pile of 200 credits."
	worth = 200

/obj/item/weapon/money/c500
	icon_state = "spacecash500"
	access = ACCESS_CRATE_CASH
	desc = "A pile of 500 credits."
	worth = 500

/obj/item/weapon/money/c1000
	icon_state = "spacecash1000"
	access = ACCESS_CRATE_CASH
	desc = "A pile of 1000 credits."
	worth = 1000

/obj/item/weapon/money/attack_self(var/mob/user)
	interact(user)

/obj/item/weapon/money/proc/interact(var/mob/user)

	user.machine = src

	var/dat

	dat += "<BR>[worth] [currency]"
	dat += "<BR>New pile:"

	dat += "<A href='?src=\ref[src];sd=5'>-</a>"
	dat += "<A href='?src=\ref[src];sd=1'>-</a>"
	if(round<=0.1)
		dat += "<A href='?src=\ref[src];sd=0.1'>-</a>"
		if(round<=0.01)
			dat += "<A href='?src=\ref[src];sd=0.01'>-</a>"
	dat += "[split]"
	if(round<=0.01)
		dat += "<A href='?src=\ref[src];su=0.01'>+</a>"
	if(round<=0.1)
		dat += "<A href='?src=\ref[src];su=0.1'>+</a>"
	dat += "<A href='?src=\ref[src];su=1'>+</a>"
	dat += "<A href='?src=\ref[src];su=5'>+</a>"
	dat += "<BR><A href='?src=\ref[src];split=1'>split</a>"


	user << browse(dat, "window=computer;size=400x500")

	onclose(user, "computer")
	return

/obj/item/weapon/money/Topic(href, href_list)
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

		if (href_list["su"])
			var/samt = text2num(href_list["su"])
			if(split+samt<worth)
				split+=samt
		if (href_list["sd"])
			var/samt = text2num(href_list["sd"])
			if(split-samt>0)
				split-=samt
		if(href_list["split"])
			new /obj/item/weapon/money(get_turf(src),split,currency)
			worth-=split
			split = round(worth/2,round)
			updatedesc()


		src.add_fingerprint(usr)
	src.updateUsrDialog()
	for (var/mob/M in viewers(1, src.loc))
		if (M.client && M.machine == src)
			src.attack_self(M)
	return

/obj/item/weapon/money/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I,/obj/item/weapon/money))
		var/mob/living/carbon/c = user
		if(!uppertext(I:currency)==uppertext(currency))
			c<<"You can't mix currencies!"
			return ..()
		else
			worth+=I:worth
			c<<"You combine the piles."
			updatedesc()
			del I
	return ..()



/obj/machinery/atm
	name = "\improper NanoTrasen Automatic Teller Machine"
	desc = "For all your monetary needs!"
	icon = 'terminals.dmi'
	icon_state = "atm"
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	var/obj/item/weapon/card/id/card
	var/obj/item/weapon/money/cashes = list()
	var/inserted = 0
	var/accepted = 0
	var/pincode = 0

	attackby(var/obj/A, var/mob/user)
		if(istype(A,/obj/item/weapon/money))
			cashes += A
			user.drop_item()
			A.loc = src
			inserted += A:worth
			return
		if(istype(A,/obj/item/weapon/coin))
			if(istype(A,/obj/item/weapon/coin/iron))
				cashes += A
				user.drop_item()
				A.loc = src
				inserted += 1
				return
			if(istype(A,/obj/item/weapon/coin/silver))
				cashes += A
				user.drop_item()
				A.loc = src
				inserted += 10
				return
			if(istype(A,/obj/item/weapon/coin/gold))
				cashes += A
				user.drop_item()
				A.loc = src
				inserted += 50
				return
			if(istype(A,/obj/item/weapon/coin/plasma))
				cashes += A
				user.drop_item()
				A.loc = src
				inserted += 2
				return
			if(istype(A,/obj/item/weapon/coin/diamond))
				cashes += A
				user.drop_item()
				A.loc = src
				inserted += 300
				return
			user << "You insert your [A.name] in ATM"
		..()

	attack_hand(var/mob/user)
		if(istype(user, /mob/living/silicon))
			user << "\red Artificial unit recognized. Artificial units do not currently receive monetary compensation, as per NanoTrasen regulation #1005."
			return

		if(!(stat && NOPOWER) && ishuman(user))
			var/dat
			user.machine = src
			if(!accepted)
				if(scan(user))
					pincode = input(usr,"Enter a pin-code") as num
					if(card.checkaccess(pincode,usr))
						accepted = 1
//						usr << sound('nya.mp3')
			else
				dat = null
				dat += "<h1>NanoTrasen Automatic Teller Machine</h1><br/>"
				dat += "For all your monetary needs!<br/><br/>"
				dat += "Welcome, [card.registered_name]. You have [card.money] credits deposited.<br>"
				dat += "Current inserted item value: [inserted] credits.<br><br>"
				dat += "Please, select action<br>"
				dat += "<a href=\"?src=\ref[src]&with=1\">Withdraw Physical Credits</a><br/>"
				dat += "<a href=\"?src=\ref[src]&eca=1\">Eject Inserted Items</a><br/>"
				dat += "<a href=\"?src=\ref[src]&ins=1\">Convert Inserted Items to Credits</a><br/>"
				dat += "<a href=\"?src=\ref[src]&lock=1\">Lock ATM</a><br/>"
			user << browse(dat,"window=atm")
			onclose(user,"close")
	proc
		withdraw(var/mob/user)
			if(accepted)
				var/amount = input("How much would you like to withdraw?", "Amount", 0) in list(1,10,20,50,100,200,500,1000, 0)
				if(amount == 0)
					return
				if(card.money >= amount)
					card.money -= amount
					switch(amount)
						if(1)
							new /obj/item/weapon/money(loc)
						if(10)
							new /obj/item/weapon/money/c10(loc)
						if(20)
							new /obj/item/weapon/money/c20(loc)
						if(50)
							new /obj/item/weapon/money/c50(loc)
						if(100)
							new /obj/item/weapon/money/c100(loc)
						if(200)
							new /obj/item/weapon/money/c200(loc)
						if(500)
							new /obj/item/weapon/money/c500(loc)
						if(1000)
							new /obj/item/weapon/money/c1000(loc)
				else
					user << "\red Error: Insufficient funds."
					return

		scan(var/mob/user)
			if(istype(user,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = user
				if(H.wear_id)
					if(istype(H.wear_id, /obj/item/weapon/card/id))
						card = H.wear_id
						return 1
					if(istype(H.wear_id,/obj/item/device/pda))
						var/obj/item/device/pda/P = H.wear_id
						if(istype(P.id,/obj/item/weapon/card/id))
							card = P.id
							return 1
					return 0
				return 0

		insert()
			if(accepted)
				card.money += inserted
				inserted = 0

	Topic(href,href_list)
		if (usr.machine==src && get_dist(src, usr) <= 1 || istype(usr, /mob/living/silicon/ai))
			if(href_list["eca"])
				if(accepted)
					for(var/obj/item/weapon/money/M in cashes)
						M.loc = loc
					inserted = 0
					if(!cashes)
						cashes = null
			if(href_list["with"] && card)
				withdraw(usr)
			if(href_list["ins"] && card)
				if(accepted)
					card.money += inserted
					inserted = 0
					if(cashes)
						cashes = null
			if(href_list["lock"])
				card = null
				accepted = 0
				usr.machine = null
				usr << browse(null,"window=atm")
			src.updateUsrDialog()
		else
			usr.machine = null
			usr << browse(null,"window=atm")

/obj/item/weapon/card/id/proc/checkaccess(p,var/mob/user)
	if(p == pin)
		user << "\green Access granted"
		return 1
	user << "\red Access denied"
	return 0