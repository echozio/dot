{
  lib,
  ...
}:
{
  services.pipewire.wireplumber.extraConfig = {
    devices."monitor.alsa.rules" = [
      {
        matches = lib.singleton {
          "alsa.card_name" = "Xonar STX";
          "media.class" = "Audio/Sink";
        };
        actions.update-props = {
          "node.description" = "Desktop";
          "node.nick" = "Desktop";
        };
      }
      {
        matches = lib.singleton {
          "alsa.card_name" = "Xonar STX";
          "media.class" = "Audio/Source";
        };
        actions.update-props."node.disabled" = true;
      }
      {
        matches = lib.singleton {
          "alsa.card_name" = "RODE NT-USB";
          "media.class" = "Audio/Source";
        };
        actions.update-props = {
          "node.description" = "Voice";
          "node.nick" = "Voice";
        };
      }
      {
        matches = lib.singleton {
          "alsa.card_name" = "RODE NT-USB";
          "media.class" = "Audio/Sink";
        };
        action.update-props."node.disabled" = true;
      }
      {
        matches = lib.singleton {
          "alsa.card_name" = "HDA ATI HDMI";
        };
        actions.update-props."node.disabled" = true;
      }
      {
        matches = lib.singleton {
          "alsa.card_name" = "HD 720P webcam";
        };
        actions.update-props."node.disabled" = true;
      }
      {
        matches = lib.singleton {
          "alsa.card_name" = "HD-Audio Generic";
        };
        actions.update-props."node.disabled" = true;
      }
    ];
    loopback = {
      "wireplumber.components" = lib.singleton {
        name = "loopback.lua";
        type = "script/lua";
        provides = "custom.loopback";
      };
      "wireplumber.profiles".main."custom.loopback" = "required";
    };
  };
  services.pipewire.wireplumber.extraScripts."loopback.lua" = ''
    masterOutput = LocalModule("libpipewire-module-loopback", [[
      audio.position = [ FL FR ]
      capture.props = {
        media.class = Audio/Sink
        node.name = "capture.master"
        node.description = "Master"
        node.latency = 1024/44100
        audio.rate = 44100
        audio.channels = 2
        audio.position = [ FL FR ]
      }
      playback.props = {
        node.name = "playback.master"
        node.description = "Master"
        node.latency = 1024/44100
        audio.rate = 44100
        audio.channels = 2
        audio.position = [ AUX0 AUX1 ]
        target.object = "alsa_output.usb-DENON_DJ_DENON_DJ_MC7000_201603-00.pro-output-0"
      }
    ]])

    headphoneOutput = LocalModule("libpipewire-module-loopback", [[
      audio.position = [ FL FR ]
      capture.props = {
        media.class = Audio/Sink
        node.name = "capture.headphones"
        node.description = "Headphones"
        node.latency = 1024/44100
        audio.rate = 44100
        audio.channels = 2
        audio.position = [ FL FR ]
      }
      playback.props = {
        node.name = "playback.headphones"
        node.description = "Headphones"
        node.latency = 1024/44100
        audio.rate = 44100
        audio.channels = 2
        audio.position = [ AUX2 AUX3 ]
        target.object = "alsa_output.usb-DENON_DJ_DENON_DJ_MC7000_201603-00.pro-output-0"
      }
    ]])
  '';
}
