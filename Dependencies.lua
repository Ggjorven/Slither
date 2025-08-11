------------------------------------------------------------------------------
-- Utils
------------------------------------------------------------------------------
function local_require(path)
	return dofile(path)
end

function this_directory()
    local str = debug.getinfo(2, "S").source:sub(2)
	local path = str:match("(.*/)")
    return path:gsub("\\", "/") -- Replace \\ with /
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Dependencies
------------------------------------------------------------------------------
local Dependencies =
{
	Nano = 
	{
		IncludeDir = this_directory() .. "/vendor/Nano/Nano/Nano/include"
	},
	NanoNetworking = 
    {
        IncludeDir = {},
        LibName = "NanoNetworking"
    },
    NanoGraphics = 
    {
        IncludeDir = {},
        LibName = "Graphics"
    },
}

-- TODO: Replace IncludeDirs with IncludeDir when updating NanoNetworking
Dependencies.NanoNetworking.IncludeDir = local_require("vendor/NanoNetworking/NanoNetworking/Dependencies.lua").Combined.IncludeDirs
table.insert(Dependencies.NanoNetworking.IncludeDir, this_directory() .. "/vendor/NanoNetworking/NanoNetworking/NanoNetworking/src")

Dependencies.NanoGraphics.IncludeDir = local_require("vendor/NanoGraphics/NanoGraphics/Dependencies.lua").Combined.IncludeDir
table.insert(Dependencies.NanoGraphics.IncludeDir, this_directory() .. "/vendor/NanoGraphics/NanoGraphics/Graphics/src")
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Merge
------------------------------------------------------------------------------
Dependencies.Combined =
{
    IncludeDir = {},
    LibName = {},
    LibDir = {}
}

for name, dep in pairs(Dependencies) do
    if name ~= "Combined" then
        -- IncludeDirs
        if dep.IncludeDir then
            table.insert(Dependencies.Combined.IncludeDir, dep.IncludeDir)
        end

        -- LibNames
        if dep.LibName then
            table.insert(Dependencies.Combined.LibName, dep.LibName)
        end

        -- LibDirs
        if dep.LibDir then
            table.insert(Dependencies.Combined.LibDir, dep.LibDir)
        end
    end
end
------------------------------------------------------------------------------

return Dependencies