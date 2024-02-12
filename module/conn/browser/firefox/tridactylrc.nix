config: user: lib: ''
jsb Object.keys(tri.config.get("searchurls")).reduce((prev, u) => prev.catch(()=>{}).then(_ => tri.excmds.setnull("searchurls." + u)), Promise.resolve()) 

${builtins.concatStringsSep "\n" (map (attrs: "set searchurls.${attrs.shortcut} ${builtins.replaceStrings [ "{}" ] [ "%s" ] attrs.url}") config.browsers.searchEngines)}

colorscheme ${user}
set newtab about:blank
set allowautofocus false
set tabcontaineraware true
set hintnames short
unbind j
unbind k

autocmd DocStart ^http(s?)://www.reddit.com js tri.excmds.urlmodify("-t", "www", "old")
autocmd DocLoad twitter.com urlmodify -t twitter.com nitter.net

''
