config: user: lib: ''
jsb Object.keys(tri.config.get("searchurls")).reduce((prev, u) => prev.catch(()=>{}).then(_ => tri.excmds.setnull("searchurls." + u)), Promise.resolve()) 

${builtins.concatStringsSep "\n" (lib.flatten [
(map (attrs: "set searchurls.${attrs.shortcut} ${builtins.replaceStrings [ "{}" ] [ "%s" ] attrs.url}") config.browsers.searchEngines)
])}

colorscheme nix
set newtab ${config.browsers.homepage}
set allowautofocus false
set tabcontaineraware true
set hintnames short
unbind <S-l>
unbind <S-h>
bind j scrollline 10
bind k scrollline -10
bind b fillcmdline taball
bind q fillcmdline tabclose

autocmd DocStart ^http(s?)://www.reddit.com js tri.excmds.urlmodify("-t", "www", "old")
autocmd DocLoad twitter.com urlmodify -t twitter.com nitter.net

unfocus

''
