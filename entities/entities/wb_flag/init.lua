AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:KeyValue(key,value)
    if key == "team" then self.team=tonumber(value) self:SetNWInt("flagteam",self.team) return false end
end

function ENT:Initialize()
	if self.team==1 then self.Entity:SetColor(Color(60,60,255))
	elseif self.team==2 then self.Entity:SetColor(Color(255,100,0))
	elseif self.team==3 then self.Entity:SetColor(Color(255,0,0))
	elseif self.team==4 then self.Entity:SetColor(Color(0,255,0)) end
	self:SetMaterial("models/debug/debugwhite",true)
	self:SetModel( "models/flag/flag.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	--self:SetTrigger( true )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow(false)

        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end


	self.stolen = false
	self.origin = self:GetPos()
	--print(self.origin)
	self.carrier = nil
	self.cantake = true
end

function ENT:Use( activator, caller )
    return
end


-- functions
local metatable = ENT

function ENT:Notify( s2 , c2 , adj , s1 , c1 ) // killfeed notifies
     net.Start("killfeed")
          net.WriteString(s1)
          net.WriteColor(c1)

          net.WriteString(adj)

          net.WriteString(s2)
          net.WriteColor(c2)
     net.Broadcast()
end

function metatable:returnToBase() -- return the flag back to its base
	self:SetParent(nil)
	self:SetPos(self.origin)
	self:SetAngles(Angle(0,0,0))
	self.cantake=true
	self.stolen=false

	if self.carrier!=nil then self.carrier:SetNWEntity("carrying",Entity(0)) end -- yo, you are not holding me
	self.carrier=nil


	PrintMessage( HUD_PRINTCENTER, teamdata[self.team].name.."'s flag has returned." )
     self:Notify(teamdata[self.team].name.."'s flag" , team.GetColor(self.team) , "returned to" ,teamdata[self.team].name , team.GetColor(self.team) )
end

function metatable:dropFlag()
	PrintMessage( HUD_PRINTCENTER, teamdata[self.team].name.."'s flag was dropped!" )
     self:Notify( self.carrier:Nick() , team.GetColor(self.carrier:Team()) , "dropped" , teamdata[self.team].name.."'s flag!" , team.GetColor(self.team) )

	self:SetParent(nil)
	self.cantake = false -- until 3 seconds
	timer.Simple(3,function() self.cantake = true end ) -- make pickupable in 3 seconds

	self.stolen = true

	self.carrier:SetNWEntity("carrying",Entity(0)) -- yo, you are not holding me
	self.carrier=nil

	-- send to ground
	local tr = util.TraceLine( {
	start = self:GetPos(),
	endpos = self:GetPos()+Vector(0,0,-10000),
	filter = function( ent ) if ( ent:GetClass() == "worldspawn" ) then return true end end
	} )
	self:SetPos(tr.HitPos)

	timer.Create("resetflag"..self:EntIndex(),self.returntime,1, function() self:returnToBase() end ) -- reset flag after time
end

function metatable:pickupFlag(ply)
	if ply:GetNWEntity("carrying",Entity(0)):GetClass()==Entity(0) then return end -- has a flag? noooopppeee
	self.carrier = ply
	ply:SetNWEntity("carrying", self ) -- make it so the player holds a NW value of the flag

	local BoneIndx = self.carrier:LookupBone("ValveBiped.Bip01_Pelvis")
	local BonePos , BoneAng = self.carrier:GetBonePosition( BoneIndx )
	self:SetPos( self.carrier:LocalToWorld(Vector(-5,0,0)) )
	self:SetAngles( Angle(0, BoneAng.y-90 ,0) )
	self:SetParent( self.carrier, -1 )

	self.cantake = false
	self.stolen = true
	PrintMessage( HUD_PRINTCENTER, self.carrier:Name().." ("..team.GetName(self.carrier:Team())..") has taken "..teamdata[self.team].name.."'s flag!" )
     self:Notify( self.carrier:Nick() , team.GetColor(self.carrier:Team()) , "picked up" , teamdata[self.team].name.."'s flag!" , team.GetColor(self.team) )
	net.Start("elimination") net.WriteString("Take the flag back to your base!") net.Send(self.carrier)
	timer.Stop("resetflag"..self:EntIndex())
end






function ENT:Think()
	local find = ents.FindInSphere(self:GetPos()+Vector(0,0,50),25) -- start a trace

     // update timer
     self:SetNWInt("returntime",timer.TimeLeft("resetflag"..self:EntIndex()))

	if self.carrier == nil && self.cantake then -- if we can take it
		local find = ents.FindInSphere(self:GetPos()+Vector(0,0,50),25)
		for i,ent in ipairs(find) do
			if ent:IsPlayer() && ent:Team()!=self.team && ent:Team()!=5 && ent:GetNWInt("carrying",Entity(0))==Entity(0) && !ent:GetNWBool("invis") && ent:Alive() then -- must be player, musnt be on their own team, must not be a spectator. and not invis. and alive
				self:pickupFlag(ent) -- call pickup function
			end
		end

	elseif self.carrier != nil && !self.carrier:Alive() then -- if carrier is dead,
		self:dropFlag()
	end

	-- handle caps / flag reset triggers
	for i,ent in ipairs(find) do
		if ent:GetClass()=="wb_trig_flagcap" && self.carrier!=nil then
			if ent.team != self.team && self.carrier:Team()==ent.team then

					-- return the flag
					self:SetParent(nil)
					self:SetPos(self.origin)
					self:SetAngles(Angle(0,0,0))
					self.cantake=true
					self.stolen=false





					-- award points
					PrintMessage( HUD_PRINTCENTER, teamdata[self.team].name.."'s flag was captured by "..teamdata[self.carrier:Team()].name.."!!!" )
                         self:Notify( self.carrier:Nick() , team.GetColor(self.carrier:Team()) , "CAPTURED" , teamdata[self.team].name.."'s flag!" , team.GetColor(self.team) )
					team.AddScore(self.carrier:Team(),1)
					self.carrier:SetNWInt("points",ent:GetNWInt("points")+10)
					net.Start("elimination") net.WriteString("Captured Flag +10") net.Send(self.carrier)

					self.carrier:SetNWEntity("carrying",Entity(0)) -- yo, you are not holding me
					self.carrier=nil
				end
		end
		-- flag reset
		if ent:GetClass()=="wb_trig_flagreset" || ent:GetClass()=="trigger_hurt" then self:SetNWInt("returntime",0) timer.Destroy("resetflag"..self:EntIndex()) self:returnToBase() end
	end


end
