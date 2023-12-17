def _exec_conan(ctx, params, conan_user_home):
    ctx.execute(
        ["conan"] + params,
        quiet = False,
        environment = {
            "CONAN_USER_HOME": conan_user_home,
        },
    )

def _build_local_conan_packages(ctx, conan_user_home):
    conan_build_folder = str(ctx.path("CONAN_BUILD_FOLDER"))

    for pkg in ctx.attr.local_conan_packages:
        conan_pkg_path = ctx.workspace_root.get_child(pkg)

        _exec_conan(
            ctx,
            [
                "install",
                conan_pkg_path,
                "--install-folder",
                conan_build_folder,
            ],
            conan_user_home,
        )

        _exec_conan(
            ctx,
            [
                "build",
                conan_pkg_path,
                "--build-folder",
                conan_build_folder,
                "--install-folder",
                conan_build_folder,
            ],
            conan_user_home,
        )

        _exec_conan(
            ctx,
            [
                "export-pkg",
                conan_pkg_path,
            ],
            conan_user_home,
        )

def _conan_build_repo_impl(ctx):
    # We create a separate conan user home for each conan command to make it more deterministic
    conan_user_home = str(ctx.path(".").get_child("conan_user_home"))

    _build_local_conan_packages(ctx, conan_user_home)

    ctx.file(
        "MODULE.bzl",
        content = "module(name = \"{}\", version = \"{}\")\n".format(ctx.name, ctx.attr.version),
    )

    conanfile_path = ctx.path(".").get_child(ctx.name + "_conanfile.txt")
    ctx.file(
        conanfile_path,
        content = """[requires]
{}
""".format("\n".join(ctx.attr.conan_deps)),
    )

    _exec_conan(
        ctx,
        [
            "install",
            str(conanfile_path),
            "--install-folder",
            str(ctx.path(".")),  # This is a bit of a hack to make conan install the package into the folder as the name is
            "--generator=BazelDeps",
            "--generator=deploy",
        ],
        conan_user_home,
    )

conan_build_repo = repository_rule(
    implementation = _conan_build_repo_impl,
    attrs = {
        "local_conan_packages": attr.string_list(
            mandatory = False,
            doc = "Paths to conan local packages. The packages will be built using conan build.",
        ),
        "conan_deps": attr.string_list(
            mandatory = True,
            doc = "A list of conan dependencies to be installed. The syntax of dependencies is equivalnet to the syntax in a regular    conanfile.txt",
        ),
        "version": attr.string(
            mandatory = True,
            doc = "Version of the conan package",
        ),
    },
    environ = [
        "RELOAD_CONAN",
    ],
    local = True,
)
