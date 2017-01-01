pixelFunction = {}

function pixelFunction.allwhite(x,y,r,g,b,a)
	r, g, b, a = 255, 255, 255, 255
	return r, g, b, a
end

function pixelFunction.fill(x, y, r, g, b, a)
	
	if r ~= currentcolor[1] then
	r, g, b = currentcolor
	end
	return x, y, r, g, b, a
end

function floodFill(x, y, tc, rc)
	--while newdata:
end