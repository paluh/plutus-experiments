# Docs for this file: https://github.com/input-output-hk/iogx/blob/main/doc/api.md#flakenix
{
  description = "Midnight Glacier Drop on Cardano Plutus Scripts and Indexer";

  inputs = {
    iogx = {
      url = "github:input-output-hk/iogx";
      inputs.hackage.follows = "cardano-node/hackageNix";
      inputs.CHaP.follows = "cardano-node/CHaP";
      inputs.haskell-nix.follows = "cardano-node/haskellNix";
      inputs.nixpkgs.follows = "cardano-node/nixpkgs";
    };

    cardano-signer.url = "github:jhbertra/cardano-signer";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs.follows = "iogx/nixpkgs";

    # When updating, see if we can get rid of nixpkgs-postgrest
    nixpkgs-postgrest.url = "nixpkgs";

    cardano-node.url = "github:IntersectMBO/cardano-node/9.1.0";
    cardano-addresses.url = "github:IntersectMBO/cardano-addresses?ref=03aace86f4a7b4bdb4af4ae8da98929d89514b9f";

    cardano-db-sync.url = "github:IntersectMBO/cardano-db-sync/13.3.0.0";
    services-flake.url = "github:juspay/services-flake";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-github-actions.url = "github:nix-community/nix-github-actions";
  };

  # Docs for mkFlake: https://github.com/input-output-hk/iogx/blob/main/doc/api.md#mkflake
  outputs = inputs: inputs.iogx.lib.mkFlake {

    inherit inputs;

    repoRoot = ./.;

    outputs = import ./nix/outputs.nix;

    systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];

    nixpkgsArgs = {
      config = { };
      overlays = [ ];
    };

    # debug = false;

    # flake = { repoRoot, inputs }: {};
  };

  nixConfig = {
    extra-sandbox-paths = [
      "/etc/skopeo/auth.json=/etc/skopeo/auth.json"
    ];
    extra-substituters = [
      "https://cache.iog.io"
    ];
    extra-trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
    allow-import-from-derivation = true;
  };
}
