local ITEM = {}
ITEM.DataName = "item__base"
ITEM.IsBase = true

ITEM.Description = "BASE ITEM"
ITEM.ToolTip = ""

ITEM.Draw3DName = true
	--If set to true, then overrides the base draw function completely, and lets LocalDraw do everything
ITEM.OverrideDraw = false

--Called from the cl_init on the entity item__base.
--Does drawing of the item
function ITEM:LocalDraw()
	self:DrawModel()
end

RegisterItem(ITEM)