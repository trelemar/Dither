local tmath = {}

function tmath.distanceFromCenter(x, w)
	return math.abs(x - (w / 2))
end

return tmath