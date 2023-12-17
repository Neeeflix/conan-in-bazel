def _exec_conan(ctx, params, conan_user_home):
    ctx.execute(
        ["conan"] + params,
        quiet = False,
        environment = {
            "CONAN_USER_HOME": conan_user_home,
        },
    )

def _conan_build_repo_impl(ctx):
    # We create a separate conan user home for each conan command to make it more deterministic
    conan_user_home = str(ctx.path(".").get_child("conan_user_home"))
    conan_build_folder = str(ctx.path("CONAN_BUILD_FOLDER"))
    conan_install_folder = str(ctx.path("install"))

    pkg = ctx.attr.conan_package
    conan_pkg_path = ctx.workspace_root.get_child(pkg.package)

    ctx.template(
        "MODULE.bzl",
        str(ctx.path(Label(":templates/module.bzl.in"))),
    )

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

    _exec_conan(
        ctx,
        [
            "install",
            #TODO: make this a parameter to be passe dto the rule
            str(ctx.path(Label(":conanfile.txt"))),
            "--install-folder",
            conan_install_folder,
        ],
        conan_user_home,
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
