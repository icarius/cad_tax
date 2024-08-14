return {
    EconomyTax = {
        low = 100000,
        medium = 250000,
        high = 500000,
        ultra = 1000000,
        extreme = 2000000,
    },

    EconomyTaxPercentage = {
        low = 0.1,
        medium = 0.5,
        high = 0.6,
        ultra = 0.8,
        extreme = 1,
    },

    EconomyTaxInterval = 120, -- in minutes (2 hrs)

    CarTaxRate = 100,         -- $100 per car
    CarTaxInterval = 180,     -- in minutes (3hrs)

    HouseTaxRate = 500,       -- $500 per house
    HouseTaxInterval = 180,   -- in minutes (3hrs)

    -- account where all the taxes will go to
    TaxesAccountEnabled = false,

    TaxesAccount = {
        accountType = 'business',   -- 'business' or 'player'
        playerCitizenId = 'QBUSSUCK', -- player citizenid (only for player account)
        business_name = 'gov',      -- 'businessName' (only for business account)
    },

    Lang = {
        player_tax = 'Player tax recieved $%d',
        car_tax = 'Vehicle tax recieved $%d',
        house_tax = 'House tax recieved $%d'
    },
}
