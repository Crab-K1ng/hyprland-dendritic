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
    }@inputs:
    let
      # Hard code system for ease of use, hyprland only supports x86_64-linux anyway iirc
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      runtimePkgs = with pkgs; [
        foot
      ];
    in
    {
      lib.runtimePkgs.${system} = runtimePkgs;

      packages.${system} = {
        default = wrappers.lib.wrapPackage (
          { ... }: {
            inherit pkgs;
            package = pkgs.hyprland;
            runtimePkgs = runtimePkgs;
            env."HYPRLAND_ROOT" = ./.;
            flags."--config" = ./hyprland.lua;
          }
        );
      };
    };

}
