------------------------------------------------------------------------------
-- Dependencies
------------------------------------------------------------------------------
local Dependencies =
{
	Nano = 
	{
		IncludeDir = "%{wks.location}/vendor/Nano/Nano/Nano/include"
	},
	NanoNetworking = 
    {
        IncludeDirs = {},
        LibName = "NanoNetworking"
    },
}

Dependencies.NanoNetworking.IncludeDirs = local_require("vendor/NanoNetworking/NanoNetworking/Dependencies.lua").Combined.IncludeDirs
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Merge
------------------------------------------------------------------------------
Dependencies.Combined =
{
    IncludeDirs = {},
    LibNames = {},
    LibDirs = {}
}

for name, dep in pairs(Dependencies) do
    if name ~= "Combined" then
        -- IncludeDirs
        if dep.IncludeDir then
            table.insert(Dependencies.Combined.IncludeDirs, dep.IncludeDir)
        end
        if dep.IncludeDirs then
            table.insert(Dependencies.Combined.IncludeDirs, dep.IncludeDirs)
        end
        
        -- LibNames
        if dep.LibName then
            table.insert(Dependencies.Combined.LibNames, dep.LibName)
        end
        if dep.LibNames then
            table.insert(Dependencies.Combined.LibNames, dep.LibNames)
        end

        -- LibDirs
        if dep.LibDir then
            table.insert(Dependencies.Combined.LibDirs, dep.LibDir)
        end
        if dep.LibDirs then
            table.insert(Dependencies.Combined.LibDirs, dep.LibDirs)
        end
    end
end
------------------------------------------------------------------------------

return Dependencies