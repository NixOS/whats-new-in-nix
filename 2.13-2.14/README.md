# What's new in Nix 2.13.0 - 2.14.0?

[![hackmd-github-sync-badge](https://hackmd.io/j2_6RaXMRxikUopcvuHYJg/badge)](https://hackmd.io/j2_6RaXMRxikUopcvuHYJg)


## Release 2.13 (2023-01-17)

<!--
- The repeat and enforce-determinism options have been removed since they had been broken under many circumstances for a long time.
-->

- You can now use flake references in the old command line interface, e.g.

    ```
    # nix-build flake:nixpkgs -A hello
    # nix-build -I nixpkgs=flake:github:NixOS/nixpkgs/nixos-22.05 \
        '<nixpkgs>' -A hello
    # NIX_PATH=nixpkgs=flake:nixpkgs nix-build '<nixpkgs>' -A hello
    ```
<!--
- Instead of "antiquotation", the more common term string interpolation is now used consistently. Historical release notes were not changed.
-->

- Error traces have been reworked to provide detailed explanations and more accurate error locations. A short excerpt of the trace is now shown by default when an error occurs.

- Allow explicitly selecting outputs in a store derivation installable, just like we can do with other sorts of installables. For example,

    ```
    # nix build /nix/store/gzaflydcr6sb3567hap9q6srzx8ggdgg-glibc-2.33-78.drv^dev
    ```

    now works just as

    ```
    # nix build nixpkgs#glibc^dev
    ```
    
    does already.

- ??? On Linux, nix develop now sets the personality for the development shell in the same way as the actual build of the derivation. This makes shells for i686-linux derivations work correctly on x86_64-linux.

- You can now disable the global flake registry by setting the flake-registry configuration option to an empty string. The same can be achieved at runtime with --flake-registry "".


# Release 2.14 (2023-02-28)

- A new function builtins.readFileType is available. It is similar to builtins.readDir but acts on a single file or directory.

<!--
- In flakes, the .outPath attribute of a flake now always refers to the directory containing the flake.nix. This was not the case for when flake.nix was in a subdirectory of e.g. a Git repository. The root of the source of a flake in a subdirectory is still available in .sourceInfo.outPath.
-->

- ??? In derivations that use structured attributes, you can now use unsafeDiscardReferences to disable scanning a given output for runtime dependencies:

    ```
    __structuredAttrs = true;
    unsafeDiscardReferences.out = true;
    ```

    This is useful e.g. when generating self-contained filesystem images with their own embedded Nix store: hashes found inside such an image refer to the embedded store and not to the host's Nix store.

    This requires the discard-references experimental feature.
    
## Conclusion

@garbas needs to find a script from last time

rev range for
-> 2.8.0: `69c6fb12eea414382f0b945c0d6c574c43c7c9a3...ad7c99ef20dff74a65d6c8ac2a2c42f538e0a1dd`
33
-> 2.9.0: `de13b445730e94a24690fed6480f86a5f9c102c8...ee57f91413c9d01f1027eccbe01f7706c94919ac`
37
-> 2.10.0: `d046eb1463fad967d47cc5becfe5b7a08b5adfa8...929ab5b195cb063f7f38e7d6aceb262aaabbeee0`
63
-> 2.11.0: `57cf36f81e4f00ed7c67f159f2de11978470563f...b0488a29dc7401e5ecd9221215da5ea9879e56d6`
1
-> 2.12.0: `08dcd22582d65e73f29df79b3765e76cea8f3314...0b25446f2e20233a32b67796eb776a2193866627`
53