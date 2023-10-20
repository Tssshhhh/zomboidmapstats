if MapLoader == nil then MapLoader = {} end

-- Parser variables --
local parserInitialized = false
local isLoadingLouisville = false
local isLoadingMall1 = false
local isLoadingMall2 = false
local isLoadingWestpoint = false
local isLoadingRiverside = false
local isLoadingRiversideWest = false
local isLoadingResort = false
local isLoadingCentertown = false
local isLoadingRosewood = false
local isLoadingMuldraugh = false
local isLoadingFullSouth = false
local isLoadingRoadstations = false
local isLoadingAll = false
local isLoadingSmalllost1 = false
local isLoadingSmalllost2 = false
local xParser = nil;
local yParser = nil;
-- Coordinates --
-- Louisville
local louisvillecoords = {12000, 1227, 14400, 4200}
-- Mall Area
local mallareacoords1 = {12450, 4156, 12900, 6450}
local mallareacoords2 = {12950, 4850, 14150, 5950}
-- Westpoint
local westpointcoords = {9300, 6600, 12400, 7800}
-- Riverside
local riversidecoords = {5727, 5192, 6982, 5578}
local westrivercoords = {3600, 5650, 4350, 6400}
local resortcoords = {5200, 5800, 6350, 6750}
-- Ekron
local centertowncoords = {6947, 8082, 7543, 8545}
-- Muldraugh
local muldraughcoords = {10270, 9191, 11066, 10640}
-- March Ridge
local fullsouthcoords = {9778, 12585, 10500, 13167}
-- Rosewood
local rosewoodcoords = {7495, 11093, 8529, 12387}
-- Road stations / shops
local roadstationscoords = {11305, 8229, 11932, 9000}
local smalllost1coords = {5423, 9400, 6004, 9994}
local smalllost2coords = {9920, 10801, 10304, 11180}

local function doTeleport()
    local playerChar = getPlayer()
    -- force zoom out for maximum loading area
    getCore():doZoomScroll(0, 1);
    -- print("Teleporting to " .. xParser .. ".x - " .. yParser .. ".y")
    playerChar:setX(xParser);
    playerChar:setY(yParser);
    playerChar:setLx(xParser);
    playerChar:setLy(yParser);
    xParser = xParser + 70;
    -- Look around twice
    for i = 1, 2 do
        ISTimedActionQueue.add(MLWaitForLoad:new(playerChar, IsoDirections.W, 50));
        ISTimedActionQueue.add(MLWaitForLoad:new(playerChar, IsoDirections.NW, 50));
        ISTimedActionQueue.add(MLWaitForLoad:new(playerChar, IsoDirections.N, 50));
        ISTimedActionQueue.add(MLWaitForLoad:new(playerChar, IsoDirections.NE, 50));
        ISTimedActionQueue.add(MLWaitForLoad:new(playerChar, IsoDirections.E, 50));
        ISTimedActionQueue.add(MLWaitForLoad:new(playerChar, IsoDirections.SE, 50));
        ISTimedActionQueue.add(MLWaitForLoad:new(playerChar, IsoDirections.S, 50));
        ISTimedActionQueue.add(MLWaitForLoad:new(playerChar, IsoDirections.SW, 50));
        ISTimedActionQueue.add(MLWaitForLoad:new(playerChar, IsoDirections.W, 50));
    end
end

local function doLoadSection(coordsTable)
    local isFinished = false
    -- Initialize parser variables
    if parserInitialized == false then
        xParser = coordsTable[1];
        yParser = coordsTable[2];
        parserInitialized = true;
    end
    -- Do teleport
    doTeleport()
    -- if parser X reached the max, then reset and advance Y
    if xParser > coordsTable[3] then
        xParser = coordsTable[1];
        yParser = yParser + 70;
    end
    -- Clear parser variables
    if yParser > coordsTable[4] then
        xParser = nil;
        yParser = nil;
        parserInitialized = false;
        -- Is Loading Finished
        isFinished = true
    end
    return isFinished
end

local function endLoadMap()
    ISWorldMap.ToggleWorldMap(getPlayer():getPlayerNum());
    setGameSpeed(1);
    getGameTime():setMultiplier(1);
end

local function EveryTenMinutes()

    -- Loading Louisville
    if isLoadingLouisville then
        local isLoaded = doLoadSection(louisvillecoords)
        if isLoaded == true then
            isLoadingLouisville = false;
            endLoadMap();
        end
    end

    -- Loading Mall Area
    if isLoadingMall1 then
        local isLoaded = doLoadSection(mallareacoords1)
        if isLoaded == true then
            isLoadingMall1 = false;
            isLoadingMall2 = true;
        end
    end
    if isLoadingMall2 then
        local isLoaded = doLoadSection(mallareacoords2)
        if isLoaded == true then
            isLoadingMall2 = false;
            endLoadMap();
        end
    end

    -- Loading Westpoint
    if isLoadingWestpoint then
        local isLoaded = doLoadSection(westpointcoords)
        if isLoaded == true then
            isLoadingWestpoint = false;
            endLoadMap();
        end
    end

    -- Loading Riverside
    if isLoadingRiverside then
        local isLoaded = doLoadSection(riversidecoords)
        if isLoaded == true then
            isLoadingRiverside = false;
            isLoadingRiversideWest = true;
        end
    end
    if isLoadingRiversideWest then
        local isLoaded = doLoadSection(westrivercoords)
        if isLoaded == true then
            isLoadingRiversideWest = false;
            isLoadingResort = true;
        end
    end
    if isLoadingResort then
        local isLoaded = doLoadSection(resortcoords)
        if isLoaded == true then
            isLoadingResort = false;
            endLoadMap();
        end
    end

    -- Loading Ekron
    if isLoadingCentertown then
        local isLoaded = doLoadSection(centertowncoords)
        if isLoaded == true then
            isLoadingCentertown = false;
            endLoadMap();
        end
    end

    -- Loading Rosewood
    if isLoadingRosewood then
        local isLoaded = doLoadSection(rosewoodcoords)
        if isLoaded == true then
            isLoadingRosewood = false;
            endLoadMap();
        end
    end

    -- Loading Muldraugh
    if isLoadingMuldraugh then
        local isLoaded = doLoadSection(muldraughcoords)
        if isLoaded == true then
            isLoadingMuldraugh = false;
            endLoadMap();
        end
    end

    -- Loading March Ridge
    if isLoadingFullSouth then
        local isLoaded = doLoadSection(fullsouthcoords)
        if isLoaded == true then
            isLoadingFullSouth = false;
            endLoadMap();
        end
    end

    -- Loading Road Stations and Shops
    if isLoadingRoadstations then
        local isLoaded = doLoadSection(roadstationscoords)
        if isLoaded == true then
            isLoadingRoadstations = false;
            isLoadingSmalllost1 = true;
        end
    end
    if isLoadingSmalllost1 then
        local isLoaded = doLoadSection(smalllost1coords)
        if isLoaded == true then
            isLoadingSmalllost1 = false;
            isLoadingSmalllost2 = true;
        end
    end
    if isLoadingSmalllost2 then
        local isLoaded = doLoadSection(smalllost2coords)
        if isLoaded == true then
            isLoadingSmalllost2 = false;
            endLoadMap();
        end
    end

    -- IS LOADING ALL --
    if isLoadingAll then
        local isLoaded = doLoadSection(mallareacoords1)
        if isLoaded == true then
            isLoadingAll = false;
            all_isLoadingMall2 = true;
        end
    end
    if all_isLoadingMall2 then
        local isLoaded = doLoadSection(mallareacoords2)
        if isLoaded == true then
            all_isLoadingMall2 = false;
            all_isLoadingWestpoint = true;
        end
    end
    if all_isLoadingWestpoint then
        local isLoaded = doLoadSection(westpointcoords)
        if isLoaded == true then
            all_isLoadingWestpoint = false;
            all_isLoadingRiverside = true;
        end
    end
    if all_isLoadingRiverside then
        local isLoaded = doLoadSection(riversidecoords)
        if isLoaded == true then
            all_isLoadingRiverside = false;
            all_isLoadingRiversideWest = true;
        end
    end
    if all_isLoadingRiversideWest then
        local isLoaded = doLoadSection(westrivercoords)
        if isLoaded == true then
            all_isLoadingRiversideWest = false;
            all_isLoadingResort = true;
        end
    end
    if all_isLoadingResort then
        local isLoaded = doLoadSection(resortcoords)
        if isLoaded == true then
            all_isLoadingResort = false;
            all_isLoadingCentertown = true;
        end
    end
    if all_isLoadingCentertown then
        local isLoaded = doLoadSection(centertowncoords)
        if isLoaded == true then
            all_isLoadingCentertown = false;
            all_isLoadingRosewood = true;
        end
    end
    if all_isLoadingRosewood then
        local isLoaded = doLoadSection(rosewoodcoords)
        if isLoaded == true then
            all_isLoadingRosewood = false;
            all_isLoadingMuldraugh = true;
        end
    end
    if all_isLoadingMuldraugh then
        local isLoaded = doLoadSection(muldraughcoords)
        if isLoaded == true then
            all_isLoadingMuldraugh = false;
            all_isLoadingFullSouth = true;
        end
    end
    if all_isLoadingFullSouth then
        local isLoaded = doLoadSection(fullsouthcoords)
        if isLoaded == true then
            all_isLoadingFullSouth = false;
            all_isLoadingRoadstations = true;
        end
    end
    if all_isLoadingRoadstations then
        local isLoaded = doLoadSection(roadstationscoords)
        if isLoaded == true then
            all_isLoadingRoadstations = false;
            all_isLoadingSmalllost1 = true;
        end
    end
    if all_isLoadingSmalllost1 then
        local isLoaded = doLoadSection(smalllost1coords)
        if isLoaded == true then
            all_isLoadingSmalllost1 = false;
            all_isLoadingSmalllost2 = true;
        end
    end
    if all_isLoadingSmalllost2 then
        local isLoaded = doLoadSection(smalllost2coords)
        if isLoaded == true then
            all_isLoadingSmalllost2 = false;
            all_isLoadingLouisville = true;
        end
    end
    if all_isLoadingLouisville then
        local isLoaded = doLoadSection(louisvillecoords)
        if isLoaded == true then
            all_isLoadingLouisville = false;
            endLoadMap();
        end
    end
end

Events.EveryTenMinutes.Add(EveryTenMinutes);

-- Context Menus

local function doLoadSetup(playerObj)
    ISWorldMap.ToggleWorldMap(playerObj:getPlayerNum())
    local mapLoaderModData = ModData.get('MapLoader')
    local speed = nil
    if mapLoaderModData then
        speed = mapLoaderModData['speed']
    end
    print("------ speed ------")
    print(speed)
    if speed then
        if speed == 4 then
            setGameSpeed(4);getGameTime():setMultiplier(40);
        end
        if speed == 3 then
            setGameSpeed(3)
            getGameTime():setMultiplier(20)
        end
        if speed == 2 then
            setGameSpeed(2);
            getGameTime():setMultiplier(5);
        end
        if speed == 1 then
            setGameSpeed(1);getGameTime():setMultiplier(1);
            getGameTime():setMultiplier(1)
        end
    else
        setGameSpeed(3)
        getGameTime():setMultiplier(20)
    end
    playerObj:setGhostMode(true)
    playerObj:setGodMod(true)
    playerObj:setInvisible(true)
end

function MapLoader.doLoadLouisville(playerObj)
    if not playerObj then return end
    doLoadSetup(playerObj)
    isLoadingLouisville = true
end

function MapLoader.doLoadMall(playerObj)
    if not playerObj then return end
    doLoadSetup(playerObj)
    isLoadingMall1 = true
end

function MapLoader.doLoadWestpoint(playerObj)
    if not playerObj then return end
    doLoadSetup(playerObj)
    isLoadingWestpoint = true
end

function MapLoader.doLoadRiverside(playerObj)
    if not playerObj then return end
    doLoadSetup(playerObj)
    isLoadingRiverside = true
end

function MapLoader.doLoadCentertown(playerObj)
    if not playerObj then return end
    doLoadSetup(playerObj)
    isLoadingCentertown = true
end

function MapLoader.doLoadRosewood(playerObj)
    if not playerObj then return end
    doLoadSetup(playerObj)
    isLoadingRosewood = true
end

function MapLoader.doLoadMuldraugh(playerObj)
    if not playerObj then return end
    doLoadSetup(playerObj)
    isLoadingMuldraugh = true
end

function MapLoader.doLoadFullSouth(playerObj)
    if not playerObj then return end
    doLoadSetup(playerObj)
    isLoadingFullSouth = true
end

function MapLoader.doLoadRoadstations(playerObj)
    if not playerObj then return end
    doLoadSetup(playerObj)
    isLoadingRoadstations = true
end

function MapLoader.doLoadAll(playerObj)
    if not playerObj then return end
    doLoadSetup(playerObj)
    isLoadingAll = true
end

function MapLoader.doUpdateSpeed(speed)
    local mapLoaderModData = ModData.getOrCreate('MapLoader')
    mapLoaderModData['speed'] = speed
    print("------ doUpdateSpeed ------")
    print(mapLoaderModData)
end

function MapLoader.getCoords(playerObj)
    if not playerObj then return end
    print("X: " .. playerObj:getX())
    print("Y: " .. playerObj:getY())
    print("Z: " .. playerObj:getZ())
end

function MapLoader.contextMenuOptions(player, context, worldobjects, test)
    local playerObj = getSpecificPlayer(player)

    -- Load regions -- Explore text sur les galeries 
    local regionOption = context:addOption("[ML] Load region", worldobjects, nil);
    local subMenu = ISContextMenu:getNew(context);
    context:addSubMenu(regionOption, subMenu);
    -- Loading Muldraugh
    subMenu:addOption("[ML] Load Muldraugh", playerObj, MapLoader.doLoadMuldraugh)
    -- Loading Rosewood
    subMenu:addOption("[ML] Load Rosewood", playerObj, MapLoader.doLoadRosewood)
    -- Loading Westpoint
    subMenu:addOption("[ML] Load Westpoint", playerObj, MapLoader.doLoadWestpoint)
    -- Loading Riverside
    subMenu:addOption("[ML] Load Riverside", playerObj, MapLoader.doLoadRiverside)
    -- Loading Ekron
    subMenu:addOption("[ML] Load Ekron", playerObj, MapLoader.doLoadCentertown)
    -- Loading March Ridge
    subMenu:addOption("[ML] Load March Ridge", playerObj, MapLoader.doLoadFullSouth)
    -- Loading Mall Area
    subMenu:addOption("[ML] Load Mall Area", playerObj, MapLoader.doLoadMall)
    -- Loading Road Stations and Shops
    subMenu:addOption("[ML] Load Stations and Shops", playerObj, MapLoader.doLoadRoadstations)
    -- Loading Louisville
    subMenu:addOption("[ML] Load Louisville", playerObj, MapLoader.doLoadLouisville)
    -- Get current coords
    subMenu:addOption("[ML] Get Coords", playerObj, MapLoader.getCoords)
    -- Get current coords
    subMenu:addOption("[ML] LOAD ALL (high risk of crash)", playerObj, MapLoader.doLoadAll)


    -- Load regions --
    local configureOption = context:addOption("[ML] Configure Speed", worldobjects, nil);
    local subMenu2 = ISContextMenu:getNew(context);
    context:addSubMenu(configureOption, subMenu2);
    -- Speed 4 (default)
    subMenu2:addOption("[ML] Speed 4 (very fast)", 4, MapLoader.doUpdateSpeed)
    -- Speed 3 (default)
    subMenu2:addOption("[ML] Speed 3 (fast, default)", 3, MapLoader.doUpdateSpeed)
    -- Speed 2
    subMenu2:addOption("[ML] Speed 2 (medium)", 2, MapLoader.doUpdateSpeed)
    -- Speed 1
    subMenu2:addOption("[ML] Speed 1 (slow)", 1, MapLoader.doUpdateSpeed)
end

Events.OnFillWorldObjectContextMenu.Add(MapLoader.contextMenuOptions);

-- ModData.getOrCreate('OE_aerobicsboosted')[playerObj:getUsername()] = true