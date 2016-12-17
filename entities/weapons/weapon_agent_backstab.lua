AddCSLuaFile()

SWEP.Author = "georgeravenholm"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Agent's Backstabber"
SWEP.Instructions = "Aim for the back."
SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_ct.mdl"
SWEP.UseHands = true
SWEP.Weight = 1
SWEP.AutoSwitchTo=true
SWEP.AutoSwitchFrom=true
SWEP.Slot=0
SWEP.SlotPos=0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair=true
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

local Swing = Sound("Weapon_Crowbar.Single")
local Hit = Sound("Weapon_Crowbar.Melee_Hit")
local range = 50

function SWEP:Initialize()

end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_IDLE)
end

function SWEP:PrimaryAttack()
	if CLIENT then return end -- fuck off client

	local ply = self:GetOwner()
	ply:LagCompensation(true)

	local shootpos = ply:GetShootPos()
	local endshootpos = shootpos + ply:GetAimVector() * range

	local tmin = Vector(1,1,1) * -10
	local tmax = Vector(1,1,1) * 10

	local tr = util.TraceHull(
	{
		start=shootpos,
		endpos= endshootpos,
		maxs=tmax,
		mins=tmin,
		filter=ply,
		mask = MASK_SHOT_HULL,
	}
	)

	if(not IsValid(tr.Entity)) then
		--nvm
	end

	local hit = tr.Entity
	if IsValid(hit)&&(hit:IsPlayer()||hit:IsNPC()) then

		-- test for actual bakestaybe
		--print( math.deg(math.acos(ply:GetAimVector():Dot(hit:GetAimVector()))))
		--ply:PrintMessage(HUD_PRINTTALK,"my yaw: "..ply:EyeAngles().y)
		--ply:PrintMessage(HUD_PRINTTALK,"his yaw: "..hit:EyeAngles().y)
		--ply:PrintMessage(HUD_PRINTTALK,"diff: "..ply:EyeAngles().y-hit:EyeAngles().y)

		self:SendWeaponAnim(ACT_VM_HITCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)
		local d = DamageInfo()
		d:SetAttacker(ply)
		local diff = ply:EyeAngles().y-hit:EyeAngles().y -- difference in eye angle yaws
		local backstab = (diff >= -80) && (diff <=80)

		d:SetDamage( backstab and 1000 or 40) -- if backstab, 1000 damage else 20 damage
		d:SetDamageType(DMG_SLASH)
		hit:TakeDamageInfo(d)
		ply:EmitSound(Hit)

		if backstab then
			hit:EmitSound(Sound("ambient/creatures/town_child_scream1.wav"))
		end

		if !hit:Alive() then
			ply:SetHealth(math.Clamp(ply:Health()+50,0,ply:GetMaxHealth()))
		end

	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)

		ply:EmitSound(Swing)
	end


	ply:LagCompensation(false)
	self.DrawCrosshair=false -- turn off crosshair

	self:SetNextPrimaryFire( CurTime() + 1.5 )
	timer.Simple(0.1,function() self:SendWeaponAnim(ACT_VM_IDLE) end)
	timer.Simple(1.5,function() self.DrawCrosshair=true end) -- turn on crosshair when ready
end

function SWEP:CanSecondaryAttack()
    return false
end
