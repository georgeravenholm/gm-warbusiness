include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
function ENT:Initialize()

	self:SetModel( "models/props_junk/garbage_metalcan002a.mdl" )
	--self:SetMaterial("models/alyx/emptool_glow")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	--self:SetCollisionGroup( COLLISION_GROUP_WEAPON ) -- dont collide with players

  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then

		phys:EnableGravity(false)
		phys:SetMass(10)

		phys:Wake()
		phys:ApplyForceCenter( self:GetCreator():GetAimVector()*8000 + VectorRand()*50 )
	end
	self:SetColor(ColorRand())

	self.Created = CurTime()+5
	self:SetTrigger( true )


end

function ENT:Think()
	if CurTime() > self.Created || !self:GetCreator():Alive() then self:Remove() end
	// IF hit world, then d e d
	local min,max = self:GetCollisionBounds()
	local tr =
	{
		mins=min*5,
		maxs=max*5,
		mask=MASK_SOLID_BRUSHONLY,
		--filter={self}
		start=self:GetPos(),
	endpos= self:GetPos(),


	}
	local result = util.TraceHull(tr)
	if result.HitWorld then self:Remove() end
end


function ENT:StartTouch(ent)
	if IsValid(ent) && ent!=self:GetCreator() && ent:IsPlayer() then
		if ent:Team()==self:GetCreator():Team() then constraint.NoCollide( ent, self, 0,0 ) return end
		-- deal damage then die
		/*BroadcastLua([[local vPoint = Vector(]]..ent:GetPos().x..","..ent:GetPos().x..","..ent:GetPos().z..[[)
local effectdata = EffectData()
effectdata:SetOrigin( vPoint )
util.Effect( "HelicopterMegaBomb", effectdata )]])*/

		local d = DamageInfo()
		d:SetDamage(self.Damage)
		d:SetDamageBonus(0)
		d:SetAttacker(self:GetCreator()) // IMPORTANT REMEBER this
		d:SetInflictor(self)
		d:SetDamageType(DMG_DISSOLVE)

		ent:TakeDamageInfo(d)


	end
	if ent!=self:GetCreator() then self:Remove() end
end
