# Docs for this file: https://github.com/input-output-hk/iogx/blob/main/doc/api.md#mkhaskellprojectinshellargs
# See `shellArgs` in `mkHaskellProject` in ./project.nix for more details.

{ repoRoot, inputs, pkgs, lib, system }:

# Each flake variant defined in your project.nix project will yield a separate
# shell. If no flake variants are defined, then cabalProject is the original 
# project.
cabalProject:

{
  name = "plutus-experiments";

  packages = [
    pkgs.retry
    pkgs.magic-wormhole
    pkgs.jq
    pkgs.nodePackages.pnpm
    pkgs.nodejs
    inputs.cardano-addresses.packages."cardano-addresses-cli:exe:cardano-address"
    inputs.cardano-node.packages.cardano-node
    inputs.cardano-node.packages.cardano-cli
  ];

  tools = {
    haskell-language-server =
      let
        hlsProject = pkgs.haskell-nix.cabalProject' {
          name = "haskell-language-server";
          src = inputs.iogx.inputs.haskell-nix.inputs."hls-2.6";
          configureArgs = "--disable-benchmarks --disable-tests";
          compiler-nix-name = lib.mkDefault "ghc96";
          modules = [{
            packages.ghcide.patches = [
              # https://github.com/haskell/haskell-language-server/issues/4046#issuecomment-1926242056
              ./ghcide-workaround.diff
            ];
          }];
        };
      in
      hlsProject.hsPkgs.haskell-language-server.components.exes.haskell-language-server;
  };

  preCommit = {
    cabal-fmt.enable = true;
    cabal-fmt.extraOptions = "--no-tabular";
    fourmolu.enable = true;
    hlint.enable = false;
    shellcheck.enable = false;
    prettier.enable = true;
    nixpkgs-fmt.enable = true;
  };

  scripts = { };

  env = { };

  # This is where the SPO 1 socket is located for the local testnet
  shellHook = ''
  '';
}
 
