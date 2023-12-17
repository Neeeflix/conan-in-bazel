load("//conan:conan.bzl", "conan_build_repo")

conan_build_repo(
    name = "hello",
    conan_deps = [
        "hello-world/0.0.1",
    ],
    local_conan_packages = [
        "test/test-lib",
    ],
    version = "0.0.1",
)
