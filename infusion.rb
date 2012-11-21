
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.2"

define_platform "darwin-osx" do |platform|
	platform.configure do
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

		ccflags [:buildflags]
		cxxflags [:buildflags]
		ldflags [:buildflags, :linkflags]

		configure []

		default cc {toolchain_path + "usr/bin/clang"}
		default cxx {toolchain_path + "usr/bin/clang++"}
		default ld {toolchain_path + "usr/bin/ld"}
		default ar {toolchain_path + "usr/bin/ar"}
		default libtool {toolchain_path + "usr/bin/libtool"}
	end
	
	platform.make_available! if RUBY_PLATFORM.include?("darwin")
end

