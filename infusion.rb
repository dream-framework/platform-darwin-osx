
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.1"

define_platform "darwin-osx" do |platform|
	platform.configure do
		xcode_path Pathname.new(`xcode-select --print-path`.chomp)
		platform_path {xcode_path + "Platforms/MacOSX.platform"}
		toolchain_path {xcode_path + "Toolchains/XcodeDefault.xctoolchain"}
		
		default sdk_version {ENV["MACOSX_SDK_VERSION"] || "10.7"}
		sdk_path {platform_path + "Developer/SDKs/MacOSX#{sdk_version}.sdk"}

		default architectures ["-arch i386", "-arch x86_64"]

		buildflags {[
			architectures,
			"-isysroot", sdk_path,
			"-mmacosx-version-min=#{sdk_version}",
			"-mdynamic-no-pic",
		]}

		cflags {[
			buildflags
		]}

		cxxflags {[
			buildflags
		]}

		configure []

		cc {toolchain_path + "usr/bin/clang"}
		cxx {toolchain_path + "usr/bin/clang++"}
		ld {toolchain_path + "usr/bin/ld"}
	end
	
	platform.make_available! if RUBY_PLATFORM.include?("darwin")
end

