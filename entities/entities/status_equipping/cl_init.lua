include("shared.lua")
ENT.DisplayOnHud = true

function ENT:PanelDraw(x,y)
	draw.SlantedRectHorizOffset(x, y, self.TextWidth, 35, 15, Color(0, 0, 0, 180), Color(0, 0, 0, 190), 2, 2)
	draw.DrawText(self.NameSTR, "hidden12", x + 14, y + 4, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		
	draw.SlantedRectHoriz(x + 5, y + 20, 180, 10, 15, Color(0, 0, 0, 255),Color(0, 0, 0, 190))
		
	surface.SetDrawColor(0, 255, 0, 255)
	draw.SlantedRectHoriz(x + 6, y + 21, 178 - 178 * math.max((self:GetDTFloat(0) - CurTime()) / (self:GetDTFloat(0) - self.Created), 0), 8, 15, Color(0, 100, 255, 255), Color(0, 0, 0, 190))
end

function ENT:Initialize()
	if self:GetOwner() ~= LocalPlayer() then return end
	self:DrawShadow(false)
	self.Created = CurTime()

	local owner = self:GetOwner()
	
	local id = self:GetItemID()
	local pitem = LocalPlayer():GetItemByID(id)
	local item = ITEMS[pitem.Name]
		
	if owner:GetEquipmentSlot(EQUIP_ARMOR_BODY) == id or owner:GetEquipmentSlot(EQUIP_ARMOR_HEAD) == id or owner:GetEquipmentSlot(EQUIP_ARMOR_ACCESSORY1) == id then
		self.NameSTR = "Unequipping: "
	else
		self.NameSTR = "Equipping: "
	end
		
	self.NameSTR = self.NameSTR..pitem:GetItemName()
	
	surface.SetFont("hidden12")
	local tw1, th1 = surface.GetTextSize(self.NameSTR)

	self.TextWidth = math.max(tw1 + 30, 200)
end

function ENT:OnInitialize()
	AddLocalStatus(self)
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() and owner[self:GetClass()] == self then
		owner[self:GetClass()] = nil
	end
	
	RemoveLocalStatus(self)
end

