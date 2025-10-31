# Build

We use devcontainer to maintain a consistent build environment.

To build all supported EDK2 variants, please run `make deb` within devcontainer.

Set `BUILD_TARGET` to `DEBUG` in `src/Makefile` to build for debug artifacts.

Edit `DSC` in `src/Makefile` to reduce amount of variants that will be built.
You should also edit `debian/edk2-cix.install` to exclude unbuild variants,
otherwise `debuild` will complain that those files are missing.

## Update submodules

We are currently in active development with `edk2-cix`, which means the
underlying submodules can change drastically, and requires main repo to adjust.

However, since we rebase our submodules fequently, there is not much point to
commit those temporary commit IDs into `edk2-cix`. When those commit IDs
expired, users will not be able to clone repo with submodules without failure.

In general, if you clone and switch to a tagged release, the build should work
as intended. If you are working with the latest HEAD of `edk2-cix`, you may
encounter build issues, and will need to update your submodules to the latest
development HEAD for it to work.

The current development branch of the submodules is their default branch. You
can also run `git submodule update --remote` as a quick oneliner to update
submodules.
