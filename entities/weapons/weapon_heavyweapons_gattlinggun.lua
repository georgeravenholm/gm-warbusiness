AddCSLuaFile()

SWEP.Author = "georgeravenholm"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Gattling Gun"
SWEP.Instructions = "Destroy them!\nRight-Click: SuperShot"
SWEP.ViewModel = "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.UseHands = true
SWEP.Weight = 0
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

SWEP.Primary.ClipSize=255
SWEP.Primary.DefaultClip=0
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize=-1
SWEP.Secondary.DefaultClip=-1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

SWEP.Charge = 0 // percentage of chargedness
--SWEP.DefaultSpeed = 0

local Shoot = Sound("weapons/airboat/airboat_gun_energy1.wav")

function SWEP:Initialize()
    self:SetClip1(self.Primary.ClipSize) -- fill with ammo
		self:SetHoldType("crossbow")
end

function SWEP:Equip()
	self.DefaultSpeed = self.Owner:GetWalkSpeed() -- cache owners walk speed to prevent delay in networkssing
	self.DefaultJump = self.Owner:GetJumpPower()

	if CLIENT then return end
	self.UpCharge = CreateSound(self.Owner,"vehicles/Crane/crane_startengine1.wav")
	self.UnCharge = CreateSound(self.Owner,"vehicles/Airboat/fan_motor_shut_off1.wav")
end

function SWEP:ChargeSound(bool)// If true, charge up sound, flase charge down Sound
	--print(bool)

	if bool then
		if !self.UpCharge:IsPlaying() then self.UnCharge:Stop() self.UpCharge:Play() end
	else
		if !self.UnCharge:IsPlaying() then self.UpCharge:Stop() self.UnCharge:Play() end
	end
end

function SWEP:Holster()
	self.Charge = 0
	--self.Owner:SetWalkSpeed(self.DefaultSpeed)
	--self.Owner:SetRunSpeed(self.DefaultSpeed)
	--print(self.DefaultSpeed)
	return true // reset charge and speed on holster
end

function SWEP:DrawHUD()
	draw.SimpleText("Charge = "..self:GetNWInt("charge",0),"ChatFont",ScrW()/2,ScrH()/2+50,( self:GetNWInt("charge",0)>=100 and Color(0,255,0) or Color(255,0,0) ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end



function SWEP:IncCharge(int)
	self.Charge = self.Charge + int // Really, no int++?!?!
end

function SWEP:Think()
	-- Manage charge
	if CLIENT then return end
	local OldCharge = self.Charge
	self:IncCharge(-2) // decrease!
	local ply = self.Owner // we dont want to keep typing that sgit
	if ply:KeyDown(IN_ATTACK) || ply:KeyDown(IN_ATTACK2) then self:IncCharge(4) end // increase charge if pushing buttons

	self.Charge = math.Clamp(self.Charge,0,200) // Clamp, over charge to have some time still spun up and make sure it doesnt go negative
	if SERVER then self:SetNWInt("charge",self.Charge) end
	// Now we have charge, slow us down if we are charged
	--if CLIENT then return end
	local charged = self.Charge >= 100

	ply:SetWalkSpeed( (self.Charge >= 100 and self.DefaultSpeed/2 or self.DefaultSpeed ) ) // Set speed to half of class' normal speed if charged
	ply:SetRunSpeed(ply:GetWalkSpeed()) // fix later
	// Sounds
	self:ChargeSound( self.Charge > OldCharge || self.Charge ==200 ) // also fix later....

	ply:SetJumpPower(!charged and self.DefaultJump or 0) // fix later again?!
end

function SWEP:AdjustMouseSensitivity()
    return self:GetNWInt("charge",0) >= 100 and 0.4 or 1
end

function SWEP:SecondaryAttack()
    return
end

function SWEP:PrimaryAttack()
    -- shooty shooty
		--print(self.Charge)
		if self:GetNWInt("charge",0) < 100 || !self:CanPrimaryAttack() then return end -- return if not charged/overcharged
		--if CLIENT && self:GetNWInt("charge") < 100 then return end
		-- wow we are actually shooting now


		-- Make sure we can shoot first

		--if SERVER then BroadcastLua([[Entity(]].. self:EntIndex() ..[[):ShootEffects()]]) end
		--if CLIENT then print("Client is doing effeckts | "..self.Charge) end
		self:ShootEffects(	)
		self.Weapon:EmitSound(Shoot)
		self.Owner:ViewPunch( Angle( math.random(-1,1),math.random(-1,1),math.random(-1,1) ) * 0.1 )
		-- Play shoot sound
		--if CLIENT then return end
		--)


		--self:ShootBullet( self.Damage, 1, 0.01 )
		// We are using pellets now.
		if SERVER then
			local pel = ents.Create("wb_pellet")
			local ply = self.Owner
			pel.Damage = 20
			pel:SetPos( ply:GetShootPos() )

			pel:SetCreator(ply)
			pel:SetOwner(ply)
			pel:Spawn() // spawn
			pel:SetVelocity( ply:GetAimVector()*100 )
		end

		-- Remove 1 bullet from our clip
		self:TakePrimaryAmmo( 1 )
		self:SetNextPrimaryFire(CurTime()+ (classdata[self.Owner:GetNWInt("class")].name=="CEO" and 0.01 or 0.2 ))
		-- Punch the player's view



end
