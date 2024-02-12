rule = {
	matches = {
        {
            { "node.name", "equals", "alsa_output.usb-Focusrite_Scarlett_Solo_USB-00.analog-stereo" },
        },
    },
	apply_properties = {
		[ "node.description" ] = "Scarlett Solo Out",
		[ "node.nick" ] = "Scarlett Out",
	},
}

table.insert(alsa_monitor.rules, rule)
