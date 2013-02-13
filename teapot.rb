
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.6"

define_target "platform-darwin-osx" do |target|
	target.provides "Platform/darwin-osx" do
		default platform_name "darwin-osx"
		
		default xcode_path Pathname.new(`xcode-select --print-path`.chomp)
		default platform_path {xcode_path + "Platforms/MacOSX.platform"}
		default toolchain_path {xcode_path + "Toolchains/XcodeDefault.xctoolchain"}
		
		default sdk_version {ENV["MACOSX_SDK_VERSION"] || "10.7"}
		default sdk_path {platform_path + "Developer/SDKs/MacOSX#{sdk_version}.sdk"}

		default architectures %W{-arch i386 -arch x86_64}

		buildflags [
			:architectures,
			"-isysroot", :sdk_path,
			->{"-mmacosx-version-min=#{sdk_version}"},
		]

		linkflags []

		cflags [:buildflags]
		cxxflags [:buildflags]
		ldflags [:buildflags, :linkflags]

		configure []

		default cc {toolchain_path + "usr/bin/clang"}
		default cxx {toolchain_path + "usr/bin/clang++"}
		default ld {toolchain_path + "usr/bin/ld"}
		default ar {toolchain_path + "usr/bin/ar"}
		default libtool {toolchain_path + "usr/bin/libtool"}
	end
	
	target.depends :variant
	
	target.provides :platform => "Platform/darwin-osx"
	
	target.provides 'Language/C++11' do
		cxxflags %W{-std=c++11 -stdlib=libc++ -Wno-c++11-narrowing}
	end
	
	target.provides 'Library/OpenGL' do
		ldflags ["-framework", "OpenGL"]
	end
	
	target.provides 'Library/OpenAL' do
		ldflags ["-framework", "OpenAL"]
	end
	
	target.provides "Library/z" do
		append linkflags "-lz"
	end
	
	target.provides "Library/bz2" do
		append linkflags "-lbz2"
	end
	
	target.provides 'Aggregate/Display' do
		ldflags [
			"-framework", "Foundation",
			"-framework", "Cocoa",
			"-framework", "AppKit",
			"-framework", "CoreVideo",
			"-framework", "CoreServices"
		]
	end
end
