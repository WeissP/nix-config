{
  pkgs ? import <nixpkgs> { },
}:
pkgs.linuxKernel.packages.linux_6_11
