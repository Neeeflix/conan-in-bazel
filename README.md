# conan-in-bazel

This tooling enables bazel to use conan for building 
and installing packages from conan packages.

In the WORKSPACE it is shown how to use the `conan_install` 
rule from [conan/conan.bzl](conan/conan.bzl).  
- With `conan_deps` you pass all conan packages that should be 
installed as an external dependency.  
- With `local_conan_packages` you pass paths to conan packages
  to be build into conan-cache.

## Tests
There are two sub-folderts in [test](test):
- `test-application` which holds a test, demonstrating that depending
  on an external dependency added via `conan_install` works.
- `test-lib` provides an exemplary conan package to be built into the 
  local conan cache.

### Execute tests
``` bash
bazel test //...:all
```
