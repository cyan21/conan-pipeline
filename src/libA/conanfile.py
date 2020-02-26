from conans import ConanFile, CMake

class LibA(ConanFile):
    name = "libA"
    version = "1.0"

    url = "https://github.com/cyan21/conan-pipeline.git"
    settings = "os", "arch", "compiler", "build_type"
    options = {"shared": [True, False]}
    default_options = {"shared": False}

    generators = "cmake"

    scm = {"type": "git",
           "url": "https://github.com/cyan21/conan-pipeline.git",
           "revision": "auto"}

    def build(self):
        cmake = CMake(self)
        cmake.configure(source_folder="src/libA")
        cmake.build()
        cmake.install()

    def package(self):
        self.copy("LICENSE", dst="licenses")

    def package_info(self):
        self.cpp_info.libs = ["libA",]

