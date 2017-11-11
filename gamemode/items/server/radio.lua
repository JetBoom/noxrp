local ITEM = {}
ITEM.DataName = "radio"

ITEM.RequiresPower = true
ITEM.PowerConsumptionRate = 0.5

function ITEM:SetupLocalVars()
	self.Power = false
	self.IsPowered = false
	self.Frequency = 102.2
end

function ITEM:OnUseLocked(pl)
end
	
function ITEM:TogglePower(pl)
end

function ITEM:PlayerCanHearRadio(pl)
	return pl:GetPos():Distance(self:GetPos()) < 600
end
	
function ITEM:OnReceiveText(pl, text, distance)
	local str = ""
	
	local tab = {}
	if string.sub(text, 1, 2) == "/w" then
		text = string.sub(text, 4)
		tab.Color = Color(255, 255, 150, 255)
		str = "[W] - "
	else
		tab.Color = Color(200, 255, 255, 255)
	end
	tab.LifeTime = 5
		
	local modtext = ""
	if distance > 100 then
		local scramble = (600 - distance) * 0.002
		--1 is perfect quality, 0 is worst (inaudable)
			
		local num
		if string.sub(text, 1, 1) == "/" then
			num = string.len(text) - 4
		else
			num = string.len(text)
		end
			
		if scramble >= 0.7 then
			str = str.."("..pl:Nick().."): "
		else
			str = str.."(???): "
		end
			
		local scrambleamount = math.ceil(num - num * scramble)
		local scrambles = {}
		
		if scrambleamount > 0 then
			for i = 1, scrambleamount do 
				local val = math.random(num)
				table.insert(scrambles, val)
			end
				
			table.sort(scrambles)

			local lastindex = 1
			for index, var in pairs(scrambles) do
				modtext = modtext..string.sub(text, lastindex, var - 1).."~"
				lastindex = var + 1
			end
				
			modtext = modtext..string.sub(text, lastindex)
				
			self:EmitSound("noxrp/static.wav", 100, math.random(75, 120), 0.3)
		end
	else
		str = str.."("..pl:Nick().."): "
		modtext = text
			
		self:EmitSound("buttons/blip1.wav", 100, math.random(95, 105), 0.5)
	end
		
	tab.Text = str..modtext
		
	BroadcastLocalOverheadText(tab, self)
end

function ITEM:OnPowered(powerbox)
end

function ITEM:OnLosePower(powerbox)
end

RegisterItem(ITEM)