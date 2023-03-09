# syntax=docker/dockerfile:1
FROM nixos/nix:2.14.1
MAINTAINER "Daniel Baker" "daniel.n.baker@gmail.com"

ENV NIX_CONFIG='extra-experimental-features = nix-command flakes'
COPY 2.13-2.14/ /2.13-2.14/
RUN nix-env -iA nixpkgs.vim
