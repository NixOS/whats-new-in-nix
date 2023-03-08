# What's new in Nix 2.13.0 - 2.14.0?

[![hackmd-github-sync-badge](https://hackmd.io/j2_6RaXMRxikUopcvuHYJg/badge)](https://hackmd.io/j2_6RaXMRxikUopcvuHYJg)

## Intro

- [dan]: Hi, I am Daniel Baker. Welcome to the next installment of the Nix release videos. This is a summary of several releases 2.13 through 2.14
- [tom]: My name Tom Bereknyei and I'm exicited to provide an introduction to the new features and progress for the Nix project overall.
- [dan]: I hope you will find this visual walkthrough informative. If we missed anything, please let us know in the comments below.
- [tom]: there's a lot to cover, so let's get started


## Release 2.13

1. [dan] You can now use flake references in the old command line interface, e.g.

    ```
    # nix-build flake:nixpkgs -A hello
    # nix-build -I nixpkgs=flake:github:NixOS/nixpkgs/nixos-22.05 \
        '<nixpkgs>' -A hello
    # NIX_PATH=nixpkgs=flake:nixpkgs nix-build '<nixpkgs>' -A hello
    ```

2. [dan] Error traces have been reworked to provide detailed explanations and more accurate error locations. A short excerpt of the trace is now shown by default when an error occurs.

3. [dan] Allow explicitly selecting outputs in a store derivation installable, just like we can do with other sorts of installables. For example,

    ```
    # nix build /nix/store/gzaflydcr6sb3567hap9q6srzx8ggdgg-glibc-2.33-78.drv^dev
    ```

    now works just as

    ```
    # nix build nixpkgs#glibc^dev
    ```
    
    does already.

4. [tom] You can now disable the global flake registry by setting the flake-registry configuration option to an empty string. The same can be achieved at runtime with --flake-registry "".


## Release 2.14

5. [tom] A new function builtins.readFileType is available. It is similar to builtins.readDir but acts on a single file or directory.

6. [tom] In derivations that use structured attributes, you can now use unsafeDiscardReferences to disable scanning a given output for runtime dependencies:

    ```
    __structuredAttrs = true;
    unsafeDiscardReferences.out = true;
    ```

    This is useful e.g. when generating self-contained filesystem images with their own embedded Nix store: hashes found inside such an image refer to the embedded store and not to the host's Nix store.

    This requires the discard-references experimental feature.

## Outro

### [tom] Nix team changes

Introduce Nix team and John Ericson was [added](https://github.com/NixOS/nix/pull/7580).


### [dan] Compare number of contributors between versions

Scripts here -> https://hackmd.io/2i__EvtqTpu3EpkQ3F8R4A?edit

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

### [tom] Maybe do performance comparision between versions

@tomberek will ask penne to maybe do it

```
chrt -f 10 \
    taskset -c 1 hyperfine --warmup 2 --runs 20 \
    taskset -c 2,3 nix eval --raw --impure --expr 'with import <nixpkgs/nixos> {}; system'

```

### Final words

- [dan] And that's the last feature for now. Yesterday was the release for 2.14 and is the last release scheduled for the year. This contains a large number of documentation and stability fixes. NixOS 22.11 release that just happened will have 2.11. The Nix repo itself will always have the latest releases available. As always, let us know if there are additional changes you are excitied about. Please "thumbs-up" any issues or PRs in the Nix repo to bring it to the attention of the Nix maintenance team.

- [tom] These releases would not be possible without all the hard work done by the contributors. We also want to thank the users for bug reports, example usages, ideas, and for making the Nix community a better place. Thank you!

[tom+dan]: **Wave!**