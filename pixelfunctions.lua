pixelFunction = {}

function pixelFunction.allwhite(x,y,r,g,b,a)
	r, g, b, a = 255, 255, 255, 255
	return r, g, b, a
end

function pixelFunction.clear(x,y,r,g,b,a)
	r, g, b, a = 255, 255, 255, 0
	return r, g, b, a
end

function pixelFunction.fill(x, y, r, g, b, a)
	
	if r ~= currentcolor[1] then
	r, g, b = currentcolor
	end
	return x, y, r, g, b, a
end

function Moveleft(x, y, r, g, b, a)
	if x < 31 then
		r, g, b, a = newdata:getPixel(x + 1, y)
	end
	return r, g, b, a
end

function Moveright(x, y, r, g, b, a)
		r, g, b, a = newdata:getPixel(x - 1, y)
	return r, g, b, a
end


function moveData()

end

function floodFill(x, y, target_color, replacement_color)
	if y < 0 or y > newdata:getHeight() or x < 0 or x > newdata:getWidth() then return
	elseif targetcolor == replacement_color then return
	elseif newdata:getPixel(x, y) ~= target_color then return
	else
	newdata:setPixel(x, y, replacement_color)
	floodFill(x, y + 1, target_color, replacement_color)
	--floodFill(x, y - 1, target_color, replacement_color)
	floodFill(x - 1, y, target_color, replacement_color)
	--floodFill(x + 1, y, target_color, replacement_color)
	return 
	end
end
