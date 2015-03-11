lush = require "lush"

function love.load()
	bgMusic = lush.play("jingle.ogg", {tags = {"bgmusic"}, looping = true, stream = true})
	nextShot = 0
end

function love.update()
	if nextShot < love.timer.getTime() then
		nextShot = love.timer.getTime() + 0.5
		lush.play({"1.wav", "2.wav"})
	end

	lush.tagSetVolume({"all"}, 1.0)

	if love.keyboard.isDown(" ") then
		lush.tagSetVolume({"all"}, 0.1)
	end

	if love.keyboard.isDown("lctrl") then
		lush.tagSetVolume({"bgmusic"}, 0.1)
	end

	if love.keyboard.isDown("s") then
		lush.tagStop({"all"})
	end

	lush.update()
end
