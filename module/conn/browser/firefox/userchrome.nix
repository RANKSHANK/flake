config: lib: let
    colors = config.lib.stylix.colors;
    font = config.stylix.fonts;
in ''
:root {
--tab-active-bg-color: #${colors.base02};
--tab-inactive-bg-color: #${colors.base00};
--tab-active-fg-fallback-color: #${colors.base05};		/* color of text in an active tab without a container */
--tab-inactive-fg-fallback-color: #${colors.base05};		/* color of text in an inactive tab without a container */
--urlbar-focused-bg-color: #${colors.base04};
--urlbar-not-focused-bg-color: #${colors.base00};
--toolbar-bgcolor: #${colors.base00} !important;
--tab-font: '${font.monospace.name}';
--urlbar-font: '${font.monospace.name}';

/* try increasing if you encounter problems */
--urlbar-height-setting: ${toString (font.sizes.applications + 1)}pt !important;
--tab-min-height: ${toString (font.sizes.applications + 1)}pt !important;

/* I don't recommend you touch this unless you know what you're doing */
--arrowpanel-menuitem-padding: 2px !important;
--arrowpanel-border-radius: 0px !important;
--arrowpanel-menuitem-border-radius: 0px !important;
--toolbarbutton-border-radius: 0px !important;
--toolbarbutton-inner-padding: 0px 2px !important;
--toolbar-field-focus-background-color: var(--urlbar-focused-bg-color) !important;
--toolbar-field-background-color: var(--urlbar-not-focused-bg-color) !important;
--toolbar-field-focus-border-color: transparent !important;
}


/* --- GENERAL DEBLOAT ---------------------------------- */

/* Ui close button is pointless here */
.titlebar-close {
    display:none !important;
}

/* Bottom left page loading status or url preview */
#statuspanel { display: none !important; }

/* remove radius from right-click popup */
menupopup, panel { --panel-border-radius: 0px !important; }
menu, menuitem, menucaption { border-radius: 0px !important; }

/* no stupid large buttons in right-click menu */
menupopup > #context-navigation { display: none !important; }
menupopup > #context-sep-navigation { display: none !important; }

/* --- DEBLOAT NAVBAR ----------------------------------- */

#back-button { display: none; }
#forward-button { display: none; }
#reload-button { display: none; }
#stop-button { display: none; }
#home-button { display: none; }
#library-button { display: none; }
#fxa-toolbar-menu-button { display: none; }
/* empty space before and after the url bar */
#customizableui-special-spring1, #customizableui-special-spring2 { display: none; }


/* remove padding between toolbar buttons */
toolbar .toolbarbutton-1 { padding: 0 0 !important; }

/* add padding to the right of the last button so that it doesn't touch the edge of the window */
#PanelUI-menu-button {
padding: 0px 4px 0px 0px !important;
}

#urlbar-container {
    --urlbar-container-height: var(--urlbar-height-setting) !important;
    margin-left: 0 !important;
    margin-right: 0 !important;
    padding-top: 0 !important;
    padding-bottom: 0 !important;
    font-family: var(--urlbar-font, 'monospace');
    font-size: ${toString font.sizes.applications}pt;
}

#urlbar {
    --urlbar-height: var(--urlbar-height-setting) !important;
    --urlbar-toolbar-height: var(--urlbar-height-setting) !important;
    min-height: var(--urlbar-height-setting) !important;
    border-color: var(--lwt-toolbar-field-border-color, hsla(240,5%,5%,.25)) !important;
}

#urlbar-input {
    margin-left: 0.8em !important;
    margin-right: 0.4em !important;
}

/* keep pop-up menus from overlapping with navbar */
#widget-overflow { margin: 0 !important; }
#appMenu-popup { margin: 0 !important; }
#customizationui-widget-panel { margin: 0 !important; }
#unified-extensions-panel { margin: 0 !important; }

    /* --- UNIFIED EXTENSIONS BUTTON ------------------------ */

    /* make extension icons smaller */
#unified-extensions-view {
    --uei-icon-size: ${toString font.sizes.applications}pt;
    }

    /* hide bloat */
    .unified-extensions-item-message-deck,
#unified-extensions-view > .panel-header,
#unified-extensions-view > toolbarseparator,
/* #unified-extensions-manage-extensions {
    display: none !important;
    }
*/
    /* add 3px padding on the top and the bottom of the box */
    .panel-subview-body {
    padding: 3px 0px !important;
    }

#unified-extensions-view .unified-extensions-item-menu-button {
    margin-inline-end: 0 !important;
    }

#unified-extensions-view .toolbarbutton-icon {
    padding: 0 !important;
    }

    .unified-extensions-item-contents {
    line-height: 1 !important;
    white-space: nowrap !important;
    }

    /* --- DEBLOAT URLBAR ----------------------------------- */

#identity-box { display: none; }
#pageActionButton { display: none; }
#pocket-button { display: none; }
#urlbar-zoom-button { display: none; }
#tracking-protection-icon-container { display: none !important; }
#reader-mode-button{ display: none !important; }
#star-button { display: none; }
#star-button-box:hover { background: inherit !important; }

    /* Go to arrow button at the end of the urlbar when searching */
#urlbar-go-button { display: none; }

#titlebar {
    --proton-tab-block-margin: 0px !important;
    --tab-block-margin: 0px !important;
}

#TabsToolbar, .tabbrowser-tab {
    max-height: var(--tab-min-height) !important;
    font-size: ${toString font.sizes.applications}pt !important;
}

/* Change color of normal tabs */
tab:not([selected="true"]) {
    background-color: var(--tab-inactive-bg-color) !important;
    color: var(--identity-icon-color, var(--tab-inactive-fg-fallback-color)) !important;
}

tab {
    font-family: var(--tab-font, monospace);
    font-weight: bold;
    border: none !important;
}

    /* safari style tab width */
.tabbrowser-tab[fadein] {
    max-width: 100vw !important;
    border: none
}

/* Always show tab close button on hover and never otherwise */
.tabbrowser-tab .tab-close-button{
  display:none;
}
.tabbrowser-tab:not([pinned]):hover .tab-close-button{
  display: flex !important;
  align-items: center;
}

    /* disable favicons in tab */
    /* .tab-icon-stack:not([pinned]) { display: none !important; } */

    .tabbrowser-tab {
    /* remove border between tabs */
    padding-inline: 0px !important;
    /* reduce fade effect of tab text */
    --tab-label-mask-size: 1em !important;
    /* fix pinned tab behaviour on overflow */
    overflow-clip-margin: 0px !important;
    }

    /* Tab: selected colors */
#tabbrowser-tabs .tabbrowser-tab[selected] .tab-content {
    background: var(--tab-active-bg-color) !important;
    color: var(--identity-icon-color, var(--tab-active-fg-fallback-color)) !important;
    }

    /* Tab: hovered colors */
#tabbrowser-tabs .tabbrowser-tab:hover:not([selected]) .tab-content {
    background: var(--tab-active-bg-color) !important;
    }


    /* disable tab shadow */
#tabbrowser-tabs:not([noshadowfortests]) .tab-background:is([selected], [multiselected]) {
    box-shadow: none !important;
    }

    /* remove dark space between pinned tab and first non-pinned tab */
#tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs]) >
#tabbrowser-arrowscrollbox >
    .tabbrowser-tab:nth-child(1 of :not([pinned], [hidden])) {
    margin-inline-start: 0px !important;
    }

    /* remove dropdown menu button which displays all tabs on overflow */
#alltabs-button { display: none !important }

    /* fix displaying of pinned tabs on overflow */
#tabbrowser-tabs:not([secondarytext-unsupported]) .tab-label-container {
    height: var(--tab-min-height) !important;
    }

    /* remove overflow scroll buttons */
#scrollbutton-up, #scrollbutton-down { display: none !important; }

    /* remove new tab button */
#tabs-newtab-button {
    display: none !important;
    }

    /* hide private browsing indicator */
#private-browsing-indicator-with-label {
    display: none;
    }

    /* --- AUTOHIDE NAVBAR ---------------------------------- */
:root{
  --uc-autohide-toolbox-delay: 500ms;
  --uc-toolbox-rotation: 82deg;
}

:root[sizemode="maximized"]{
  --uc-toolbox-rotation: 88.5deg;
}

@media  (-moz-platform: windows){
  #navigator-toolbox:not(:-moz-lwtheme){ background-color: -moz-dialog !important; }
}

:root[sizemode="fullscreen"],
#navigator-toolbox[inFullscreen]{ margin-top: 0 !important; }

#navigator-toolbox{
  position: fixed !important;
  display: block;
  background-color: var(--lwt-accent-color,black) !important;
  transition: transform 82ms linear, opacity 82ms linear !important;
  transition-delay: var(--uc-autohide-toolbox-delay) !important;
  transform-origin: top;
  transform: rotateX(var(--uc-toolbox-rotation));
  opacity: 0;
  line-height: 0;
  z-index: 1;
  pointer-events: none;
}

#navigator-toolbox:hover,
#navigator-toolbox:focus-within{
  transition-delay: 33ms !important;
  transform: rotateX(0);
  opacity: 1;
}
/* This ruleset is separate, because not having :has support breaks other selectors as well */
#mainPopupSet:has(> #appMenu-popup:hover) ~ toolbox{
  transition-delay: 33ms !important;
  transform: rotateX(0);
  opacity: 1;
}

#navigator-toolbox > *{ line-height: normal; pointer-events: auto }

#navigator-toolbox,
#navigator-toolbox > *{
  width: 100vw;
  -moz-appearance: none !important;
}

/* These two exist for oneliner compatibility */
#nav-bar{ width: var(--uc-navigationbar-width,100vw) }
#TabsToolbar{ width: calc(100vw - var(--uc-navigationbar-width,0px)) }

/* Don't apply transform before window has been fully created */
:root:not([sessionrestored]) #navigator-toolbox{ transform:none !important }

:root[customizing] #navigator-toolbox{
  position: relative !important;
  transform: none !important;
  opacity: 1 !important;
}

#navigator-toolbox[inFullscreen] > #PersonalToolbar,
#PersonalToolbar[collapsed="true"]{ display: none }
''
