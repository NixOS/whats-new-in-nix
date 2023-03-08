# syntax=docker/dockerfile:1
FROM nixos/nix:2.11.0
MAINTAINER "Daniel Baker" "daniel.n.baker@gmail.com"

ENV NIX_CONFIG='extra-experimental-features = nix-command flakes'
COPY demos/ /demos/
RUN nix-env -iA nixpkgs.vim
