AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:KeyValue(key,value)
  if key=="team" then
    self.team = value
		print(key..value)
  end
  
end

function ENT:PassesFilter( trigger, ent )
	print(ent:Team().." vs "..self.team)
	return ent:Team()==self.team
end
