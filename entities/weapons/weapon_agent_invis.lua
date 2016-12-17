AddCSLuaFile()

SWEP.Author = "georgeravenholm"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Invisinator"
SWEP.Instructions = "Left-Click: Become invisible for 10 seconds.\nRight-Click: Force Uncloak"
SWEP.ViewModel = "models/weapons/v_bugbait.mdl"
SWEP.WorldModel = "models/weapons/w_bugbait.mdl"
SWEP.UseHands = false
SWEP.Weight = 1
SWEP.AutoSwitchTo=false
SWEP.AutoSwitchFrom=false
SWEP.Slot=0
SWEP.SlotPos=1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair=false
SWEP.Spawnable=true
SWEP.AdminSpawnable=true
--SWEP.SetHoldType = "melee"

SWEP.Primary.ClipSize=-1
SWEP.Primary.DefaultClip=-1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize=-1
SWEP.Secondary.DefaultClip=-1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.AboutUnInvis=false

local GoInvis = Sound("buttons/combine_button5.wav")
local UnInvis = Sound("weapons/stunstick/alyx_stunner2.wav")
local Recharged = Sound("buttons/button24.wav")
local NotReady = Sound("buttons/combine_button_locked.wav")
local Invis = false

function SWEP:Initialize()
	self:SetHoldType("melee")
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_IDLE)
	self.Owner:SetNWBool("AboutUnInvis",false)
end

function SWEP:PrimaryAttack()
	if CLIENT then return end -- fuck off client

	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	local ply = self:GetOwner()
	ply:SetAnimation(PLAYER_ATTACK1)

	-- Block invis if we have the flag
	if ply:GetNWInt("carrying",Entity(0))!=Entity(0) then
		ply:EmitSound(NotReady)
		self:SetNextPrimaryFire( CurTime() + 1 )
		timer.Simple(0.1,function()self:SendWeaponAnim(ACT_VM_IDLE)end)
		return
	end

	-- go invis
	ply:SetNWBool("invis",true)
	ply:EmitSound(GoInvis)
	--ply:SetAnimation(PLAYER_ATTACK1)

	-- AR2Explosion effect

	local effect = EffectData()
	effect:SetOrigin(self:GetOwner():GetPos())
	effect:SetScale(100)
	effect:SetMagnitude( 100 )
	effect:SetRadius( 500 )
	util.Effect( "AntlionGib", effect, true )

	ply:SetRenderMode(RENDERMODE_TRANSALPHA)
	ply:SetColor(Color(255,255,255,0))
	ply:SetWalkSpeed(classdata[ply:GetNWInt("class")].speed+100)
	ply:SetRunSpeed(classdata[ply:GetNWInt("class")].speed+100)

	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor(Color(255,255,255,0))




	timer.Simple(7,function() -- about to loose invis effect
		if !ply:Alive() || !ply:GetNWBool("invis") then return end
		ply:SetNWBool("AboutUnInvis",true)

	end )



	timer.Simple(10,function() -- end invis
		if !ply:Alive() || !ply:GetNWBool("invis") then return end
		--self:SendWeaponAnim(ACT_VM_)
		ply:SetNWBool("invis",false)
		ply:EmitSound(UnInvis)
		ply:SetColor(Color(255,255,255,255))
		if self:IsValid() then self:SetColor(Color(255,255,255,255)) end
		ply:GetViewModel( 0 ):SetColor(Color(255,255,255,255))
		ply:SetWalkSpeed(classdata[ply:GetNWInt("class")].speed)
		ply:SetRunSpeed(classdata[ply:GetNWInt("class")].speed)
		ply:SetNWBool("AboutUnInvis",false)
	end )


	self:SetNextPrimaryFire( CurTime() + 15 )
	timer.Simple(15,function() if ply:Alive()|| !IsValid(self) then ply:EmitSound(Recharged) end end )
	timer.Simple(0.1,function() if ply:GetActiveWeapon()==self then self:SendWeaponAnim(ACT_VM_IDLE) end end)
end

function SWEP:Holster(wep)
    return !self:GetOwner():GetNWBool("invis")
end

function SWEP:SecondaryAttack()
	local ply = self.Owner
	if !ply:GetNWBool("invis") || CLIENT then return end
	ply:SetNWBool("invis",false)
	ply:EmitSound(UnInvis)
	ply:SetColor(Color(255,255,255,255))
	if self:IsValid() then self:SetColor(Color(255,255,255,255)) end
	ply:GetViewModel( 0 ):SetColor(Color(255,255,255,255))
	ply:SetWalkSpeed(classdata[ply:GetNWInt("class")].speed)
	ply:SetRunSpeed(classdata[ply:GetNWInt("class")].speed)
	ply:SetNWBool("AboutUnInvis",false)
end


function SWEP:Think()
	if CLIENT then
		local vm = self.Owner:GetViewModel( 0 )
		--print(vm:GetMaterial())
		vm:SetRenderMode(RENDERMODE_TRANSALPHA)
		vm:SetColor(Color(255,255,255,self.Owner:GetNWBool("invis") and (self.Owner:GetNWBool("AboutUnInvis") and 150 or 25) or 255))
		--vm:SetMaterial("models/alyx/emptool_glow",false)
	end
end
