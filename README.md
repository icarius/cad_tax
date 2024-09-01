# cad_tax

A Simple QBX Tax System

# Dependances
* ox_lib
* qbx_core

  
# Installation

* Change Config values in `config/sv_config.lua` to your liking.
* Copy/Paste en.json and traduct it in your language, pay attention to rename it (ex: it.json for Italian)
* Done

# Server Exports

```lua
exports.cad_tax:GetCurrentTax(src, type)    -- Get Current Tax percent for the type ['vehicle', 'house', 'income']
exports.cad_tax:PlayersTax() -- Run this tax manually
exports.cad_tax:CarsTax()  -- Run this tax manually
exports.cad_tax:HousesTax()  -- Run this tax manually
```
