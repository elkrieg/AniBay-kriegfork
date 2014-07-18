/*/var/list/enter_whitelist = list()

/proc/load_enter_whitelist()
	var/text = file2text("data/enter_whitelist.txt")
	if (!text)
		diary << "Failed to load enter_whitelist.txt\n"
	else
		enter_whitelist = dd_text2list(text, "\n")*/


//////////////////////////////////// WHITELIST ////////////////////////////////////
var/list/bwhitelist

/proc/load_bwhitelist()
	log_admin("Loading whitelist")
	bwhitelist = list()
	var/DBConnection/dbcon = new()
	dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
	if(!dbcon.IsConnected())
		log_admin("Failed to load bwhitelist. Error: [dbcon.ErrorMsg()]")
		return
	var/DBQuery/query = dbcon.NewQuery("SELECT byond FROM whitelist ORDER BY byond ASC")
	query.Execute()
	while(query.NextRow())
		bwhitelist += "[query.item[1]]"
	if (bwhitelist==list(  ))
		log_admin("Failed to load bwhitelist or its empty")
		return
	dbcon.Disconnect()

/proc/check_bwhitelist(var/K)
	if (!bwhitelist)
		load_bwhitelist()
		if (!bwhitelist)
			return 0
	if (K in bwhitelist)
		return 1
	return 0