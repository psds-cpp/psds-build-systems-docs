import os

from conan import ConanFile
from conan.tools.meson import Meson, MesonToolchain


class HelloMesonConan(ConanFile):
    name = "hello"
    version = "0.1.0"
    settings = "os", "arch", "compiler", "build_type"

    def layout(self):
        self.folders.build = os.path.join("build", str(self.settings.build_type))
        self.folders.generators = os.path.join(self.folders.build, "generators")

    def generate(self):
        tc = MesonToolchain(self)
        tc.generate()

    def build(self):
        meson = Meson(self)
        meson.configure()
        meson.build()
