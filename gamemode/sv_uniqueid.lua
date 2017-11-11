function GetUID()
	local num = (tonumber(file.Read("noxrp/uid.txt") or 2049) or 2049) + 1
	file.Write("noxrp/uid.txt", num)

	return num
end
