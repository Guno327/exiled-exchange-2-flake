{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.exiled-exchange-2;

  version = "0.9.4";
  pname = "exiled-exchange-2";

  src = pkgs.fetchurl {
    url = "https://github.com/Kvan7/Exiled-Exchange-2/releases/download/v${version}/Exiled-Exchange-2-${version}.AppImage";
    sha256 = "sha256-RhidU7W5aIvl1958FIoQlmni9JLYe/iKI7gkfqO5oEs=";
  };

  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};

  desktopItem = pkgs.makeDesktopItem {
    name = "exiled-exchange-2";
    exec = "exiled-exchange-2 ${escapeShellArgs cfg.launchArgs}";
    icon = "exiled-exchange-2";
    type = "Application";
    comment = "Path of Exile 2 overlay";
    desktopName = "Exiled Exchange 2";
  };

  drv = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${desktopItem}/share/applications/exiled-exchange-2.desktop \
        $out/share/applications/exiled-exchange-2.desktop

      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/exiled-exchange-2.png \
        $out/share/icons/hicolor/512x512/apps/exiled-exchange-2.png
    '';

    meta = {
      mainProgram = "exiled-exchange-2";
      description = "Path of Exile 2 overlay program";
      homepage = "https://github.com/Kvan7/Exiled-Exchange-2";
      downloadPage = "https://kvan7.github.io/Exiled-Exchange-2/download";
      changelog = "https://github.com/Kvan7/Exiled-Exchange-2/releases/tag/v${version}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [guno327];
      platforms = ["x86_64-linux"];
    };
  };

  isHome = config ? home;
in {
  options.exiled-exchange-2 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Exiled Exchange 2 overlay.";
    };

    launchArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional command-line arguments passed to Exiled Exchange 2.";
      example = ["--no-overlay" "--listen=localhost:5000"];
    };
  };

  config = mkIf cfg.enable (
    if isHome
    then {
      home.packages = [drv];
    }
    else {
      environment.systemPackages = [drv];
    }
  );
}
