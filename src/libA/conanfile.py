from conans import ConanFile, CMake

class LibA(ConanFile):
    name = "libA"
    version = "1.0"

    settings = "os", "arch", "compiler", "build_type"
    options = {"shared": [True, False]}
    default_options = {"shared": False}

    generators = "cmake"

    scm = {"type": "git",
           "subfolder": "src/libA",
           "url": "https://github.com/cyan21/conan-pipeline.git",
           "revision": "auto"}

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        cmake.install()

    def package(self):
        self.copy("LICENSE", dst="licenses")

    def package_info(self):
        self.cpp_info.libs = ["libA",]

