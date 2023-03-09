# Purpose

The purpose of these files is to create a common environment for video capture.
We are using gotty in the browser to create a neutral terminal that will keep people's attention on the video content. 
The environment uses Docker to ensure no user or system influence on the demonstrations.

# Getting started

1. Run `./start-gotty` to start gotty
2. Go to `localhost:8080` in your browser.
3. Run `./start-demo`

# Info

- The `Dockerfile` at the top level of the repo controls the Nix version.
  If you need to modify which version of Nix, edit the `FROM nixos/nix` line.

- The Docker environment will also contain the episode folders from the top level of the repo.
