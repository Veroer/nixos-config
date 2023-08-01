# An overlay allows for a package set to be extended with new or modified packages

# `final` refers to the package set with all overlays applied.
# This allows for added or modified packages to be referenced with
# all relevant changes
final:

# `prev` refers to the previous package set before this current overlay is applied.
# This is cheaper for nix to evaluate, thus should be prefered over final when possible.
prev:


{
  # Patch aws-sdk-cpp to automatically pick up header location
  # specific to nixpkgs, as nixpkgs separates build-time and runtime
  # depencenies (a saving of 400MB in header + generated files).
  # In the case of c and c++, this means the header files are
  # located in a separate directory from the libraries.
  #
  # From a developer perspective, this avoids having to manually specify
  # the header location with `-DAWS_CORE_HEADER_FILE` each time
  # one invokes `cmake` on the command line when using
  # `find_package(AWSSDK COMPONENTS [comps])`
  #
  # For more information, see:
  # - aws-sdk-cpp issue: https://github.com/aws/aws-sdk-cpp/issues/2009
  # - Nixpkgs fix: https://github.com/NixOS/nixpkgs/pull/182918
  # 16.14 now requires experimental import assertions syntax, pin to 16.13
  # https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_V16.md
  nodejs-16_x = prev.nodejs-16_x.overrideAttrs (oldAttrs: rec {
    version = "16.17.1";
    name = "nodejs-${version}";

    src = prev.fetchurl {
      url = "https://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      sha256 = "sha256-MhFLPcOUXtD5X4vDO0LGjg7xjECMtWEiVyoWPZB+y8w=";
    };

    # Nixpkgs applies two patches for 16.15. One patch is for finding headers
    # needed for v8 on darwin using apple_sdk 11; the other patch fixes crashes
    # related cache dir defaulting to using `$HOME` without asserting that
    # it exists.
    #
    # However, 16.13 doesn't need the second patch, as the regression which
    # caused it was introduced after 16.13. This ends up being a no-op. But
    # nix will still try to apply the patch and fail with "this patch has
    # already been applied".
    #
    # For more context, see (https://github.com/npm/cli/pull/5197)
    #
    # lib.head will select the first element in an array
    patches = [
      (prev.lib.head oldAttrs.patches)
    ];
  });

  # Ensure that yarn is using the pinned version
  yarn = prev.yarn.override (_: {
    nodejs = final.nodejs-16_x;
  });
}
