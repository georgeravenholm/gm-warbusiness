AddCSLuaFile()

// Notifications
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

// Killfeed
local killfeed = killfeed or {}
killfeed = vgui.Create("DPanel")
killfeed:SetPos(ScrW()-700,0)
killfeed:SetSize( 700,300 )
killfeed.Paint = function() end

local kflist = vgui.Create("DListLayout",killfeed)
kflist:Dock(FILL)

net.Receive("killfeed", function()
	-- killfeede
	// Get string and colour data ito vars
	local dead = net.ReadString()
	local deadCol = net.ReadColor()
	local weapon = net.ReadString() // weapon class
	local killer = net.ReadString()
	local killerCol = net.ReadColor()

	local p = vgui.Create("DPanel",DListLayout)
	p:SetSize(killfeed:GetWide(),25)

	--suicide = false

	// Now put that info into the panel
	p.Paint = function(self,w,h)
		local col = Color(150,150,150,255)
		if killer==LocalPlayer():Nick() || killer == LocalPlayer():Nick() then col = Color(255,255,255,255) end
		draw.RoundedBox(8,0,0,w,h,col)
		draw.SimpleText(killer,"ChatFont",10,h/2,killerCol,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) // killer
		// adj'd
		if weponverbs[weapon] == nil then draw.SimpleText(weapon,"ChatFont",w/2,h/2,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) else draw.SimpleText(weponverbs[weapon],"ChatFont",w/2,h/2,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) end
		draw.SimpleText(dead,"ChatFont",w-10,h/2,deadCol,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER) // dead
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
