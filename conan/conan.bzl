def _conan_build_repo_impl(ctx):
    # We create a separate conan user home for each conan command to make it more deterministic
    conan_user_home = str(ctx.path(".").dirname) + "/" + ctx.name

    pkg = ctx.attr.conan_package
    conan_pkg_path = ctx.workspace_root.get_child(pkg.package)
    print(conan_pkg_path)

    ctx.execute(
        [
            "conan",
            "install",
            conan_pkg_path,
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
)
