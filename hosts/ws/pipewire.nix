{
  lib,
  ...
}:
{
  services.pipewire.wireplumber.extraConfig = {
    general = {
      "wireplumber.settings" = {
        "device.restore-profile" = false;
        "device.restore-routes" = false;
        "device.routes.default-sink-volume" = 1.0;
        "device.routes.default-source-volume" = 1.0;
      };

      "wireplumber.profiles".main = {
        "hooks.device.profile.state" = "disabled";
        "hooks.device.routes.state" = "disabled";
        "hooks.default-nodes.state" = "disabled";
        "hooks.stream.state" = "disabled";
      };
    };

    devices."monitor.alsa.rules" = [
      {
        matches = lib.singleton {
          "device.description" = "DENON DJ MC7000";
        };
        actions.update-props = {
          "device.profile" = "pro-audio";
        };
      }
      {
        matches = lib.singleton {
          "alsa.card_name" = "Xonar STX";
          "media.class" = "Audio/Sink";
        };
        actions.update-props = {
          "node.description" = "Desktop";
          "node.nick" = "Desktop";
          "priority.session" = 8000;
          "priority.driver" = 8000;
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
          "priority.session" = 9000;
          "priority.driver" = 9000;
        };
      }
      {
        matches = lib.singleton {
          "alsa.card_name" = "RODE NT-USB";
          "media.class" = "Audio/Sink";
        };
        actions.update-props."node.disabled" = true;
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
        priority.session = 6000
        priority.driver = 6000
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
        priority.session = 7000
        priority.driver = 7000
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
