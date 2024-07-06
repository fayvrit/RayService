local Tools = { Vertices = { { 1, 1, -1 }, { 1, -1, -1 }, { -1, -1, -1 }, { -1, 1, -1 }, { 1, 1, 1 }, { 1, -1, 1 }, { -1, -1, 1 }, { -1, 1, 1 } } }
local RayService = {}

RayService.__index = RayService

Tools.GetCorner = function(Part)
	local Positions = {}

	table.insert(Positions, Part.Position)

	for _ , CornerVector in Tools.Vertices do
		local CF = Part.CFrame * CFrame.new((Part.Size.X * .5) * CornerVector[1], (Part.Size.Y * .5) * CornerVector[2], (Part.Size.Z * .5) * CornerVector[3])
		table.insert(Positions, CF.Position)
	end

	return Positions
end

RayService.Cast3DObject = function(Origin, Direction, Filter)
	local Cast = { }
	setmetatable(Cast, RayService)

	Cast.Origin = Origin
	Cast.Direction = Direction

	Cast.Corners = { }
	Cast.Results = { }

	Filter = Filter or { }

	Filter.Instances = Filter.Instances or { }
	Filter.FilterType = Filter.FilterType or "Exclude"
	Filter.IgnoreWater = Filter.IgnoreWater or Filter.IgnoreWater == nil

	Cast.Params = RaycastParams.new()
	Cast.Params.FilterDescendantsInstances = Filter.Instances
	Cast.Params.FilterType = Enum.RaycastFilterType[Filter.FilterType]
	Cast.Params.IgnoreWater = Filter.IgnoreWater or Filter.IgnoreWater == nil

	coroutine.wrap(Cast.Update)(Cast)

	return Cast
end

RayService.Update = function(self, Origin, Direction, Params)
	local Cast = self

	Cast.Origin = Origin or Cast.Origin
	Cast.Direction = Direction or Cast.Direction
	Cast.Params = Params or Cast.Params

	coroutine.wrap(Cast.Clear)(Cast)
	
	for _ , CornerDirection in Tools.GetCorner(Cast.Direction) do
		table.insert(Cast.Corners, CornerDirection)
	end

	for i , CornerOrigin in Tools.GetCorner(Cast.Origin) do
		local ray = RayService.New(CornerOrigin, Cast.Corners[i] - CornerOrigin, Cast.Params)

		if ray then
			table.insert(Cast.Results, ray)
		end
	end
	
	return Cast
end

RayService.Clear = function(self)
	local Cast = self

	Cast.Results = { }
	Cast.Corners = { }
end

RayService.New = function(Origin, Direction, Params)
	local Result = workspace:Raycast(Origin, Direction, Params) or { }
	
	return Result.Instance and Result
end

return RayService
