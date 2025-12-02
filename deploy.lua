local BUILD_DIR = "builds"
local PLATFORMS = { "html5", "linux", "windows" }

local highlight = function(text) return "\x1b[1m\x1b[35m" .. text .. "\x1b[0m" end

local archive = function(directory, file)
	print(highlight "Deleting " .. file)
	os.execute("rm " .. file)
	print(string.format(highlight("Archiving") .. " %s to %s", directory, file))
	os.execute(string.format("7z a %s %s/* | grep new", file, directory))
end

local push = function(file, address, channel)
	print(highlight(string.format(highlight("Uploading") .. " %s to %s:%s", file, address, channel)))
	os.execute(string.format("butler push %s %s:%s", file, address, channel))
end

local deploy = function(platform)
	local zip_file = string.format("./builds/%s/%s-build.zip", platform, platform)
	print(highlight("\n\n" .. string.upper(platform) .. "\n"))
	archive(string.format("./%s/%s", BUILD_DIR, platform), zip_file)
	push(zip_file, "aquarock/mmqg-dev", platform)
end

os.execute("timg ./app_icon.ico")
if not arg[1] then
	deploy("html5")
elseif arg[1] == "all" then
	for _, platform in ipairs(PLATFORMS) do deploy(platform) end
else
	for _, platform in ipairs(arg) do deploy(platform) end
end
