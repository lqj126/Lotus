workspace "Lotus" --�����������
    architecture "x86_64" --����ƽ̨ ֻ��64λ--(x86,x86_64,ARM)
        startproject "Sandbox" 

    configurations 
    {
        "Debug",
        "Release",
        "Dist"
    }
--��ʱ���� ���� ���Ŀ¼
--��ϸ������֧�ֵ�tokens �ɲο� [https://github.com/premake/premake-core/wiki/Tokens]
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"
  
-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "Lotus/vendor/GLFW/include"

include "Lotus/vendor/GLFW"

project "Lotus" --��Ŀ����
    location "Lotus" --���·��
    kind "SharedLib" --��������Ŀ��dll��̬��
    language "c++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")--���Ŀ¼
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")--�м���ʱ�ļ���Ŀ¼

    pchheader "ltpch.h"
    pchsource "Lotus/src/ltpch.cpp"

    files--����Ŀ���ļ�
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs--���Ӱ���Ŀ¼
    { 
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}"
    }
	
	links
    {
        "GLFW",
        "opengl32.lib"
    }

    filter "system:windows"--windowsƽ̨������
        cppdialect "c++17"
        staticruntime "On"  
        systemversion "latest"

        defines --Ԥ�����
        {
            "LT_BUILD_DLL",
            "LT_PLATFORM_WINDOWS",
            "_WINDLL",
            "_UNICODE",
            "UNICODE",
        }

        postbuildcommands -- build����Զ�������
        {
            ("{COPY} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Sandbox/\"") --��������dll�⵽sanbox.exe��ͬһĿ¼��ȥ
            --"{COPY} %{cfg.objdir}/output.map %{cfg.targetdir}"
        }

    filter "configurations:Debug"
        defines "LT_DEBUG"
        runtime "Debug"
        buildoptions "/MDd"
        symbols "on"

    filter "configurations:Release"
        defines "LT_RELEASE"
        runtime "Release"
        buildoptions "/MD"
        optimize "on"

    filter "configurations:Dist"
        defines "LT_DIST"
        runtime "Release"
        buildoptions "/MD"
        optimize "on"

project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "c++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "Lotus/vendor/spdlog/include",
        "Lotus/src"
    }

    links
    {
        "Lotus"
    }

    filter "system:windows"
        cppdialect "c++17"
        staticruntime "On"
        systemversion "latest"

        defines
        {
            "LT_PLATFORM_WINDOWS",
            "_UNICODE",
            "UNICODE",
        }

    filter "configurations:Debug"
        defines "LT_DEBUG"
        runtime "Debug"
        buildoptions "/MDd"
        symbols "on"

    filter "configurations:Release"
        defines "LT_RELEASE"
        runtime "Release"
        buildoptions "/MD"
        optimize "on"

    filter "configurations:Dist"
        defines "LT_DIST"
        runtime "Release"
        buildoptions "/MD"
        optimize "on"