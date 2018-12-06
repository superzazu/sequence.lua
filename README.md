# sequence.lua

A Lua library that provides a doubly linked list, allowing you to safely add and remove elements to a sequence, even while iterating on it.

This library is heavily inspired by PICO-8 functions "add", "del", "all" and "foreach".

Example:

```lua
local sequence = require "sequence"

monsters = sequence.new()
monsters:add({["hp"] = 3})
monsters:add({["hp"] = 2})
monsters:add({["hp"] = 3})
monsters:add({["hp"] = 4})

for monster in monsters:all() do
    monster.hp = monster.hp - 2

    if monster.hp <= 0 then
        monsters:del(monster)
    end
end

monsters:foreach(function(m)
    print(m.hp)
end)

print(monsters.count) -- 3
print(#monsters) -- only available for Lua 5.2+
```

