include('shared.lua')
include('teammenu.lua')
include('elimination.lua')
include('classmenu.lua')
include('hud.lua')
include('scoreboard.lua')

AddCSLuaFile()

/*function GM:PreDrawHalos()
    // Halos on... flags!
		return false
		for k,v in ipairs(ents.FindByClass("wb_flag")) do
			halo.Add( {v}, team.GetColor(v:GetNWInt("flagteam")), 0, 0, 1,false,true )
			v:DrawModel()
		end

		halo.Add( team.GetPlayers(LocalPlayer():Team()), team.GetColor(LocalPlayer():Team()), 3, 3, 1,false,true )
end*/

function GM:OnPlayerChat(ply,text,teamChat) // le memery on asking to change class
	if ply==LocalPlayer()&&string.match(string.lower(text),"how")!=nil && string.match(string.lower(text),"change")!=nil && (string.match(string.lower(text),"class")!=nil || string.match(string.lower(text),"character")!=nil || string.match(string.lower(text),"weapons")!=nil ) then -- they asked how to change class
		Derma_Message("PRESS F2 OR TYPE CHOOSECLASS IN CONSOLE, YA IDIOT. CANT YOU READ WINDOWS? IF YOU ARE ON A LAPTOP TRY THE FUNCTION OR 'FN' BUTTON, OTHERWISE IF YOU DO NOT KNOW HOW TO OPEN CONSOLE THEN FRICKING GOOGLE IT MATE OK THANKS","T R I G G E R E D",
		"jesus fucking christ mate calm down im just a little kid who cant press the fn button, but can you please open the classmenu for me i just wanted to enjoy your gamemode. huh? youll do it? thanks so much i really appreciate that and im really happy you were so nice")
		RunConsoleCommand("chooseclass")
	elseif ply==LocalPlayer()&&string.match(string.lower(text),"how")!=nil && string.match(string.lower(text),"change")!=nil && (string.match(string.lower(text),"team")!=nil || string.match(string.lower(text),"company")!=nil || string.match(string.lower(text),"group")!=nil ) then -- they asked how to change class
		Derma_Message("PRESS F1 OR TYPE CHOOSETEAM IN CONSOLE, YA IDIOT. CANT YOU READ WINDOWS? IF YOU ARE ON A LAPTOP TRY THE FUNCTION OR 'FN' BUTTON, OTHERWISE IF YOU DO NOT KNOW HOW TO OPEN CONSOLE THEN FRICKING GOOGLE IT MATE OK THANKS","T R O G G E R E D",
		"jesus fucking christ mate calm down im just a little kid who cant press the fn button, but can you please open the team menu for me i just wanted to enjoy your gamemode. huh? youll do it? thanks so much i really appreciate that and im really happy you were so nice")
		RunConsoleCommand("chooseteam")
	end
end


-- ive got to get the time
time = 0
setup = false
fourway = false
victor = -1
net.Receive("roundrefresh", function()
  -- update that trash
  time = net.ReadInt(32)
  setup = net.ReadBool()
	fourway = net.ReadBool()
	gamemode = net.ReadInt(4)
	victor = net.ReadInt(4)
end)


net.Receive("music", function()
  -- update that trash
  local url = net.ReadString()
  local credit = net.ReadString()
	sound.PlayURL(url, "noblock", function(channel,errorID,errorString)
		-- callaback
		--if errorID!=0 then print("(War Business) !!! Failed to load URL "..url.." for music!") print("(War Business) Error: "..errorString) end
		if IsValid(channel) then

			channel:Play()
			--channel:EnableLooping(true)
			LocalPlayer():ChatPrint(credit)
			g_station = channel
		end
	end)
end)

-- welcome box
net.Receive("welcome", function()
	Derma_Message( "Welcome to War Business!\nPress F1 to change team, and F2 to change classe.\n(if those dont work, try the fn key on your laptops or if that fails, 'chooseclass' and 'chooseteam' in console)\nThe gamemode is probably ctf.", "Welcome!", "I solemly swear that I read this and wont ask how to change classes." )
end)

-- ???
function GM:ShouldDrawLocalPlayer() return false end

-- name tags
function GM:HUDDrawTargetID() end

function test()
	for k,v in pairs(ents.GetAll()) do if v:GetClass() == "wb_trig_flagcap" then print("FOUND "..tostring(v) .. (v:GetNWInt("team",-1)) ) else print(v:GetClass()) end end
end
