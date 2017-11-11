function LockDoor(pl, key)
	if key == IN_USE and pl:KeyDown(IN_ATTACK2) then
		pl:ConCommand("lockthisdoor")
	end
end
hook.Add("KeyPress", "PlayerLockDoor", LockDoor)