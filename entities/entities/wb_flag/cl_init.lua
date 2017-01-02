include('shared.lua')

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end


function ENT:Draw()
		--print(self:GetNWEntity("carrier"))
    --if self:GetNetworkedEntity("Carrier")==LocalPlayer() && !LocalPlayer():ShouldDrawLocalPlayer() then return false end
		if LocalPlayer():GetNWEntity("carrying",Entity(0)) == self then return false end -- if player is holding flag, dont draw
		self:DrawModel() -- Draws Model Client Side

		// timer 2d3d
		local yaw = (LocalPlayer():GetPos()-self:GetPos()):Angle().y
		local timeTill = self:GetNWInt("returntime")
		if timeTill == 0 then return end // dont draw timer if not dropped
		cam.Start3D2D( self:LocalToWorld(Vector(-5,0,70)),Angle(90,yaw,0)+Angle(270,90,90), 1 )

			surface.SetDrawColor( self:GetColor() )
			//surface.DrawRect( -15, -15, 30, 30 )
			draw.Circle(0,0,15,32)

			surface.SetDrawColor( Color((timeTill/self.returntime)*255,(timeTill/self.returntime)*255,(timeTill/self.returntime)*255) )
			draw.Circle(0,0, (timeTill/self.returntime)*15 ,32)

			draw.DrawText(math.Round(timeTill).."s","DebugFixed",0,-7.5,Color( 5, 5, 0, 255 ),TEXT_ALIGN_CENTER)
			//draw.SimpleText("Helllo","DermaDefault",0,0,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		cam.End3D2D()
end

function ENT:DrawTranslucent()
	self:Draw()
end
