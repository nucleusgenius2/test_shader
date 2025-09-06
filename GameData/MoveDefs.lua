
local moveDefs 	=	 {
	{
		name =	"Small Vechicle",
		footprintX =	2,
		footprintZ =	2,
		maxWaterDepth =	20,
		maxSlope =	40,
	},
	{
		name =	"Large Vechicle",
		footprintX =	3,
		footprintZ =	3,
		maxWaterDepth =	20,
		maxSlope =	40,
	},
	{
		name =	"Hover commander",
		footprintX =	4,
		footprintZ =	4,
		maxSlope =	40,
		speedModClass = 2,
	},
	
	{
		name =  "Large Hover",
		footprintX =	3,
		footprintZ =	3,
		maxSlope =	28,
		speedModClass = 2,
	},
	{	
		name =	"Small Hover",
		footprintX =	2,
		footprintZ =	2,
		speedModClass = 2,
	},
	{	
		name =	"Small Ship",
		footprintX =	2,
		footprintZ =	2,
		minWaterDepth =	3,
		speedModClass = 3,
	},
	{	
		name =	"Medium Ship",
		footprintX =	3,
		footprintZ =	3,
		minWaterDepth =	3,
		speedModClass = 3,
	},
	{	
		name =	"Large Ship",
		footprintX =	4,
		footprintZ =	4,
		minWaterDepth =	5,
		speedModClass = 3,
	},
	{	
		name =	"Small Sub",
		footprintX =	2,
		footprintZ =	2,
		minWaterDepth =	30,
		speedModClass = 3,
		waterline = 30,
	},
}

return moveDefs

