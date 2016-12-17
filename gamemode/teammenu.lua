-- Team menu
AddCSLuaFile()
function requestTeam(teamid)
  net.Start( "requestTeam" )
	 net.WriteInt(teamid,4)
  net.SendToServer()
end


--local lp = LocalPlayer()

--/* rippy dippy you ugly peice of garbage
function oldTeamMenu()
	--gui.EnableScreenClicker(true)
	local frame = {}
	frame = vgui.Create("DFrame")
  frame:SetBackgroundBlur(true)
  frame:SetSize(200,300)
  frame:Center()
  frame:SetTitle("Choose a team!")
  frame:SetDraggable(true)
  frame:MakePopup()

  local joinSpectate = vgui.Create("DButton",frame)
  joinSpectate:SetText("Spectate")
  joinSpectate:Dock(BOTTOM)
  joinSpectate:SetToolTip("Perv on everyone.")
  joinSpectate:SetEnabled(true)
  function joinSpectate:DoClick() requestTeam(5) frame:Close() end

  local teamList = vgui.Create("DListLayout",frame)
  teamList:Dock(TOP)

  local joinHRT = vgui.Create("DButton",teamList)
  joinHRT:SetText("holmrekR tek ("..#team.GetPlayers(1)..")")
  joinHRT:SetToolTip(  )
  joinHRT:SetSize(200,50)
  function joinHRT:DoClick() requestTeam(1) frame:Close() end
  teamList:Add(joinHRT)

  local joinOOC = vgui.Create("DButton",teamList)
  joinOOC:SetText("Orangee Co. ("..#team.GetPlayers(2)..")")
  joinOOC:SetToolTip(  )
  joinOOC:SetSize(200,50)
  function joinOOC:DoClick() requestTeam(2) frame:Close() end

  local joinBBE = vgui.Create("DButton",teamList)
  joinBBE:SetText("Slaver Enterprises ("..#team.GetPlayers(3)..")")
  joinBBE:SetToolTip( "\"we use the best slaves for you\"\nwe work in selling the best mangos, cotton, suger, coco beans and coffee beans\nwe help prisoners learn life lessons such as how to make slaver enterprises seal of approval mangos\nmost of our workers are from prisons and 3rd world countries\nwe also steal grapes because its cheaper to send 5 children soldier to steal grapes then buying them\nyours trueley, rick fenado" )
  joinBBE:SetSize(200,50)
  joinBBE:SetEnabled(fourway)
  teamList:Add(joinBBE)
  function joinBBE:DoClick() requestTeam(3) frame:Close() end

  local joinABI = vgui.Create("DButton",teamList)
  joinABI:SetText("Abrika Industries ("..#team.GetPlayers(4)..")")
  joinABI:SetToolTip(  )
  joinABI:SetSize(200,50)
  joinABI:SetEnabled(fourway)
  teamList:Add(joinABI)
  function joinABI:DoClick() requestTeam(4) frame:Close() end
end

function teamMenu()
	local frame = {}
	frame = vgui.Create("DFrame")

  frame:SetSize(800,400)
  frame:Center()
  frame:SetTitle("Choose a team!")
  frame:SetDraggable(true)
	frame:SetBackgroundBlur(true)
  frame:MakePopup()
	function frame:Paint(self,width,height)
		local colo = team.GetColor(LocalPlayer():Team())
		colo.a = 200
		draw.RoundedBox(0,0,0,w,h,colo)
	end

	// Panels
	for i=1,5,1 do
		panel = vgui.Create("DPanel",frame)
		panel:SetSize(frame:GetWide()/5,frame:GetTall()-25)
		panel:SetPos(frame:GetWide()/5*i-frame:GetWide()/5,25)
		panel:SetEnabled(team.Joinable(i)||i==5)

		//images
		local img = vgui.Create("DImage",panel)
		img:Dock(FILL)
		img:SetImage( teamdata[i].image , "vgui/avatar_default" )

		// buttons
		button = vgui.Create("DButton",panel)
		button:SetText( i!=5 and "Join "..teamdata[i].name.."!\n("..team.NumPlayers(i)..")\n(hover for more info)" or "Spectate!\n("..team.NumPlayers(i)..")" )
		button:SetSize(panel:GetWide(),50)
		button:SetPos( 0, panel:GetTall()-button:GetTall() )
		button:SetToolTip(teamdata[i].tooltip)
		function button:DoClick() requestTeam(i) frame:Close() end
	end

end

concommand.Add("chooseteam",teamMenu)
