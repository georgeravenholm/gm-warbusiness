-- Class
AddCSLuaFile()
function requestClass(class)
  net.Start( "requestClass" )
	 net.WriteInt(class,10)
	 --LocalPlayer():ChatPrint("Requesting class "..class)
  net.SendToServer()
	--LocalPlayer():SetNWInt("class",class)
end


--local lp = LocalPlayer()
function oldClassMenu()
	--gui.EnableScreenClicker(true)
	if LocalPlayer():Team() == 5 then return end -- spectators dont choose classes!
	local frame = {}
	frame = vgui.Create("DFrame")
  frame:SetBackgroundBlur(true)
  frame:SetSize(200,300)
  frame:Center()
  frame:SetTitle("Choose a class!")
  frame:SetDraggable(true)
  frame:MakePopup()

	local classList = vgui.Create("DListLayout",frame)
  classList:Dock(FILL)

	for k,v in ipairs(classdata) do
		local button = vgui.Create("DButton",classList)
		button:SetText(v.name)
	  button:SetToolTip( v.info )
	  button:SetSize(200,25)
		function button:DoClick() requestClass(k) frame:Close() end
	  classList:Add(button)
	end
end

function classMenu()
	if LocalPlayer():Team() == 5 then return end -- spectators dont choose classes!
	local frame = {}
	frame = vgui.Create("DFrame")
	frame:SetBackgroundBlur(true)
	frame:SetSize(800,400)
	frame:Center()
	frame:SetTitle("Choose a class!")
	frame:SetDraggable(true)
	frame:MakePopup()
	function frame:Paint(width,height)
		local colo = team.GetColor(LocalPlayer():Team())
		colo.a = 200
		draw.RoundedBox(0,0,0,width,height,colo)
	end

	local sheet = vgui.Create("DColumnSheet",frame)
	sheet:Dock(FILL)

	for index,class in ipairs(classdata) do
		if class.name=="CEO" then continue end // if ceo, move on
		local panel = vgui.Create("DPanel",sheet)
		panel:Dock(FILL)

		local infos = vgui.Create("DPanel",panel) // Draw info, eg title, health...
		infos:Dock(FILL)
		function infos:Paint(width,height)
			draw.SimpleText(class.name,"lilclip",0,-10,Color(0,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			draw.SimpleText(class.basic,"DermaDefault",0,50,Color(0,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			draw.SimpleText("Weapons: "..class.weapons,"DermaDefault",0,22*3,Color(0,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			draw.SimpleText("Tips: ","DermaDefault",0,22*4,Color(0,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			draw.SimpleText("* "..class.tip1,"DermaDefault",0,22*5,Color(0,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			draw.SimpleText("* "..class.tip2,"DermaDefault",0,22*6,Color(0,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

			draw.SimpleText("Stats: ","DermaDefault",0,200+22*0,Color(0,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			draw.SimpleText("* Health: "..class.health,"DermaDefault",0,200+22*1,Color(0,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			draw.SimpleText("* Speed: ".. math.Round(class.speed/classdata[1].speed*100) .. "% of a T1" ,"DermaDefault",0,200+22*2,Color(0,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		end

		// Add model panel with S U B  M I T  BU T TON
		local modelp = vgui.Create("DPanel",panel)
		modelp:SetSize(200,363)
		modelp:SetPos(467,0)

		local model = vgui.Create("DModelPanel",modelp)//Temp, change when each class has their own model
		model:Dock(FILL)
		model:SetModel( teamdata[LocalPlayer():Team()].model ) -- you can only change colors on playermodels

		local dance = model:GetEntity():LookupSequence( class.animation )
		model:GetEntity():SetSequence( dance )


		function model:LayoutEntity( Entity )
			self:SetCamPos( Vector( 300, 60, 50 ) )
			self:RunAnimation()
			self:SetFOV( 10 )
			--self:SetLookAng( Angle(10,180,0) )
		end -- disables default rotation
		function model.Entity:GetPlayerColor() return team.GetColor( LocalPlayer():Team() ) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.


		// Submit
		local changeclassbutton = vgui.Create("DButton",modelp)
		changeclassbutton:Dock(BOTTOM)
		changeclassbutton:SetText("Choose Class")
		changeclassbutton:SetEnabled(index!=LocalPlayer():GetNWInt("class"))
		function changeclassbutton:DoClick()
			requestClass(index)
			frame:Close()
		end



		// Get number of players with class in teams
		local classnum=0
		for k,ply in ipairs(team.GetPlayers(LocalPlayer():Team())) do
			if ply:GetNWInt("class")==index then classnum=classnum+1 end
		end
		sheet:AddSheet(class.name.."(x "..classnum..")",panel)
	end

	// CEO page is special.
	local class = classdata[8]
	local panel = vgui.Create("DPanel",sheet)
	panel:Dock(FILL)

	local infos = vgui.Create("DPanel",panel) // Draw info, eg title, health...
	infos:Dock(FILL)
	function infos:Paint(width,height)
		draw.SimpleText(class.name,"lilclip",0,-10,Color(0,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
		draw.SimpleText("!!! 3 STEP VERIFICATION REQUIRED !!!","sans",width/2,height/2-100,Color(255,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)


	end

	// Create 3 fake "verifcation panels"
	local vpans = {}
	for i=0,2,1 do
		local vpan = vgui.Create("DPanel",panel)
		vpan:SetSize(200,200)
		vpan:SetPos( 235*i ,150)
		vpan.Paint = function(self,width,height)
			draw.RoundedBox(0,0,0,width,height,Color(255,0,0))
		end
		vpans[i+1]=vpan
	end

	local vpan = vpans[1]
	local but = vgui.Create("DButton",vpan)
	but:Dock(BOTTOM)
	but:SetText("y=(x+5^2)(x-512)")
	vpan.Paint = function(self,width,height)
		draw.RoundedBox(0,0,0,width,height,Color(255,0,0))
		draw.SimpleText( "CIPHERTRON 1000.5", "ChatFont",width/2,height/2,Color(0,150,0,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER )
		for x=10,200,20 do
			for y=10,190,20 do
				draw.SimpleText( math.random(0,10), "ChatFont",x,y,Color(0,255,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER )
			end
		end
	end
	function but:DoClick()
		local randomify = math.random(0,10)

		if randomify == 10 then self:SetText("math.random(-999,999)") else self:SetText(math.random(-999,999)) end
	end

	local vpan = vpans[2]
	local but = vgui.Create("DButton",vpan)

	local texts =
	{
		"Please answer the following questions",
		"in 25 words or less:",
		"1. What is your pets name?",
		"2. Is the cake, really a lie?",
		"3. Is [NAME OF USER HERE] gay?",
		"4. Do you work for [ teamdata[LocalPlayer():Team].name ]?",
		"5. Is War Business Great?",
		"6. What is the password georgeravenholm uses for his servers?",
		"7. What actually is Garreys Mode?",
	}
	for y=0,160,20 do
		local text= vgui.Create("DTextEntry",vpan)
		text:SetText(texts[y/20+1])
		text:SetSize(200,20)
		text:SetPos(0,y)
	end

	but:Dock(BOTTOM)
	but:SetText("Submit")
	function but:DoClick()
		self:SetText("任何事情都会发生，甚至中国") // anything goes, even chinese
	end



	vpan.Paint = function(self,width,height)
		draw.RoundedBox(0,0,0,width,height,Color(255,0,0))
	end



	local vpan = vpans[3]
	local but = vgui.Create("DButton",vpan)
	but:Dock(BOTTOM)
	but:SetText("العقلية اضافية هو مثلي الجنس") // EXTRA MENTAL IS GAY
	function but:DoClick()
		if table.HasValue(specialpeople,LocalPlayer():SteamID()) then requestClass(8) frame:Close() end
	end
	vpan.Paint = function(self,width,height)
		draw.RoundedBox(0,0,0,width,height,Color(255,0,0))
		draw.SimpleText( "slidey.exe", "ChatFont",width/2,height/2,Color(0,150,0,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER )
	end

	local List	= vgui.Create( "DIconLayout", vpan )
	List:SetSize( 200, 180 )
	List:SetPos( 0, 0 )
	List:SetSpaceY( 0 ) //Sets the space in between the panels on the X Axis by 5
	List:SetSpaceX( 0 ) //Sets the space in between the panels on the Y Axis by 5

	local keypadLabels =
	{
		"0+1","sqrt(4)","9/3",
		"4+8-3*8/3","10-10+15","69-9",
		"windows","Octagon","NO",
		"OK","x^0-1","<",
	}
	for i = 1, 12 do //Make a loop to create a bunch of panels inside of the DIconLayout
		local ListItem = List:Add( "DButton" ) //Add DPanel to the DIconLayout
		ListItem:SetSize( 200/3, 45 ) //Set the size of it
		ListItem:SetText(keypadLabels[i])
		function ListItem:DoClick()
			self:SetEnabled(false)
		end
		//You don't need to set the position, that is done automatically.
	end

	sheet:AddSheet("CEO",panel)
end

concommand.Add("chooseclass",classMenu)
