{
  lib,
  pkgs,
  user,
  ...
}:
{
  home-manager.users.${user} = {
    programs.swayimg.enable = true;

    xdg.configFile."swayimg/init.lua".text = # lua
      ''
        swayimg.text.set_font("JetBrains Mono Nerd Font Propo")
        swayimg.text.set_size(16)

        swayimg.viewer.set_drag_button("MouseLeft")

        local exit = function() swayimg.exit() end
        swayimg.viewer.on_key("q", exit)
        swayimg.gallery.on_key("q", exit)

        swayimg.viewer.on_key("Escape", function() swayimg.set_mode("gallery") end)

        local gallery_move = function(dir) return function() swayimg.gallery.switch_image(dir) end end
        swayimg.gallery.on_key("g", gallery_move("first"))
        swayimg.gallery.on_key("Shift+g", gallery_move("last"))
        swayimg.gallery.on_key("Ctrl+u", gallery_move("pgup"))
        swayimg.gallery.on_key("Ctrl+d", gallery_move("pgdown"))
        swayimg.gallery.on_key("h", gallery_move("left"))
        swayimg.gallery.on_key("j", gallery_move("down"))
        swayimg.gallery.on_key("k", gallery_move("up"))
        swayimg.gallery.on_key("l", gallery_move("right"))

        local viewer_move = function(dir) return function() swayimg.viewer.switch_image(dir) end end
        swayimg.viewer.on_key("g", viewer_move("first"))
        swayimg.viewer.on_key("Shift+g", viewer_move("last"))
        swayimg.viewer.on_key("j", viewer_move("next"))
        swayimg.viewer.on_key("k", viewer_move("prev"))
        swayimg.viewer.on_key("r", viewer_move("random"))

        local show_zoom = function()
            swayimg.text.set_status(swayimg.viewer.get_scale() * 100 .. "%")
        end
        local zoom = function(multiplier)
          return function()
            local m = swayimg.get_mouse_pos()
            swayimg.viewer.set_abs_scale(swayimg.viewer.get_scale() * multiplier, m.x, m.y)
            show_zoom()
          end
        end
        swayimg.viewer.on_mouse("MouseMiddle", function()
          swayimg.viewer.reset()
          show_zoom()
        end)
        swayimg.viewer.on_mouse("ScrollUp", zoom(1.1))
        swayimg.viewer.on_mouse("ScrollDown", zoom(1/1.1))

        local function shell_escape(s) return "'"..string.gsub(s, "'", "'\"'\"'").."'" end
        swayimg.viewer.on_key("y", function()
          local image = swayimg.viewer.get_image()
          os.execute("${lib.getExe' pkgs.wl-clipboard "wl-copy"} -- "..shell_escape(image.path))
          swayimg.text.set_status("Image path copied to clipboard")
        end)
        swayimg.viewer.on_key("Shift+y", function()
          local image = swayimg.viewer.get_image()
          os.execute("${lib.getExe pkgs.imagemagick} "..shell_escape(image.path).." png:- | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}")
          swayimg.text.set_status("Image data copied to clipboard")
        end)
      '';
  };
}
