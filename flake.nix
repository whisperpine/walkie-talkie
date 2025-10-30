{
  description = "A Nix-flake-based Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                rust-overlay.overlays.default
                self.overlays.default
              ];
            };
          }
        );
    in
    {
      overlays.default = final: prev: {
        rustToolchain =
          let
            rust = prev.rust-bin;
          in
          # rust.stable.latest.default.override {
          #   extensions = [ "rust-src" ];
          #   targets = [ ];
          # };
          rust.nightly."2025-10-29".default.override {
            extensions = [ "rust-src" ];
            targets = [ ];
          };
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          # the default dev environment
          default = pkgs.mkShell {
            packages = with pkgs; [
              # --- others --- #
              just # just a command runner
              typos # check typo issues
              husky # manage git hooks
              opentofu # infrastructure as code
              cocogitto # conventional commit toolkit

              # --- frontend --- #
              bun # used as a package manager
              biome # linting typescript

              # --- rust --- #
              rustToolchain
              cargo-edit # managing cargo dependencies
              cargo-deny # linting dependencies
              bacon # background code checker

              # --- openapi --- #
              openapi-generator-cli # generate code based on OAS
              redocly # lint openapi and generate docs
            ];

            shellHook = ''
              # make sure npm packages are installed
              bun install --cwd wt-webapp
              # install git hook managed by husky
              if [ ! -e "./.husky/_" ]; then
                # set git hooks
                husky install
              fi
            '';
          };

          # this dev environment is used in CI.
          # nix develop .#gen
          gen = pkgs.mkShell {
            packages = with pkgs; [
              rustToolchain
              openapi-generator-cli # generate code based on OAS
              redocly # lint openapi and generate docs
            ];
          };
        }
      );
    };
}
