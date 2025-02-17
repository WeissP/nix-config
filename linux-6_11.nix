{ pkgs ? import <nixpkgs> {} }:

let
  linuxKernel = pkgs.linuxKernel;
in
linuxKernel.packages.linux_6_11
