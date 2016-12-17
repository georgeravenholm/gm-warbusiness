AddCSLuaFile()
-- scoreboard
surface.CreateFont( "TNR", {
font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
extended = false,
size = 50
} )

surface.CreateFont( "Spectators", {
font = "Agency FB", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
extended = false,
size = 20
} )
local scoreboard = {}

------------------------------------------------------------------------------------------

// The lack of functions in this is absolutely disgusting.
function scoreboardSpacer(list)
	local panel = vgui.Create("DPanel",list)
	panel:SetSize(750,20)
	panel.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(200,200,200,240))
	end
	list:Add(panel)
end

function scoreboardTeam(list,t)
	local panel = vgui.Create("DPanel",list)
	panel:SetSize(750,20)
	panel.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,team.GetColor(t))
		draw.SimpleText(teamdata[t].name,"ChatFont",0,h/2,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end

	list:Add(panel)
	for i, ply in pairs( team.GetPlayers(t) ) do
		if ply:IsValid() then
			 local panel = vgui.Create("DPanel",list)
			 panel:SetSize(750,20)
			 panel.Paint = function(self,w,h)
				 draw.RoundedBox(0,0,0,w,h,team.GetColor(ply:Team()))
				 local white=Color(255,255,255,255)
				 if table.HasValue(specialpeople,ply:SteamID()) then -- me! :D
					local time = CurTime()*3 // this is just so we don't invoke 3 times
					local r = math.abs(math.sin(time * 2) * 255);
					local g = math.abs(math.sin(time * 2 + 2) * 255);
					local b = math.abs(math.sin(time * 2 + 4) * 255);
					white=Color(r,g,b)
				 end
				 draw.SimpleText(ply:GetName(),"ChatFont",0,h/2,(ply:Alive() and white or Color(200,50,50)),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				 draw.SimpleText(( ((ply:Team() == LocalPlayer():Team())||(table.HasValue(specialpeople,LocalPlayer():SteamID()))) and classdata[ply:GetNWInt("class",1)].name or "?" ).."   >"..ply:GetNWInt("killstreak")..">  "..ply:GetNWInt("points").."pts   "..ply:Ping().."ms","ChatFont",w-65,h/2,Color(255,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			 end

			 -- mute button
			 panel.player = ply
			 panel.mute = vgui.Create("DButton",panel)
			 panel.mute:SetSize(60,20)
			 panel.mute:SetPos(690,0)
			 panel.mute:SetText( (  panel.player:IsMuted() and "Unmute" or "Mute" ) )
			 --panel.mute:SetColor( (  panel.player:IsMuted() and Color(255,0,0,255) or Color(0,255,0,255) ) )
			 panel.mute.DoClick = function()
				 panel.player:SetMuted(!panel.player:IsMuted())
				 panel.mute:SetText( (  panel.player:IsMuted() and "Unmute" or "Mute" ) )
				 --panel.mute:SetColor( (  panel.player:IsMuted() and Color(255,0,0,255) or Color(0,255,0,255) ) )
			 end

			 list:Add(panel)
		 end
	end

end

function GM:ScoreboardShow()
    gui.EnableScreenClicker(true)
    scoreboard = vgui.Create("DFrame")
    scoreboard:SetDeleteOnClose( true )
    scoreboard:SetTitle("")
    scoreboard:ShowCloseButton(false)
    scoreboard:SetDraggable(false)
    scoreboard:SetBackgroundBlur(true)
    scoreboard:SetSize(750,750)
    scoreboard:SetPos( ScrW()/2-375, 50 )
    scoreboard.Paint = function(self,w,h)

      draw.RoundedBox(0,0,0,w,h,Color(200,200,200,240))

      -- title



      draw.SimpleText("War Business","TNR",w/2,50,Color(0,0,0,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
      draw.SimpleText("by georgeravenholm","Trebuchet24",w/2,75,Color(15,15,15,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

      draw.SimpleText("\""..GetHostName().."\"","Trebuchet24",w/2,125,Color(15,15,15,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
      draw.SimpleText(game.GetMap(),"Trebuchet24",w/2,150,Color(15,15,15,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

      -- ping notice
      draw.SimpleText("Note: Ping should only be used as an estimate","Default",w/2,h-10,Color(50,50,50,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

			-- speccers
			local fags = {"none"}
			for i, spectator in ipairs(team.GetPlayers(5)) do
				fags[i]=spectator:Nick()
			end
			draw.SimpleText("Spectators: "..table.concat(fags,", "),"Spectators",4,200,team.GetColor(5),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end

    -- Create the DList
		local scroll=vgui.Create( "DScrollPanel", scoreboard ) //Create the Scroll panel
		scroll:SetSize( 750, 500 )
		scroll:SetPos( 0,250 )

    local list = vgui.Create( "DListLayout", scroll )
    --list:SetSize(750,500)
    --list:SetPos(0,250)
		list:Dock(FILL)
		list:SetVerticalScrollbarEnabled( true )
    --list:SetPaintBackground( true )
    --list:SetBackgroundColor( Color( 10, 10, 10,255 ) )

		scoreboardTeam(list,1)

		scoreboardSpacer(list)

    scoreboardTeam(list,2)

		if !fourway then return end

		scoreboardSpacer(list)

    scoreboardTeam(list,3)
		scoreboardSpacer(list)
		scoreboardTeam(list,4)


end

function GM:ScoreboardHide()
    scoreboard:Remove()
    gui.EnableScreenClicker(false)
end
