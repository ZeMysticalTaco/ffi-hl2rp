PLUGIN.name = "Chatter"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Adding a bit of atmosphere with metropolice / overwatch chatter."

if SERVER then
	function PLUGIN:CharacterLoaded(char)
		local player = char.player

		if player:IsCombine() then
			player.NextChatterTick = CurTime() + 5
		else
			player.NextChatterTick = nil
		end

		if player:IsCombine() then
			player:SetNetVar("chatter", true)
		else
			player:SetNetVar("chatter", false)
		end
	end

	--[[-------------------------------------------------------------------------
hacky but i'm tired.
---------------------------------------------------------------------------]]
	fff = {"Metropolice", "Dispatch"}
	fff2 = {"Overwatch", "Dispatch"}

	function PLUGIN:PlayerTick(player)
		local char = player:GetCharacter()

		if char then
			if not player:GetNetVar("chatter") then
				player.NextChatterTick = nil

				return
			end

			if char:GetFaction() == FACTION_MPF and player.NextChatterTick < CurTime() then
				self:EmitChatter(player, table.Random(fff), "random")
				player.NextChatterTick = CurTime() + math.random(60, 300)
			end

			if char:GetFaction() == FACTION_OTA and player.NextChatterTick < CurTime() then
				self:EmitChatter(player, table.Random(fff2), "random")
				player.NextChatterTick = CurTime() + math.random(60, 300)
			end
		end
	end

	--[[-------------------------------------------------------------------------
Note to self:

this:
table[table + 1] = {
	tablevalue1 = valueinput
	tablevalue2 = valueinput2
}
means:
inserting a new value into the table using the next key, automatically filling the entry with content.
---------------------------------------------------------------------------]]
	local beginners = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/on1.wav", "npc/combine_soldier/vo/off1.wav"}
	--[[
local beginnersMPF = {
	"npc/overwatch/radiovoice/on1.wav",
	"npc/overwatch/radiovoice/on3.wav"
}

local beginnersOTA = {
	"npc/combine_soldier/vo/off1.wav"
}--]]
	local endings = {"npc/overwatch/radiovoice/off2.wav", "npc/overwatch/radiovoice/off4.wav"}
	local randomthingsMPF = {"administer", "affirmative", "affirmative2", "airwatchsubjectis505", "allrightyoucango", "allunitsbol34sat", "allunitscloseonsuspect", "allunitscode2", "allunitsmaintainthiscp", "allunitsmovein", "allunitsreportlocationsuspect", "allunitsrespondcode3", "anyonepickup647e", "assaultpointsecureadvance", "atcheckpoint", "backup", "block", "blockisholdingcohesive", "canalblock", "catchthatbliponstabilization", "cauterize", "checkformiscount", "chuckle", "citizen", "citizensummoned", "classifyasdbthisblockready", "clearandcode100", "clearno647no10-107", "code100", "code7", "condemnedzone", "confirmadw", "confirmpriority1sighted", "contactwith243suspect", "contactwithpriority2", "control100percent", "controlsection", "converging", "covermegoingin", "cpbolforthat243", "cpiscompromised", "cpisoverrunwehavenocontainment", "cprequestsallunitsreportin", "cpweneedtoestablishaperimeterat", "criminaltrespass63", "defender", "deservicedarea", "designatesuspectas", "destroythatcover", "dismountinghardpoint", "dispatchIneed10-78", "dispreportssuspectincursion", "dispupdatingapb", "distributionblock", "document", "dontmove", "establishnewcp", "examine", "expired", "externaljurisdiction", "fifteen", "fifty", "finalverdictadministered", "finalwarning", "firetodislocateinterpose", "firingtoexposetarget", "firstwarningmove", "freenecrotics", "get11-44inboundcleaningup", "getdown", "getoutofhere", "goingtotakealook", "gota10-107sendairwatch", "gothimagainsuspect10-20at", "gotoneaccomplicehere", "gotsuspect1here", "grenade", "hardpointscanning", "hero", "hesgone148", "hesrunning", "hesupthere", "hidinglastseenatrange", "highpriorityregion", "holdingon10-14duty", "holdit", "holditrightthere", "holdthisposition", "Ihave10-30my10-20responding", "industrialzone", "infection", "infestedzone", "inject", "innoculate", "inposition", "inpositionathardpoint", "inpositiononeready", "intercede", "interlock", "investigate", "investigating10-103", "is10-108", "is415b", "Isaidmovealong", "isathardpointreadytoprosecute", "isclosingonsuspect", "isdown", "isgo", "ismovingin", "isolate", "ispassive", "isreadytogo", "issuingmalcompliantcitation", "Ivegot408hereatlocation", "jury", "keepmoving", "king", "level3civilprivacyviolator", "line", "localcptreportstatus", "location", "lock", "lockyourposition", "lookingfortrouble", "lookout", "lookoutrogueviscerator", "looseparasitics", "loyaltycheckfailure", "malcompliant10107my1020", "malignant", "matchonapblikeness", "meters", "minorhitscontinuing", "move", "movealong", "movealong3", "movebackrightnow", "moveit", "moveit2", "movetoarrestpositions", "movingtocover", "movingtohardpoint", "movingtohardpoint2", "necrotics", "needanyhelpwiththisone", "nine", "nineteen", "ninety", "nocontact", "non-taggedviromeshere", "noncitizen", "nonpatrolregion", "novisualonupi", "nowgetoutofhere", "officerdowncode3tomy10-20", "officerdownIam10-99", "officerneedsassistance", "officerneedshelp", "officerunderfiretakingcover", "outbreak", "outlandbioticinhere", "outlandzone", "pacifying", "patrol", "pickingupnoncorplexindy", "possible10-103alerttagunits", "possible404here", "possible647erequestairwatch", "possiblelevel3civilprivacyviolator", "preparefor1015", "prepareforjudgement", "preparingtojudge10-107", "preserve", "pressure", "priority2anticitizenhere", "proceedtocheckpoints", "productionblock", "prosecute", "protectioncomplete", "ptatlocationreport", "ptgoagain", "putitinthetrash1", "putitinthetrash2", "quick", "readytoamputate", "readytojudge", "readytoprosecute", "readytoprosecutefinalwarning", "reinforcementteamscode3", "reportsightingsaccomplices", "repurposedarea", "requestsecondaryviscerator", "residentialblock", "responding2", "restrict", "restrictedblock", "rodgerthat", "roller", "runninglowonverdicts", "sacrificecode1maintaincp", "search", "searchingforsuspect", "secondwarning", "sector", "sentencedelivered", "serve", "seven", "seventeen", "seventy", "shit", "shotsfiredhostilemalignants", "six", "sixteen", "sixty", "sociocide", "stabilizationjurisdiction", "standardloyaltycheck", "stationblock", "sterilize", "stick", "stillgetting647e", "stormsystem", "subject", "subjectis505", "subjectisnowhighspeed", "supsecthasmovednowto", "suspect11-6my1020is", "suspectinstormrunoff", "suspectisbleeding", "suspectlocationunknown", "suspectusingrestrictedcanals", "suspend", "sweepingforsuspect", "tag10-91d", "tagonebug", "tagonenecrotic", "tagoneparasitic", "takecover", "tap", "teaminpositionadvance", "ten", "ten2", "ten4", "ten8standingby", "ten91dcountis", "ten97", "ten97suspectisgoa", "tenzerovisceratorishunting", "terminalrestrictionzone", "thatsagrenade", "therehegoeshesat", "thereheis", "thirteen", "thirty", "thisisyoursecondwarning", "three", "threehundred", "transitblock", "twelve", "twenty", "two", "twohundred", "union", "unitis10-65", "unitis10-8standingby", "unitisonduty10-8", "unitreportinwith10-25suspect", "unlawfulentry603", "upi", "utlsuspect", "utlthatsuspect", "vacatecitizen", "vice", "victor", "visceratordeployed", "visceratorisoc", "visceratorisoffgrid", "wasteriver", "watchit", "wearesociostablethislocation", "wegotadbherecancel10-102", "wehavea10-108", "workforceintake", "xray", "yellow"}
	--[["pressure",
	"document",
	"restrict",
	"intercede",
	"preserve",
	"search",
	"suspend",
	"investigate",
	"interlock",
	"administer",
	"cauterize",
	"innoculate",
	"examine",--]]
	local randomthingsDSP = {"404zone", "accomplicesoperating", "administer", "airwatchcopiesnoactivity", "airwatchreportspossiblemiscount", "alarms62", "allteamsrespondcode3", "allunitsapplyforwardpressure", "allunitsat", "allunitsbeginwhitnesssterilization", "allunitsbolfor243suspect", "allunitsdeliverterminalverdict", "allunitsreturntocode12", "allunitsverdictcodeis", "allunitsverdictcodeonsuspect", "amputate", "anticitizen", "antifatigueration3mg", "apply", "assault243", "attemptedcrime27", "attention", "beginscanning10-0", "block", "canalblock", "capitalmalcompliance", "cauterize", "citizen", "completesentencingatwill", "condemnedzone", "confirmupialert", "controlsection", "criminaltrespass63", "defender", "deservicedarea", "destrutionofcpt", "devisivesociocidal", "disassociationfromcivic", "disengaged647e", "distributionblock", "disturbancemental10-103m", "disturbingunity415", "document", "eight", "engagingteamisnoncohesive", "examine", "externaljurisdiction", "failuretocomply", "failuretotreatoutbreak", "finalverdictadministered", "five", "fmil_Region 073", "four", "fugitive17f", "halfrankpoints", "halfreproductioncredits", "hero", "highpriorityregion", "illegalcarrying95", "illegalinoperation63s", "immediateamputation", "incitingpopucide", "industrialzone", "infection", "infestedzone", "inject", "innoculate", "inprogress", "intercede", "interlock", "investigate", "investigateandreport", "isnow", "isolate", "jury", "king", "leadersreportratios", "level5anticivilactivity", "line", "lock", "lockdownlocationsacrificecode", "nine", "noncitizen", "nonpatrolregion", "nonsanctionedarson51", "off2", "off4", "officerat", "officerclosingonsuspect", "one", "outlandzone", "patrol", "permanentoffworld", "politistablizationmarginal", "posession69", "prematuremissiontermination", "prepareforfinalsentencing", "preparetoinnoculate", "preparetoreceiveverdict", "preparevisualdownload", "preserve", "pressure", "productionblock", "promotingcommunalunrest", "prosecute", "publicnoncompliance507", "quick", "recalibratesocioscan", "recievingconflictingdata", "recklessoperation99", "reinforcementteamscode3", "remainingunitscontain", "reminder100credits", "remindermemoryreplacement", "reporton", "reportplease", "repurposedarea", "residentialblock", "resistingpacification148", "respond", "restrict", "restrictedblock", "restrictedincursioninprogress", "rewardnotice", "riot404", "roller", "search", "sector", "serve", "seven", "six", "socialfractureinprogress", "sociocide", "sociostabilizationrestored", "stabilizationjurisdiction", "stationblock", "statuson243suspect", "sterilize", "stick", "stormsystem", "subject", "suspectisnow187", "suspectmalignantverdictcodeis", "suspend", "suspendnegotiations", "switchcomtotac3", "switchtotac5reporttocp", "tap", "teamsreportstatus", "terminalprosecution", "terminalrestrictionzone", "threattoproperty51b", "three", "transitblock", "two", "union", "unlawfulentry603", "upi", "vice", "victor", "violationofcivictrust", "wasteriver", "weapon94", "workforceintake", "xray", "yellow"}
	local randomthingsOTA = {"administer", "affirmative", "affirmative2", "affirmativewegothimnow", "alert1", "anticitizenone", "antiseptic", "apex", "bearing", "blade", "block31mace", "block64jet", "bodypackholding", "boomer", "bouncerbouncer", "callcontactparasitics", "callcontacttarget1", "callhotpoint", "cleaned", "closing", "closing2", "confirmsectornotsterile", "contact", "contactconfim", "contactconfirmprosecuting", "contained", "containmentproceeding", "copy", "copythat", "cover", "coverhurt", "coverme", "dagger", "dash", "degrees", "delivered", "designatetargetas", "displace", "displace2", "echo", "eight", "eighteen", "eighty", "eleven", "engagedincleanup", "engaging", "executingfullresponse", "extractoraway", "extractorislive", "fifteen", "fifty", "fist", "five", "fixsightlinesmovein", "flaredown", "flash", "flatline", "flush", "four", "fourteen", "fourty", "fullactive", "ghost", "ghost2", "goactiveintercept", "gosharp", "gosharpgosharp", "grid", "gridsundown46", "hammer", "hardenthatposition", "hasnegativemovement", "heavyresistance", "helix", "hunter", "hurricane", "ice", "inbound", "infected", "ion", "isatcode", "isfieldpromoted", "isfinalteamunitbackup", "isholdingatcode", "jet", "judge", "kilo", "leader", "lostcontact", "mace", "meters", "motioncheckallradials", "movein", "necrotics", "necroticsinbound", "niner", "nineteen", "ninety", "nomad", "nova", "noviscon", "one", "onecontained", "onedown", "onedutyvacated", "onehundred", "outbreak", "outbreakstatusiscode", "overwatch", "overwatchconfirmhvtcontained", "overwatchreportspossiblehostiles", "overwatchrequestreinforcement", "overwatchrequestreserveactivation", "overwatchrequestskyshield", "overwatchrequestwinder", "overwatchsectoroverrun", "overwatchtarget1sterilized", "overwatchtargetcontained", "overwatchteamisdown", "ovewatchorders3ccstimboost", "payback", "phantom", "prepforcontact", "priority1objective", "prioritytwoescapee", "prosecuting", "quicksand", "range", "ranger", "razor", "readycharges", "readyextractors", "readyweapons", "readyweaponshostilesinbound", "reaper", "reportallpositionsclear", "reportallradialsfree", "reportingclear", "requestmedical", "requeststimdose", "ripcord", "ripcordripcord", "savage", "scar", "sectionlockupdash4", "sector", "sectorisnotsecure", "sectorissecurenovison", "secure", "seven", "seventeen", "seventy", "shadow", "sharpzone", "sightlineisclear", "six", "sixteen", "sixty", "skyshieldreportslostcontact", "slam", "slash", "spear", "stab", "stabilizationteamhassector", "stabilizationteamholding", "standingby", "star", "stayalert", "stayalertreportsightlines", "stinger", "storm", "striker", "sundown", "suppressing", "swarmoutbreakinsector", "sweeper", "sweepingin", "swift", "sword", "target", "targetblackout", "targetcompromisedmovein", "targetcontactat", "targetineffective", "targetisat", "targetmyradial", "targetone", "teamdeployedandscanning", "ten", "thatsitwrapitup", "thirteen", "thirty", "three", "threehundred", "tracker", "twelve", "twenty", "two", "twohundred", "uniform", "unitisclosing", "unitisinbound", "unitismovingin", "vamp", "viscon", "visualonexogens", "weaponsoffsafeprepforcontact", "weareinaninfestationzone", "wehavefreeparasites", "wehavenontaggedviromes", "winder", "zero"}
	--[[local namesOTA = {
	"leader",
	"flash",
	"ranger",
	"hunter",
	"blade",
	"scar",
	"hammer",
	"sweeper",
	"swift",
	"fist",
	"sword",
	"savage",
	"tracker",
	"slash",
	"razor",
	"stab",
	"spear",
	"striker",
	"dagger"
}--]]
	--[[
local namesMPF = {

}

local phonetics = {
	["APEX"] = "npc/combine_soldier/vo/apex.wav",
	["ION"] = "npc/combine_soldier/vo/ion.wav",
	["JET"] = "npc/combine_soldier/vo/jet.wav",
	["KILO"] = "npc/combine_soldier/vo/kilo.wav",
	["MACE"] = "npc/combine_soldier/vo/mace.wav",
	["NOVA"] = "npc/combine_soldier/vo/nova.wav",
	["PAYBACK"] = "npc/combine_soldier/vo/payback.wav",
	["SUNDOWN"] = "npc/combine_soldier/vo/sundown.wav",
	["UNIFORM"] = "npc/combine_soldier/vo/uniform.wav",
	["BOOMER"] = "npc/combine_soldier/vo/boomer.wav",
	["ECHO"] = "npc/combine_soldier/vo/echo.wav",
	["FLATLINE"] = "npc/combine_soldier/vo/flatline.wav",
	["HELIX"] = "npc/combine_soldier/vo/helix.wav",
	["ICE"] = "npc/combine_soldier/vo/ice.wav",
	["QUICKSAND"] = "npc/combine_soldier/vo/quicksand.wav",
	["RIPCORD"] = "npc/combine_soldier/vo/ripcord.wav"
}--]]
	local combinedRandom = {}
	table.Add(combinedRandom, randomthingsMPF)
	table.Add(combinedRandom, randomthingsDSP)
	table.Add(combinedRandom, randomthingsOTA)

	--[[-------------------------------------------------------------------------
The phonetic system, using dictations from the HL2 Source Files.
---------------------------------------------------------------------------]]
	function PLUGIN:SayPhonetic(player, phonetic)
	end

	function PLUGIN:EmitChatter(player, side, chatter, pitch, volume)
		if not player:GetNetVar("chatter", false) then
			return
		end

		local emits = 0
		local emitb = 0

		if not chatter then
			print("No value entered for chatter!")
		end

		--[[
	if chatter == "random" then
		chatter = table.Random(combinedRandom)
		print("Set Chatter to Random")
		print("Result: " .. chatter)
		local beginner = table.Random(beginners)
		player:EmitSound(beginner, nil, pitch, volume)
		emits = SoundDuration(beginner)

		timer.Create("timerstart" .. player:UniqueID(), emits + 0.05, 1, function()
			player:EmitSound("npc/metropolice/vo/" .. chatter .. ".wav", nil, math.random(60, 140), volume)
			emitb = SoundDuration("npc/metropolice/vo/" .. chatter .. ".wav") + 0.5

			timer.Create("timerend" .. player:UniqueID(), emitb + 0.05, 1, function()
				player:EmitSound(table.Random(endings), nil, pitch, volume)
			end)
		end)
	end--]]
		if not level then
			level = 200
		end

		if not pitch then
			pitch = math.random(60, 140)
		end

		if not volume then
			volume = 1
		end

		--[[-------------------------------------------------------------------------
Your next line is... Timers inside timers!? Isn't it!
---------------------------------------------------------------------------]]
		if side == "Metropolice" then
			if chatter == "random" then
				chatter = table.Random(randomthingsMPF)
				print("Set Chatter to RandomMP")
				print("Result: " .. chatter)
			end

			local beginner = table.Random(beginners)
			player:EmitSound(beginner, nil, pitch, volume)
			emits = SoundDuration(beginner)

			timer.Create("timerstart" .. player:UniqueID(), emits + 0.05, 1, function()
				player:EmitSound("npc/metropolice/vo/" .. chatter .. ".wav", nil, math.random(60, 140), volume)
				emitb = SoundDuration("npc/metropolice/vo/" .. chatter .. ".wav") + 0.5

				timer.Create("timerend" .. player:UniqueID(), emitb + 0.05, 1, function()
					player:EmitSound(table.Random(endings), nil, pitch, volume)
				end)
			end)
		end

		if side == "Overwatch" then
			if chatter == "random" then
				chatter = table.Random(randomthingsOTA)
				print("Set Chatter to RandomOW")
				print("Result: " .. chatter)
			end

			local beginner = table.Random(beginners)
			player:EmitSound(beginner, nil, pitch, volume)
			emits = SoundDuration(beginner)

			timer.Create("timerstart" .. player:UniqueID(), emits + 0.05, 1, function()
				player:EmitSound("npc/combine_soldier/vo/" .. chatter .. ".wav", nil, math.random(60, 140), volume)
				emitb = SoundDuration("npc/combine_soldier/vo/" .. chatter .. ".wav") + 0.5

				timer.Create("timerend" .. player:UniqueID(), emitb + 0.05, 1, function()
					player:EmitSound(table.Random(endings), nil, pitch, volume)
				end)
			end)
			--player:EmitSound("npc/combine_soldier/vo/" .. chatter .. ".wav", level, pitch, volume)
		end

		if side == "Dispatch" then
			if chatter == "random" then
				chatter = table.Random(randomthingsDSP)
				print("Set Chatter to RandomDP")
				print("Result: " .. chatter)
			end

			local beginner = table.Random(beginners)
			player:EmitSound(beginner, nil, pitch, volume)
			emits = SoundDuration(beginner)

			timer.Create("timerstart" .. player:UniqueID(), emits + 0.05, 1, function()
				player:EmitSound("npc/overwatch/radiovoice/" .. chatter .. ".wav", nil, math.random(60, 140), volume)
				emitb = SoundDuration("npc/overwatch/radiovoice/" .. chatter .. ".wav") + 0.5

				timer.Create("timerend" .. player:UniqueID(), emitb + 0.05, 1, function()
					player:EmitSound(table.Random(endings), nil, pitch, volume)
				end)
			end)
			--player:EmitSound("npc/overwatch/radiovoice/" .. chatter .. ".wav", level, pitch, volume)
		end
	end
end

local precache_randomthingsMPF = {"administer", "affirmative", "affirmative2", "airwatchsubjectis505", "allrightyoucango", "allunitsbol34sat", "allunitscloseonsuspect", "allunitscode2", "allunitsmaintainthiscp", "allunitsmovein", "allunitsreportlocationsuspect", "allunitsrespondcode3", "anyonepickup647e", "assaultpointsecureadvance", "atcheckpoint", "backup", "block", "blockisholdingcohesive", "canalblock", "catchthatbliponstabilization", "cauterize", "checkformiscount", "chuckle", "citizen", "citizensummoned", "classifyasdbthisblockready", "clearandcode100", "clearno647no10-107", "code100", "code7", "condemnedzone", "confirmadw", "confirmpriority1sighted", "contactwith243suspect", "contactwithpriority2", "control100percent", "controlsection", "converging", "covermegoingin", "cpbolforthat243", "cpiscompromised", "cpisoverrunwehavenocontainment", "cprequestsallunitsreportin", "cpweneedtoestablishaperimeterat", "criminaltrespass63", "defender", "deservicedarea", "designatesuspectas", "destroythatcover", "dismountinghardpoint", "dispatchIneed10-78", "dispreportssuspectincursion", "dispupdatingapb", "distributionblock", "document", "dontmove", "establishnewcp", "examine", "expired", "externaljurisdiction", "fifteen", "fifty", "finalverdictadministered", "finalwarning", "firetodislocateinterpose", "firingtoexposetarget", "firstwarningmove", "freenecrotics", "get11-44inboundcleaningup", "getdown", "getoutofhere", "goingtotakealook", "gota10-107sendairwatch", "gothimagainsuspect10-20at", "gotoneaccomplicehere", "gotsuspect1here", "grenade", "hardpointscanning", "hero", "hesgone148", "hesrunning", "hesupthere", "hidinglastseenatrange", "highpriorityregion", "holdingon10-14duty", "holdit", "holditrightthere", "holdthisposition", "Ihave10-30my10-20responding", "industrialzone", "infection", "infestedzone", "inject", "innoculate", "inposition", "inpositionathardpoint", "inpositiononeready", "intercede", "interlock", "investigate", "investigating10-103", "is10-108", "is415b", "Isaidmovealong", "isathardpointreadytoprosecute", "isclosingonsuspect", "isdown", "isgo", "ismovingin", "isolate", "ispassive", "isreadytogo", "issuingmalcompliantcitation", "Ivegot408hereatlocation", "jury", "keepmoving", "king", "level3civilprivacyviolator", "line", "localcptreportstatus", "location", "lock", "lockyourposition", "lookingfortrouble", "lookout", "lookoutrogueviscerator", "looseparasitics", "loyaltycheckfailure", "malcompliant10107my1020", "malignant", "matchonapblikeness", "meters", "minorhitscontinuing", "move", "movealong", "movealong3", "movebackrightnow", "moveit", "moveit2", "movetoarrestpositions", "movingtocover", "movingtohardpoint", "movingtohardpoint2", "necrotics", "needanyhelpwiththisone", "nine", "nineteen", "ninety", "nocontact", "non-taggedviromeshere", "noncitizen", "nonpatrolregion", "novisualonupi", "nowgetoutofhere", "officerdowncode3tomy10-20", "officerdownIam10-99", "officerneedsassistance", "officerneedshelp", "officerunderfiretakingcover", "outbreak", "outlandbioticinhere", "outlandzone", "pacifying", "patrol", "pickingupnoncorplexindy", "possible10-103alerttagunits", "possible404here", "possible647erequestairwatch", "possiblelevel3civilprivacyviolator", "preparefor1015", "prepareforjudgement", "preparingtojudge10-107", "preserve", "pressure", "priority2anticitizenhere", "proceedtocheckpoints", "productionblock", "prosecute", "protectioncomplete", "ptatlocationreport", "ptgoagain", "putitinthetrash1", "putitinthetrash2", "quick", "readytoamputate", "readytojudge", "readytoprosecute", "readytoprosecutefinalwarning", "reinforcementteamscode3", "reportsightingsaccomplices", "repurposedarea", "requestsecondaryviscerator", "residentialblock", "responding2", "restrict", "restrictedblock", "rodgerthat", "roller", "runninglowonverdicts", "sacrificecode1maintaincp", "search", "searchingforsuspect", "secondwarning", "sector", "sentencedelivered", "serve", "seven", "seventeen", "seventy", "shit", "shotsfiredhostilemalignants", "six", "sixteen", "sixty", "sociocide", "stabilizationjurisdiction", "standardloyaltycheck", "stationblock", "sterilize", "stick", "stillgetting647e", "stormsystem", "subject", "subjectis505", "subjectisnowhighspeed", "supsecthasmovednowto", "suspect11-6my1020is", "suspectinstormrunoff", "suspectisbleeding", "suspectlocationunknown", "suspectusingrestrictedcanals", "suspend", "sweepingforsuspect", "tag10-91d", "tagonebug", "tagonenecrotic", "tagoneparasitic", "takecover", "tap", "teaminpositionadvance", "ten", "ten2", "ten4", "ten8standingby", "ten91dcountis", "ten97", "ten97suspectisgoa", "tenzerovisceratorishunting", "terminalrestrictionzone", "thatsagrenade", "therehegoeshesat", "thereheis", "thirteen", "thirty", "thisisyoursecondwarning", "three", "threehundred", "transitblock", "twelve", "twenty", "two", "twohundred", "union", "unitis10-65", "unitis10-8standingby", "unitisonduty10-8", "unitreportinwith10-25suspect", "unlawfulentry603", "upi", "utlsuspect", "utlthatsuspect", "vacatecitizen", "vice", "victor", "visceratordeployed", "visceratorisoc", "visceratorisoffgrid", "wasteriver", "watchit", "wearesociostablethislocation", "wegotadbherecancel10-102", "wehavea10-108", "workforceintake", "xray", "yellow"}
local precache_randomthingsDSP = {"404zone", "accomplicesoperating", "administer", "airwatchcopiesnoactivity", "airwatchreportspossiblemiscount", "alarms62", "allteamsrespondcode3", "allunitsapplyforwardpressure", "allunitsat", "allunitsbeginwhitnesssterilization", "allunitsbolfor243suspect", "allunitsdeliverterminalverdict", "allunitsreturntocode12", "allunitsverdictcodeis", "allunitsverdictcodeonsuspect", "amputate", "anticitizen", "antifatigueration3mg", "apply", "assault243", "attemptedcrime27", "attention", "beginscanning10-0", "block", "canalblock", "capitalmalcompliance", "cauterize", "citizen", "completesentencingatwill", "condemnedzone", "confirmupialert", "controlsection", "criminaltrespass63", "defender", "deservicedarea", "destrutionofcpt", "devisivesociocidal", "disassociationfromcivic", "disengaged647e", "distributionblock", "disturbancemental10-103m", "disturbingunity415", "document", "eight", "engagingteamisnoncohesive", "examine", "externaljurisdiction", "failuretocomply", "failuretotreatoutbreak", "finalverdictadministered", "five", "fmil_Region 073", "four", "fugitive17f", "halfrankpoints", "halfreproductioncredits", "hero", "highpriorityregion", "illegalcarrying95", "illegalinoperation63s", "immediateamputation", "incitingpopucide", "industrialzone", "infection", "infestedzone", "inject", "innoculate", "inprogress", "intercede", "interlock", "investigate", "investigateandreport", "isnow", "isolate", "jury", "king", "leadersreportratios", "level5anticivilactivity", "line", "lock", "lockdownlocationsacrificecode", "nine", "noncitizen", "nonpatrolregion", "nonsanctionedarson51", "off2", "off4", "officerat", "officerclosingonsuspect", "one", "outlandzone", "patrol", "permanentoffworld", "politistablizationmarginal", "posession69", "prematuremissiontermination", "prepareforfinalsentencing", "preparetoinnoculate", "preparetoreceiveverdict", "preparevisualdownload", "preserve", "pressure", "productionblock", "promotingcommunalunrest", "prosecute", "publicnoncompliance507", "quick", "recalibratesocioscan", "recievingconflictingdata", "recklessoperation99", "reinforcementteamscode3", "remainingunitscontain", "reminder100credits", "remindermemoryreplacement", "reporton", "reportplease", "repurposedarea", "residentialblock", "resistingpacification148", "respond", "restrict", "restrictedblock", "restrictedincursioninprogress", "rewardnotice", "riot404", "roller", "search", "sector", "serve", "seven", "six", "socialfractureinprogress", "sociocide", "sociostabilizationrestored", "stabilizationjurisdiction", "stationblock", "statuson243suspect", "sterilize", "stick", "stormsystem", "subject", "suspectisnow187", "suspectmalignantverdictcodeis", "suspend", "suspendnegotiations", "switchcomtotac3", "switchtotac5reporttocp", "tap", "teamsreportstatus", "terminalprosecution", "terminalrestrictionzone", "threattoproperty51b", "three", "transitblock", "two", "union", "unlawfulentry603", "upi", "vice", "victor", "violationofcivictrust", "wasteriver", "weapon94", "workforceintake", "xray", "yellow"}
local precache_randomthingsOTA = {"administer", "affirmative", "affirmative2", "affirmativewegothimnow", "alert1", "anticitizenone", "antiseptic", "apex", "bearing", "blade", "block31mace", "block64jet", "bodypackholding", "boomer", "bouncerbouncer", "callcontactparasitics", "callcontacttarget1", "callhotpoint", "cleaned", "closing", "closing2", "confirmsectornotsterile", "contact", "contactconfim", "contactconfirmprosecuting", "contained", "containmentproceeding", "copy", "copythat", "cover", "coverhurt", "coverme", "dagger", "dash", "degrees", "delivered", "designatetargetas", "displace", "displace2", "echo", "eight", "eighteen", "eighty", "eleven", "engagedincleanup", "engaging", "executingfullresponse", "extractoraway", "extractorislive", "fifteen", "fifty", "fist", "five", "fixsightlinesmovein", "flaredown", "flash", "flatline", "flush", "four", "fourteen", "fourty", "fullactive", "ghost", "ghost2", "goactiveintercept", "gosharp", "gosharpgosharp", "grid", "gridsundown46", "hammer", "hardenthatposition", "hasnegativemovement", "heavyresistance", "helix", "hunter", "hurricane", "ice", "inbound", "infected", "ion", "isatcode", "isfieldpromoted", "isfinalteamunitbackup", "isholdingatcode", "jet", "judge", "kilo", "leader", "lostcontact", "mace", "meters", "motioncheckallradials", "movein", "necrotics", "necroticsinbound", "niner", "nineteen", "ninety", "nomad", "nova", "noviscon", "one", "onecontained", "onedown", "onedutyvacated", "onehundred", "outbreak", "outbreakstatusiscode", "overwatch", "overwatchconfirmhvtcontained", "overwatchreportspossiblehostiles", "overwatchrequestreinforcement", "overwatchrequestreserveactivation", "overwatchrequestskyshield", "overwatchrequestwinder", "overwatchsectoroverrun", "overwatchtarget1sterilized", "overwatchtargetcontained", "overwatchteamisdown", "ovewatchorders3ccstimboost", "payback", "phantom", "prepforcontact", "priority1objective", "prioritytwoescapee", "prosecuting", "quicksand", "range", "ranger", "razor", "readycharges", "readyextractors", "readyweapons", "readyweaponshostilesinbound", "reaper", "reportallpositionsclear", "reportallradialsfree", "reportingclear", "requestmedical", "requeststimdose", "ripcord", "ripcordripcord", "savage", "scar", "sectionlockupdash4", "sector", "sectorisnotsecure", "sectorissecurenovison", "secure", "seven", "seventeen", "seventy", "shadow", "sharpzone", "sightlineisclear", "six", "sixteen", "sixty", "skyshieldreportslostcontact", "slam", "slash", "spear", "stab", "stabilizationteamhassector", "stabilizationteamholding", "standingby", "star", "stayalert", "stayalertreportsightlines", "stinger", "storm", "striker", "sundown", "suppressing", "swarmoutbreakinsector", "sweeper", "sweepingin", "swift", "sword", "target", "targetblackout", "targetcompromisedmovein", "targetcontactat", "targetineffective", "targetisat", "targetmyradial", "targetone", "teamdeployedandscanning", "ten", "thatsitwrapitup", "thirteen", "thirty", "three", "threehundred", "tracker", "twelve", "twenty", "two", "twohundred", "uniform", "unitisclosing", "unitisinbound", "unitismovingin", "vamp", "viscon", "visualonexogens", "weaponsoffsafeprepforcontact", "weareinaninfestationzone", "wehavefreeparasites", "wehavenontaggedviromes", "winder", "zero"}
local precache_combinedRandom = {}
table.Add(precache_combinedRandom, precache_randomthingsMPF)
table.Add(precache_combinedRandom, precache_randomthingsDSP)
table.Add(precache_combinedRandom, precache_randomthingsOTA)
--[[-------------------------------------------------------------------------
Precache sounds so that we don't have lag for new sounds.
Seriously it's annoying.
---------------------------------------------------------------------------]]
for k, v in pairs(precache_combinedRandom) do
	util.PrecacheSound(v)
end
