require "TimedActions/ISBaseTimedAction"

MLWaitForLoad = ISBaseTimedAction:derive("MLWaitForLoad");

function MLWaitForLoad:isValid()
    return true;
end

function MLWaitForLoad:update()
end

function MLWaitForLoad:start()
end

function MLWaitForLoad:stop()
    ISBaseTimedAction.stop(self);
end

function MLWaitForLoad:perform()
    -- needed to remove from queue / start next.
    self.character:setDir(self.direction)
    ISBaseTimedAction.perform(self);
end

function MLWaitForLoad:new(character, direction, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.direction = direction;
    o.stopOnWalk = false;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end
