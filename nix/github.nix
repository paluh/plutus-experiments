{ repoRoot, inputs, pkgs, system, lib }: {
  packages.generate-gha-matrix =
    let
      # mkGithubMatrix doesn't like nested sets, but we
      # get nested sets by default from iogx in hydraJobs
      jobs = inputs.self.hydraJobs.${system};
      drv-paths =
        let
          go = set: lib.concatMap
            (name:
              if set.${name} ? outPath
              then [ [ name ] ]
              else map (path: [ name ] ++ path) (go set.${name}))
            (builtins.attrNames set);
        in
        go jobs;

      removed-jobs = [
        # The profiled dev shell build causes an out of space issue on the builders, skip it for now
        [ "required" ]
        [ "profiled" "devShells" "default" ]
      ];

      removeMany = toRemove: lib.filter (x: !(builtins.elem x toRemove));

      flattened-jobs = builtins.listToAttrs (map
        (drv-path: {
          # Hack: Take advantage of lack of quoting by mkGithubMatrix
          name = lib.concatStringsSep "." drv-path;
          value = lib.attrByPath drv-path null jobs;
        })
        (removeMany removed-jobs drv-paths));

      matrix = inputs.nix-github-actions.lib.mkGithubMatrix {
        checks.${system} = flattened-jobs;
        attrPrefix = "hydraJobs";
      };
    in
    pkgs.writeShellApplication {
      name = "generate-gha-matrix";
      text = ''
        echo matrix=${lib.escapeShellArg (builtins.toJSON matrix.matrix)} >> "$GITHUB_OUTPUT"
      '';
    };
}
