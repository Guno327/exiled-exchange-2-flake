{
  description = "Exiled Exchange 2 Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    packages."${system}".exiled-exchange-2 = pkgs.callPackage ./exiled-exchange-2 {};
  };
}
