def _conan_build_repo_impl(ctx):
    # We create a separate conan user home for each conan command to make it more deterministic
    conan_user_home = str(ctx.path(".").get_child("conan_user_home"))
    conan_build_folder = str(ctx.path("CONAN_BUILD_FOLDER"))
    conan_install_folder = str(ctx.path("install"))

    pkg = ctx.attr.conan_package
    conan_pkg_path = ctx.workspace_root.get_child(pkg.package)

    ctx.execute(
        [
            "conan",
            "install",
            conan_pkg_path,
            "--install-folder",
            conan_build_folder,
        ],
        quiet = False,
        environment = {
            "CONAN_USER_HOME": conan_user_home,
        },
    )

    ctx.execute(
        [
            "conan",
            "build",
            conan_pkg_path,
            "--build-folder",
            conan_build_folder,
            "--install-folder",
            conan_build_folder,
        ],
        quiet = False,
        environment = {
            "CONAN_USER_HOME": conan_user_home,
        },
    )

    ctx.execute(
        [
            "conan",
            "export-pkg",
            conan_pkg_path,
        ],
        quiet = False,
        environment = {
            "CONAN_USER_HOME": conan_user_home,
        },
    )

    ctx.execute(
        [
            "conan",
            "install",
            str(ctx.path(Label(":conanfile.txt"))),
            "--install-folder",
            conan_install_folder,
        ],
        quiet = False,
        environment = {
            "CONAN_USER_HOME": conan_user_home,
        },
    )

conan_build_repo = repository_rule(
    implementation = _conan_build_repo_impl,
    attrs = {
        "conan_package": attr.label(
            mandatory = True,
            allow_files = True,
            doc = "A package containing a conan package.",
        ),
    },
    environ = [
        "RELOAD_CONAN",
    ],
    local = True,
)
