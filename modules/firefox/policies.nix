{
  name,
  lib,

  user,
  ...
}:
let
  installExtension = id: attrs: {
    ${id} = {
      installation_mode = "normal_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
    }
    // attrs;
  };
in
{
  # Read: https://mozilla.github.io/policy-templates/

  home-manager.users.${user}.programs.firefox.policies = {
    ExtensionUpdate = true;
    ExtensionSettings = lib.mkMerge [
      (installExtension "{446900e4-71c2-419f-a6a7-df9c091e268b}" {
        # Bitwarden
        private_browsing = true;
        default_area = "navbar";
      })
      (installExtension "uBlock0@raymondhill.net" {
        private_browsing = true;
        default_area = "navbar";
      })
      (installExtension "addon@darkreader.org" {
        private_browsing = true;
        default_area = "navbar";
      })
      (installExtension "firefox@tampermonkey.net" {
        private_browsing = true;
        default_area = "navbar";
      })
      (installExtension "soundfixer@unrelenting.technology" {
        private_browsing = true;
        default_area = "navbar";
      })
      (installExtension "{d7742d87-e61d-4b78-b8a1-b469842139fa}" {
        # Vimium
        private_browsing = true;
        default_area = "menupanel";
      })
      (installExtension "{0c3ab5c8-57ac-4ad8-9dd1-ee331517884d}" {
        # Proxy Toggle
        private_browsing = true;
        default_area = "menupanel";
      })

      # YouTube repairs
      (installExtension "sponsorBlocker@ajay.app" {
        private_browsing = true;
        default_area = "menupanel";
      })
      (installExtension "{0d7cafdd-501c-49ca-8ebb-e3341caaa55e}" {
        # YouTube NonStop
        private_browsing = true;
        default_area = "menupanel";
      })
      (installExtension "{7b1bf0b6-a1b9-42b0-b75d-252036438bdc}" {
        # YouTube High Definition
        private_browsing = true;
        default_area = "menupanel";
      })
      (installExtension "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" {
        # Return YouTube Dislike
        private_browsing = true;
        default_area = "menupanel";
      })
    ];

    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    Cookies = {
      Behavior = "reject-tracker-and-partition-foreign";
      BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";
    };
    DefaultDownloadDirectory = "\${home}/dls";
    DownloadDirectory = "\${home}/dls";
    DisableFeedbackCommands = true;
    DisableFirefoxAccounts = true;
    DisableFirefoxScreenshots = true;
    DisableFirefoxStudies = true;
    DisableFormHistory = true;
    DisableMasterPasswordCreation = true;
    DisablePasswordReveal = true;
    DisablePocket = true;
    DisableProfileImport = true;
    DisableProfileRefresh = true;
    DisableSetDesktopBackground = true;
    DisableSystemAddonUpdate = true;
    DisableTelemetry = true;
    DisplayBookmarksToolbar = "never";
    DisplayMenuBar = "never";
    DNSOverHTTPS.Enabled = false;
    DontCheckDefaultBrowser = true;
    EnableTrackingProtection = {
      Value = true;
      Cryptomining = true;
      Fingerprinting = true;
      EmailTracking = true;
      SuspectedFingerprinting = true;
    };
    EncryptedMediaExtensions = {
      Enabled = false;
      Locked = true;
    };
    ExemptDomainFileTypePairsFromFileTypeDownloadWarnings = [
      {
        file_extension = "*";
        domains = [ "*" ];
      }
    ];
    FirefoxHome = {
      Search = false;
      TopSites = false;
      SponsoredTopSites = false;
      Highlights = false;
      Pocket = false;
      Stories = false;
      SponsoredPocket = false;
      SponsoredStories = false;
      Snippets = false;
      Locked = true;
    };
    FirefoxSuggest = {
      WebSuggestions = false;
      SponsoredSuggestions = false;
      ImproveSuggest = false;
      Locked = true;
    };
    GoToIntranetSiteForSingleWordEntryInAddressBar = false;
    HardwareAcceleration = true;
    HttpsOnlyMode = "disabled";
    LegacyProfiles = false;
    LegacySameSiteCookieBehaviorEnabled = false;
    ManualAppUpdateOnly = true;
    NetworkPrediction = false;
    NewTabPage = false;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    PasswordManagerEnabled = false;
    Preferences = {
      "accessibility.browsewithcaret" = {
        Value = false;
        Status = "locked";
      };
      "accessibility.browsewithcaret_shortcut.enabled" = {
        Value = false;
        Status = "locked";
      };
      "browser.aboutConfig.showWarning" = {
        Value = false;
        Status = "locked";
      };
      "browser.compactmode.show" = {
        Value = true;
        Status = "locked";
      };
      "browser.link.open_newwindow.restriction" = {
        Value = 0;
        Status = "locked";
        Type = "number";
      };
      "browser.ml.enable" = {
        Value = false;
        Status = "locked";
      };
      "browser.search.region" = {
        Value = "US";
        Status = "locked";
      };
      "browser.uidensity" = {
        Value = 1;
        Status = "locked";
        Type = "number";
      };
      "dom.block_download_insecure" = {
        Value = false;
        Status = "locked";
      };
      "extensions.ui.dictionary.hidden" = {
        Value = true;
        Status = "locked";
      };
      "network.IDN_show_punycode" = {
        Value = true;
        Status = "locked";
      };
      "print.more-settings.open" = {
        Value = true;
        Status = "locked";
      };
      "print.print_bgcolor" = {
        Value = false;
        Status = "locked";
      };
      "print.print_bgimages" = {
        Value = false;
        Status = "locked";
      };
      "ui.context_menus.after_mouseup" = {
        Value = true;
        Status = "locked";
      };
      "ui.key.menuAccessKeyFocuses" = {
        Value = false;
        Status = "locked";
      };
      "browser.theme.content-theme" = {
        Value = 2;
        Status = "locked";
      };
      "browser.theme.dark-private-windows" = {
        Value = true;
        Status = "locked";
      };
      "browser.theme.dark-toolbar-theme" = {
        Value = true;
        Status = "locked";
      };
      "browser.theme.native-theme" = {
        Value = true;
        Status = "locked";
      };
      "browser.theme.toolbar-theme" = {
        Value = 0;
        Status = "locked";
        Type = "number";
      };
      "browser.newtabpage.activity-stream.system.showWeather" = {
        Value = false;
        Status = "locked";
      };
      "browser.newtabpage.activity-stream.telemetry" = {
        Value = false;
        Status = "locked";
      };
    };
    PrimaryPassword = false;
    PopupBlocking.Default = false;
    RequestedLocales = [ "en-US" ];
    SanitizeOnShutdown = {
      Cache = true;
      FormData = true;
    };
    SearchBar = "unified";
    SearchEngines = {
      PreventInstalls = true;
    };
    SearchSuggestEnabled = false;
    ShowHomeButton = false;
    SkipTermsOfUse = true;
    StartDownloadsInTempDirectory = true;
    UserMessaging = {
      WhatsNew = false;
      ExtensionRecommendations = false;
      FeatureRecommendations = false;
      UrlbarInterventions = false;
      SkipOnboarding = true;
      MoreFromMozilla = false;
      FirefoxLabs = false;
      Locked = true;
    };
  };
}
