local sequence = {
    _VERSION         = 'sequence v1.0.0',
    _DESCRIPTION    = 'A double linked list implementation in Lua',
    _URL            = 'https://github.com/superzazu/sequence.lua',
    _LICENSE        = [[
Copyright (c) 2018 Nicolas Allemand

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]
}

-- creates a new sequence
sequence.new = function()
    local s = {}
    s.count = 0
    s.first = nil
    s.last = nil

    setmetatable(s, {
        __len = function(t)
            return t.count
        end
    })

    -- shortcuts:
    s.add = function(self, e)
        sequence.add(self, e)
    end

    s.del = function(self, e)
        sequence.del(self, e)
    end

    s.all = function(self)
        return sequence.all(self)
    end

    s.foreach = function(self, f)
        sequence.foreach(self, f)
    end

    return s
end

-- adds an element e at the end of sequence s
sequence.add = function(s, e)
    local new_node = {
        ["obj"] = e,
        ["next"] = nil,
        ["prev"] = s.last,
    }

    if s.first == nil then
        s.first = new_node
    end

    if s.last then
        s.last.next = new_node
    end

    s.last = new_node
    s.count = s.count + 1
end

-- deletes the first instance of element e in sequence s
sequence.del = function(s, e)
    for element in sequence.all(s, true) do
        if element.obj == e then
            if element.next then
                element.next.prev = element.prev
            else
                s.last = element.prev
            end
            if element.prev then
                element.prev.next = element.next
            else
                s.first = element.next
            end

            s.count = s.count - 1
            break
        end
    end
end

-- iterates through all the elements of a sequence s in order
-- during iteration, you can safely remove and add elements to the sequence
-- "return_node" returns the node instead of the object stored in sequence.
sequence.all = function(s, return_node)
    return_node = return_node or false
    local current_node = -1
    return function()
        if current_node == -1 then
            current_node = s.first
        else
            current_node = current_node.next
        end

        if current_node then
            if return_node == true then
                return current_node
            else
                return current_node.obj
            end
        end

        return nil
    end
end

-- for each element in sequence s, executes function f with the element
-- as parameter
sequence.foreach = function(s, f)
    for element in sequence.all(s) do
        f(element)
    end
end

return sequence
