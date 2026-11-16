{
  description = "Dendritic Hyprland Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    wrappers.url = "github:nix-community/nix-wrapper-modules";
  };

  outputs =
    {
      self,
      nixpkgs,
      wrappers,
    }:
    let
      # Hard code system for ease of use, hyprland only supports x86_64-linux anyway iirc
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      runtimePkgsDefault = {
        inherit (pkgs)
          foot
          waybar
          nemo
          ;
      };

      mkWrapper =
        {
          pkgs,
          package,
          runtimePkgs ? { },
          env,
          flags,
        }:
        (wrappers.lib.wrapPackage (
          { ... }: {
            inherit
              pkgs
              package
              env
              flags
              ;

            runtimePkgs = builtins.attrValues (runtimePkgsDefault // runtimePkgs);
          }
        ));
    in
    {
      packages.${system} = {
        default = pkgs.lib.makeOverridable mkWrapper {
          inherit pkgs;
          package = pkgs.hyprland;
          env."HYPRLAND_ROOT" = ./.;
          flags."--config" = ./hyprland.lua;
        };
      };
    };

}
