AddCSLuaFile()

SWEP.Author = "georgeravenholm"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Adhiesive Strips"
SWEP.Instructions = "Left-Click: Slap (adhiesive stips)\nAlt: Self-Heal (freezes you)\nNote: You can give your patient 10hp more than they can normally have."
SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel = ""
SWEP.UseHands = false
SWEP.Weight = 1
SWEP.AutoSwitchTo=false
SWEP.AutoSwitchFrom=false
SWEP.Slot=0
SWEP.SlotPos=1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair=true
SWEP.Spawnable=true
SWEP.AdminSpawnable=true
--SWEP.SetHoldType = "melee"

SWEP.Primary.ClipSize=1
SWEP.Primary.DefaultClip=1
SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize=-1
SWEP.Secondary.DefaultClip=1
SWEP.Secondary.Ammo = "XBowBolt"
SWEP.Secondary.Automatic = false

SWEP.Healing = false
SWEP.Healed= 0

local Slap = Sound("Flesh.ImpactHard")
local Heal = Sound("items/smallmedkit1.wav")
local Swing = Sound("WeaponFrag.Throw")
local SelfHeal = Sound("items/medcharge4.wav")

function SWEP:Initialize()
	self:SetHoldType("fist")
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_IDLE)
end

function SWEP:PrimaryAttack()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_left" ) )
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )
	if CLIENT || self.Healing then return end -- fuck off client

	--self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	local ply = self:GetOwner()
	ply:LagCompensation(true)
	ply:SetAnimation(PLAYER_ATTACK1)


	-- First we slap and see what happens
	local shootpos = ply:GetShootPos()
	local endshootpos = shootpos + ply:GetAimVector() * 50
	ply:EmitSound(Swing)

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
	if IsValid(hit)&&(hit:IsPlayer()) then -- hit!
		if hit:Team() == ply:Team() then -- heal him!
			if ply:GetAmmoCount( self:GetPrimaryAmmoType() ) == 0 then return end -- no adheisive strips? cant do itm8sorry
			ply:EmitSound(Heal)

			-- no points if it wasnt actually a heal!
			if (hit:Health()<(hit:GetMaxHealth()+10)) && self.Healed%15==0 then --1point per 15hp
				ply:SetNWInt("points", ply:GetNWInt("points")+1 )
				net.Start("elimination") net.WriteString("Healed "..hit:Nick().." +1") net.Send(ply)
			end

			hit:SetHealth( math.Clamp( hit:Health()+5 ,0,hit:GetMaxHealth()+10) ) -- only allow up to 10hp extra
			ply:RemoveAmmo(1,self:GetPrimaryAmmoType()) -- use a bandaid
			self.Healed = self.Healed + 5
			self:TakePrimaryAmmo(1)
			self:SetNextPrimaryFire( CurTime() + 0.2 )
			ply:LagCompensation(false)
			if ply:GetAmmoCount( self:GetPrimaryAmmoType() ) == 0 then self:SetClip1(0) return end -- dont reset clip1 if no ammo left!
			timer.Simple(0.2,function()self:SetClip1(1) end)

			return
		else -- enemy? slap him!
			local dmg = DamageInfo()
			dmg:SetDamage(10)
			dmg:SetDamageType(DMG_CLUB)
			dmg:SetDamageForce( ply:GetAimVector()*60000 )
			dmg:SetAttacker(ply)

			hit:TakeDamageInfo(dmg)
			hit:SetVelocity( ply:GetAimVector()*math.random(250,1000) )
			self:SetNextPrimaryFire( CurTime() + 0.3 )
			ply:EmitSound(Slap)
			ply:LagCompensation(false)
		end
	else -- miss!
		self:SetNextPrimaryFire( CurTime() + 0.5 )
		ply:LagCompensation(false)
end



	--self:SetNextPrimaryFire( CurTime() + 2 )
	timer.Simple(1,function() if ply:GetActiveWeapon()==self then self:SendWeaponAnim(ACT_VM_IDLE) end end )

end

function SWEP:SecondaryAttack()
	local ply = self.Owner
	--ply:LagCompensation(true)
	if ply:GetAmmoCount( self:GetPrimaryAmmoType() ) == 0 || self.Healing==true then return end
	self.Healing = true -- were now healing! no switching
	self.HealPercent=0

	self:SetNextSecondaryFire(15)
	--print("ayy")

	ply:SetMoveType(MOVETYPE_NONE)
	--ply:EmitSound(SelfHeal)

	local healsound = CreateSound(ply,"items/medcharge4.wav")
	healsound:Play()

	hook.Add("PlayerDeath","stopselfheal",function(dead)
		if dead==ply then healsound:Stop() timer.Destroy("selfheal") end
	end)

	timer.Create("selfheal",10,1,function()

		--if ply:Alive() then timer.Destroy("heal") end
		--ply:SetHealth(math.Clamp(ply:Health()+10,0,ply:GetMaxHealth()))
		--self.HealPercent=self.HealPercent+10
		if ply:Alive() && healsound:IsPlaying() then -- heal done
			self.Healing = false
			--self.HealPercent = 0
			ply:SetMoveType(MOVETYPE_WALK)
			ply:SetHealth(math.Clamp(ply:Health()+ply:GetMaxHealth()/2,0,ply:GetMaxHealth()))
			--timer.Destroy("heal")
			healsound:Stop()

			-- use 10 bandaids
			ply:RemoveAmmo(10,self:GetPrimaryAmmoType())
			if ply:GetAmmoCount( self:GetPrimaryAmmoType() ) == 0 then self:SetClip1(0) end

			self:SetNextSecondaryFire(10)
			ply:EmitSound("items/suitchargeok1.wav")
		end
	end)

end

function SWEP:Holster()
    return !self.Healing
end

function SWEP:Reload()
    return
end

--function SWEP:FreezeMovement()
--	return true
---end
