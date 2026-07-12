{
	description = "Revoke's NixOS & Hyprland System Flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		hyprland.url = "github:hyprwm/Hyprland";
		awww.url = "git+https://codeberg.org/LGFae/awww";
		vicinae.url = "github:vicinaehq/vicinae";
		helium.url = "github:schembriaiden/helium-browser-nix-flake";
		helium.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, hyprland, ...}@inputs: {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./configuration.nix
			];
		};
	};
}
