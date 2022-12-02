local Knit = require( game.ReplicatedStorage.Knit )
local InventoryHelper = require( Knit.Helpers.InventoryHelper )

local data = {
    Coins = 200;
    Orbs = 0;
    InventoryLevel = 1;
    Speed = 1;
    Rebirths = 0;
    Steps = 0;
    UnlockedZones = {"Starter"};
    Pets = {};
}

InventoryHelper.AddBatchToInventory(data.Pets, {
    {
        Name = "Frost Dragon";
        _equipped = false;
        Level = 1;
    };

    {
        Name = "Fireball";
        _equipped = true;
        Level = 1;
    };

    {
        Name = "Bear";
        _equipped = false;
        Level = 5;
    };

    {
        Name = "Horse";
        _equipped = true;
        Level = 1;
    };

    {
        Name = "Cat";
        _equipped = false;
        Level = 1;
    };

    {
        Name = "Rock Dragon";
        _equipped = true;
        Level = 30;
    }
})

local function GetPlayerDataTemplate()
    local formattedData = {}
    for key, value in pairs( data ) do
        if ( type(value) == "function" ) then
            formattedData[ key ] = value()
        else
            formattedData[ key ] = value
        end
    end
    return formattedData
end

return GetPlayerDataTemplate()