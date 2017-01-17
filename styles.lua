
fonts = {
	rm = lg.newFont("fonts/Roboto-Medium.ttf", dp(14)),
	rr = lg.newFont("fonts/Roboto-Regular.ttf", dp(16)),
	header = lg.newFont("fonts/Roboto-Bold.ttf", dp(16)),
	rn = lg.newFont("fonts/RobotoCondensed-Regular.ttf", dp(14)),
}

colors = {
	primary = {80, 80, 100},
	primaryl = {160, 160, 180},
	secondary = {0, 140, 20},
	tertairy = {140, 0, 20},
	quadary = {0, 20, 140},
	--"#001CB4",
	primaryd = "#FF002C",
	white = {255,255,255},
	black = {0,0,0}
}
gridcolors = {
	black = {0, 0, 0},
	red = {255, 0, 0},
	blue = {0, 0, 255}
}

header = {
	font = fonts.header,
	fgColor = colors.black
}

raisedbutton = {
	font = fonts.rm,
	bgColor = colors.primary,
	fgColor = colors.white,
	radius = dp(2),
	innerRadius = dp(2),
}

tb = {
	font = fonts.rm,
	bgColor = colors.black,
	fgColor = colors.primaryl,
	radius = dp(2),
	innerRadius = dp(2)
}
	
raisedbuttonlight = {
	font = fonts.rm,
	bgColor = colors.white,
	fgColor = colors.black,
	radius = dp(2),
	innerRadius = dp(2),
	showBorder = true,
	borderWidth = dp(1),
	borderColor = colors.black,
}
	
flatbutton = {
	font = fonts.rm,
	bgColor = colors.primary,
	fgColor = colors.white,
}
	
list = {
	font = fonts.rn,
	bgColor = {205, 205, 225},
	fgColor = colors.primary,
	radius = dp(2),
	innerRadius = dp(2),
}
	
dialog = {
	font = fonts.rr,
	bgColor = colors.white,
	fgColor = colors.black,
	showBorder = true,
	borderWidth = dp(2),
	borderColor = colors.black,
	radius = 0
}

window = {
	font = fonts.header,
	bgColor = colors.primaryl,
	radius = dp(2),
	fgColor = colors.primary,
	showBorder = true,
	borderWidth = dp(6),
	borderColor = colors.primaryl,
}

toast = {
	font = fonts.rr,
	bgColor = colors.primary,
	fgColor = colors.white,
	radius = dp(21),
	align = "center"
}

defWindowArgs = {
	x = sw/8 * 3, 
	y = sh/4, 
	w = sw/8 * 2, 
	h = sh/2, 
	layout = "grid 6x1"
}

compactWindowArgs = {
	x = sw/8 * 2, 
	y = sh/4, 
	w = sw/8 * 4, 
	h = sh/2, 
	layout = "grid 6x4"
}

largeWindowArgs = {
	x = sw/8* 1,
	y = sh/6,
	w = sw/8 * 6,
	h = sh/6 * 4,
	layout = "grid 8x5"
}