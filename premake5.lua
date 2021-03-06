workspace "Hazel"														-- Aquvalent VS .sln file
	architecture "x64"													-- Aquvalent bit 32 or 64

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}


outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"         -- "{Debug, Release} - {windows, mac, linux} - {x32, x64}"


-- Include directories relative to root folder (solution directory)
IncludeDir = {}															-- Create struct
IncludeDir["GLFW"] = "Hazel/vendor/GLFW/include"						-- path of directory put into struct, and this struct then use in HazelProject as variable
																		-- this struct need for to set #include glfw/glfw3.h. it's contain .h files so its necessary for Compiler
IncludeDir["Glad"] = "Hazel/vendor/Glad/include"
IncludeDir["Imgui"] = "Hazel/vendor/imgui"

include "Hazel/vendor/GLFW"												-- include premake5 file of GLFW project
include "Hazel/vendor/GLAD"
include "Hazel/vendor/imgui"

project "Hazel"															-- Aquvalent VS .vcxproj file
	location "Hazel"													-- project Folder
	kind "SharedLib"													-- project is DLL library
	language "C++"														 -- Set Program language

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")					 -- Output director for .exe files -- we create this output path here because output files make in Hazel Project
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")					-- Output director for .obj files -- we create this output path here because output files make in Hazel Project
	
	pchheader "hzpch.h"													-- Equivalent to use precompile file into Project
	pchsource "Hazel/src/hzpch.cpp"										-- Equivalent to create precompile file in VS

	files
	{
		"%{prj.name}/src/**.h",											-- create all project files ** means that search all .h or .cpp files in src folder or it's subfolder'
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",								-- project Hazel include files for Compiler
		"%{IncludeDir.GLFW}",												-- get variable "GLFW" from struct for Compiler
		"%{IncludeDir.Glad}",
		"%{IncludeDir.imgui}"
	}

	links																-- Linking GLFW into HazelProject, now Hazel is dependon GLFW
	{ 
		"GLFW",
		"Glad",
		"Imgui",
		"opengl32.lib"
	}

	--For windows platform
	filter "system:windows"
		cppdialect "C++17"												-- Compiler definition
		staticruntime "Off"												-- Linking Runtime library / I switch off it's not static any more'
		systemversion "latest"											-- windows SDK version

		-- #defines
		defines
		{
			"HZ_BUILD_DLL",
			"HZ_PLATFORM_WINDOWS",
			--"GLFW_INCLUDE_NONE"
		}


		postbuildcommands
		{
			-- Copy and Past the DLL file - Hazel.dll - from Hazel folder into Sandbox folder
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
		}


		filter "configurations:Debug"
			defines "HZ_DEBUG"
			buildoptions "/MDd"											-- it happend that we need Dynamic library
																		-- because Hazel and glfw heaps not comunicate correctly
																		-- thats why we switch off staticruntime
																		-- This directive = Project properties->code generation->RunTime Library - /MDd
			symbols "On"

		filter "configurations:Release"
			defines "HZ_RELEASE"
			buildoptions "/MD"
			optimize "On"

		filter "configurations:Dist"
			defines "HZ_DIST"
			buildoptions "/MD"
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
		staticruntime "Off"
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