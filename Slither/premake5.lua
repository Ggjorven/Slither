local Dependencies = local_require("../Dependencies.lua")
local MacOSVersion = MacOSVersion or "14.5"
local OutputDir = OutputDir or "%{cfg.buildcfg}-%{cfg.system}"

project "Slither"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++23"
	staticruntime "On"

	debugdir ("%{prj.location}")

	architecture "x86_64"

	warnings "Extra"

	targetdir ("%{wks.location}/bin/" .. OutputDir .. "/%{prj.name}")
	objdir ("%{wks.location}/bin-int/" .. OutputDir .. "/%{prj.name}")

	files
	{
		"src/**.h",
		"src/**.hpp",
		"src/**.inl",
		"src/**.cpp"
	}

	defines
	{
		"_CRT_SECURE_NO_WARNINGS",
		"_SILENCE_ALL_MS_EXT_DEPRECATION_WARNINGS",
	}

	includedirs
	{
		"src",
	}

	includedirs(Dependencies.NanoNetworking.IncludeDir)
	includedirs(Dependencies.NanoGraphics.IncludeDir)

	links(Dependencies.NanoNetworking.LibName)
	links(Dependencies.NanoGraphics.LibName)

	filter "system:windows"
		defines "SL_PLATFORM_DESKTOP"
		defines "SL_PLATFORM_WINDOWS"
		systemversion "latest"
		staticruntime "on"

        defines
        {
            "NOMINMAX"
        }

		local NanoNetworkingDependencies = local_require("../vendor/NanoNetworking/NanoNetworking/Dependencies.lua")

		postbuildcommands
		{
			'{COPYFILE} "' .. NanoNetworkingDependencies.OpenSSL.IncludeDir .. '/../bin/' .. NanoNetworkingDependencies.OpenSSL.DllName .. '" "%{cfg.targetdir}"',
			'{COPYFILE} "' .. NanoNetworkingDependencies.OpenSSL.IncludeDir .. '/../bin/' .. NanoNetworkingDependencies.OpenSSL.DllName .. '" "%{prj.location}"' -- Note: This is the debugdir
		}

	filter "system:linux"
		defines "SL_PLATFORM_DESKTOP"
		defines "SL_PLATFORM_LINUX"
		defines "SL_PLATFORM_UNIX"
		systemversion "latest"
		staticruntime "on"

		-- TODO: Proper linking in order

    filter "system:macosx"
		defines "SL_PLATFORM_DESKTOP"
		defines "SL_PLATFORM_MACOS"
		defines "SL_PLATFORM_UNIX"
		defines "SL_PLATFORM_APPLE"
		systemversion(MacOSVersion)
		staticruntime "on"

	filter "action:vs*"
    	buildoptions { "/Zc:preprocessor" }

	filter "action:xcode*"
		-- Note: If we don't add the header files to the externalincludedirs
		-- we can't use <angled> brackets to include files.
		externalincludedirs(includedirs())

	filter "configurations:Debug"
		defines "SL_CONFIG_DEBUG"
		runtime "Debug"
		symbols "on"
		
	filter "configurations:Release"
		defines "SL_CONFIG_RELEASE"
		runtime "Release"
		optimize "on"

	filter "configurations:Dist"
		defines "SL_CONFIG_DIST"
		runtime "Release"
		optimize "Full"
		linktimeoptimization "on"
