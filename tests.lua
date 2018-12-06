-- requires utest (https://github.com/iudalov/u-test): luarocks install u-test
-- to run the tests, run in terminal "lua tests.lua"
local test = require "u-test"
local sequence = require "sequence"

local function get_lua_version()
    local major, minor = _VERSION:match("Lua (%d).(%d)")
    return major * 10 + minor
end

test.can_add_elements_with_add = function()
    local mysequence = sequence.new()

    mysequence:add(1)
    mysequence:add(2)
    mysequence:add(3)
    sequence.add(mysequence, 4)

    test.equal(mysequence.count, 4)
end

test.can_access_first_and_last_elements = function()
    local mysequence = sequence.new()

    mysequence:add(1)
    mysequence:add(2)
    mysequence:add(3)

    test.equal(mysequence.first.obj, 1)
    test.equal(mysequence.last.obj, 3)
end

test.can_remove_elements_with_del = function()
    local mysequence = sequence.new()

    mysequence:add(1)
    mysequence:add(2)
    mysequence:add(3)

    mysequence:del(2)

    test.equal(mysequence.count, 2)
    test.equal(mysequence.first.obj, 1)
end

test.can_remove_first_element = function()
    -- checks that removing the first element in sequence updates
    -- "first" attribute
    local mysequence = sequence.new()

    mysequence:add(1)
    mysequence:add(2)
    mysequence:add(3)

    mysequence:del(1)

    test.equal(mysequence.count, 2)
    test.equal(mysequence.first.obj, 2)
end

test.can_remove_last_element = function()
    -- checks that removing the last element in sequence updates
    -- "last" attribute
    local mysequence = sequence.new()

    mysequence:add(1)
    mysequence:add(2)
    mysequence:add(3)

    mysequence:del(3)

    test.equal(mysequence.count, 2)
    test.equal(mysequence.last.obj, 2)
end

test.can_iterate_with_all = function()
    local mysequence = sequence.new()

    mysequence:add(1)
    mysequence:add(2)
    mysequence:add(3)

    local count = 0
    for element in mysequence:all() do
        count = count + element
    end
    test.equal(count, 6)
end

test.can_delete_current_element_while_iterating = function()
    local monsters = sequence.new()

    monsters:add({["hp"] = 2})
    monsters:add({["hp"] = 5})
    monsters:add({["hp"] = 4})

    -- will remove only the first element:
    for monster in monsters:all() do
        monster.hp = monster.hp - 2
        if monster.hp <= 0 then
            monsters:del(monster)
        end
    end

    local count = 0
    for monster in monsters:all() do
       count = count + monster.hp
    end

    test.equal(count, 5 - 2 + 4 - 2)
end

test.can_delete_next_element_while_iterating = function()
    local mysequence = sequence.new()

    mysequence:add({["count"] = 0})
    mysequence:add({["count"] = 1})
    mysequence:add({["count"] = 2})

    -- removing the second element while iterating on the first one:
    for element in mysequence:all() do
        if element.count == 0 then
            mysequence:del(mysequence.first.next.obj)
        end
    end

    local count = 0
    for element in mysequence:all() do
       count = count + element.count
    end

    test.equal(count, 2)
    test.equal(mysequence.count, 2)
end

test.can_add_elements_while_iterating = function()
    local mysequence = sequence.new()

    mysequence:add({["count"] = 1})
    mysequence:add({["count"] = 2})
    mysequence:add({["count"] = 3})

    for element in mysequence:all() do
        if element.count == 3 then
            mysequence:add({["count"] = 10})
        end
    end

    local count = 0
    for element in mysequence:all() do
       count = count + element.count
    end

    test.equal(count, 16)
    test.equal(mysequence.count, 4)
end

test.can_use_foreach = function()
    local mysequence = sequence.new()

    mysequence:add({["count"] = 0})
    mysequence:add({["count"] = 1})
    mysequence:add({["count"] = 2})
    mysequence:add({["count"] = 4})

    mysequence:foreach(function(element)
        element.count = element.count * 2
    end)

    local count = 0
    for element in mysequence:all() do
       count = count + element.count
    end

    test.equal(count, 14)
end

test.can_use_length_operator_on_sequences = function()
    -- note: this test only work on Lua 5.2+ (use of __len metatable)
    if get_lua_version() < 52 then
        return
    end

    local mysequence = sequence.new()

    for i = 1, 10 do
        mysequence:add(i)
    end

    test.equal(#mysequence, 10)
    test.equal(mysequence.count, 10)

    for i = 4, 8 do
        mysequence:del(i)
    end

    test.equal(#mysequence, 5)
    test.equal(mysequence.count, 5)
end

test.summary()
