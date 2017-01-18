local tmath = {}

function tmath.distanceFromCenter(x, w)
	return math.abs(x - (w / 2))
end

function tmath.Within(x, y, w, h)
	local bool
	if x > 0 and x <= w and y > 0 and y <= h then bool = true
	else bool = false end
	return bool
end

return tmath