do
	
local soundDataMap = {}
local getSoundData = function(str)
	if not soundDataMap[str] then
		soundDataMap[str] = love.sound.newSoundData(str)
		return soundDataMap[str]
	else
		return soundDataMap[str]
	end
end

lush = {} -- Lightweight, Unefficient Sound Helper library
local sources = {}
local path = ""

local transformTagList = function(tags)
	local ret = {}
	for tagIndex = 1, #tags do
		ret[tags[tagIndex]] = true
	end
	return ret
end

function lush.setPath(p) path = p end
	
function lush.play(filename, properties)
	if type(filename) == "table" then filename = filename[love.math.random(1,#filename)] end
	filename = path .. filename
	
	properties = properties and properties or {}
	properties.looping = properties.looping and properties.looping or false
	properties.stream = properties.stream and properties.stream or false
	properties.volume = properties.volume and properties.volume or 1.0
	properties.tags = properties.tags and transformTagList(properties.tags) or {}
	properties.tags["all"] = true
	
	local src
	if properties.stream == true then
		src = love.audio.newSource(filename, "stream")
	else
		src = love.audio.newSource(getSoundData(filename))
	end
	
	src:setLooping(properties.looping)
	src:setVolume(properties.volume)
	love.audio.play(src)
	
	table.insert(sources, {source = src, properties = properties})
	return src
end

function lush.getSourceProperties(src)
	for i = 1, #sources do
		if sources[i].source == src then return sources[i].properties end
	end
end
	
function lush.update() 
	-- Benchmark this and see how many elements are removed each update. If the number is big enough, consider using the version in "BenchmarkLater"
	--local useNow = [[
	for i = #sources, 1, -1 do
		if sources[i].source:isStopped() then
			table.remove(sources, i) 
		end
	end
	--]]
	
	-- method state above is implemented here for later comparison:
	local BenchmarkLater = [[
	local n = #sources
	for i = 1, n do
		if sources[i].source:isStopped() then sources[i] = nil end
	end
	
	local newLength = 0
	for i = 1, n do
		if sources[i] then
			newLength = newLength + 1
			sources[newLength] = sources[i]
		end
	end
	
	for i = newLength + 1, n do
		sources[i] = nil
	end
	]]
end

function lush.actTag(tags, func)
	for ti = 1, #tags do
		for si = 1, #sources do
			if sources[si].properties.tags[tags[ti]] then
				func(sources[si].source)
			end
		end
	end
end

function lush.tagPlay(tags) lush.actTag(tags, function(source) source:play() end) end
function lush.tagStop(tags) lush.actTag(tags, function(source) source:stop() end) end
function lush.tagPause(tags) lush.actTag(tags, function(source) source:pause() end) end
function lush.tagSetVolume(tags, volume) lush.actTag(tags, function(source) source:setVolume(volume) end) end

end