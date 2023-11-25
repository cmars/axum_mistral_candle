{
  description = "axum_mistral_candle";

  inputs = {
    nixpkgs.url = "nixpkgs";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            rust-overlay.overlays.default
          ];
        };

        arch = "x86_64";  # TODO: derive this from system?

      in {

        devShells.default = pkgs.mkShell {
          buildInputs = [
          ] ++ (with pkgs; [
            cargo
            cargo-watch
            rustfmt
            rust-analyzer
            (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
            clang
            llvmPackages.llvm
            llvmPackages.libclang
            gnumake
            pkg-config
            openssl
            cudatoolkit
          ]);

          LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib";
          CUDA_ROOT="${pkgs.cudatoolkit}";
        };
      }
    ));
}
