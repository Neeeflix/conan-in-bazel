from conans import ConanFile, CMake, tools


class HelloWorldConan(ConanFile):
    name = "hello-world"
    version = "0.0.1"
    license = "MIT"
    author = "Johannes Wendel johanneswendel9@gmail.com"
    description = "This is just a simple library for testing usage"
    settings = "os"
    options = {"shared": [True, False]}
    default_options = {"shared": False}

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def build(self):
        cmake = CMake(self)
        cmake.configure(source_folder="hello")
        cmake.build()

    def package(self):
        self.copy("*.hpp", src="hello")
        self.copy("*hello.lib", dst="lib", keep_path=False)
        self.copy("*.dll", dst="bin", keep_path=False)
        self.copy("*.so", dst="lib", keep_path=False)
        self.copy("*.dylib", dst="lib", keep_path=False)
        self.copy("*.a", dst="lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = ["hello-lib"]

