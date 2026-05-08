{
  description = "SchemaCrawler - Free database schema discovery and comprehension tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        jdk = pkgs.jdk17;
      in
      {
        devShells.default = pkgs.mkShell {
          name = "schemacrawler";

          packages = with pkgs; [
            jdk
            maven
            graphviz   # required for schemacrawler-diagram tests
            docker     # required for Testcontainers database integration tests (-Dheavydb)
            git
          ];

          env = {
            JAVA_HOME = "${jdk}";
          };

          shellHook = ''
            echo ""
            echo "SchemaCrawler development environment"
            echo "======================================"
            echo "Java:      $(java -version 2>&1 | head -1)"
            echo "Maven:     $(mvn -version 2>&1 | head -1)"
            echo "Graphviz:  $(dot -V 2>&1)"
            echo ""
            echo "Quick start:"
            echo "  mvn clean verify                    # build and run unit tests"
            echo "  mvn clean verify -Ddistrib          # include distribution artifacts"
            echo "  mvn clean verify -Dverify           # include ArchUnit verification tests"
            echo "  mvn clean verify -Dheavydb          # include Testcontainers DB tests (requires Docker)"
            echo ""
            echo "NOTE: SchemaCrawler-Core must be available on Maven Central or built locally first."
            echo "      See: https://github.com/schemacrawler/SchemaCrawler-Core"
            echo ""
          '';
        };
      });
}
