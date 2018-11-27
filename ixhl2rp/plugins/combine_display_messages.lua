PLUGIN.name = "Combine Display Messages"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Adds additional messages to the combine display."

local display_messages = {

	"Updating data connections...",
	"Looking up main protocols...",
	"Updating Translation Matrix...",
	"Establishing connection with overwatch...",
	"Opening up aura scanners...",
	"Establishing Clockwork protocols...",
	"Looking up active fireteam control centers...",
	"Command uplink established...",
	"Inititaing self-maintenance scan...",
	"Scanning for active biosignals...",
	"Updating cid registry link...",
	"Establishing variables for connection hooks...",
	"Creating socket for incoming connection...",
	"Initializing squad uplink interface...",
	"@sivoe-main: 3fj89323r829j20-",
	"Validating memory replacement integrity...",
	"Visual uplink status code: GREEN...",
	"Refreshing primary database connections...",
	"Creating ID's for internal structs...",
	"Dumping cache data and renewing from external memory...",
	"Updating squad statuses...",
	"Looking up front end codebase changes...",
	"Software status nominal...",
	"Querying database for new recruits... RESPONSE: OK",
	"Establishing connection to long term maintenance procedures...",
	"Looking up CP-5 Main...",
	"Updating railroad activity monitors...",
	"Caching new response protocols...",
	"Calculating the duration of patrol...",
	"Caching internal watch protocols..."
}

--This might be expensive, i'm not sure.
function PLUGIN:PlayerTick(player)
	if player:IsCombine() and player:Alive() then
		if !player.nextTrivia or player.nextTrivia <= CurTime() then
			Schema:AddCombineDisplayMessage(table.Random(display_messages), Color(255,255,255,255))
			player.nextTrivia = CurTime() + 5
		end
	end
end

