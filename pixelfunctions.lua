pixelFunction = {}

function pixelFunction.allwhite(x,y,r,g,b,a)
	r, g, b, a = 255, 255, 255, 0
	return r, g, b, a
end

function pixelFunction.clear(x,y,r,g,b,a)
	r, g, b, a = 255, 255, 255, 0
	return r, g, b, a
end

function biggerPencil(x, y, size, color)
	if not tmath.Within(x, y, currentData:getWidth(), currentData:getHeight()) then return end
	if x == touchx + size then return end
	if y == touchy + size then return end
	currentData:setPixel(x, y, color)
	x = x + 1
	return biggerPencil(x, y, size, color)
end

function floodFill(x, y, target_color, replacement_color)
	if not tmath.Within(x, y, currentData:getWidth(), currentData:getHeight()) then return
	elseif target_color == replacement_color then return
	elseif currentData:getPixel(x, y) ~= target_color then return
	else
	currentData:setPixel(x, y, replacement_color)
	floodFill(x, y + 1, target_color, replacement_color)
	floodFill(x, y - 1, target_color, replacement_color)
	floodFill(x - 1, y, target_color, replacement_color)
	floodFill(x + 1, y, target_color, replacement_color)
	return floodFill(x, y, target_color, replacement_color)
	end
end
