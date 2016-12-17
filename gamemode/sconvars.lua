-- Create ConVars (shared)
if !ConVarExists("wb_gamemode") then
	CreateConVar("wb_gamemode",0,{FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED},"Gamemode: 0=2deathmatch 1=4deathmatch 2=2ctf 3=4ctf 4=2pl 5=4pl")
	CreateConVar("wb_roundtime",120,{FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED},"How long a round goes on for in seconds (set by map)")
	CreateConVar("wb_setuptime",3,{FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED},"How long players are frozen before a round, or time defenders have to setup. (set by map)")
	CreateConVar("wb_ctfpointstowin",30,{FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED},"Not currently used.")

	CreateConVar("wb_respawntime",0,{FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED},"The post-deathcam period until respawn in seconds")
	CreateConVar("wb_musicurl",[[https://docs.google.com/uc?authuser=0&id=0BwyVpXVLj37PMFk3bDZWR3UxaGs&export=download]],{FCVAR_SERVER_CAN_EXECUTE},"The URL for the map's music")
	CreateConVar("wb_musiccredit","Disco Medusae Kevin MacLeod (incompetech.com)",{FCVAR_SERVER_CAN_EXECUTE},"The CREDITS for the map's music")
end
--CreateConVar("wb_httpmusic","http://",{FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED},"The music that plays. Please give a raw HTTP link.")
