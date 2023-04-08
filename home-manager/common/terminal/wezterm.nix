{ ... }:

# let
#   myPkgs = import fetchFromGitHub {
#     owner = "NixOS";
#     repo = "nixpkgs";
#     rev = "b69883faca9542d135fa6bab7928ff1b233c167f";
#     sha256 = "sha256-eVPy47T2wcsN7NxtwMoyuC6loBVXsoJjf/2q31i3vxQ=";
#   }; 
# in

{
  programs.wezterm.enable = true;
}
