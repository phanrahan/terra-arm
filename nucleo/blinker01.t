local output = ... --the output file name

local PUT32 = terralib.externfunction("PUT32", {uint,uint} -> {})
local GET32 = terralib.externfunction("GET32", {uint} -> {uint})
local dummy = terralib.externfunction("dummy", {uint} -> {})

local RCCBASE = 0x40021000
local GPIOABASE = 0x48000000

terra wait(n:int)
    for i = 0,n do dummy(i) end
end

terra blink()
    PUT32(GPIOABASE+0x18,(1<<5)<<0)
    wait(800000)
    PUT32(GPIOABASE+0x18,(1<<5)<<16)
    wait(200000)
end

local T = {}

terra T.notmain()

    var ra=GET32(RCCBASE+0x14)
    ra =ra or (1<<17)
    PUT32(RCCBASE+0x14,ra)

    --moder
    ra=GET32(GPIOABASE+0x00)
    ra = ra and not (3<<10) 
    ra = ra or (1<<10) 
    PUT32(GPIOABASE+0x00,ra)

    --OTYPER
    ra=GET32(GPIOABASE+0x04)
    ra = ra and not (1<<5)
    PUT32(GPIOABASE+0x04,ra)

    -- ospeedr
    ra=GET32(GPIOABASE+0x08)
    ra = ra or (3<<10)
    PUT32(GPIOABASE+0x08,ra)

    -- pupdr
    ra=GET32(GPIOABASE+0x0C)
    ra = ra and not (3<<10)
    PUT32(GPIOABASE+0x0C,ra)
    
    while true do
        blink()
    end
    return 
end

local target = { Triple = "thumb-none-eabi", CPU = "cortex-m0", Features = ""}
terralib.saveobj(output,T,nil,target)
