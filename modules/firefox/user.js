// Restore previous session
user_pref("browser.startup.page", 3);

// Middle mouse scroll
user_pref("general.autoScroll", true);

// Don't navigate history with alt+scroll
user_pref("mousewheel.with_alt.action", 1);

// Don't go full screen when sites request it
user_pref("full-screen-api.ignore-widgets", true);

// Disable full screen nag
user_pref("full-screen-api.warning.timeout", 0);

// Enable browser toolbox
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.debugger.remote-enabled", true);

user_pref("browser.sessionstore.resume_from_crash", true);
user_pref("browser.tabs.insertAfterCurrent", true);
user_pref("browser.tabs.insertAfterCurrentExceptPinned", true);
user_pref("general.aboutConfig.enable", true);
user_pref("middlemouse.paste", false);
user_pref("sidebar.animation.enabled", false);
// user_pref("image.jxl.enabled", true);
user_pref("devtools.cache.disabled", true);
user_pref("devtools.netmonitor.persistlog", true);
user_pref("devtools.webconsole.persistlog", true);
user_pref("devtools.webconsole.timestampMessages", true);

user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
