workspace "Hazel"														-- Aquvalent VS .sln file
	architecture "x64"													-- Aquvalent bit 32 or 64

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}


outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"         -- "{Debug, Release} - {windows, mac, linux} - {x32, x64}"

project "Hazel"															-- Aquvalent VS .vcxproj file
	location "Hazel"													-- project Folder
	kind "SharedLib"                                                    -- project is DLL library
	language "C++"                                                      -- Set Program language

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")                   -- Output director for .exe files -- we create this output path here because output files make in Hazel Project
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")                  -- Output director for .obj files -- we create this output path here because output files make in Hazel Project
	
	files
	{
		"%{prj.name}/src/**.h",											-- create all project files ** means that search all .h or .cpp files in src folder or it's subfolder'
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include"                             -- project Hazel include files
	}

	--For windows platform
	filter "system:windows"                                            
		cppdialect "C++17"                                              -- Compiler definition
		staticruntime "On"												-- Linking Runtime library
		systemversion "latest"                                    -- windows SDK version

		-- #defines
		defines
		{
			"HZ_BUILD_DLL",
			"HZ_PLATFORM_WINDOWS"
		}


		postbuildcommands
		{
			-- Copy and Past the DLL file - Hazel.dll - from Hazel folder into Sandbox folder
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
		}


		filter "configurations:Debug"
			defines "HZ_DEBUG"
			symbols "On"

		filter "configurations:Release"
			defines "HZ_RELEASE"
			optimize "On"

		filter "configurations:Dist"
			defines "HZ_DIST"
			optimize "On"


project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"


	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}") 
	
	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"Hazel/vendor/spdlog/include",
		"Hazel/src"
	}


	-- Hazel project Linking to Sadnbox project
	links
	{
		"Hazel"
	}

	--For windows platform
	filter "system:windows"                            
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"                   

		-- #defines
		defines
		{
			"HZ_PLATFORM_WINDOWS"
		}



		filter "configurations:Debug"
			defines "HZ_DEBUG"
			symbols "On"

		filter "configurations:Release"
			defines "HZ_RELEASE"
			optimize "On"

		filter "configurations:Dist"
			defines "HZ_DIST"
			optimize "On"