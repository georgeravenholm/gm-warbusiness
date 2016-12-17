AddCSLuaFile()
-- HUD
surface.CreateFont( "bigclip", {
  font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
  extended = false,
  size = 100,
  weight = 500,
  antialias=true,
})
surface.CreateFont( "lilclip", {
  font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
  extended = false,
  size = 60,
  weight = 500,
  antialias=true,
})

surface.CreateFont( "sans", {
  font = "Comic Sans MS", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
  extended = false,
  size = 40,
  weight = 500,
  antialias=true,
})


local hide = {
	CHudHealth = true,
	CHudBattery = true,
  CHudAmmo = true,
  CHudZoom = true,
  CHudPoisonDamageIndicator = true,
  CHudSecondaryAmmo = true,
  CHudSquadStatus = true,
}

net.Receive("youwerekilled",function()
  local attacker = net.ReadEntity()
  local panel = vgui.Create("DPanel")
  panel:SetSize(300,100)
  --panel:SetAlpha(150)
  panel:Dock(TOP)

  panel.Paint = function(self,w,h)
    draw.RoundedBox(0,0,0,w,h,Color(150,150,150,150))
    draw.SimpleText("You were killed by:","DermaLarge",w/2,h/2-20,Color(50,50,50),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    draw.SimpleText(attacker:Nick(),"DermaLarge",w/2,h/2+20,team.GetColor(attacker:Team()),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    draw.SimpleText("("..teamdata[attacker:Team()].name..")","DermaDefault",w/2,h/2+40,team.GetColor(attacker:Team()),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
  end

  timer.Simple(3.5,function() panel:Remove() end)
end)

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end

	-- Don't return anything here, it may break other addons that rely on this hook.
end )

// That is it! its time to put this clusterfuck into functions
function drawVictor()
	if victor != -1 then
		local won = "Victory!"
		if victor != LocalPlayer():Team() then won = "Failure!" end
		if victor == 5 then won = "Stalemate?!" end
		draw.RoundedBoxEx(8, w/2-200,h-200,400,100,team.GetColor(victor),true,true,false,false)
		draw.SimpleText(won,"lilclip",w/2,h-200,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(teamdata[victor].name,"DermaLarge",w/2,h-160,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText("has winned!","DermaDefault",w/2,h-145,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end

function drawCarrying()
	if LocalPlayer():GetNWInt("carrying",Entity(1)):IsValid() && LocalPlayer():GetNWInt("carrying",Entity(1)):GetClass()=="wb_flag" then -- have flag
		local time = CurTime()*10 // this is just so we don't invoke 3 times
		local r = math.abs(math.sin(time * 2) * 255);
		local g = math.abs(math.sin(time * 2 + 2) * 255);
		local b = math.abs(math.sin(time * 2 + 4) * 255);
		draw.SimpleText("YOU HAVE THE FLAG","sans",w/2,h/2,Color(r,g,b,240),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

		// Show where to bring the flag
		local flagcap = Entity(0)
		for k,v in ipairs(ents.FindByClass("wb_trig_flagcap")) do
			print(v)
			if v:GetNWInt("team")==LocalPlayer():Team() then flagcap=v return end
		end
		if !IsValid(flagcap) then return end
		local pos = flagcap:GetPos():ToScreen()
		draw.SimpleText("Bring the flag here!","sans",pos.x,pos.y,teamCol,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end

heighpee=150
helpth = 1
function drawHealth()
	local healthFraction = math.Clamp(((LocalPlayer():GetMaxHealth()-LocalPlayer():Health())/LocalPlayer():GetMaxHealth()),0,1)
	heighpee = Lerp(5 * FrameTime(), heighpee, healthFraction)
	helpth = Lerp(10 * FrameTime(), helpth, LocalPlayer():Health())
	local healthCol = Color(150,150,150)
	if LocalPlayer():Health()/LocalPlayer():GetMaxHealth() <= 0.40 then healthCol=Color(255,50,50) end

	draw.RoundedBox(0,200,h-300,200,200,teamCol)
	draw.RoundedBox(0,212.5,h-300+12.5,175,175,healthCol)
	draw.RoundedBox(0,212.5,h-300+12.5,175,175*heighpee,Color(255,255,255))

	-- make it a plus
	draw.RoundedBox(0,212.5,h-300+12.5,60,60,teamCol)
	draw.RoundedBox(0,212.5+115,h-300+12.5,60,60,teamCol)

	draw.RoundedBox(0,212.5,h-300+12.5+115,60,60,teamCol)
	draw.RoundedBox(0,212.5+115,h-300+12.5+115,60,60,teamCol)
	if LocalPlayer():Alive() then hp=math.Clamp(math.Round(helpth),0,999) else hp = "ded" end
	draw.SimpleText(hp,"sans",300,h-200,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

	-- streak
	draw.SimpleText(">"..LocalPlayer():GetNWInt("killstreak")..">","ChatFont",362.5,h-262.5,Color(0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function drawTimer()
	local timestr = string.ToMinutesSeconds(time)
	--local timestr = time
	-- GAME TIME --
	if LocalPlayer():Alive() then
		if setup && time > 0 then
			draw.RoundedBox(4,w/2-100/2,50,100,75,Color(175,175,175,200))
			draw.SimpleText("Setup","ChatFont",w/2,110,Color(50,50,50,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		local timecol = Color(255,255,255,255)
		if time <= 10 then timecol = Color(255,0,0) end
		draw.RoundedBox(4,w/2-125/2,50,125,50,teamCol)
		draw.SimpleText(timestr,"sans",w/2,75,timecol,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end

function drawGamemodeScores()
	-- gamemode specific huds
	local gm = gamemode
	if gm == 0 || gm==2 then -- 2way dm/2ctf!
		draw.RoundedBox(4,w/2-250,h-100,500,110,Color(150,150,150))
		draw.RoundedBoxEx(4,w/2-240,h-87.5,240,75,team.GetColor(1),true,false,true,false)
		draw.RoundedBoxEx(4,w/2,h-87.5,240,75,team.GetColor(2),false,true,false,true)

		draw.SimpleText(team.GetScore(1),"sans",w/2-100,h-50,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(team.GetScore(2),"sans",w/2+100,h-50,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	elseif gm == 1 || gm==3 then -- 2way dm/2ctf!
		draw.RoundedBox(4,w/2-250,h-100,500,110,Color(150,150,150))
		draw.RoundedBoxEx(4,w/2-240,h-87.5,120,75,team.GetColor(1),true,false,true,false)
		draw.RoundedBoxEx(4,w/2-120,h-87.5,120,75,team.GetColor(2),false,false,false,false)
		draw.RoundedBoxEx(4,w/2,h-87.5,120,75,team.GetColor(3),false,false,false,false)
		draw.RoundedBoxEx(4,w/2+120,h-87.5,120,75,team.GetColor(4),false,true,false,true)

		draw.SimpleText(team.GetScore(1),"sans",w/2-180,h-50,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(team.GetScore(2),"sans",w/2-60,h-50,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(team.GetScore(3),"sans",w/2+60,h-50,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText(team.GetScore(4),"sans",w/2+180,h-50,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end

function drawAmmo()
		-- draw ammo
		if LocalPlayer():GetActiveWeapon():IsValid() then
			if LocalPlayer():GetActiveWeapon():GetMaxClip1() <= 0 then return end
			local total=math.Clamp( LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()),0,999 )
			local clip=math.Clamp(LocalPlayer():GetActiveWeapon():Clip1(),0,999)

			-- box

			draw.RoundedBox(8,w-400,h-175, 200,75,teamCol )
			draw.SimpleText(tostring(clip),"bigclip",w-400,h-210,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			draw.SimpleText(tostring(total),"lilclip",w-210,h-180,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
			--draw.SimpleText(tostring(clip).." | "..tostring(total),"DermaLarge",ScrW()/2,ScrH()-100+healthSine+150,Color(200,200,200,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER )
		end
end

function drawPlayerInfo()
	local aim = LocalPlayer():GetEyeTrace().Entity
	if ( aim:IsPlayer() && (aim:Team()==LocalPlayer():Team() || LocalPlayer():Team()==5 || (LocalPlayer():GetNWInt("class",1)==2 &&!aim:GetNWBool("invis")) || LocalPlayer():GetNWInt("class",1)==8) ) then
		-- Aim name tags XD lol
		draw.RoundedBox(8,w/2-150,h/2-25+100,300,50,team.GetColor(aim:Team()))
		draw.RoundedBox(8,w/2-145,h/2-20+100,290,40,Color(255,255,255))
		draw.SimpleText(tostring(aim:Health()).."/"..tostring(aim:GetMaxHealth()).." | "..aim:Name(),"ChatFont",w/2-120,h/2+100,team.GetColor(aim:Team()),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
end

hook.Add("HUDPaint","HUDIdent",function()
  teamCol = team.GetColor(LocalPlayer():Team())

	if (LocalPlayer():IsValid()) then
    w = ScrW()
    h = ScrH()
    if LocalPlayer():Team()!=5 then

			drawVictor()
			drawCarrying()
			drawHealth()


    end

		drawTimer() // if alive

    drawGamemodeScores()


    drawPlayerInfo()

    drawAmmo()
	end
end)
