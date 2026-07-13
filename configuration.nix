# configuration.nix
{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings = {
    substituters = [ "https://vicinae.cachix.org" ];
    trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.disable_ipv6" = 1;
    "net.ipv6.conf.default.disable_ipv6" = 1;
  };

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver vpl-gpu-rt ];
  };

  users.users.revoke = {
    isNormalUser = true;
    description = "revoke";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "input" ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;
  documentation.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    git wget curl unzip ripgrep fd eza bat btop
    kitty
    vesktop
    kdePackages.dolphin
    kdePackages.spectacle
    kdePackages.ark
    yazi mpv
    gcc clang nodejs pnpm python3 vscode
    fastfetch
    imagemagick chafa cava
    android-tools android-file-transfer jmtpfs simple-mtpfs
    gvfs usbutils pciutils
    playerctl
    upower power-profiles-daemon
    inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    python314Packages.pywal16
  ];

  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.fish.enable = true;
  programs.kdeconnect.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.caskaydia-cove
    nerd-fonts.iosevka
    nerd-fonts.hack
    noto-fonts
    noto-fonts-color-emoji
    inter
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 5;
    percentageAction = 2;
    allowRiskyCriticalPowerAction = false;
  };

  system.stateVersion = "26.05";
}
