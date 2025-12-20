{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.attrsets) attrValues mapAttrs;
  inherit (lib.strings) concatStringsSep;

  sounds = {
    clock5 = {
      url = "https://cdn.pixabay.com/download/audio/2025/04/17/audio_225d2ba65d.mp3?filename=block-1-328874.mp3";
      hash = "sha256-VVH2kPpFy2uf1q5NVwaFhwv9ZOYLEgMAH9sbzOLzahk=";
    };
    clock10 = {
      url = "https://cdn.pixabay.com/download/audio/2025/04/17/audio_8ea07751c0.mp3?filename=block-2-328875.mp3";
      hash = "sha256-l8CetJ8k8crI+4ViPCJZsT0gfesGHB3I8U2tAAsrRH0=";
    };
    clock15 = {
      url = "https://cdn.pixabay.com/download/audio/2022/03/24/audio_194021bc19.mp3?filename=wood-block-105066.mp3";
      hash = "sha256-pxyj+vVfhMCKVXCFDy/Ex+6Y9qa0qWWN2LWTYV9APWQ=";
    };
    clock60 = {
      url = "https://cdn.pixabay.com/download/audio/2022/03/24/audio_87a6eb2172.mp3?filename=wood-spin-105828.mp3";
      hash = "sha256-UDVhDqmy44kpc/Wv2fnZkh84qxojaEyQ63pkuogX2eU=";
    };
  };

  grabSounds = concatStringsSep "\n" (attrValues (mapAttrs (name: attrs: ''
  function ${name}() {
    ${name}.play();

  }
  SoundEffect {
    id: ${name}
    source: "${pkgs.stdenv.mkDerivation {
        pname = "quickshell-sound-${name}";
        version = "1.0";
        src = pkgs.fetchurl {
          inherit (attrs) url hash;
        };
        phases = [ "installPhase" ];
        buildInputs = [ pkgs.ffmpeg ];
        installPhase = ''
          mkdir -p $out
          ffmpeg -i $src $out/sound.wav
        '';
      }}/sound.wav"

    }
'') sounds));
in pkgs.writeText "Sounds.qml" /* qml */ ''
  pragma Singleton

  import Quickshell
  import Quickshell.Io

  import QtQuick
  import QtMultimedia


  Singleton {
    id: root
    ${grabSounds}
  }
''
