
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "1.0.0"

define_target "platform-darwin-osx" do |target|
	target.priority = 10
	
	target.provides "Platform/darwin-osx" do
		default platform_name "darwin-osx"
		
		default xcode_path Path.new(`xcode-select --print-path`.chomp)
		default platform_path {xcode_path + "Platforms/MacOSX.platform"}
		default toolchain_path {xcode_path + "Toolchains/XcodeDefault.xctoolchain"}
		
		default sdk_path {platform_path + "Developer/SDKs/MacOSX.sdk"}

		default architectures %W{-arch x86_64}

		buildflags [
			:architectures,
			"-isysroot", :sdk_path,
			"-pipe"
		]

		linkflags []

		cflags [:buildflags]
		cxxflags [:buildflags]
		ldflags [:linkflags]

		configure []

		default cc {toolchain_path + "usr/bin/clang"}
		default cxx {toolchain_path + "usr/bin/clang++"}
		default ld {toolchain_path + "usr/bin/ld"}
		default ar {toolchain_path + "usr/bin/ar"}
		default libtool {toolchain_path + "usr/bin/libtool"}
		default install {["/usr/bin/install", "-C"]}
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
	
	target.provides "Library/dl" do
		append linkflags "-ldl"
	end
end
