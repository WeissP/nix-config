{
  pkgs ? import <nixpkgs> { },
}:
pkgs.linuxKernel.packages.linux_6_11.override {
  structuredExtraConfig = with pkgs.lib.kernel; {
    # Disable all GPU drivers
    DRM_AMDGPU = no;
    DRM_NOUVEAU = no;
    DRM_I915 = no;
    VGA_ARB = no;
    FRAMEBUFFER_CONSOLE = no;
    
    # Disable graphics support
    AGP = no;
    FB = no;
    FB_CFB_FILLRECT = no;
    FB_CFB_COPYAREA = no;
    FB_CFB_IMAGEBLIT = no;
    
    # Disable video output
    VGA_CONSOLE = no;
    DUMMY_CONSOLE = no;
  };
}
