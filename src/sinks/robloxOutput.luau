local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sourcemapParsing = require(ReplicatedStorage.Packages.awesomelogging.sourcemapParsing)

return function(source, level, text)
	local outputFunction = print

	if level == "error" then
		outputFunction = error
	elseif level == "warn" then
		outputFunction = warn
	end

	if level == "error" then
		task.spawn(outputFunction, `&RED[{source}] {text}`, 0)
		local traceback = debug.traceback()
		local lines = string.split(traceback, "\n")

		local reachedSource = false
		for _, line in lines do
			local endNameCharacter = string.find(line, ":")
			if endNameCharacter then
				local name = string.sub(line, 1, endNameCharacter - 1)
				local filePath = sourcemapParsing.fullNameToFile(name)
				local replaced = string.gsub(line, name, filePath)

				if filePath == source then
					reachedSource = true
					print(`&BLUE{replaced}&RESET`)
				elseif not reachedSource then
					continue
				else
					print(`&BLUE{replaced}&RESET`)
				end
			end
		end
	elseif level == "warn" then
		outputFunction(`[&RED_YELLOW{source}&RESET] {text}`)
	else
		outputFunction(`[&GREEN{source}&RESET] {text}`)
	end
end
