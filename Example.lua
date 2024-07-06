local Author = 'fayvrit'
local Repo = 'RayService'
local Files = 'Source.lua'

local RawLink = string.format('https://raw.githubusercontent.com/%s/%s/main/%s', Author, Repo, Files)

local RayService = loadstring(game:HttpGet(RawLink))()

local Filter = { }
Filter.Instances = {}

local Cast = RayService.Cast3DObject(obj1, obj2, Filter)
Cast:Update()
