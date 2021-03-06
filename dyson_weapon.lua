AddCSLuaFile()

SWEP.PrintName = "Is that a dyson?" 
SWEP.Author = "Lord Dyson" 
SWEP.Purpose = "Emits Dysons"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModel = Model( "models/weapons/v_irifle.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_irifle.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

local ShootSound = Sound( "weapons/flaregun/fire.wav" ) 

function SWEP:PrimaryAttack() 

	self.Weapon:SetNextPrimaryFire( CurTime() + 0.1)		
	for i = 0,2,1 
	do 
	   self:ThrowDyson( "models/blender_stone/dyson.mdl" ) 
	end
end
 
function SWEP:SecondaryAttack()

	for i = 0,8,1 
	do 
	   self:ThrowDyson( "models/blender_stone/dyson.mdl" ) 
	end
end

function SWEP:ThrowDyson( model_file )

	self:EmitSound( ShootSound )

	if ( CLIENT ) then return end
	
	local ent = ents.Create( "prop_physics" )
	local Forward = self.Owner:EyeAngles():Forward()
	
	if ( !IsValid( ent ) ) then return end
	
	ent:SetModel( model_file  )
	ent:SetPos( self.Owner:GetShootPos() + Forward * 32 )	
	ent:SetAngles( self.Owner:EyeAngles())
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	
	if ( !IsValid( phys ) ) then ent:Remove() return end

	local velocity = self.Owner:GetAimVector()
	velocity = (velocity * 500000) + (VectorRand() * 25000)
	phys:ApplyForceCenter(velocity)
 
	cleanup.Add( self.Owner, "props", ent )
 
	undo.Create( "Thrown_Dyson" )
		undo.AddEntity( ent )
		undo.SetPlayer( self.Owner )
	undo.Finish()
end
