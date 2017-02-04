pixelFunction = {}

function pixelFunction.allwhite(x,y,r,g,b,a)
	r, g, b, a = 255, 255, 255, 0
	return r, g, b, a
end

function pixelFunction.clear(x,y,r,g,b,a)
	r, g, b, a = 255, 255, 255, 0
	return r, g, b, a
end

function pixelFunction.merge(x,y,r,g,b,a)
	local nr, ng, nb, na = thedata:getPixel(x, y)
	if na ~= 0 then
		r, g, b, a = nr, ng, nb, na
	end
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

function NewLayer()
	 table.insert(currentFrame, currentLayer + 1, love.image.newImageData(currentData:getWidth(), currentData:getHeight()))
		currentLayer = currentLayer + 1
		currentData = currentFrame[currentLayer]
		LayerSpinner.max, LayerSpinner.value = #currentFrame, currentLayer
		table.insert(FrameImages[FrameSpinner.value], currentLayer, love.graphics.newImage(currentFrame[currentLayer]))
		currentimage = FrameImages[FrameSpinner.value][currentLayer]
end

function NewLayerTest()
	for i = 1, FrameSpinner.max do
		table.insert(Frames[i], currentLayer + 1, love.image.newImageData(currentData:getWidth(), currentData:getHeight()))
	end
	currentLayer = currentLayer + 1
	currentData = currentFrame[currentLayer]
	LayerSpinner.max, LayerSpinner.value = #currentFrame, currentLayer
	for i = 1, FrameSpinner.max do
	table.insert(FrameImages[i], currentLayer, love.graphics.newImage(Frames[i][currentLayer]))
	end
	currentimage = FrameImages[FrameSpinner.value][currentLayer]
end

function MoveLayer(direction)
	local belowLayer = currentLayer + direction
		currentFrame[currentLayer], currentFrame[belowLayer] = currentFrame[belowLayer], currentFrame[currentLayer]
		FrameImages[FrameSpinner.value][currentLayer], FrameImages[FrameSpinner.value][belowLayer] = FrameImages[FrameSpinner.value][belowLayer], FrameImages[FrameSpinner.value][currentLayer]
		LayerSpinner.value = LayerSpinner.value + direction
	for i, v in pairs(FrameImages[FrameSpinner.value]) do
		v:refresh()
	end
	currentimage:refresh()
end

function RemoveLayer()
	for i = 1, #Frames do
		table.remove(Frames[i], LayerSpinner.value)
		table.remove(FrameImages[i], LayerSpinner.value)
	end
	--currentLayer = currentLayer - 1
	--currentData = currentFrame[currentLayer]
	LayerSpinner.max, LayerSpinner.value = LayerSpinner.max - 1, LayerSpinner.value - 1
	--table.remove(FrameImages[LayerSpinner.value], currentLayer + 1)
	--currentimage = FrameImages[FrameSpinner.value][currentLayer]
end

function MergeLayer()
	--currentFrame[currentLayer - 1]:mapPixel(pixelFunction.merge)
	for i = 1, #Frames do
		thedata = Frames[i][LayerSpinner.value]
		Frames[i][LayerSpinner.value - 1]:mapPixel(pixelFunction.merge)
	end
	RemoveLayer()
end

function clearFrames()
	for i = 1, #Frames do
		table.remove(Frames[i])
		table.remove(FrameImages[i])
	end
end

function NewFrame()
	table.insert(Frames, FrameSpinner.value + 1, {})
	table.insert(FrameImages, FrameSpinner.value + 1, {})
	for i = 1, LayerSpinner.max do
		table.insert(Frames[FrameSpinner.value + 1], love.image.newImageData(currentData:getWidth(), currentData:getHeight()))
	end
	for i, v in pairs(Frames[FrameSpinner.value + 1]) do
		--FrameImages[FrameSpinner.value + 1][i] = love.graphics.newImage(v)
		table.insert(FrameImages[FrameSpinner.value + 1], love.graphics.newImage(v))
	end
	FrameSpinner.max, FrameSpinner.value = FrameSpinner.max + 1, FrameSpinner.value + 1
end