# cad_tax

A Simple QBX Tax System

# Installation

* Change Config values in `cad_tax/config/sv_config.lua` to your liking.
* Done

# Server Exports

```lua
exports.cad_tax:GetCurrentTax(src, type)    -- Get Current Tax percent for the type ['vehicle', 'house', 'income']
exports.cad_tax:PlayersTax() -- Run this tax manually
exports.cad_tax:CarsTax()  -- Run this tax manually
exports.cad_tax:HousesTax()  -- Run this tax manually
```
