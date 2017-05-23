local tmath = {}

function tmath.distanceFromCenter(x, w)
	return math.abs(x - (w / 2))
end

function tmath.Within(x, y, w, h)
	local bool
	if x >= 0 and x < w and y >= 0 and y < h then bool = true
	else bool = false end
	return bool
end

function tmath.getDPI()
	local ps = love.window.getPixelScale()
	local dpi = nil
	if ps <= 1 then dpi = "mdpi"
	elseif ps <= 1.5 then dpi = "hdpi"
	elseif ps <= 2 then dpi = "xhdpi"
	elseif ps <= 3 then dpi = "xxhdpi"
	else dpi = "xxxhdpi"
	end
	
	return dpi
end

return tmath