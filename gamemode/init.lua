AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sconvars.lua")
AddCSLuaFile("teammenu.lua")
AddCSLuaFile("classmenu.lua")
AddCSLuaFile("elimination.lua")
AddCSLuaFile("scoreboard.lua")
AddCSLuaFile("hud.lua")
--AddCSLuaFile("elimination.lua")

resource.AddFile( "sound/ks/5.wav" )
resource.AddFile( "sound/ks/10.wav" )
resource.AddFile( "sound/ks/15.wav" )
resource.AddFile( "sound/ks/18.wav" )
resource.AddFile( "sound/ks/19.wav" )
resource.AddFile( "sound/ks/elite.wav" )
resource.AddFile( "sound/ks/fail.mp3" )

resource.AddFile( "sound/hitsound/hrt/1/1.mp3" )
resource.AddFile( "sound/hitsound/hrt/1/2.mp3" )
resource.AddFile( "sound/hitsound/hrt/1/3.mp3" )
--resource.AddFile( "sound/hitsound/hrt/1/4.mp3" )

resource.AddFile( "sound/hitsound/hrt/2/1.mp3" )
resource.AddFile( "sound/hitsound/hrt/2/2.mp3" )
resource.AddFile( "sound/hitsound/hrt/2/3.mp3" )
--resource.AddFile( "sound/hitsound/hrt/2/4.mp3" )

resource.AddFile( "sound/hitsound/oec/1/1.mp3" )
resource.AddFile( "sound/hitsound/oec/1/2.mp3" )
resource.AddFile( "sound/hitsound/oec/1/3.mp3" )
--resource.AddFile( "sound/hitsound/oec/1/4.mp3" )

resource.AddFile( "sound/hitsound/oec/2/1.mp3" )
resource.AddFile( "sound/hitsound/oec/2/2.mp3" )
resource.AddFile( "sound/hitsound/oec/2/3.mp3" )
--resource.AddFile( "sound/hitsound/oec/2/4.mp3" )


--- Sharp Shooter Rifle
resource.AddFile( "models/sharp_rifle/v_sniper.mdl" )
resource.AddFile( "models/sharp_rifle/v_sniper.dx90.vtx" )
resource.AddFile( "models/sharp_rifle/v_sniper.vvd" )
resource.AddFile( "models/sharp_rifle/w_sniper.mdl" )
resource.AddFile( "models/sharp_rifle/w_sniper.dx90.vtx" )
resource.AddFile( "models/sharp_rifle/w_sniper.vvd" )

resource.AddFile( "materials/models/weapons/w_sniper/w_amr_sheet.vmt" )
resource.AddFile( "materials/models/weapons/w_sniper/w_amr_sheet.vtf" )
resource.AddFile( "materials/models/weapons/w_sniper/w_amr_sheet_normal.vtf" )

resource.AddFile( "materials/models/weapons/v_sniper/amr_lens.vmt" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_lens.vtf" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_lens_normal.vtf" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_rendertarget.vmt" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_scope.vmt" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_scope_sheet.vmt" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_scope_sheet.vtf" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_scope_sheet_normal.vtf" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_sheet1.vtf" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_sheet1_normal.vtf" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_sheet1.vmt" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_sheet2.vtf" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_sheet2_normal.vtf" )
resource.AddFile( "materials/models/weapons/v_sniper/amr_sheet2.vmt" )

resource.AddFile( "materials/images/wb_teamicons/abrika.png" )
resource.AddFile( "materials/images/wb_teamicons/belmont.png" )
resource.AddFile( "materials/images/wb_teamicons/holmrekr.png" )
resource.AddFile( "materials/images/wb_teamicons/orangee.png" )
resource.AddFile( "materials/images/wb_teamicons/spectate.png" )




include('shared.lua')

-- keep all these values updated
local setuptime = GetConVar("wb_setuptime"):GetInt()
local roundtime = GetConVar("wb_roundtime"):GetInt()


-- round system
local time = 0
local setup = false
local game = false
local victor = -1


function GM:Think()
	fourway = math.fmod(GetConVar("wb_gamemode"):GetInt(),2)!=0 && GetConVar("wb_gamemode"):GetInt() != 0
	setuptime = GetConVar("wb_setuptime"):GetInt()
	roundtime = GetConVar("wb_roundtime"):GetInt()
end

local humiliate = false

-- models/flag/flag.mdl

function GM:PlayerConnect(name,ip)
	PrintMessage(HUD_PRINTTALK,"> "..name.." has connected.")
end

--[[
function GM:PlayerDisconnected(ply)
  PrintMessage(HUD_PRINTTALK,"> "..ply:.." has left.")
end]]





function GM:PlayerSelectSpawn(ply)
	if ply:Team()==5 then return end
     local ent = table.Random( team.GetSpawnPoints( ply:Team() ) )
     if ent!=nil && ent!=NULL then
     	ply:SetEyeAngles(ent:GetAngles())
          return ent
     else
          return table.Random( ents.FindByClass("info_player_start") )
     end
end

function announceBalance(ply)
	PrintMessage( HUD_PRINTCENTER, ply:Name().." was autobalanced to "..teamdata[ply:Team()].name )
	ply:ChatPrint("You have been autobalanced to "..teamdata[ply:Team()].name)
end

local metaplayer = FindMetaTable("Player")
function metaplayer:AutoBalance()
	if GetConVar("wb_debug"):GetInt() == 1 then return false end
	if !fourway then
		if ( team.NumPlayers(1)>team.NumPlayers(2)+1 ) && self:Team()==1 then self:SetTeam(2) announceBalance(self) return true-- Team 1 has > than 1 player advantage.
		elseif ( team.NumPlayers(2)>team.NumPlayers(1)+1 ) && self:Team()==2 then self:SetTeam(1) announceBalance(self) return true end -- Team 2 has > than 1 player advantage.
	else
		-- four way.
		local myteam = self:Team()
		local myplayers = team.NumPlayers(myteam)
		local teamone = team.NumPlayers(1)
		local teamtwo = team.NumPlayers(2)
		local teamthree = team.NumPlayers(3)
		local teamfour = team.NumPlayers(4)

		if myteam == 1 then
			if myplayers > teamtwo+1 then self:SetTeam(2) announceBalance(self) return true end
			if myplayers > teamthree+1 then self:SetTeam(3) announceBalance(self) return true end
			if myplayers > teamfour+1 then self:SetTeam(4) announceBalance(self)  return true end
		elseif myteam == 2 then
			if myplayers > teamone+1 then self:SetTeam(1) announceBalance(self)  return true end
			if myplayers > teamthree+1 then self:SetTeam(3) announceBalance(self)  return true end
			if myplayers > teamfour+1 then self:SetTeam(4) announceBalance(self)  return true end
		elseif myteam == 3 then
			if myplayers > teamtwo+1 then self:SetTeam(2) announceBalance(self)  return true end
			if myplayers > teamone+1 then self:SetTeam(1) announceBalance(self)  return true end
			if myplayers > teamfour+1 then self:SetTeam(4) announceBalance(self)  return true end
		elseif myteam == 4 then
			if myplayers > teamtwo+1 then self:SetTeam(2) announceBalance(self)  return true end
			if myplayers > teamthree+1 then self:SetTeam(3) announceBalance(self)  return true end
			if myplayers > teamone+1 then self:SetTeam(1) announceBalance(self)  return true end
		end
	end
end

util.AddNetworkString("welcome")
util.AddNetworkString("music")
function GM:PlayerInitialSpawn(ply)
	-- Welcome them
	net.Start("welcome")
	net.Send(ply)

	ply:SetNWInt("class",1)
	PrintMessage(HUD_PRINTTALK,"> "..ply:Nick().." has spawned!")
	if !fourway then
		if team.NumPlayers(1) < team.NumPlayers(2) then ply:SetTeam(1) else ply:SetTeam(2) end
	else
		ply:SetTeam( 1 )
		if ply:AutoBalance() then ply:KillSilent() end
	end
end

function metaplayer:CanJoin(join)
	if !fourway then
		if ( team.NumPlayers(1)-1>team.NumPlayers(2)+1 ) && self:Team()==1 then self:SetTeam(2) return false
		elseif ( team.NumPlayers(2)-1>team.NumPlayers(1)+1 ) && self:Team()==2 then self:SetTeam(1) return false end
		return true -- we lived!
	else
		-- four way.
		-- check if a situation where ply changes team would cause a disbalance, else if we survive return true.
		local myteam = self:Team()
		local teams =
		{
			team.NumPlayers(1),
			team.NumPlayers(2),
			team.NumPlayers(3),
			team.NumPlayers(4),
			team.NumPlayers(5), -- just so spectatorfags dont error
		}

		-- Create a situation.
		teams[myteam]=teams[myteam]-1 -- remove player from their team
		teams[join]=teams[join]+1 -- add a player to the team they want to join.

		-- Check for disbalance
		--if teams[1] > teams[1]+1 then return false end  | dont check these, they'll always be true.
		if teams[1] > teams[2]+1 then return false end
		if teams[1] > teams[3]+1 then return false end
		if teams[1] > teams[4]+1 then return false end

		if teams[2] > teams[1]+1 then return false end
		--if teams[2] > teams[2]+1 then return false end
		if teams[2] > teams[3]+1 then return false end
		if teams[2] > teams[4]+1 then return false end

		if teams[3] > teams[1]+1 then return false end
		if teams[3] > teams[2]+1 then return false end
		--if teams[3] > teams[3]+1 then return false end
		if teams[3] > teams[4]+1 then return false end

		if teams[4] > teams[1]+1 then return false end
		if teams[4] > teams[2]+1 then return false end
		if teams[4] > teams[3]+1 then return false end
		--if teams[4] > teams[4]+1 then return false end

		return true -- we lived!
	end
end


function GM:PlayerSpawn(ply) -----------------------------------------------------------------------------------------------------------------------------------
	ply:StripWeapons()
	ply:StripAmmo()
	ply:SetNWEntity("carrying",Entity(0))
	if (ply:Team() == 3 || ply:Team() == 4) && !fourway then ply:SetTeam(5) end -- if not fourway and they are on SVR or ABT put them in spectatorfags
	if ply:Team()!=5 then // A L L O F THIS IF NOT SPECTATING
		if ply:AutoBalance() then ply:KillSilent() end
		ply:UnSpectate()

		-- Reset >0> KillStreak >0>
		ply:SetNWInt("killstreak",0)
		-- If they are a bot, randomise their class
		if ply:IsBot() then
			ply:SetNWInt("class",math.random(7))
			--print(table.Random(ply:GetWeapons()))
		end

	     ply:SetPlayerColor(team.GetColor(ply:Team()):ToVector())
	     ply:SetModel( teamdata[ply:Team()].model )
	     ply:SetNoCollideWithTeammates( true )
			ply:AllowFlashlight(true)

			ply:SetJumpPower( 250 )


		// All these comments were the old weapon spawning, when classes were not yet implemented
		/*ply:SetMaxHealth(150)
	     ply:SetHealth(ply:GetMaxHealth())
	     ply:SetRunSpeed(300)
	     ply:SetWalkSpeed( ply:GetRunSpeed() )

	     ply:Give("weapon_smg1")
	     ply:Give("weapon_crowbar")
	     ply:Give("weapon_pistol")
	     ply:Give("weapon_frag")
	     ply:Give("weapon_357")

	     ply:SetAmmo( 100, "Pistol", true )
	     ply:SetAmmo( 12, "357", true )
	     ply:SetAmmo( 200, "SMG1", true )
	     ply:SetAmmo( 3,"Grenade")*/

		-- We now have classes.
		local class = classdata[ply:GetNWInt("class",1)] -- Put the classdata into this local var for easy access
		ply:SetMaxHealth(class.health)
	     ply:SetHealth(ply:GetMaxHealth())
	     ply:SetRunSpeed(class.speed)
	     ply:SetWalkSpeed( ply:GetRunSpeed() )
		if class==7 then ent:SetModelScale( ent:GetModelScale() * 10, 1 ) end

		-- give them weapons
		for k,wep in ipairs(class.loadout) do
			ply:Give(wep)
		end

		-- give them ammo
		for k,ammo in ipairs(class.ammo) do
			ply:SetAmmo(ammo.amount,ammo.type)
		end

		if ply:IsBot() then // If bot, then equip a random weapon instead of just default
			ply:SetActiveWeapon(table.Random(ply:GetWeapons()))
			--ply:Give("weapon_agent_backstab",true)
			--ply:SelectWeapon("weapon_agent_backstab")
			--ply:SetHealth(999999)
		end

		-- make 10 sec invunrability
		if !ply:IsBot() && !setup  then-- we still have to kill bots
			ply:SetNWInt("uber",CurTime()+3)
			ply:PrintMessage(HUD_PRINTCENTER,"[Spawn] You are now invincible for ".. "3" .." seconds!")
			timer.Create("uber",1,2,  function()ply:PrintMessage(HUD_PRINTCENTER,"[Spawn] You are now invincible for ".. math.Round(ply:GetNWInt("uber")-CurTime()) ..( math.Round(ply:GetNWInt("uber")-CurTime())==1 and " second!" or " seconds!" ) )end)
			timer.Simple(3,function() if ply:Alive() then ply:PrintMessage(HUD_PRINTCENTER,"[Spawn] You are no longer invincible!") end end)
		end

	     ply:SetupHands()
	else
	     -- spawn mr.playa as a spectatorerino cappichino spaghettioli ravioli
		GAMEMODE:PlayerSpawnAsSpectator( ply )
		ply:SetTeam(5)
  	end
end


function GM:PlayerDeathThink( ply ) return false end // Disable respawning manually

util.AddNetworkString("youwerekilled")
util.AddNetworkString("elimination")
util.AddNetworkString("killfeed")
function GM:PlayerDeath(ply,inflictor,attacker)

	-- send to keelfeede
	net.Start("killfeed")
		//net.WriteEntity(ply)
		//if attacker:IsPlayer() && attacker!=ply then net.WriteString(attacker:GetActiveWeapon():GetClass()) else net.WriteString("killed") end
		//net.WriteEntity(attacker)

		// Instead of sending the entites which can be removed, send the text and team colours to the clients

		//recycle code to get the adjective
		if attacker:IsPlayer() && attacker!=ply then // if another player killed this player
			net.WriteString(ply:Nick()) // Dead's name
			net.WriteColor(team.GetColor(ply:Team())) // Dead's team colour

			net.WriteString(attacker:GetActiveWeapon():GetClass()) // killers weapon

			net.WriteString(attacker:Nick()) // killer's name
			net.WriteColor(team.GetColor(attacker:Team())) // killer's team colour
		else // suicide or world kill
			net.WriteString("Themself") // Dead's name
			net.WriteColor(team.GetColor(ply:Team())) // Dead's team colour
			net.WriteString("killed") // sey person killed
			net.WriteString(ply:Nick()) // killer's name
			net.WriteColor(team.GetColor(ply:Team())) // killer's team colour
		end
	net.Broadcast()

     if humlilate == true then
          return false
     end

	--print(attacker)
	ply:SetNWBool("invis",false) -- we dont want an invis after death exploit!
	ply:AutoBalance()

     -- points
     local gm = GetConVar("wb_gamemode"):GetInt()
     if gm == 0 && attacker:IsPlayer() && attacker != ply then -- 2way dm!
          team.AddScore(attacker:Team(),1)
     elseif gm == 1 && attacker:IsPlayer() && attacker != ply then -- 2way dm!
          team.AddScore(attacker:Team(),1)
     end

	-- End ply's streak !
	if ply:GetNWInt("killstreak",0) >= 5 then
		local streak = ply:GetNWInt("killstreak",0)
		ply:SendLua([[surface.PlaySound("ks/fail.mp3")]])

		if ply != attacker && attacker:IsPlayer() then
			PrintMessage(HUD_PRINTCENTER,">"..streak.."> "..attacker:Nick().." ended "..ply:Nick().."-s streak! >"..streak..">")
			PrintMessage(HUD_PRINTTALK,">"..streak.."> "..attacker:Nick().." ended "..ply:Nick().."-s streak! >"..streak..">")
		else
			PrintMessage(HUD_PRINTCENTER,">"..streak.."> "..ply:Nick().." ended their own streak! >"..streak..">")
			PrintMessage(HUD_PRINTTALK,">"..streak.."> "..ply:Nick().." ended their own streak! >"..streak..">")
		end
	end

     if attacker:IsPlayer() && attacker != ply then
			attacker:SetNWInt("points", attacker:GetNWInt("points")+2 )
			attacker:SetNWInt("killstreak", attacker:GetNWInt("killstreak")+1 )
			net.Start("elimination") net.WriteString("Eliminated "..ply:Nick().." +2") net.Send(attacker)

			local streak = attacker:GetNWInt("killstreak",0) -- lets handle killstreak messages!



			if streak == 5 then
				PrintMessage(HUD_PRINTCENTER,">"..streak.."> "..attacker:Nick().." is on a killstreak! >"..streak..">")
				PrintMessage(HUD_PRINTTALK,">"..streak.."> "..attacker:Nick().." is on a killstreak! >"..streak..">")
				attacker:SendLua([[surface.PlaySound("ks/5.wav")]])
			end

			if streak == 10 then
				PrintMessage(HUD_PRINTCENTER,">"..streak.."> "..attacker:Nick().." is on a killing spree! >"..streak..">")
				PrintMessage(HUD_PRINTTALK,">"..streak.."> "..attacker:Nick().." is on a killing spree! >"..streak..">")
				attacker:SendLua([[surface.PlaySound("ks/10.wav")]])
			end

			if streak == 15 then
				PrintMessage(HUD_PRINTCENTER,">"..streak.."> "..attacker:Nick().." is destroying! >"..streak..">")
				PrintMessage(HUD_PRINTTALK,">"..streak.."> "..attacker:Nick().." is destroying! >"..streak..">")
				attacker:SendLua([[surface.PlaySound("ks/15.wav")]])
			end

			if streak == 18 then
				---PrintMessage(HUD_PRINTCENTER,">"..streak.."> "..attacker:Nick().." is close! >"..streak..">")
				---PrintMessage(HUD_PRINTTALK,">"..streak.."> "..attacker:Nick().." is close! >"..streak..">")
				attacker:SendLua([[surface.PlaySound("ks/18.wav")]])
			end

			if streak == 19 then
				---PrintMessage(HUD_PRINTCENTER,">"..streak.."> "..attacker:Nick().." is almost there! >"..streak..">")
				---PrintMessage(HUD_PRINTTALK,">"..streak.."> "..attacker:Nick().." is almost there! >"..streak..">")
				attacker:SendLua([[surface.PlaySound("ks/19.wav")]])
			end

			if streak >= 20 && math.fmod(streak,5)==0 then
				PrintMessage(HUD_PRINTCENTER,">"..streak.."> "..attacker:Nick().." is ELITE! >"..streak..">")
				PrintMessage(HUD_PRINTTALK,">"..streak.."> "..attacker:Nick().." is ELITE! >"..streak..">")
				attacker:SendLua([[surface.PlaySound("ks/elite.wav")]])
			end
		end

     if attacker:IsPlayer() && attacker!=ply && !humiliate then
          net.Start("youwerekilled")
          net.WriteEntity(attacker)
          net.Send(ply)

          ply:Spectate( OBS_MODE_FREEZECAM )
          ply:SpectateEntity( attacker )
          ply:StripWeapons()

          timer.Simple( 3, function()
			if ply:Alive() || humiliate then return end -- why respawn if we are alive? also, no respawning during humiliation
		          ply:SpectateEntity( table.Random( team.GetPlayers(ply:Team()) ) )
			 ply:SetObserverMode(OBS_MODE_ROAMING)
		          timer.Simple( GetGlobalInt("respawntime",5), function() if ply:Alive() || humiliate then return end ply:Spawn() end )
          end )
     elseif ply:IsValid() && !humiliate then
          ply:Spectate( OBS_MODE_DEATHCAM )
          ply:SpectateEntity( attacker )
          ply:StripWeapons()

          timer.Simple( 3, function()
			if ply:Alive() || humiliate then return end -- why respawn if we are alive? also, no respawning during humiliation
			ply:SpectateEntity( table.Random( team.GetPlayers(ply:Team()) ) )
			ply:SetObserverMode(OBS_MODE_ROAMING)
			timer.Simple( GetGlobalInt("respawntime",5), function() if ply:Alive() || humiliate then return end ply:Spawn() end )
          end )
     end
end



-- Choose the model for hands according to their player model.
function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

-- No friendly fire!
util.AddNetworkString("hitsound")
function GM:PlayerShouldTakeDamage( ply, attacker )
  if !attacker:IsPlayer() then return true end

	-- hitsound

	if attacker:IsPlayer() && attacker:Team()!=ply:Team() then
		-- send a hitsound command to mr. playa
		net.Start("hitsound")
			--net.WriteInt(dmginfo:GetDamage(),12)
		net.Send(attacker)
	end

  return ((ply:Team()!=attacker:Team() || ply==attacker) && CurTime()>ply:GetNWInt("uber") ) || humuliate-- If they are different teams (or they damage themselves) AND the player doesnt have respawn invunrability   but always damage if round is over
end


// round sytem
function endRound()
	game = false
	setup = true
	time=0
	humiliate = true
end

function initRound()
	time = setuptime -- setup time
     setup = true
     game = true
     humiliate = false
	victor = -1

     team.SetScore(1,0)
     team.SetScore(2,0)
     team.SetScore(3,0)
     team.SetScore(4,0)

	RunConsoleCommand("gmod_admin_cleanup")

     for i,ply in pairs(ents.FindByClass("player")) do
     	if ply:Team()!=5 then ply:Spawn() ply:Freeze(true) end
     end
end

function roundSetTime(int)
	time=int // only should run with lua_run for debuggingsment
end

function startRound()
     time =roundtime -- round length
     setup = false
     game = true

     for i,ply in pairs(ents.FindByClass("player")) do
          ply:Freeze(false)
			net.Start("music")
				net.WriteString(GetConVar("wb_musicurl"):GetString())
				net.WriteString(GetConVar("wb_musiccredit"):GetString())
			net.Send(ply)
     end
end

util.AddNetworkString("roundrefresh")
function broadcastRound()
     net.Start("roundrefresh")
        	net.WriteInt(time,32)
        	net.WriteBool(setup)
   		net.WriteBool(fourway)
	   	net.WriteInt(GetConVar("wb_gamemode"):GetInt(),4)
		net.WriteInt(victor,4)
	net.Broadcast()
end

util.AddNetworkString("roundwinner")
function roundSystem()
	broadcastRound() -- keep clients up to date
	if ( ( (team.NumPlayers(1)+team.NumPlayers(2)) < 2 && !fourway ) || ( (team.NumPlayers(1)+team.NumPlayers(2)+team.NumPlayers(3)+team.NumPlayers(4)) < 3 && fourway ) ) then
     	endRound()
     	time=0
	     humiliate = false
	     for i,ply in pairs(ents.FindByClass("player")) do
	          ply:Freeze(false)
	     end
	     return
 	end -- end round

	if (game) then
	     if (setup) then -- SETUP TOM?
	     	time=time-1
	          for i,ply in pairs(ents.FindByClass("player")) do
	             if ply:Team()!=5 then ply:Freeze(true) end
	          end

	          if (time <= 0) then
	             startRound()
	          end
	     else -- regulars
			time=time-1
	          if (time <= 0) then
	          	local winner = 0
	          if !fourway then --2way
	               if (team.GetScore(1)>team.GetScore(2)) then winner = 1
	          	elseif (team.GetScore(2)>team.GetScore(1)) then winner = 2 end
	          else --4way
	               if (team.GetScore(1)>team.GetScore(2)&&team.GetScore(1)>team.GetScore(3)&&team.GetScore(1)>team.GetScore(4)) then winner = 1
		               elseif (team.GetScore(2)>team.GetScore(1)&&team.GetScore(2)>team.GetScore(3)&&team.GetScore(2)>team.GetScore(4)) then winner = 2
		               elseif (team.GetScore(3)>team.GetScore(1)&&team.GetScore(3)>team.GetScore(2)&&team.GetScore(3)>team.GetScore(4)) then winner = 3
		               elseif (team.GetScore(4)>team.GetScore(1)&&team.GetScore(4)>team.GetScore(2)&&team.GetScore(4)>team.GetScore(3)) then winner = 4
	               end
	          end
			victor = winner
			if winner == 0 then victor = 5 end
	          if winner != 0 then PrintMessage( HUD_PRINTCENTER, teamdata[winner].name.." WINS!" )
	          else PrintMessage( HUD_PRINTCENTER, "STALEMATE FUCK YOU ALL!" ) for i,ply in pairs( ents.FindByClass("player") ) do if ply:Team()!=5 then ply:SetHealth(25) ply:Ignite(999) end end end
			broadcastRound()
	          endRound()
	          for i,ply in pairs( ents.FindByClass("player") ) do
	          	if ply:Team()!=winner && ply:Team()!=5 then ply:StripWeapons() end
	          end
	          if victor != 5 then timer.Simple(30,initRound) else timer.Simple(10,initRound) end -- humilate time, 30 if players win, 10 if stalemate
		end
	end

	elseif (!humiliate) then
		initRound()
	end

  	broadcastRound() -- zis is ze time, clients!
end
timer.Create("roundsys",1,0,roundSystem) // put that bloody massive timer into a function

-- Make F1 open menu for clients
function GM:ShowHelp(ply)
     ply:ConCommand("chooseteam")
end

function GM:ShowTeam(ply)
     ply:ConCommand("chooseclass")
end

-- Handle team requests
util.AddNetworkString("requestteam")
net.Receive( "requestteam", function( len, ply )
	local request = net.ReadInt(4)

  // debug
  if GetConVar("wb_debug"):GetInt() == 1 then ply:SetTeam(request) ply:Kill() return true end

  if request == ply:Team() || humiliate then return end

  if request == 5 then -- spectate
		ply:SetTeam(5)
		ply:KillSilent()
     ply:Spawn()
     return
  end

	if ply:CanJoin(request) then ply:SetTeam(request) PrintMessage(HUD_PRINTTALK,ply:Nick().." joined "..team.GetName(ply:Team())) ply:Kill() return end
	// if we are here, we cant change team
	ply:PrintMessage(HUD_PRINTCENTER,"You can't join that team!")
	ply:PrintMessage(HUD_PRINTTALK,"You can't join that team!")
	ply:ConCommand("chooseteam")
end )

-- Handle class requests
util.AddNetworkString("requestClass")
net.Receive( "requestClass", function( len, ply )
	if ply:Team()==5 then return end
	local request = net.ReadInt(10)
	if request==8 && !table.HasValue(specialpeople,ply:SteamID()) then
		ply:PrintMessage(HUD_PRINTTALK,"You are not the CEO!")
		return false
	end
	ply:SetNWInt("class",request)
	if ply:Alive() then ply:Kill() end
	ply:PrintMessage(HUD_PRINTTALK,"Changing class to "..classdata[ply:GetNWInt("class",1)].name)

	-- if they are near a spawnpoint, respawn them
	local nearents = ents.FindInSphere(ply:GetPos(),200)
	local nearclasses = {}

	for k,v in pairs(nearents) do
		nearclasses[k]=v:GetClass() -- convert near ents into their classses
	end

	if table.HasValue(nearclasses,team.GetSpawnPoint(ply:Team())[1]) then ply:Spawn() end -- is there an ent with the teams spawnpoint class?
end)

function GM:CanPlayerSuicide( ply )
  return ply:Team()!=5 && (!setup) && !humiliate && GetConVar("wb_gamemode"):GetInt()!=0 && GetConVar("wb_gamemode"):GetInt() !=1
end

function GM:PlayerFootstep( ply )
	return ply:GetNWInt("class")==2 // if agent, do not play footsteps
end

function GM:GetFallDamage( ply, speed )
	return 0 -- no fall damage
end

function GM:PlayerSpray(ply)
	local Timestamp = os.time()
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
	print( "(War Business) ".. ply:Nick() .. " sprayed @"..TimeString )
	return false
end
