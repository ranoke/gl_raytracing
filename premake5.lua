workspace "gl_renderer"
    architecture "x86_64"
    configurations { "Debug", "Release", "Dist" }


outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["spdlog"] = "%{wks.location}/third_party/spdlog/include"
IncludeDir["glfw"]  = "%{wks.location}/third_party/glfw/include"
IncludeDir["glew"]  = "%{wks.location}/third_party/glew/include"
IncludeDir["imgui"] = "%{wks.location}/third_party/imgui"
IncludeDir["flecs"] = "%{wks.location}/third_party/flecs"
IncludeDir["glm"]  = "%{wks.location}/third_party/glm/include"

include "/third_party/glew"
include "/third_party/glfw"

includedirs
{
  "/third_party/imgui",
  "/third_party/flecs",
}

project "gl_renderer"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++latest"
    staticruntime "on"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
      -- headers
      "source/**.h",

      -- my sources 
      "source/main.cpp",
      "source/window.cpp",
      "source/gfx/gfx.cpp",
      "source/gfx/gfx_utils.cpp",
      "source/gui/gui.cpp",
      "source/utils/stb_image.cpp",
      "source/utils/stb_perlin.cpp",
      "source/utils/stb_leakcheck.cpp",
      "source/utils/stb_include.cpp",
      "source/utils/tiny_obj_loader.cpp",
    
      --imgui
      "third_party/imgui/imgui_demo.cpp",
      "third_party/imgui/imgui_draw.cpp",
      "third_party/imgui/imgui_tables.cpp",
      "third_party/imgui/imgui_widgets.cpp",
      "third_party/imgui/imgui.cpp",

      -- flecs
      "third_party/flecs/flecs.c",
    }

    includedirs
    {
      "source",
      "%{IncludeDir.spdlog}",
      "%{IncludeDir.glew}",
      "%{IncludeDir.glfw}",
      "%{IncludeDir.imgui}",
      "%{IncludeDir.flecs}",
      "%{IncludeDir.glm}"
    }

    defines
    {
	    "GLFW_INCLUDE_NONE",
	    "GLEW_STATIC"
    }

    links 
    { 
      "glew",
      "glfw",
    }

    filter "system:windows"
      system "windows"
      links { "opengl32.lib",  }
      defines { 
        "_CRT_SECURE_NO_WARNINGS",
        "R_PLATFORM_WINDOWS"
      }
      

    filter "system:linux"
      system "linux"
      linkoptions {"-pthread"}
      links { "GL", "dl"}
      defines {
        "R_PLATFORM_LINUX"
      }
      

    filter "configurations:Debug"
      defines { "DEBUG", "R_DEBUG" }
      runtime "Debug"
      symbols "On"

    filter "configurations:Release"
      defines { "RDEBUG", "R_RELEASE" }
      runtime "Release"
      optimize "On"

    filter "configurations:Dist"
      defines { "NDEBUG", "R_DIST" }
      runtime "Release"
      optimize "On"


