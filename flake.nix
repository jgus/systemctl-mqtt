{
  description = "systemctl-mqtt - MQTT client triggering & reporting shutdown on systemd-based systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      pythonPackages = pkgs.python3Packages;

      version = "2.0.0";
    in
    {
      packages.default = pythonPackages.buildPythonApplication {
        pname = "systemctl-mqtt";
        inherit version;
        pyproject = true;

        src = self;

        env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

        build-system = with pythonPackages; [
          setuptools
          setuptools-scm
          wheel
        ];

        dependencies = with pythonPackages; [
          aiomqtt
          jeepney
        ];

        doCheck = false;

        meta = {
          description = "MQTT client triggering & reporting shutdown on systemd-based systems";
          homepage = "https://github.com/jgus/systemctl-mqtt";
          mainProgram = "systemctl-mqtt";
        };
      };
    });
}
