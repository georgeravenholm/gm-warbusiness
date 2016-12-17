AddCSLuaFile()
net.Receive("elimination",function()
	local text = net.ReadString()
	local function inQuad( fraction, beginning, change )
		return change * ( fraction ^ 2 ) + beginning
	end

	local main = vgui.Create( "DFrame" )
	main:ShowCloseButton(false)
	main:SetTitle("")
	main:SetSize( 1000, 100 )
	main.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,0,0,Color(0,0,0,0))
		local time = CurTime()*3 // this is just so we don't invoke 3 times
		local r = math.abs(math.sin(time * 2) * 255);
		local g = math.abs(math.sin(time * 2 + 2) * 255);
		local b = math.abs(math.sin(time * 2 + 4) * 255);
		draw.SimpleText(text,"DermaLarge",w/2,h/2,Color(r,g,b,240),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	main:SetPos( ScrW()/2-500,ScrH()-200 )
	main:ColorTo(Color(0,0,0,0),3,1)
	main:MoveTo( ScrW()/2-500,ScrH()-400,3,0.5,1, function() main:Close() end )

end)

local killfeed = {}
killfeed = vgui.Create("DPanel")
killfeed:SetPos(ScrW()-700,0)
killfeed:SetSize( 700,300 )
killfeed.Paint = function() end

local kflist = vgui.Create("DListLayout",killfeed)
kflist:Dock(FILL)

net.Receive("killfeed", function()
	-- killfeede
	local killed = net.ReadEntity()
	local weapon = net.ReadString()
	local attacker = net.ReadEntity()
	--local suicide = net.ReadBool()

	local p = vgui.Create("DPanel",DListLayout)
	p:SetSize(killfeed:GetWide(),25)

	--suicide = false

local weponverbs =
{
	["weapon_357"]="high noon'd",
	["weapon_crowbar"]="struck down",
	["weapon_pistol"]="shot",
	["weapon_smg1"]="gunned down",
	["weapon_ar2"]="shot down",
	["weapon_frag"]="exploded",
	["weapon_agent_backstab"]="backstabbed",
	["weapon_crossbow"]="sniped",
	["weapon_sharp_rifle"]="sniped",
	["weapon_doc_heal"]="slapped",
	["weapon_shotgun"]="buck'd up",
	["weapon_teirtwo_shotgun"]="buck'd up",
}

	if killed!=attacker && attacker:IsPlayer() then
		p.Paint = function(self,w,h)
			local col = Color(150,150,150,255)
			if attacker==LocalPlayer() || killed == LocalPlayer() then col = Color(255,255,255,255) end
			draw.RoundedBox(8,0,0,w,h,col)
			draw.SimpleText(attacker:Nick(),"ChatFont",10,h/2,team.GetColor(attacker:Team()),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			if weponverbs[weapon] == nil then draw.SimpleText(weapon,"ChatFont",w/2,h/2,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) else draw.SimpleText(weponverbs[weapon],"ChatFont",w/2,h/2,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) end
			draw.SimpleText(killed:Nick(),"ChatFont",w-10,h/2,team.GetColor(killed:Team()),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		end
	else
		p.Paint = function(self,w,h)
			local col = Color(150,150,150,255)
			if attacker==LocalPlayer() || killed == LocalPlayer() then col = Color(255,255,255,255) end
			draw.RoundedBox(8,0,0,w,h,col)
			draw.RoundedBox(8,0,0,w,h,Color(200,200,200,255))
			if !IsValid(killed) then return end
			draw.SimpleText(killed:Nick(),"ChatFont",10,h/2,team.GetColor(killed:Team()),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText("killed","ChatFont",w/2,h/2,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText("Themself!","ChatFont",w-10,h/2,team.GetColor(killed:Team()),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		end
	end

	kflist:Add(p)
	--timer.Simple(5,function() p:Remove() end	)

	local s = vgui.Create("DPanel",DListLayout) -- spacer
	s:SetSize(killfeed:GetWide(),10)
	s.Paint = function(self,w,h)
	end
	kflist:Add(s)
	timer.Simple(8,function() p:Remove() s:Remove() end	)
end)

local hitsounds =
{
	[1] =
	{
		"hitsound/hrt/1/1.mp3",
		"hitsound/hrt/1/2.mp3",
		"hitsound/hrt/1/3.mp3",
		--"sound/hitsoubnd/hrt/1/4.mp3",

		"hitsound/hrt/2/1.mp3",
		"hitsound/hrt/2/2.mp3",
		"hitsound/hrt/2/3.mp3",
		--"sound/hitsoubnd/hrt/2/4.mp3",
	},
	[2] =
	{
		"hitsound/oec/1/1.mp3",
		"hitsound/oec/1/2.mp3",
		"hitsound/oec/1/3.mp3",
		--"sound/hitsoubnd/oec/1/4.mp3",

		"hitsound/oec/2/1.mp3",
		"hitsound/oec/2/2.mp3",
		"hitsound/oec/2/3.mp3",
		--"sound/hitsoubnd/oec/2/4.mp3",
	},

	[3] =
	{
		"hitsound/hrt/1/1.mp3",
		"hitsound/hrt/1/2.mp3",
		"hitsound/hrt/1/3.mp3",
		--"sound/hitsoubnd/hrt/1/4.mp3",

		"hitsound/hrt/2/1.mp3",
		"hitsound/hrt/2/2.mp3",
		"hitsound/hrt/2/3.mp3",
		--"sound/hitsoubnd/hrt/2/4.mp3",
	},
	[4] =
	{
		"hitsound/oec/1/1.mp3",
		"hitsound/oec/1/2.mp3",
		"hitsound/oec/1/3.mp3",
		--"sound/hitsoubnd/oec/1/4.mp3",

		"hitsound/oec/2/1.mp3",
		"hitsound/oec/2/2.mp3",
		"hitsound/oec/2/3.mp3",
		--"sound/hitsoubnd/oec/2/4.mp3",
	},
}

local curhitsound=1
CreateClientConVar( "wb_hitsoundrate", "1", true, false, "How long the cooldown is before another hitsound can play." )
--local hitsoundrate = 0.5
local canhitsound=true
-- hitsound zone
net.Receive("hitsound",function()
	if !canhitsound then return end
	--print("hitsound!")
	LocalPlayer():EmitSound( hitsounds[LocalPlayer():Team()][curhitsound],511,100,1,CHAN_AUTO ) -- chan_voice2 for announcers
	curhitsound = curhitsound+1
	if curhitsound > 6 then curhitsound = 1 end
	canhitsound=false -- we cant hitsound
	timer.Simple(GetConVar("wb_hitsoundrate"):GetFloat(),function() canhitsound=true end)--until 0.5secs
end)
