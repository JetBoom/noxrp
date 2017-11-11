CreateClientConVar("noxrp_viewedhelp", 0, true, true)

local PANEL = {}

local HelpTopics = {
"Introduction",
"Server Rules",
"Getting Started",
"Skills/Stats",
"Crafting",
"Guns",
"Tools",
"Commands"
}

local HTMLPanel = {}
HTMLPanel[1] = [[<p>Welcome to NoxRP, an upcoming RP/RPG gamemode for Garry's mod. It is currently in very early alpha, but new features are constantly being added.</p>
<p>Click on the various topics on the left for more information.</p>
]]

HTMLPanel[2] = [[<center><p>Here is a list of the various rules and guidelines:</p></center>
<ol>
<li>Don't cheat or exploit. Report any exploits you find.</li>
<li>Follow the other NoXiousNet rules and use common sense.</li>
</ol>
]]

HTMLPanel[3] = [[<center><span style="font-size:18px;color:#196CE8;text-decoration:underline;">Creating a Character</span></center>
<p>When first joining, you can create a new character by pressing the 'New Character' button at the bottom.
On the second page, you will be selecting your model. This is going to be your main model, so choose wisely.
On the third page, you will be selecting your stats. Each stat has its own purpose, listed in each box. You have a base allocation of ]]..STATS_FREEPOINTS..[[ to use, but you can freely distribute the rest of the points with a penalty to those. The minimum points you can have in a stat is 1, and the max is ]]..STATS_MAXPERSTAT..[[
On the final page, you will be selecting a skill to start with. Selecting one will put some points automatically into it, giving a slight start into that specific skill. Unlike stats, skills are more specific and only benefit select things.</p>
<p>Once you created your character and spawn, you will spawn somewhere in the town. There are a few notes about this:</p>
<ul>
<li>Police will patrol the streets. Put your weapon/gun away when walking near them (Default: Z (Zoom key)) or they will get upset at you.</li>
<li>You can press use on certain merchants to talk with them.</li>
<li>Players can kill each other wherever. However, they lose karma upon doing so, at which low karma will have all police shoot on sight at them.</li>
<li>-In addition, players being fired at can type /police, which alerts any nearby police to run to their location and assist them. If their karma is too low however, then they won't bother.</li>
<li>Police have very powerful guns to keep the peace. Killing them won't drop it, but they might drop other items. Be prepared for the huge karma loss!</li>
<li>In addition to the previous points about karma, players killed that have low karma will award positive karma to the killer, and vice versa. Don't be surprised if someone tries to kill you for a bounty.</li>
</ul>
<p>So, you might be wondering on where to go from here. The big point about this gamemode is there is no 'main objective'. The objective is to do what you wish, whether that be make guns
and go on a killing spree or just be a miner and mine rare ores. The world will react to whatever you choose. If you go on a killing spree, the police will try to hunt you down, or even a player.
If you try to mine rare ores, you might uncover an unknown area that is full of monsters, or even a map transition to another map!</p>
<center><span style="font-size:18px;color:#196CE8;text-decoration:underline;">Getting Money</span></center>
<p>One of the things you will need if you wish to interact with other players or merchants is money. Money can be acquired in a few ways:</p>
<ol>
<li>Killing monsters. Killing them will drop a small amount of money. In addition, you can sell whatever they drop to merchants that would want to buy them.</li>
<li>Crafting items. Crafting items and selling them to either players or merchants will give you money.</li>
]]

HTMLPanel[4] = [[<center><span style="font-size:18px;color:#196CE8;">Skills</span></center>
<p>There are currently a list of 7 to level. Leveling skills will let the player achieve greater things, such as causing knives to bleed or having fists knock people down.
Below is a list of the current skills and their descriptions and uses.</p>
<center><span style="font-size:18px;text-decoration:underline;">Combat Skills</span></center>
<ul>
<li><span style="color:#196CE8;">]]..SKILLS[SKILL_GUNNERY].Name..[[</span>: ]]..SKILLS[SKILL_GUNNERY].Descrip..[[
 A higher skill in gunnery allows the user to use and modify higher-end weapons. Does not affect direct weapon stats, but offers a more technical bonus.</li>
<li><span style="color:#196CE8;">]]..SKILLS[SKILL_BLADEWEAPONS].Name..[[</span>: ]]..SKILLS[SKILL_BLADEWEAPONS].Descrip..[[
 A higher skill in Blade Weapons allows the user to be more effective with knives and swords. Such examples are throwing weapons or causing bleeding with strikes.</li>
<li><span style="color:#196CE8;">]]..SKILLS[SKILL_BLUNTWEAPONS].Name..[[</span>: ]]..SKILLS[SKILL_BLUNTWEAPONS].Descrip..[[
 A higher skill in Blunt Weapons allows the user to be more effective with hammers and other blunt weapons. Such examples are causing shockwaves or knocking targets back.</li>
<li><span style="color:#196CE8;">]]..SKILLS[SKILL_UNARMED].Name..[[</span>: ]]..SKILLS[SKILL_UNARMED].Descrip..[[
 Examples of effects are knocking down targets and causing rapid but weak damage.</li>
<center><span style="font-size:18px;text-decoration:underline;">Crafting Skills</span></center>
<li><span style="color:#196CE8;">]]..SKILLS[SKILL_GUNSMITHING].Name..[[</span>: ]]..SKILLS[SKILL_GUNSMITHING].Descrip..[[
 A crafting skill for crafting and maintaining guns. A higher level allows for the crafter to make difficulty recipes easier and repair weapons. Recipes include all weapons and ammo.</li>
<li><span style="color:#196CE8;">]]..SKILLS[SKILL_ENGINEERING].Name..[[</span>: ]]..SKILLS[SKILL_ENGINEERING].Descrip..[[
 A crafting skill for crafting and maintaining armors and equipment. Allows the crafter to create usable equipment. Recipes include armors, general equipment, and vehicle parts.</li>
<li><span style="color:#196CE8;">]]..SKILLS[SKILL_ELECTRONICS].Name..[[</span>: ]]..SKILLS[SKILL_ELECTRONICS].Descrip..[[
 A crafting skill for crafting and maintaining electronics. Recipes include electronics, tools, and various other items.</li>
</ul>
<br>
<center><span style="font-size:18px;color:#196CE8;text-decoration:underline;">Stats</span></center>
<p>There are currently a list of 4 stats to level. Stats do not directly affect specific areas, but rather are more general.</p>
<ul>
<li><span style="color:#196CE8;">]]..STATS[STAT_STRENGTH].Name..[[</span>: ]]..STATS[STAT_STRENGTH].Description..[[
 While the skills give the effects of using melee weapons, this directly increases how hard the player can hit with them. Also affects how much equipment the player can carry. Slightly affects max health.</li>
<li><span style="color:#196CE8;">]]..STATS[STAT_AGILITY].Name..[[</span>: ]]..STATS[STAT_AGILITY].Description..[[
 With a higher level in this, it allows the user to perform more acrobatic moves, such as wall-jumping and wall-hanging. Also increases run speed.</li>
<li><span style="color:#196CE8;">]]..STATS[STAT_INTELLIGENCE].Name..[[</span>: ]]..STATS[STAT_INTELLIGENCE].Description..[[
 A higher level in this allows the user to more efficiently craft items, reducing crafting costs as well as others. Also affects conversations with NPCs.</li>
<li><span style="color:#196CE8;">]]..STATS[STAT_ENDURANCE].Name..[[</span>: ]]..STATS[STAT_ENDURANCE].Description..[[
 A higher level in this increases the stamina and health of the player, increasing their endurance for running and taking hits. A higher level also lets the player resist diseases easier.</li>
</ul>
]]

/*HTMLPanel[6] = [[<p>The typical type of weapon to use. While it deals more damage than melee and gadgets, it is also much harder to maintain: ammo, repairing. Weapons below a threshold in durability start to suffer penalities, and completely break at low durabilities and must be repaired to use.</p>
<p>In the above picture, this shows the typical HUD that will be displayed on guns:</p>
<p>(1): The ammo count. Shows the ammo left in the magazine compared to the maximum ammo that can be in it.
<br>
(2): The icon. A quick idea of the current weapon. Also displays short-hand letters of any equipped E-chips.
<br>
(3): Reserve ammo. Shows reserve bullets to reserve ammo boxes in the inventory.
<br>
(4): The weapon's durability. Keep an eye on it so your weapon doesn't break.</p>
]]*/

HTMLPanel[8] = [[<center>List of commands available:</center>
<br>
<center>General Commands</center>
<ul>
<li>F1: Opens the main menu.</li>
<li>F3: Opens the inventory.</li>
<li>Context Menu: Allows world interaction. Click on items and entities to bring up a list of options.</li>
</ul>
<center>Chat Commands</center>
<ul>
<li>/police, !police: If attacked, calls the closest police to your location.</li>
<li>// - Global Chat</li>
<li>/w - Whisper Chat</li>
</ul>
<center>Item Interaction</center>
<ul>
<li>[Use]: Puts the item into your inventory if you have room.</li>
<li>[Shift + Use]: Put the item into your hands to hold.</li>
<li>[Attack1 | Holding Item]: Throws an item you are currently holding.</li>
</ul>
<center>Property Item Interaction</center>
<ul>
<li>[Use]: Use locked down item.</li>
<li>[Walk | Holding Item]: Locks down an item you are currently holding.</li>
<li>[Shift + Use | If propety owner]: Picks up the item into your inventory.</li>
<li>[Shift + Use | If not property owner]: If the item is listed for sale, then tries to buy the item for the listed price.</li>
</ul>
]]

local TopicPanel = {}
TopicPanel[1] = {
	Paint = function()
	end,
	
	HTML = function(self, htmlpanel)
			htmlpanel:SetHTML([[<html>
					<head>
					<style type="text/css">
					body
					{
						font-family: "Times New Roman"
						font-size:14px;
						color:white;
						background-color:none;
						width:]].. htmlpanel:GetWide() - 48 ..[[px;
					}
					div p
					{
						margin:10px;
						padding:2px;
					}
					</style>
					</head>
					<body>
			<center><span style="font-size:22px;font-weight:bold;color:#196CE8;text-decoration:underline;">]]..HelpTopics[1]..[[</span>
			</center><div>]]..HTMLPanel[1]..[[</div>
			</body>
			</html>]])
		end
}

TopicPanel[2] = {
	Paint = function()
	end,
	
	HTML = function(self, htmlpanel)
		htmlpanel:SetHTML([[<html>
					<head>
					<style type="text/css">
					body
					{
						font-family: "Times New Roman"
						font-size:14px;
						color:white;
						background-color:none;
						width:]].. htmlpanel:GetWide() - 48 ..[[px;
					}
					div p
					{
						margin:10px;
						padding:2px;
					}
					</style>
					</head>
					<body>
			<center><span style="font-size:22px;font-weight:bold;color:#196CE8;text-decoration:underline;">]]..HelpTopics[2]..[[</span>
			</center><div>]]..HTMLPanel[2]..[[</div>
			</body>
			</html>]])
	end
}

TopicPanel[3] = {
	Paint = function()
	end,
	
	HTML = function(self, htmlpanel)
		htmlpanel:SetHTML([[<html>
					<head>
					<style type="text/css">
					body
					{
						font-family: "Times New Roman"
						font-size:14px;
						color:white;
						background-color:none;
						width:]].. htmlpanel:GetWide() - 48 ..[[px;
					}
					div p
					{
						margin:10px;
						padding:2px;
					}
					</style>
					</head>
					<body>
			<center><span style="font-size:22px;font-weight:bold;color:#196CE8;text-decoration:underline;">]]..HelpTopics[3]..[[</span>
			</center><div>]]..HTMLPanel[3]..[[</div>
			</body>
			</html>]])
	end
}

TopicPanel[4] = {
	Paint = function()
	end,
	
	HTML = function(self, htmlpanel)
		htmlpanel:SetHTML([[<html>
					<head>
					<style type="text/css">
					body
					{
						font-family: "Times New Roman"
						font-size:14px;
						color:white;
						background-color:none;
						width:]].. htmlpanel:GetWide() - 48 ..[[px;
					}
					div p
					{
						margin:10px;
						padding:2px;
					}
					</style>
					</head>
					<body>
			<center><span style="font-size:22px;font-weight:bold;color:#196CE8;text-decoration:underline;">]]..HelpTopics[4]..[[</span>
			</center><div>]]..HTMLPanel[4]..[[</div>
			</body>
			</html>]])
	end
}

/*TopicPanel[6] = {
	Paint = function(self, pnl, pw, ph)
		draw.RoundedBoxEx(8, pw * 0.5 - 100, 20, 200, 100, Color(20, 20, 20, 150), true, false, true, false)
		
		draw.SimpleText("a", "csKillIcons_HudL_NA", pw * 0.5 + 90, 35, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		draw.SimpleText("10/12", "hidden28", pw * 0.5 - 5, 30, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		draw.SimpleText("8 // 0", "hidden18", pw * 0.5 - 5, 65, Color(255, 255, 100), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		
		surface.SetDrawColor(20, 20, 20, 220)
		surface.DrawRect(pw * 0.5 - 90, 110, 140, 6)
		
		local dur = 75
		surface.SetDrawColor(Color(255 - 255 * dur * 0.01, 255 * dur * 0.01, 0))
		surface.DrawRect(pw * 0.5 - 89, 111, 138 * dur * 0.01, 4)
		
		draw.SimpleText("(1)", "hidden14", pw * 0.5 - 50, 25, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("(2)", "hidden14", pw * 0.5 + 80, 25, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("(3)", "hidden14", pw * 0.5 - 80, 70, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("(4)", "hidden14", pw * 0.5, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end,
	
	HTML = function(self, htmlpanel)
		htmlpanel:SetHTML([[<html>
					<head>
					<style type="text/css">
					body
					{
						font-family: "Times New Roman"
						font-size:14px;
						color:white;
						background-color:none;
						width:]].. htmlpanel:GetWide() - 48 ..[[px;
					}
					div p
					{
						margin:10px;
						padding:2px;
					}
					</style>
					</head>
					<body>
			<center><span style="font-size:22px;font-weight:bold;color:#196CE8;text-decoration:underline;">]]..HelpTopics[6]..[[</span>
			</center><div>]]..HTMLPanel[6]..[[</div>
			</body>
			</html>]])
	end
}*/

TopicPanel[8] = {
	Paint = function()
	end,
	
	HTML = function(self, htmlpanel)
		htmlpanel:SetHTML([[<html>
					<head>
					<style type="text/css">
					body
					{
						font-family: "Times New Roman"
						font-size:14px;
						color:white;
						background-color:none;
						width:]].. htmlpanel:GetWide() - 48 ..[[px;
					}
					div p
					{
						margin:10px;
						padding:2px;
					}
					</style>
					</head>
					<body>
			<center><span style="font-size:22px;font-weight:bold;color:#196CE8;text-decoration:underline;">]]..HelpTopics[8]..[[</span>
			</center><div>]]..HTMLPanel[8]..[[</div>
			</body>
			</html>]])
	end
}

function PANEL:Init()						
	local w = ScrW()
	local h = ScrH()
	
	AddOpenedVGUIElement(self)
	
	RunConsoleCommand("noxrp_viewedhelp", 1)
	
	self:SetPos(w * -1, 0)
	self:SetSize(w, h)
	//Has the menu move onto the screen
	self:MoveTo(0, 0, 0.25, 0, 0.5)
	
	self.MainTopic = -1
	
	local mainpanel = vgui.Create("DPanel", self)
		mainpanel:SetPos(self:GetWide() * 0.4, 5)
		mainpanel:SetSize(self:GetWide() * 0.6 - 10, self:GetTall())
		mainpanel.Paint = function()
		end
		
	self.ChildrenPanel = mainpanel
	
	local htmlpanel = vgui.Create("DHTML", mainpanel)
		htmlpanel:SetPos(5, 140)
		htmlpanel:SetSize(mainpanel:GetWide() - 10, self:GetTall() - 150)
		
	local width = self:GetWide() * 0.3 - 20
	for k, v in pairs(HelpTopics) do
		local ypos = 90 + (k - 1) * 45
		
		local helpbtn = vgui.Create("dMainMenuButton", self)
			helpbtn:SetSize(width, 35)
			helpbtn:SetPos(15, ypos)
			helpbtn.v_Text = v
			helpbtn:SetIcon("icon16/comment.png")
			helpbtn:Setup()
			if not TopicPanel[k] then
				helpbtn:SetTextColor(Color(255, 90, 90))
				helpbtn:SetTextHoverColor(Color(255, 40, 40))
				helpbtn.v_Text = helpbtn.v_Text.." [WIP]"
			else
				helpbtn.DoClick = function(btn)
					surface.PlaySound("buttons/button9.wav")
					self.MainTopic = k
					
					self.ChildrenPanel.Paint = TopicPanel[k].Paint
					//htmlpanel:SetHTML(TopicPanel[k].HTML)
					TopicPanel[k]:HTML(htmlpanel)
				end
			end
	end
	
	local backbtn = vgui.Create("dMainMenuButton", self)
		backbtn:SetSize(120, 25)
		backbtn:SetPos(15, 90 + 45 * #HelpTopics)
		if self.FromMainMenu then
			backbtn.v_Text = "Back"
		else
			backbtn.v_Text = "Exit"
		end
		backbtn:SetIcon("icon16/arrow_left.png")
		backbtn:Setup()
		backbtn.DoClick = function(btn)
			surface.PlaySound("buttons/button9.wav")
			self:DoRemove()
		end
end

local gradient = surface.GetTextureID("gui/gradient")
function PANEL:Paint( w, h )
	Derma_DrawBackgroundBlur(self, 0)
	
	surface.SetTexture(gradient)
	surface.SetDrawColor(20, 20, 20, 200)
	
	surface.DrawTexturedRect(0, 0, w * 0.4, h)
	
	surface.SetDrawColor(0, 0, 0, 250)
	surface.DrawTexturedRect(0, 10, 240, 30)
	draw.SimpleText("Help", "hidden18", 15, 25, Color(180, 180, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:Think()
end

function PANEL:DoRemove()
	LocalPlayer().v_HelpMenu = nil
	
	RemoveVGUIElement(self)
	
	if self.FromMainMenu then
		LocalPlayer().v_MainMenu = vgui.Create("dMainMenu")
	end
	self:Remove()
end

vgui.Register( "dHelpMenu", PANEL, "EditablePanel" )