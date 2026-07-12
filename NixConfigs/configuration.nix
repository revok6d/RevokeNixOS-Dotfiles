# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
nix.settings.experimental-features = [ "nix-command" "flakes"];
nix.gc = {
	automatic = true;
	dates = "weekly";
	options = "--delete-older-than 7d";
};
nix.settings = {
    substituters = [ "https://vicinae.cachix.org" ];
    trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.nameservers = [
	"1.1.1.1"
	"1.0.0.1"
	];
boot.kernel.sysctl = {
	"net.ipv6.conf.all.disable_ipv6" = 1;
	"net.ipv6.conf.default.disable_ipv6" = 1;
};

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
hardware.graphics = {
	enable = true;
	enable32Bit = true;
	extraPackages = with pkgs; [
		intel-media-driver
		vpl-gpu-rt
	];
};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."revoke" = {
    isNormalUser = true;
    description = "revoke";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "input" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };
services.greetd = {
	enable = true;
	settings = {
		default_session = {
			command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
		};
	};
};
systemd.services.greetd.serviceConfig = {
	Type = "idle";
	StandardInput = "tty";
	StandardOutput = "tty";
	StandardError = "journal";
	TTYReset = true;
	TTYVHangup = true;
	TTYVTDisallocate = true;
};
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  documentation.enable = false;
# HYPRLAND

programs.hyprland = {
	enable = true;
	xwayland.enable = true;
};
xdg.portal = {
	enable = true;
	extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
	config.common.default = "*";
};


security.rtkit.enable = true;
services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
};
services.pulseaudio.enable = false;
virtualisation.docker.enable = true;
  # List packages installed in system profile. To search, run:
  # $ niearch wget
  environment.systemPackages = with pkgs; [
	git
	wget
	curl
	unzip
	ripgrep
	fd
	eza
	bat
	btop
	kitty
	hyprlock
	hypridle
	pavucontrol
	brightnessctl
	vesktop
	kdePackages.dolphin
	yazi
	mpv
	gcc
	clang
	nodejs
	pnpm
	xdg-user-dirs
	quickshell
	qt6.qtdeclarative
	qt6.qt5compat
	qt6.qtsvg
	qt6.qtmultimedia
	qt6.qtimageformats
	tuigreet
	fastfetch
	polkit_gnome
	imagemagick
	chafa
	wl-clipboard
	cava
	android-tools
	android-file-transfer
	jmtpfs
	simple-mtpfs
	gvfs
	usbutils
	pciutils
	pcmanfm
	pamixer
	playerctl
	upower
	power-profiles-daemon
	grim
	slurp
	ark
	inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
	vesktop
	python3
	inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default
	inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
	python314Packages.pywal16
	vscode
	
];
programs.git.enable = true;
fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
	noto-fonts
	noto-fonts-color-emoji
	nerd-fonts.meslo-lg
	inter
	nerd-fonts.caskaydia-cove
	nerd-fonts.iosevka
	nerd-fonts.hack
];
programs.neovim = {
	enable = true;
	defaultEditor = true;
};
systemd.user.services.polkit-gnome-authentication-agent-1 = {
	description = "polkit-gnome authentication agent";
	wantedBy = [ "graphical-session.target" ];
	wants = [ "graphical-session.target" ];
	after = [ "graphical-session.target" ];
	serviceConfig = {
		Type = "simple";
		ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
		Restart = "on-failure";
		RestartSec = 1;
		TimeoutStopSec = 10;
	};
};
programs.fish.enable = true;
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

  system.stateVersion = "26.05"; # Did you read the comment?

}
