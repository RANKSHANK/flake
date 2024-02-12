rule = {
	matches = {
        {
            { "device.nick", "equals", "HDA NVidia" },
        },
    },
	apply_properties = {
		[ "device.disabled" ] = true,
	},
}

table.insert(alsa_monitor.rules, rule)
