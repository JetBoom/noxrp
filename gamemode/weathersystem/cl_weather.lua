//local TIME_IN_DAY = 3600
local TIME_IN_DAY = 120

GM.CurrentTime = 0
GM.CurrentFogPercent = 0
GM.WeatherType = WEATHERTYPE_CLEAR

function ReceiveWeatherType()
	local weather = net.ReadInt(8)
	
	if GAMEMODE.WeatherType == WEATHERTYPE_RAIN then
		hook.Remove("PostDrawOpaqueRenderables", "Weather.DrawRain")
	end
	
	GAMEMODE.WeatherType = weather
	
	if GAMEMODE.WeatherType == WEATHERTYPE_RAIN then
		hook.Add("PostDrawOpaqueRenderables", "Weather.DrawRain", RenderRain)
	end
end

function RenderRain()
	if GAMEMODE.WeatherType == WEATHERTYPE_RAIN then
		
	end
end

function ReceiveDayTime()
	GAMEMODE.CurrentTime = net.ReadFloat()
	
	if GAMEMODE.CurrentTime > TIME_IN_DAY and GAMEMODE.CurrentTime < TIME_IN_DAY * 2 then
		GAMEMODE.CurrentFogPercent = math.Approach(GAMEMODE.CurrentFogPercent, 1, FrameTime() * 0.2)
	else
		GAMEMODE.CurrentFogPercent = math.Approach(GAMEMODE.CurrentFogPercent, 0, FrameTime() * 0.2)
	end
end
net.Receive("sendDayTime", ReceiveDayTime)

function WeatherWorldFog()
	render.FogMode(1) 
	render.FogStart(0)
	render.FogEnd(0)
	render.FogMaxDensity(0.87 * GAMEMODE.CurrentFogPercent)

	render.FogColor(0.01 * 255, 0.01 * 255, 0.01 * 255)
		
	return true
end
hook.Add( "SetupWorldFog", "Time.WorldFog", WeatherWorldFog )

function WeatherSkyFog( skyboxscale )
	render.FogMode(1) 
	render.FogStart(0)
	render.FogEnd(0)
	render.FogMaxDensity(0.97 * GAMEMODE.CurrentFogPercent)

	render.FogColor(0.01 * 255, 0.01 * 255, 0.01 * 255 )
	return true
end
hook.Add( "SetupSkyboxFog", "Time.SkyFog", WeatherSkyFog )