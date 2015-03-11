# LUSH
A simple Sound helper library for love2d. main.lua is enough of an example and a reference.

### Playing a sound
> lush = require("lush")

> lush.play("filename.wav", {tags = {"whatever"}, looping = true})
Other possible properties are: volume (0.0 - 1.0), stream (bool), pitchShift (0.0 is default).

This function returns a love2d audio.Source-object.

> lush.update()

Should be called in regular intervals to enable stopped sounds to get freed.

### Tags & modifying playing sounds

To act on any playing sound, you can use:
> lush.actTag({"tag1", "tag2"}, function(source) source:setVolume(0.5) end)

With the following pre-provided convenience functions:
> function lush.tagPlay(tags) lush.actTag(tags, function(source) source:play() end) end

> function lush.tagStop(tags) lush.actTag(tags, function(source) source:stop() end) end

> function lush.tagPause(tags) lush.actTag(tags, function(source) source:pause() end) end

> function lush.tagSetVolume(tags, volume) lush.actTag(tags, function(source) source:setVolume(volume) end) end


### Further convenience functions
> lush.setPath(p)

Sets the path lush searches for files in

> lush.setDefaultVolume(vol)

exists.
