{
	description = "Revoke's NixOS & KDE Plasma System Flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		helium.url = "github:schembriaiden/helium-browser-nix-flake";
		helium.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, ...}@inputs: {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./configuration.nix
			];
		};
	};
}
