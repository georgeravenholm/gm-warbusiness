include('shared.lua')

function ENT:Draw()
		--print(self:GetNWEntity("carrier"))
    --if self:GetNetworkedEntity("Carrier")==LocalPlayer() && !LocalPlayer():ShouldDrawLocalPlayer() then return false end
		if LocalPlayer():GetNWEntity("carrying",Entity(0)) == self then return false end -- if player is holding flag, dont draw
		self:DrawModel() -- Draws Model Client Side
end
