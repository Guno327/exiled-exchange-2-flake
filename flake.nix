{
  description = "Flake for Exiled Exchange 2";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
  }: {
    nixosModules.exiled-exchange-2 = import ./module.nix;
    homeModules.exiled-exchange-2 = import ./modules.nix;
  };
}
