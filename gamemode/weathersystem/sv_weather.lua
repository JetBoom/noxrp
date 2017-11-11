local TIME_IN_DAY = 120 --3600 seconds for daytime and night time
GM.WeatherType = WEATHERTYPE_CLEAR

util.AddNetworkString("sendDayTime")
util.AddNetworkString("sendWeatherType")

local SkyFadeTimes = {}
SkyFadeTimes["dawn"] = {
	Interval = {0, TIME_IN_DAY * 0.05},
	TopColor = Vector(0.1, 0.2, 0.3),
	BottomColor = Vector(0.06, 0.05, 0),
	DuskColor = Vector(1, 0.2, 0),
	FadeBias = 0,
	DrawStars = true,
	DuskIntensity = 1,
	Pattern = "f"
}

SkyFadeTimes["noon"] = {
	Interval = {TIME_IN_DAY * 0.05, TIME_IN_DAY * 0.9},
	TopColor = Vector(0.20, 0.50, 1.00),
	BottomColor = Vector(0.80, 1.00, 1.00),
	DuskColor = Vector(0, 0, 0),
	FadeBias = 1,
	DuskIntensity = 1,
	Pattern = "z",
}

SkyFadeTimes["dusk"] = {
	Interval = {TIME_IN_DAY * 0.9, TIME_IN_DAY * 1},
	TopColor = Vector(0.01, 0.02, 0.05),
	BottomColor = Vector(0.06, 0.05, 0),
	DuskColor = Vector(0.5, 0.2, 0),
	FadeBias = 0,
	DrawStars = true,
	DuskIntensity = 0.2,
	Pattern = "f",
}

SkyFadeTimes["night_dusk"] = {
	Interval = {TIME_IN_DAY * 1, TIME_IN_DAY * 1.05},
	TopColor = Vector(0, 0, 0),
	BottomColor = Vector(0, 0, 0),
	DuskColor = Vector(0, 0, 0),
	FadeBias = 0,
	DrawStars = true,
	DuskIntensity = 0
}

SkyFadeTimes["night"] = {
	Interval = {TIME_IN_DAY * 1.05, TIME_IN_DAY * 1.95},
	TopColor = Vector(0, 0, 0),
	BottomColor = Vector(0, 0, 0),
	DuskColor = Vector(0, 0, 0),
	FadeBias = 0,
	DrawStars = true,
	DuskIntensity = 0
}

SkyFadeTimes["night_dawn"] = {
	Interval = {TIME_IN_DAY * 1.95, TIME_IN_DAY * 2},
	TopColor = Vector(0.01, 0.02, 0.05),
	BottomColor = Vector(0.06, 0.05, 0),
	DuskColor = Vector(0.5, 0.2, 0),
	FadeBias = 0,
	DrawStars = true,
	DuskIntensity = 1
}

local DayNight = {}
local ComputeNewLighting = false

function DayNightInit()
	local listsun = ents.FindByClass("env_sun")
	if ( #listsun > 0 ) then
		DayNight.EnvSun = listsun[1]
	end
	
	local listpaint = ents.FindByClass("env_skypaint")
	if ( #listpaint > 0 ) then
		DayNight.SkyPaint = listpaint[1]
	end
	
	local listlight = ents.FindByClass("light_environment")
	if ( #listlight > 0 ) then
		DayNight.LightEnv = listlight[1]
		
		DayNight.LightEnv:Fire("FadeToPattern", "a", 0)
		DayNight.LightEnv:Activate()
	end
	
	GAMEMODE.CurrentTime = 0
	
	DayNight.PreviousSky = "night_dawn"
	DayNight.CurrentSky = "dawn"
	DayNight.CurrentSkySettings = table.Copy(SkyFadeTimes["dawn"])
end
hook.Add("InitPostEntity", "DayNightInitialize", DayNightInit)

//abcdefghijklmnopqrstuvwxyz
function DayNight.DayThink()
	DayNight.CurrentSky = DayNight.CurrentSky or "dawn"
	DayNight.CurrentSkySettings = DayNight.CurrentSkySettings or table.Copy(SkyFadeTimes["dawn"])
	local degr = (GAMEMODE.CurrentTime / TIME_IN_DAY)
	
	GAMEMODE.CurrentTime = GAMEMODE.CurrentTime + FrameTime()
	
	net.Start("sendDayTime")
		net.WriteFloat(GAMEMODE.CurrentTime)
	net.Send(player.GetAll())
		
	local currentsky = SkyFadeTimes[DayNight.CurrentSky]
	local prevsky = SkyFadeTimes[DayNight.PreviousSky]
		
	local pattern
	local int
	local amb
	
	if GAMEMODE.CurrentTime > currentsky.Interval[2] then
		//Change from dawn to noon
		if DayNight.CurrentSky == "dawn" then
			DayNight.CurrentSky = "noon"
			DayNight.PreviousSky = "dawn"
			pattern = "m"
			int = "240 187 117 1000"
			amb = "135 172 180 150"
		//Change from noon to dusk
		elseif DayNight.CurrentSky == "noon" then
			DayNight.CurrentSky = "dusk"
			DayNight.PreviousSky = "noon"
			pattern = "d"
			int = "237 218 143 800"
			amb = "190 201 220 100"
		//Change from dusk to dusk_night (the difference between this and dusk is this is a bit lighter)
		elseif DayNight.CurrentSky == "dusk" then
			DayNight.CurrentSky = "night_dusk"
			DayNight.PreviousSky = "dusk"
			pattern = "a"
			int = "235 166 71 1000"
			amb = "135 172 180 150"
		//Change from night_dusk to night
		elseif DayNight.CurrentSky == "night_dusk" then
			DayNight.CurrentSky = "night"
			DayNight.PreviousSky = "night_dusk"
			pattern = "a"
			int = "175 230 239 65"
			amb = "83 104 130 50"
		//Change from night to night_dawn
		elseif DayNight.CurrentSky == "night" then
			DayNight.CurrentSky = "night_dawn"
			DayNight.PreviousSky = "night"
			pattern = "a"
			int = "175 230 239 65"
			amb = "83 104 130 50"
		//Change from night_dawn to dawn
		else
			DayNight.CurrentSky = "dawn"
			DayNight.PreviousSky = "night_dawn"
			pattern = "d"
			int = "240 187 117 1000"
			amb = "135 172 180 150"
		end
		
		ComputeNewLighting = true
		currentsky = SkyFadeTimes[DayNight.CurrentSky]
	end
	
	if GAMEMODE.CurrentTime > (TIME_IN_DAY * 2) then
		GAMEMODE.CurrentTime = 0
		DayNight.CurrentSky = "dawn"
		DayNight.PreviousSky = "night_dawn"
		
		//Generate new weather
		GAMEMODE.WeatherType = WEATHERTYPE_CLEAR
		
		net.Start("sendWeatherType")
			net.WriteInt(GAMEMODE.WeatherType, 8)
		net.Send(player.GetAll())
	end
		
		
	local timet = currentsky.Interval[2] - currentsky.Interval[1]
	local intrv = FrameTime() * 0.3

	DayNight.CurrentSkySettings.TopColor = LerpVector(intrv, DayNight.CurrentSkySettings.TopColor, currentsky.TopColor)
	DayNight.CurrentSkySettings.BottomColor = Lerp(intrv, DayNight.CurrentSkySettings.BottomColor, currentsky.BottomColor)
	DayNight.CurrentSkySettings.DuskColor = Lerp(intrv, DayNight.CurrentSkySettings.DuskColor, currentsky.DuskColor)
	DayNight.CurrentSkySettings.FadeBias = Lerp(intrv, DayNight.CurrentSkySettings.FadeBias, currentsky.FadeBias)
	DayNight.CurrentSkySettings.DuskIntensity = Lerp(intrv, DayNight.CurrentSkySettings.DuskIntensity, currentsky.DuskIntensity)
		
	if IsValid(DayNight.SkyPaint) then
		DayNight.SkyPaint:SetTopColor(DayNight.CurrentSkySettings.TopColor)
		DayNight.SkyPaint:SetBottomColor(DayNight.CurrentSkySettings.BottomColor)
		DayNight.SkyPaint:SetDuskColor(DayNight.CurrentSkySettings.DuskColor)
		DayNight.SkyPaint:SetFadeBias(DayNight.CurrentSkySettings.FadeBias)
		DayNight.SkyPaint:SetDrawStars(currentsky.DrawStars or false)
		DayNight.SkyPaint:SetDuskIntensity(DayNight.CurrentSkySettings.DuskIntensity)
		if currentsky.DrawStars then
			DayNight.SkyPaint:SetStarSpeed( 0.01 )
			DayNight.SkyPaint:SetStarScale( 0.5 )
			DayNight.SkyPaint:SetStarFade( 1.5 )
			DayNight.SkyPaint:SetStarTexture( "skybox/starfield" )
		end
	end
		
	if IsValid(DayNight.LightEnv) and ComputeNewLighting then
		ComputeNewLighting = false
		DayNight.LightEnv:Fire("FadeToPattern", pattern, 0)
		DayNight.LightEnv:Activate()
			
			--engine.LightStyle(0, "a")
			--ClientDownloadLightmaps()
	end
	
	DayNight.SunDir = Vector(math.cos(degr * math.pi), 0, math.sin(degr * math.pi))
	
	if IsValid(DayNight.EnvSun) then
		DayNight.EnvSun:SetKeyValue("sun_dir", tostring(DayNight.SunDir))
	end
end
hook.Add("Think", "DayNight.SunThink", DayNight.DayThink)

function ClientDownloadLightmaps()
	for k,v in pairs(player.GetAll()) do
		v:SendLua("render.RedownloadAllLightmaps()")
	end
end

function SetWorldTime(pl, cmd, args)
	if not pl:IsSuperAdmin() then return end
	
	GAMEMODE.CurrentTime = tonumber(args[1])
end
concommand.Add("noxrp_time_set", SetWorldTime)
