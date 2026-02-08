{
  lib,
  config,
  ...
}: {
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/gpu/nvidia/prime-sync.nix
    ../../../common/gpu/nvidia/blackwell
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/hidpi.nix
  ];

  boot.extraModulePackages = [config.boot.kernelPackages.lenovo-legion-module];

  boot.kernelModules = [
    "amdgpu"
    "nvidia"
  ];

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  hardware = {
    amdgpu.initrd.enable = false;

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      modesetting.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault false;
      powerManagement.finegrained = lib.mkDefault false;
      nvidiaSettings = lib.mkDefault true;

      prime = {
        amdgpuBusId = "PCI:08:00:0";
        nvidiaBusId = "PCI:01:00:0";
      };
    };
  };

  # Sound speaker fix, see #1039
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto
  '';

  boot.blacklistedKernelModules = ["snd_soc_avs"];

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  # √(2560² + 1600²) px / 16 in ≃ 189 dpi
  services.xserver.dpi = 189;
}
