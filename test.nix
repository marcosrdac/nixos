listDir = path: builtins.attrNames (builtins.readDir path)

listDir ./lib/modules
