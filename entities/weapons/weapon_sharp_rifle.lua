AddCSLuaFile()

SWEP.Author = "georgeravenholm"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Rifle"
SWEP.Instructions = "Aim for the head.\nRight-Click: Scope"
SWEP.ViewModel = "models/sharp_rifle/v_sniper.mdl"
SWEP.WorldModel = "models/sharp_rifle/w_sniper.mdl"
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

SWEP.Primary.ClipSize=4
SWEP.Primary.DefaultClip=4
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize=-1
SWEP.Secondary.DefaultClip=-1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true

SWEP.Scoped = false
SWEP.Reloading = false

local Shoot = Sound("npc/assassin/ball_zap1.wav")
local Echo = Sound("npc/sniper/echo.wav")
local Ready = Sound("weapons/physcannon/energy_bounce2.wav")
local Reload = Sound("weapons/smg1/smg1_reload.wav")

local Zoom = Sound("weapons/sniper/sniper_zoomin.wav")
local ZoomOut = Sound("weapons/sniper/sniper_zoomout.wav")
--local Hit = Sound("Weapon_Crowbar.Meelee_Hit")
--local range = 30

function SWEP:Initialize()
	self:SetHoldType("crossbow") -- make it 'camera' when zoomed in
	self.Scoped = false
end

function SWEP:Holster(wep)
	self.Scoped = false
	return true
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_IDLE)
end

function SWEP:DoImpactEffect(tr,dmgtype)
	if ( tr.HitSky ) then return end

	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
	effectdata:SetNormal( tr.HitNormal )
	util.Effect( "cball_explode", effectdata )
	if SERVER then EmitSound(Echo,tr.HitPos,0,CHAN_AUTO,1) end
end

-- Mouse sensitivity. for clients, cuz were grownups
if CLIENT then
	function SWEP:AdjustMouseSensitivity()
		if self:GetHoldType()=="smg" then return 0.25 else return 1 end -- if spinning up, make mouse slow af
	end
end

function SWEP:PrimaryAttack()

	local ply = self.Owner
	if self:Clip1()<=0 then return end
	ply:LagCompensation(true)







	self:ShootEffects()

	--self:ShootEffects()

	--ply:LagCompensation(false)

	-- calculate boolet
	local bullet = {}

	bullet.Num = 1
	bullet.Src = ply:GetShootPos()
	bullet.Dir = ply:GetAimVector()
	bullet.Spread = (Vector(0.01,0.01,0.01) * (ply:GetVelocity().x+ply:GetVelocity().y+ply:GetVelocity().z)/3)/8
	bullet.Damage = 50
	bullet.AmmoType = "XBowBolt"
	bullet.Tracer = 1
	bullet.Force	= 1000
	bullet.TracerName="ToolTracer"
	bullet.Callback = function( attacker, trace, dmg )
		-- increase damage
		if CLIENT then return end
		if trace.PhysicsBone==10 then -- if hit heat hitbox
			dmg:SetDamage(300)
			dmg:SetDamageType(DMG_DISSOLVE)
			--ply:PrintMessage(HUD_PRINTTALK,"Sik headshot!")
		else
			dmg:SetDamage(50)
			--ply:PrintMessage(HUD_PRINTTALK,"Hit bone "..trace.PhysicsBone)
		end
	end


	ply:FireBullets(bullet)
	if CLIENT || self:Clip1()<=0 then return end -- client can fuck off now
		ply:EmitSound(Shoot)
	ply:LagCompensation(false)

	self:TakePrimaryAmmo(1)
	if self:Clip1()<=0 then
		self:Reload()
		return
	end


	self:SetNextPrimaryFire( CurTime() + 2 )
	timer.Simple(0.1,function() self.Owner:SetAnimation(PLAYER_RELOAD) self:SendWeaponAnim(ACT_VM_RELOAD) end)
	timer.Simple(2,function() if self.Owner:GetActiveWeapon()==self then ply:EmitSound(Ready) end end)
end

function SWEP:Reload()
	if self.Reloading || self.Owner:GetAmmoCount(self:GetPrimaryAmmoType())==0 || CLIENT then return false end
	self:SendWeaponAnim(ACT_VM_RELOAD) --reload clip
	local ply = self.Owner
	ply:EmitSound(Reload)
	self.Reloading = true
	self:SetNextPrimaryFire( CurTime() + 4 )
	self.Owner:SetAnimation(PLAYER_RELOAD)
	timer.Simple(4,function() if IsValid(self) && self.Owner:GetActiveWeapon()==self then ply:EmitSound(Ready) self.Reloading = false end end)

	timer.Simple(4,function()
		if !IsValid(self) then return end
		self:TakePrimaryAmmo(4)
		self:SetClip1(4)


	end)
end

function SWEP:SecondaryAttack()
	if self.Scoped == true then self.Scoped = false else self.Scoped = true end
	--print(Scoped)
	if self.Scoped then -- zooooooOoooOooom in
		self.Owner:SetFOV(30,0.5)
		self:SetHoldType("smg")
		if SERVER then self.Owner:EmitSound(Zoom) end
	else -- zoom out
		self.Owner:SetFOV(0,0.5)
		self:SetHoldType("crossbow")
		if SERVER then self.Owner:EmitSound(ZoomOut) end
	end

	self:SetNextSecondaryFire( CurTime() + 0.5 )
end
