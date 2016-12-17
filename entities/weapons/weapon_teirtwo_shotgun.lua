AddCSLuaFile()

SWEP.Author = "georgeravenholm"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Super Shotgun"
SWEP.Instructions = "Be a real mother bucker!\nRight-Click: SuperShot"
SWEP.ViewModel = "models/weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = false
SWEP.Weight = 1
SWEP.AutoSwitchTo=true
SWEP.AutoSwitchFrom=true
SWEP.Slot=0
SWEP.SlotPos=0
SWEP.DrawAmmo = true
SWEP.AccurateCrosshair = false
SWEP.DrawCrosshair=true
SWEP.Spawnable=true
SWEP.AdminSpawnable=true
--SWEP.SetHoldType = "melee"

SWEP.Primary.ClipSize=1
SWEP.Primary.DefaultClip=1
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize=-1
SWEP.Secondary.DefaultClip=-1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false



local Shoot = Sound("Weapon_Shotgun.Double")
--local Ready = Sound("weapons/physcannon/energy_bounce2.wav")
--local Reload = Sound("Weapon_Shotgun.Reload")
--local Hit = Sound("Weapon_Crowbar.Meelee_Hit")
--local range = 30

function SWEP:Initialize()
	self:SetHoldType("shotgun") -- make it 'camera' when zoomed in
end

function SWEP:Holster(wep)
	return true
end

function SWEP:DoImpactEffect( tr, nDamageType )

	if ( tr.HitSky ) then return end

	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
	effectdata:SetNormal( tr.HitNormal )
	util.Effect( "MetalSpark", effectdata )
	--util.Decal("blood",tr.StartPos,tr.HitPos)

end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_IDLE)
end


function SWEP:ShootBullet( damage, num_bullets, aimcone )

	local bullet = {}

	bullet.Num 	= num_bullets
	bullet.Src 	= self.Owner:GetShootPos() -- Source
	bullet.Dir 	= self.Owner:GetAimVector() -- Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )	-- Aim Cone
	bullet.Tracer	= 5 -- Show a tracer on every x bullets
	bullet.Force	= 1 -- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.CallBack = function(attacker,tr,dmg)
		local knockback = Vector(ply:GetAimVector().x*800,ply:GetAimVector().y*800,math.Clamp(ply:GetAimVector().z*500,-250,250))
		if IsValid(tr.Entity) && tr.Entity:IsPlayer() then tr.Entity:SetVelocity(knockback*50000) end
	end
	bullet.Distance = 1000 -- only 500 max range

	self.Owner:FireBullets( bullet )

	self:ShootEffects()

end


function SWEP:PrimaryAttack()

	local ply = self.Owner
	if self:Clip1()<=0 then return end
	ply:LagCompensation(true)







	self:ShootEffects()

	--self:ShootEffects()
	ply:EmitSound(Shoot)
	ply:LagCompensation(false)

	-- calculate boolet
	--[[local bullet = {}

	bullet.Num = 50
	bullet.Src = ply:GetShootPos()
	bullet.Dir = ply:GetAimVector()
	bullet.Spread = Vector(0.1,0.1,0)
	bullet.Damage = 2
	bullet.AmmoType = "Buckshot"
	bullet.Tracer = 1
	bullet.Force	= 100
	bullet.TracerName="Tracer"
	bullet.Callback = function( attacker, trace, dmg )
		self:DoImpactEffect(trace,dmg:GetDamageType())
	end
		if CLIENT then return end


	ply:FireBullets(bullet)
	--self:ShootEffects()]]

	self:ShootBullet( 2.5, 60, 0.16 )
	self:TakePrimaryAmmo(1)

	ply:LagCompensation(false)
	ply:Freeze(true)
	local knockback = -Vector(ply:GetAimVector().x*800,ply:GetAimVector().y*800,math.Clamp(ply:GetAimVector().z*500,-250,250))
	if !ply:IsOnGround() then knockback = knockback / 2.5 end
	ply:SetVelocity( knockback )


	self:Reload()
	self:SetNextPrimaryFire( CurTime() + 2 )
	timer.Simple(0.1,function()if !ply:Alive() || !IsValid(self) then return end self.Owner:SetAnimation(PLAYER_RELOAD) self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)  end) -- ACT_SHOTGUN_PUMP
	timer.Simple(0.5,function()if !ply:Alive()|| !IsValid(self)then return end self.Owner:SetAnimation(PLAYER_RELOAD) self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH) ply:Freeze(false)  end) -- ACT_SHOTGUN_PUMP
	timer.Simple(1,function()if !ply:Alive()|| !IsValid(self)then return end self.Owner:SetAnimation(PLAYER_RELOAD) self:SendWeaponAnim(ACT_SHOTGUN_PUMP)  end) -- ACT_SHOTGUN_PUMP
	timer.Simple(2,function()if !ply:Alive()|| !IsValid(self)then return end self:SendWeaponAnim(ACT_VM_IDLE)end)
end


function SWEP:CanSecondaryAttack()
    return false
end
