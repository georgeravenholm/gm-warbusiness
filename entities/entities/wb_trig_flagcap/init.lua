AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:KeyValue(key,value)
    if key == "team" then self.team=tonumber(value) return false end
end

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end

function ENT:Think()
	self:SetNWInt("team",self.team)
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end

--[[function ENT:Touch(ent)
	if !ent:IsPlayer() then return end
  for i,flag in ipairs(ents.FindByClass("wb_flag")) do
		--print(flag.carrier:Nick()..":"..ent:Nick())
		if flag.carrier == ent then
			-- we hit a flag carrier
			-- check if cap
			--print(ent.team.."!="..flag.team.."&&"..ent.team..":"..self.team)
			if ent:Team() != flag.team && ent:Team()==self.team then
					-- cap!
				flag:SetPos(flag.origin)
				flag.cantake=true
				flag.stolen=false
				flag.carrier=nil
				PrintMessage( HUD_PRINTCENTER, teamdata[flag.team].name.."'s flag was captured by "..teamdata[ent:Team()].name.."!!!" )
				team.AddScore(ent:Team(),1)
				ent:SetNWInt("points",ent:GetNWInt("points")+10)
				net.Start("elimination") net.WriteString("Captured Flag +10") net.Send(ent)
				return

			end
		end
	end
end
]]-- do this in flag ent now plese
