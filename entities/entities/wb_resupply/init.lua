include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:KeyValue(key,value)
    if key == "team" then self.team=tonumber(value) return false end
end

function ENT:Initialize()

	self:SetModel( "models/props_interiors/VendingMachineSoda01a.mdl" )
	--self:SetMaterial("models/alyx/emptool_glow")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	--self:SetCollisionGroup( COLLISION_GROUP_WEAPON ) -- dont collide with players
	self.team = self.team or 1 // default to holmrekR tek
	self:SetColor(team.GetColor(self.team))


	self:SetUseType(SIMPLE_USE)

end

local plmeta = FindMetaTable("Player")
function plmeta:Resupply()
	class = classdata[self:GetNWInt("class")]

	// Set hp, do if because of overheal
	if self:Health() < self:GetMaxHealth() then self:SetHealth(self:GetMaxHealth()) end

	// Amo
	for k,v in ipairs(class.ammo) do
		self:SetAmmo(v.amount,v.type)
	end
end

function ENT:Use(ply)
	if ply:Team() == self.team then
		// Resupply
		self:EmitSound("buttons/weapon_confirm.wav")
		ply:Resupply()
	else
		// Make denial sounds
		self:EmitSound("buttons/weapon_cant_buy.wav")
	end
end
