--!strict
local guardSourcemap = require(script.Parent.Parent.guardSourcemap)

type sourcemapInstance = {
	children: { sourcemapInstance }?,
	className: string,
	name: string,
	filePaths: { string }?,
}

local references: { [string]: string } = {}
local reversedReferences: { [string]: string } = {}
local function recursiveSearch(inst: sourcemapInstance, correlated: Instance)
	if inst.children then
		for _, child in inst.children do
			if child.children ~= nil then
				local correlatedInstance = correlated:FindFirstChild(child.name)
				if correlatedInstance then
					recursiveSearch(child, correlatedInstance)
				end
			end

			local isScript = child.className == "Script"
				or child.className == "LocalScript"
				or child.className == "ModuleScript"
			if isScript then
				if child.filePaths ~= nil then
					local correlatedInstance = correlated:FindFirstChild(child.name)

					if correlatedInstance then
						references[correlatedInstance:GetFullName()] = string.gsub(child.filePaths[1], "\\", "/")
						reversedReferences[string.gsub(child.filePaths[1], "\\", "/")] =
							correlatedInstance:GetFullName()
					end
				end
			end
		end
	end
end
recursiveSearch(guardSourcemap.getSourcemap(), game)

local sourcemapParsing = {}

function sourcemapParsing.fullNameToFile(fullName: string)
	local start, stop = string.find(fullName, "PlayerScripts")
	if start then
		local subtractedName = string.sub(fullName, (stop :: number) + 2)
		local added = `StarterPlayer.StarterPlayerScripts.{subtractedName}`
		return references[added]
	else
		return references[fullName]
	end
end

function sourcemapParsing.instanceToFile(inst: Instance)
	local fullName = inst:GetFullName()

	return sourcemapParsing.fullNameToFile(fullName)
end

return sourcemapParsing
