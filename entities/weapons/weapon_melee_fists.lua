if SERVER then
	AddCSLuaFile()
end

SWEP.Base = "weapon__base"

SWEP.PrintName	= "Fists"

SWEP.ViewModel	= "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel	= ""

SWEP.ViewModelFOV	= 52
SWEP.Slot			= 1
SWEP.SlotPos		= 0

SWEP.NoIcon = true

SWEP.NextLerpTime = 0

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.UseHands	= true
SWEP.HoldType = "fist"

local SwingSound = Sound( "weapons/slam/throw.wav" )
local HitSound = Sound( "Flesh.ImpactHard" )

SWEP.ViewModelBoneMods = {}

SWEP.TotalPunches = 0

if SERVER then
	function SWEP:SetNewSlot()
	end
	
	function SWEP:CheckPlayerSkill(entity)
		if entity:IsNPC() or entity:IsPlayer() or entity:IsNextBot() then
			if math.random(self.Owner:GetSkillChance(SKILL_UNARMED)) == 1 then
				self.Owner:AddSkill(SKILL_UNARMED, 1)
			end
		end
	end
	
	function SWEP:UpdateDurabilitySet()
	end
	
	function SWEP:UpdateDurability()
	end
end

function SWEP:Initialize()
	self:SetHoldType( "fist" )
	
	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}
end

function SWEP:GetHolstered()
	return false
end

function SWEP:PreDrawViewModel( vm, wep, ply )

	vm:SetMaterial( "engine/occlusionproxy" ) -- Hide that view model with hacky material

end

SWEP.HitDistance = 48

function SWEP:SetupDataTables()

	self:NetworkVar("Bool", 0, "Holstered")
	
	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Float", 2, "NextSprintLerp")
	
	self:NetworkVar( "Int", 2, "Combo" )
	
end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )
	
end

function SWEP:PrimaryAttack( right )
	if self:GetHolstered() then return end

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local anim = "fists_left"
	if ( right ) then anim = "fists_right" end
	if ( self:GetCombo() >= 2 ) then
		anim = "fists_uppercut"
	end

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( SwingSound )

	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + 0.2 )
	
	self:SetNextPrimaryFire( CurTime() + 0.9 )
	self:SetNextSecondaryFire( CurTime() + 0.9 )
	
	self:SetNextSprintLerp(CurTime() + 2)
	
	self.NextLerpTime = CurTime() + 1
end

function SWEP:SecondaryAttack()
	if self:GetHolstered() then return end
	
	if self:GetOwner():GetSkill(SKILL_UNARMED) < 200 then
		self:PrimaryAttack( true )
		return
	end

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local anim
	if math.random(2) == 1 then
		anim = "fists_left"
	else
		anim = "fists_right"
	end

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( SwingSound )

	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + 0.2 )
	
	self:SetNextPrimaryFire( CurTime() + 0.3 )
	self:SetNextSecondaryFire( CurTime() + 0.3 )
	
	self:SetNextSprintLerp(CurTime() + 2)
	
	self.NextLerpTime = CurTime() + 1
	self.RapidPunch = true
	self.TotalPunches = self.TotalPunches + 1
end

function SWEP:DealDamage()

	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )
	
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner
	} )

	if ( !IsValid( tr.Entity ) ) then 
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -4, -4, -8 ),
			maxs = Vector( 4, 4, 8 )
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP.
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( HitSound )
	end

	local hit = false

	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()
	
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )
		local knockback = not self.RapidPunch
		if self.RapidPunch then
			dmginfo:SetDamage( math.random( 2, 3 ) * (self.Owner:GetStat(STAT_STRENGTH) / 20) )
			self.RapidPunch = false
		else
			dmginfo:SetDamage( math.random( 7, 9 ) * (self.Owner:GetStat(STAT_STRENGTH) / 20) )
		end
		dmginfo:SetDamageType(DMG_NONLETHAL)

		if ( anim == "fists_left" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 ) -- Yes we need those specific numbers
		elseif ( anim == "fists_right" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 + self.Owner:GetForward() * 9989 )
		elseif ( anim == "fists_uppercut" ) then
			dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012 )
			dmginfo:SetDamage( math.random( 8, 10 )  * (self.Owner:GetStat(STAT_STRENGTH) / 20) )
		end

		tr.Entity:TakeDamageInfo( dmginfo )
		hit = true
		
		if tr.HitGroup == HITGROUP_HEAD and self:GetOwner():GetSkill(SKILL_UNARMED) >= 100 and knockback then
			local power = 200 + 200 * (self:GetOwner():GetStat(STAT_STRENGTH) / 20)
			tr.Entity:ThrowFromPosition(self:GetOwner():GetPos(), power, true)
			tr.Entity:EmitSound("ambient/alarms/warningbell1.wav")
			
			local effect = EffectData()
				effect:SetOrigin(tr.HitPos)
			util.Effect("genericrefractring", effect, nil, true)
		end
		
		if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
			self:CheckPlayerSkill(tr.Entity)
		end
	end

	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80, tr.HitPos )
		end
	end

	if ( SERVER ) then
		if ( hit && anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end
	
	if self.TotalPunches >= 5 then
		self.TotalPunches = 0
		self:SetNextPrimaryFire( CurTime() + 1 )
		self:SetNextSecondaryFire( CurTime() + 1 )
	end

	self.Owner:LagCompensation( false )
end

function SWEP:OnRemove()
	
	if ( IsValid( self.Owner ) && CLIENT && self.Owner:IsPlayer() ) then
		local vm = self.Owner:GetViewModel()
		if ( IsValid( vm ) ) then vm:SetMaterial( "" ) end
	end
	
end

function SWEP:Holster( wep )

	self:OnRemove()

	return true

end

function SWEP:Deploy()

	local vm = self.Owner:GetViewModel()
	vm:SetModel(self.ViewModel)
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
	
	self:UpdateNextIdle()
	
	if ( SERVER ) then
		self:SetCombo( 0 )
	end
	
	return true

end

function SWEP:Think()
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()
	
	if self.TotalPunches > 0 and not self:GetOwner():KeyDown(IN_ATTACK2) then
		self.TotalPunches = 0
		self:SetNextPrimaryFire( CurTime() + 1 )
		self:SetNextSecondaryFire( CurTime() + 1 )
	end
	
	if ( idletime > 0 && CurTime() > idletime ) then

		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )
		
		self:UpdateNextIdle()

	end
	
	local meleetime = self:GetNextMeleeAttack()
	
	if ( meleetime > 0 && CurTime() > meleetime ) then

		self:DealDamage()
		
		self:SetNextMeleeAttack( 0 )

	end
	
	if ( SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1 ) then
		
		self:SetCombo( 0 )
		
	end
end

function SWEP:ViewModelDrawn(vm)
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			-- !! WORKAROUND !! --
			-- We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			-- !! ----------- !! --
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				-- !! WORKAROUND !! --
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				-- !! ----------- !! --
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
end

SWEP.LerpAngVM = 0
function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
	local vm = self.Owner:GetViewModel()
	local angr = Angle(0, 0, 0)
	local posr = Vector(0, 0, 0)
	
	if self:GetHolstered() then
		angr.p = -30
		angr.r = -10
		self.LerpAngVM = math.Approach(self.LerpAngVM, 1, (1 / self.HolsterTime) * FrameTime())
		
		if not self.LastViewMod == angr or self.LastViewMod == nil then
			self.LastViewMod = angr
		end
	elseif self.LerpAngVM > 0 then
		angr = self.LastViewMod
		self.LerpAngVM = math.Approach(self.LerpAngVM, 0, FrameTime() * 3)
		
		if self.LerpAngVM == 0 then
			self.LastViewMod = nil
		end
	end
	
	pos = pos + posr.x * ang:Right() * self.LerpAngVM
		+ posr.y * ang:Forward() * self.LerpAngVM
		+ posr.z * ang:Up() * self.LerpAngVM
	
	ang:RotateAroundAxis(ang:Right(), angr.p * self.LerpAngVM)
	ang:RotateAroundAxis(ang:Forward(), angr.y * self.LerpAngVM)
	ang:RotateAroundAxis(ang:Up(), angr.r * self.LerpAngVM)
	
	return pos, ang
end
