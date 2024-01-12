local robloxOutput = require(script.Parent.sinks.robloxOutput)

local sink = robloxOutput

local facade = {}

function facade.setSink(newSink: (source: string, level: string, body: string) -> ())
	sink = newSink
end

function facade.write(source, level, body)
	sink(source, level, body)
end

return facade
