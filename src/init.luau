local logger = require(script.logger)
local sourcemapParsing = require(script.sourcemapParsing)

local function findFileFromInstancePath(instancePath: string)
	local pathArray = string.split(instancePath, ".")

	local currentInstance = game
	for _, name in pathArray do
		currentInstance = currentInstance:FindFirstChild(name)
	end

	return sourcemapParsing.instanceToFile(currentInstance)
end

local log = {}

function log.setSink(newSink)
	logger.setSink(newSink)
end

type levels = "trace" | "debug" | "info" | "warn" | "error"
function log.write(source: string, level: levels, text: string)
	logger.write(source, level, text)
end

function log.trace(text: string)
	local source = findFileFromInstancePath(debug.info(2, "s"))
	logger.write(source, log.level.TRACE, text)
end

function log.debug(text: string)
	local source = findFileFromInstancePath(debug.info(2, "s"))
	logger.write(source, log.level.DEBUG, text)
end

function log.info(text: string)
	local source = findFileFromInstancePath(debug.info(2, "s"))
	logger.write(source, log.level.INFO, text)
end

function log.error(text: string)
	local source = findFileFromInstancePath(debug.info(2, "s"))
	logger.write(source, log.level.ERROR, text)
end

function log.warn(text: string)
	local source = findFileFromInstancePath(debug.info(2, "s"))
	logger.write(source, log.level.WARN, text)
end

log.level = {
	TRACE = "trace",
	DEBUG = "debug",
	INFO = "info",
	WARN = "warn",
	ERROR = "error",
}

return log
