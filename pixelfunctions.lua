pixelFunction = {}

function pixelFunction.allwhite(x,y,r,g,b,a)
	r, g, b, a = 255, 255, 255, 0
	return r, g, b, a
end

function pixelFunction.clear(x,y,r,g,b,a)
	r, g, b, a = 255, 255, 255, 0
	return r, g, b, a
end

function floodFill(x, y, target_color, replacement_color)
	if y <= 0 or y >= newdata:getHeight() or x <= 0 or x >= newdata:getWidth() then return
	elseif target_color == replacement_color then return
	elseif newdata:getPixel(x, y) ~= target_color then return
	else
	newdata:setPixel(x, y, replacement_color)
	floodFill(x, y + 1, target_color, replacement_color)
	floodFill(x, y - 1, target_color, replacement_color)
	floodFill(x - 1, y, target_color, replacement_color)
	floodFill(x + 1, y, target_color, replacement_color)
	return floodFill(x, y, taeget_color, replacement_color)
	end
end
