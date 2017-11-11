local PANEL = {}

function PANEL:Init()
	LocalPlayer().v_EquipmentPanel = self
	
	self.StatusReductions = {}
	self:UpdatePlayerReductions()
end

function PANEL:OnClose()
	LocalPlayer().v_EquipmentPanel = nil
	
	if self.WeaponModel then
		self.WeaponModel:Remove()
		self.WeaponModel = nil
	end
	
	self:Remove()
end

local gradient = surface.GetTextureID("gui/center_gradient")
local burn = Material("noxrp/statusicons/status_onfire.png")
local bullet = Material("noxrp/statusicons/status_bulletimpact.png")
local cutting = Material("noxrp/statusicons/status_bleed.png")
local blunt = Material("noxrp/statusicons/status_bluntimpact.png")
local speed = Material("noxrp/statusicons/status_speed.png")
function PANEL:Paint(w, h)
	local ply = LocalPlayer()
	local health = ply:Health()
	local breath = ply.Breath
	
	draw.SlantedRectHorizOffset(0, 0, w - 30, 25, 15, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	draw.SlantedRectHorizOffset(10, h - 45, w - 30, 25, -15, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	draw.SimpleText("Equipment", "hidden18", w * 0.5, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	local statuses = ents.FindByClass("status_*")
	local plstatus = {}
	for k,v in pairs(statuses) do
		if v:GetOwner() == ply  and v.DisplayOnHud then
			table.insert(plstatus,v)
		end
	end
		
	if #plstatus > 0 then
		local nexty = 0
		local total = #plstatus
		for k,v in pairs(plstatus) do
			v:PanelDraw(w - 220, 40 + nexty)
			nexty = nexty + 40
		end
	end
	
	local posx = w * 0.3 + 100
	local posy = h * 0.1 + 10
	local center = {x = w * 0.8, y = h * 0.5}
	draw.SlantedRectHorizOffset(posx, posy, 350, 40, 5, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	
	//Bullet Damage
	surface.SetMaterial(bullet)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(posx + 10, posy + 5, 30, 30)
	draw.SimpleText(self.StatusReductions[DMG_BULLET][2], "Xolonium16", posx + 50, posy + 15, self.StatusReductions[DMG_BULLET][1], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	//Fire Damage
	posy = posy + 50
	draw.SlantedRectHorizOffset(posx, posy, 350, 40, 5, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	
	surface.SetMaterial(burn)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(posx + 10, posy + 5, 30, 30)
	draw.SimpleText(self.StatusReductions[DMG_BURN][2], "Xolonium16", posx + 50, posy + 15, self.StatusReductions[DMG_BURN][1], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	//Cutting Damage
	posy = posy + 50
	draw.SlantedRectHorizOffset(posx, posy, 350, 40, 5, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	
	surface.SetMaterial(cutting)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(posx + 10, posy + 5, 30, 30)
	draw.SimpleText(self.StatusReductions[DMG_SLASH][2], "Xolonium16", posx + 50, posy + 15, self.StatusReductions[DMG_SLASH][1], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	//Blunt Damage
	posy = posy + 50
	draw.SlantedRectHorizOffset(posx, posy, 350, 40, 5, Color(0, 0, 0, 220), Color(0, 0, 0, 255), 2, 2)
	
	surface.SetMaterial(blunt)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(posx + 10, posy + 5, 30, 30)
	draw.SimpleText(self.StatusReductions[DMG_CLUB][2], "Xolonium16", posx + 50, posy + 15, self.StatusReductions[DMG_CLUB][1], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	
	if self.Stats then
		local dist = 70
		local scale = dist / STATS_MAXPERSTAT
	
		surface.SetDrawColor(50, 255, 50, 100)
		surface.DrawRect(center.x - 10, center.y - 10, 20, 20)
				for k, point in pairs(self.ChartBasePoints) do
					local t = k + 1
					if k == #self.ChartBasePoints then
						t = 1
					end
					surface.DrawLine(point.x, point.y, self.ChartBasePoints[t].x, self.ChartBasePoints[t].y)
				end
				
				for k, point in pairs(self.ChartBasePoints) do
					local t = k + 1
					if k == #self.ChartBasePoints then
						t = 1
					end
					surface.DrawRect(point.x - 5, point.y - 5, 10, 10)
				end
				
				surface.SetDrawColor(50, 150, 255, 100)
				for k, point in pairs(self.ChartMidPoints) do
					local t = k + 1
					if k == #self.ChartMidPoints then
						t = 1
					end
					surface.DrawRect(point.x - 5, point.y - 5, 10, 10)
				end
				
				for k, point in pairs(self.ChartMaxPoints) do
					local t = k + 1
					if k == #self.ChartMaxPoints then
						t = 1
					end
					surface.SetDrawColor(255, 255, 255, 100)
					surface.DrawLine(self.ChartBasePoints[k].x, self.ChartBasePoints[k].y, point.x, point.y)
					
					surface.SetDrawColor(50, 255, 50, 100)
					surface.DrawLine(point.x, point.y, self.ChartMaxPoints[t].x, self.ChartMaxPoints[t].y)
				end
				
				for k, point in pairs(self.ChartMaxPoints) do
					local t = k + 1
					if k == #self.ChartMaxPoints then
						t = 1
					end
					surface.DrawRect(point.x - 5, point.y - 5, 10, 10)
				end
				
				surface.SetDrawColor(255, 255, 255, 100)
				
				for k, point in pairs(self.Points) do
					local t = k + 1
					if k == #self.Points then
						t = 1
					end
					surface.DrawLine(point.x, point.y, self.Points[t].x, self.Points[t].y)
				end
				
				for k, point in pairs(self.Points) do
					local t = k + 1

					surface.DrawRect(point.x - 5, point.y - 5, 10, 10)
				end
	end
end

function PANEL:DoSetup()
	local w = self:GetWide()
	local h = self:GetTall()
	local ply = LocalPlayer()
	
	local wep = LocalPlayer():GetActiveWeapon()
	local gitem = GetGlobalItem(wep.Item)
	
	self.PlayerModel = vgui.Create("DModelPanel", self)
		self.PlayerModel:SetPos(35, self:GetTall() * 0.1)
		self.PlayerModel:SetSize(self:GetWide() * 0.2, self:GetTall() * 0.75)
		self.PlayerModel:SetModel(LocalPlayer():GetModel())
		self.PlayerModel:SetCamPos(Vector(70, 75, 35))
		self.PlayerModel:SetLookAt(Vector(-15, 0, 30))
		self.PlayerModel:SetFOV(50)
		self.PlayerModel.Entity:SetMoveType( MOVETYPE_NONE )
		function self.PlayerModel:LayoutEntity( Entity )
			if wep:IsValid() then
				local hold = LocalPlayer():GetActiveWeapon().HoldType
				
				if hold then
					if hold == "smg" then
						hold = hold.."1"
					end
					local seq = Entity:LookupSequence("idle_"..hold)
					Entity:SetSequence(seq)
				end
			else
				local seq = Entity:LookupSequence("idle_all_02")
				Entity:SetSequence(seq)
			end
			
			Entity:SetAngles( Angle( 0, RealTime() * 10 % 360, 0 ) )
			//Entity:SetAngles(Angle(0, 110, 0))
		end
		
		self.PlayerModel.DrawModel = function()
			local curparent = self.PlayerModel
			local rightx = self.PlayerModel:GetWide()
			local leftx = 0
			local topy = 0
			local bottomy = self.PlayerModel:GetTall()
			local previous = curparent
			while( curparent:GetParent() != nil ) do
				curparent = curparent:GetParent()
				local x, y = previous:GetPos()
				topy = math.Max( y, topy + y )
				leftx = math.Max( x, leftx + x )
				bottomy = math.Min( y + previous:GetTall(), bottomy + y )
				rightx = math.Min( x + previous:GetWide(), rightx + x )
				previous = curparent
			end
			
			local att = self.PlayerModel.Entity:GetAttachment(self.PlayerModel.Entity:LookupAttachment("anim_attachment_RH"))
				if gitem then
					if gitem.EquipmentViewPos then
						self.WeaponModel:SetPos(att.Pos + att.Ang:Forward() * gitem.EquipmentViewPos.x + att.Ang:Right() * gitem.EquipmentViewPos.y + att.Ang:Up() * gitem.EquipmentViewPos.z)
					else
						self.WeaponModel:SetPos(att.Pos)
					end

					if gitem.EquipmentViewAng then
						self.WeaponModel:SetAngles(att.Ang + gitem.EquipmentViewAng)
					else
						self.WeaponModel:SetAngles(att.Ang)
					end
				end
			
			render.SetScissorRect( leftx, topy, rightx, bottomy, true )
				self.PlayerModel.Entity:DrawModel()
				if self.WeaponModel then
					self.WeaponModel:DrawModel()
				end
			render.SetScissorRect( 0, 0, 0, 0, false )
		end
		
		if wep:IsValid() and not string.find(wep:GetClass(), "fists") then
			local wepmodel = ClientsideModel(wep:GetModel(), RENDER_GROUP_OPAQUE_ENTITY)
			local att = self.PlayerModel.Entity:GetAttachment(self.PlayerModel.Entity:LookupAttachment("anim_attachment_RH"))
				wepmodel:SetPos(att.Pos)

				wepmodel:SetAngles(att.Ang)
				
				wepmodel:SetParent(self.PlayerModel.Entity, 5)
				wepmodel:SetNoDraw( true )
				wepmodel:SetIK( false )
				
			self.WeaponModel = wepmodel
		end
		
	local equipment = ply:GetEquipment()		

	self.Equip_Body = vgui.Create("DPanel", self)
		self.Equip_Body:SetPos(w * 0.17, 50)
		self.Equip_Body:SetSize(300, 70)
		
		self.Equip_Body.Paint = function(pnl, pw, ph)
		--	draw.RoundedBox(8, 0, 0, pw, ph, Color(20, 20, 20, 220))
			draw.SlantedRectHorizOffset(0, 0, pw - 2, ph - 2, 10, Color(20, 20, 20, 220), Color(0, 0, 0, 255), 2, 2)
			draw.SimpleText("Armor: ", "hidden14", 15, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			if pnl.Item then
				draw.SimpleText(pnl.Item:GetItemName(), "hidden16", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				local dur = pnl.Item:GetData().Durability
				local maxdur = pnl.Item:GetData().MaxDurability
				
			//	surface.SetDrawColor(10, 10, 10, 255)
			//	surface.DrawRect(20, ph - 22, pw - 40, 10)
				draw.SlantedRectHoriz(40, ph - 18, pw - 80, 10, 6, Color(20, 20, 20, 255), Color(0, 0, 0, 255))
				
			//	surface.SetDrawColor(255 - 255 * (dur / maxdur), 255 * dur * 0.01, 10, 255)
			//	surface.DrawRect(21, ph - 21, pw - 42, 8)
				draw.SlantedRectHoriz(41, ph - 17, (pw - 82) * (dur / maxdur), 8, 6, Color(255 - 255 * (dur / maxdur), 255 * dur * 0.01, 10, 255), Color(0, 0, 0, 255))
			else
				draw.SimpleText("None", "hidden16", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		
	self.Equip_Helm = vgui.Create("DPanel", self)
		self.Equip_Helm:SetPos(w * 0.17, 130)
		self.Equip_Helm:SetSize(300, 70)
		
		self.Equip_Helm.Paint = function(pnl, pw, ph)
			--draw.RoundedBox(8, 0, 0, pw, ph, Color(20, 20, 20, 220))
			draw.SlantedRectHorizOffset(0, 0, pw - 2, ph - 2, 10, Color(20, 20, 20, 220), Color(0, 0, 0, 255), 2, 2)
			draw.SimpleText("Helmet:", "hidden14", 15, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			if pnl.Item then
				draw.SimpleText(pnl.Item:GetItemName(), "hidden16", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				local dur = pnl.Item:GetData().Durability
				local maxdur = pnl.Item:GetData().MaxDurability
				
			//	surface.SetDrawColor(10, 10, 10, 255)
			//	surface.DrawRect(20, ph - 22, pw - 40, 10)
				draw.SlantedRectHoriz(40, ph - 18, pw - 80, 10, 6, Color(20, 20, 20, 255), Color(0, 0, 0, 255))
				
			//	surface.SetDrawColor(255 - 255 * (dur / maxdur), 255 * dur * 0.01, 10, 255)
			//	surface.DrawRect(21, ph - 21, pw - 42, 8)
				draw.SlantedRectHoriz(41, ph - 17, (pw - 82) * (dur / maxdur), 8, 6, Color(255 - 255 * (dur / maxdur), 255 * dur * 0.01, 10, 255), Color(0, 0, 0, 255))
			else
				draw.SimpleText("None", "hidden16", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		
	self.Equip_Access = vgui.Create("DPanel", self)
		self.Equip_Access:SetPos(w * 0.17, 210)
		self.Equip_Access:SetSize(300, 70)
		
		self.Equip_Access.Paint = function(pnl, pw, ph)
		--	draw.RoundedBox(8, 0, 0, pw, ph, Color(20, 20, 20, 220))
			draw.SlantedRectHorizOffset(0, 0, pw - 2, ph - 2, 10, Color(20, 20, 20, 220), Color(0, 0, 0, 255), 2, 2)
			draw.SimpleText("Accessory:", "hidden14", 15, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			if pnl.Item then
				draw.SimpleText(pnl.Item:GetItemName(), "hidden16", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
				local dur = pnl.Item:GetData().Durability
				local maxdur = pnl.Item:GetData().MaxDurability
				
			//	surface.SetDrawColor(10, 10, 10, 255)
			//	surface.DrawRect(20, ph - 22, pw - 40, 10)
				draw.SlantedRectHoriz(40, ph - 18, pw - 80, 10, 6, Color(20, 20, 20, 255), Color(0, 0, 0, 255))
				
			//	surface.SetDrawColor(255 - 255 * (dur / maxdur), 255 * dur * 0.01, 10, 255)
			//	surface.DrawRect(21, ph - 21, pw - 42, 8)
				draw.SlantedRectHoriz(41, ph - 17, (pw - 82) * (dur / maxdur), 8, 6, Color(255 - 255 * (dur / maxdur), 255 * dur * 0.01, 10, 255), Color(0, 0, 0, 255))
			else
				draw.SimpleText("None", "hidden16", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		
		local center = {x = w * 0.8, y = h * 0.5}
		local dist = 70
		local scale = dist / STATS_MAXPERSTAT
		self.ChartBasePoints = {
			[1] = {x = center.x, y = center.y - 50},
			[2] = {x = center.x + 50, y = center.y},
			[3] = {x = center.x, y = center.y + 50},
			[4] = {x = center.x - 50, y = center.y},
		}
		
		self.ChartMidPoints = {
			[1] = {x = center.x, y = center.y - (50 + dist * 0.5)},
			[2] = {x = center.x + (50 + dist * 0.5), y = center.y},
			[3] = {x = center.x, y = center.y + (50 + dist * 0.5)},
			[4] = {x = center.x - (50 + dist * 0.5), y = center.y},
		}
		
		self.ChartMaxPoints = {
			[1] = {x = center.x, y = center.y - (50 + dist)},
			[2] = {x = center.x + (50 + dist), y = center.y},
			[3] = {x = center.x, y = center.y + 50 + dist},
			[4] = {x = center.x - (50 + dist), y = center.y},
		}
		
		self.Stats = LocalPlayer():GetStats()
		
		self.Points = {
					[1] = {x = center.x, y = center.y - (50 + scale * self.Stats[STAT_STRENGTH].Base)},
					[2] = {x = center.x + (50 + scale * self.Stats[STAT_AGILITY].Base), y = center.y},
					[3] = {x = center.x, y = center.y + (50 + scale * self.Stats[STAT_INTELLIGENCE].Base)},
					[4] = {x = center.x - (50 + scale * self.Stats[STAT_ENDURANCE].Base), y = center.y},
				}
				
	local panel1 = vgui.Create("DPanel", self)
		panel1:SetSize(200, 25)
		panel1:SetPos(self.ChartMaxPoints[1].x - 100, self.ChartMaxPoints[1].y - 35)
		panel1:SetToolTip(STATS[STAT_STRENGTH].Description)
			
		panel1.Paint = function(pnl, pw, ph)
			surface.SetDrawColor(20, 20, 20, 240)
			surface.DrawRect(0, 0, pw, ph)
				
			draw.SimpleText(STATS[STAT_STRENGTH].Name..": "..self.Stats[STAT_STRENGTH].Base, "nulshock14", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
			
	local panel2 = vgui.Create("DPanel", self)
		panel2:SetSize(200, 25)
		panel2:SetPos(self.ChartMaxPoints[2].x + 15, self.ChartMaxPoints[2].y - 13)
		panel2:SetToolTip(STATS[STAT_AGILITY].Description)
		
		panel2.Paint = function(pnl, pw, ph)
			surface.SetDrawColor(20, 20, 20, 240)
			surface.DrawRect(0, 0, pw, ph)
			
			draw.SimpleText(STATS[STAT_AGILITY].Name..": "..self.Stats[STAT_AGILITY].Base, "nulshock14", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	local panel3 = vgui.Create("DPanel", self)
		panel3:SetSize(200, 25)
		panel3:SetPos(self.ChartMaxPoints[3].x - 100, self.ChartMaxPoints[3].y + 15)
		panel3:SetToolTip(STATS[STAT_INTELLIGENCE].Description)
		
		panel3.Paint = function(pnl, pw, ph)
			surface.SetDrawColor(20, 20, 20, 240)
			surface.DrawRect(0, 0, pw, ph)
			
			draw.SimpleText(STATS[STAT_INTELLIGENCE].Name..": "..self.Stats[STAT_INTELLIGENCE].Base, "nulshock14", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	local panel4 = vgui.Create("DPanel", self)
		panel4:SetSize(200, 25)
		panel4:SetPos(self.ChartMaxPoints[4].x - 215, self.ChartMaxPoints[4].y - 13)
		panel4:SetToolTip(STATS[STAT_ENDURANCE].Description)
		
		panel4.Paint = function(pnl, pw, ph)
			surface.SetDrawColor(20, 20, 20, 240)
			surface.DrawRect(0, 0, pw, ph)
			
			draw.SimpleText(STATS[STAT_ENDURANCE].Name..": "..self.Stats[STAT_ENDURANCE].Base, "nulshock14", pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
	self:OnChangedEquipment()
end

function PANEL:OnChangedEquipment()
	local ply = LocalPlayer()
	local equipment = ply:GetEquipment()
	--body
	if equipment[EQUIP_ARMOR_BODY] then
		self.Equip_Body.Item = ply:GetItemByID(equipment[EQUIP_ARMOR_BODY])
	else
		self.Equip_Body.Item = nil
	end
	
	--helm
	if equipment[EQUIP_ARMOR_HEAD] then
		self.Equip_Helm.Item = ply:GetItemByID(equipment[EQUIP_ARMOR_HEAD])
	else
		self.Equip_Helm.Item = nil
	end
	
	--accessory
	if equipment[EQUIP_ARMOR_ACCESSORY1] then
		self.Equip_Access.Item = ply:GetItemByID(equipment[EQUIP_ARMOR_ACCESSORY1])
	else
		self.Equip_Access.Item = nil
	end
	
end

function PANEL:UpdatePlayerReductions()
	local ply = LocalPlayer()
	
	local red = ply:GetDamageReduction(DMG_BULLET)
	if red > 0 then
		self.StatusReductions[DMG_BULLET] = {Color(150, 255, 150), "Bullet Damage Reduction: "..(red * 100).."%"}
	elseif red < 0 then
		self.StatusReductions[DMG_BULLET] = {Color(255, 150, 150), "Bullet Damage Increase: "..(red * 100).."%"}
	else
		self.StatusReductions[DMG_BULLET] = {Color(255, 255, 255), "Bullet Damage: 0%"}
	end
	
	red = ply:GetDamageReduction(DMG_BURN)
	if red > 0 then
		self.StatusReductions[DMG_BURN] = {Color(150, 255, 150), "Burning Damage Reduction: "..(red * 100).."%"}
	elseif red < 0 then
		self.StatusReductions[DMG_BURN] = {Color(255, 150, 150), "Burning Damage Increase: "..(red * 100).."%"}
	else
		self.StatusReductions[DMG_BURN] = {Color(255, 255, 255), "Burning Reduction: 0%"}
	end
	
	red = ply:GetDamageReduction(DMG_SLASH)
	if red > 0 then
		self.StatusReductions[DMG_SLASH] = {Color(150, 255, 150), "Cutting Damage Reduction: "..(red * 100).."%"}
	elseif red < 0 then
		self.StatusReductions[DMG_SLASH] = {Color(255, 150, 150), "Cutting Damage Increase: "..(red * 100).."%"}
	else
		self.StatusReductions[DMG_SLASH] = {Color(255, 255, 255), "Cutting Reduction: 0%"}
	end

	red = ply:GetDamageReduction(DMG_CLUB)
	if red > 0 then
		self.StatusReductions[DMG_CLUB] = {Color(150, 255, 150), "Bashing Damage Reduction: "..(red * 100).."%"}
	elseif red < 0 then
		self.StatusReductions[DMG_CLUB] = {Color(255, 150, 150), "Bashing Damage Increase: "..(red * 100).."%"}
	else
		self.StatusReductions[DMG_CLUB] = {Color(255, 255, 255), "Bashing Reduction: 0%"}
	end
	
	red = ply:GetDamageReduction(REDUCTION_SPEED)
	if red > 0 then
		self.StatusReductions[REDUCTION_SPEED] = {Color(255, 150, 150), "Speed Reduction: "..(red * 100).."%"}
	elseif red < 0 then
		self.StatusReductions[REDUCTION_SPEED] = {Color(150, 255, 150), "Speed Increase: "..(red * 100).."%"}
	else
		self.StatusReductions[REDUCTION_SPEED] = {Color(255, 255, 255), "Speed Reduction: 0%"}
	end
end

function PANEL:PerformLayout()
end

function PANEL:Think()
	if self.PlayerModel then
		if self.PlayerModel:GetEntity():GetModel() != LocalPlayer():GetModel() then
			self.PlayerModel:SetModel(LocalPlayer():GetModel())
		end
	end
end

vgui.Register( "dEquipment", PANEL, "Panel" )