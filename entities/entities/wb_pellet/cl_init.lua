include('shared.lua')

function ENT:Draw()
	cam.Start3D() -- Start the 3D function so we can draw onto the screen.
  render.SetMaterial( Material("effects/energyball") )
	--render.SetMaterial( Material("models/debug/debugwhite") ) -- Tell render what material we want, in this case the flash from the gravgun
	render.SuppressEngineLighting( true )
	render.SetColorModulation(1,0.5,1)
	--print(render.GetColorModulation())
	render.SetBlend( 0.5 )
	--render.SetMaterial( Material("models/debug/debugwhite") )
	render.DrawSprite( self:GetPos(), 10, 10, white ) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
	cam.End3D()
	--self:DrawModel()
end
