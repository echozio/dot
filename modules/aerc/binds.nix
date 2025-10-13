{
  lib,
  config,
  pkgs,

  user,
  ...
}:
{
  home-manager.users.${user}.programs.aerc.extraBinds = lib.mkMerge [
    {
      global = {
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "?" = ":help keys<Enter>";
        "<C-t>" = ":term<Enter>";
      };

      # Actions
      messages = {
        a = ":read<Enter>,:archive flat<Enter>";
        d = ":read<Enter>,:move Spam<Enter>";
        f = ":move Important<Enter>";
        "<space>" = ":read -t<Enter>";

        e = ":envelope -h -s '%s: %s'<Enter>";
        E = ":pipe -m -s -- vi - -R -c 'set filetype=mail'<Enter>";

        m = ":compose<Enter>";
        b = ":bounce<space>";
        rr = ":reply -a<Enter>";
        rq = ":reply -aq<Enter>";
        Rr = ":reply<Enter>";
        Rq = ":reply -q<Enter>";
        F = ":forward<Enter>";

        v = ":mark -t<Enter>";

        V = ":mark -v<Enter>";
        "<Esc>" = [ ":unmark -a<Enter>" ];
      };
    }
    {
      # Navigation
      messages = {
        "<Enter>" = ":view<Enter>";

        j = ":next<Enter>";
        k = ":prev<Enter>";

        "<C-d>" = ":next 50%<Enter>";
        "<C-u>" = ":prev 50%<Enter>";

        "<C-f>" = ":next 100%<Enter>";
        "<C-b>" = ":prev 100%<Enter>";

        G = ":select -1<Enter>";
        gg = ":select 0<Enter>";

        H = ":collapse-folder<Enter>";
        J = ":next-folder<Enter>";
        K = ":prev-folder<Enter>";
        L = ":expand-folder<Enter>";

        zz = ":align center<Enter>";
        zt = ":align top<Enter>";
        zb = ":align bottom<Enter>";
      };

      # Search
      messages = {
        "/" = ":search<space>";
        "\\" = ":filter<space>";
        n = ":next-result<Enter>";
        N = ":prev-result<Enter>";

        "<Esc>" = [ ":clear<Enter>" ];
      };

      messages = {
        T = ":toggle-threads<Enter>";
        zc = ":fold<Enter>";
        zo = ":unfold<Enter>";
        za = ":fold -t<Enter>";
        zM = ":fold -a<Enter>";
        zR = ":unfold -a<Enter>";

        c = ":cf<space>";

        s = ":hsplit<Enter>";
        S = ":vsplit<Enter>";
        h = ":split -1<Enter>";
        l = ":split +1<Enter>";

        "|" = ":pipe<space>";
        pl = ":patch list<Enter>";
        pa = ":patch apply <Tab>";
        pd = ":patch drop <Tab>";
        pb = ":patch rebase <Tab>";
        pt = ":patch term<Enter>";
        ps = ":patch switch <Tab>";
      };

      "messages:folder=Drafts" = {
        "<Enter>" = ":recall<Enter>";
      };

      view = {
        "/" = ":toggle-key-passthrough<Enter>/";
        q = ":close<Enter>";
        o = ":open<Enter>";
        S = ":save<space>";
        "|" = ":pipe<space>";
        D = ":delete<Enter>";
        A = ":archive flat<Enter>";

        "<C-y>" = ":copy-link <space>";
        "<C-l>" = ":open-link <space>";

        r = ":reply -a<Enter>";
        rq = ":reply -aq<Enter>";
        Rr = ":reply<Enter>";
        Rq = ":reply -q<Enter>";
        F = ":forward<Enter>";

        H = ":toggle-headers<Enter>";
        "<C-k>" = ":prev-part<Enter>";
        "<C-j>" = ":next-part<Enter>";
        J = ":next<Enter>";
        K = ":prev<Enter>";
      };

      "view::passthrough" = {
        "$noinherit" = true;
        "$ex" = "<C-x>";
        "<Esc>" = ":toggle-key-passthrough<Enter>";
      };

      compose = {
        "$noinherit" = true;
        "$ex" = "<C-x>";
        "$complete" = "<C-o>";

        "<C-k>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";
        "<A-p>" = ":switch-account -p<Enter>";
        "<A-n>" = ":switch-account -n<Enter>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
      };

      "compose::editor" = {
        "$noinherit" = true;
        "$ex" = "<C-x>";
        "<C-k>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
      };

      "compose::review" = {
        y = ":send<Enter>";
        s = ":sign<Enter>";
        x = ":encrypt<Enter>";
        v = ":preview<Enter>";
        p = ":postpone<Enter>";
        q = ":choose -o d discard abort -o p postpone postpone<Enter>";
        Q = ":abort<Enter>";
        e = ":edit<Enter>";
        a = ":attach<space>";
        d = ":detach<space>";
      };

      terminal = {
        "$noinherit" = true;
        "$ex" = "<C-x>";

        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
      };
    }

    (lib.mapAttrs' (
      name: account:
      let
        passwordCmd = lib.concatStringsSep " " account.passwordCommand;
      in
      lib.nameValuePair "messages:account=${name}" {
        "gs" = ":term ${pkgs.writeShellScript "sieve-edit" ''
          printf "\033]0;%s\a" "Sieve: ${name}"
          "${lib.getExe pkgs.sieve-connect}" \
            --user "${account.userName}" \
            --server "${account.imap.host}" \
            --passwordfd 5 \
             5<<<"$(${passwordCmd})"
        ''}<Enter>";
      }
    ) config.home-manager.users.${user}.accounts.email.accounts)
  ];
}
