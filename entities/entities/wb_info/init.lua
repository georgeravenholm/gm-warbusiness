AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("music")
function ENT:KeyValue(key,value)
  if key=="gamemode" then
    self.gamemode = value
    RunConsoleCommand("wb_gamemode",value)
  end

  if key=="roundtime" then
    self.roundtime = value
    RunConsoleCommand("wb_roundtime",value)
  end

  if key=="setuptime" then
    self.setuptime = value
    RunConsoleCommand("wb_setuptime",value)
  end

  if key=="ctfpointstowin" then
    self.ctfpointstowin = value
    RunConsoleCommand("wb_ctfpointstowin",value)
  end

	if key=="musicurl" then
		-- We have some music to play!
		RunConsoleCommand("wb_musicurl",value)
  end

	if key=="musiccredit" then
		RunConsoleCommand("wb_musiccredit",value)
	end


  --print(key.." "..value)
end
