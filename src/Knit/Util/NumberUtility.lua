-- NumberUtility
-- Author(s): serverOptimist
-- Date: 03/29/2021

--[[
    NumberUtility.FormatWithCommas( number: number ): string
        ( 9999 ) -> "9,999"
    NumberUtility.FormatCurrency( number: number ): string
        ( 999999999 ) -> "999.99M+"
    NumberUtility.NumberToWord( number: number ): string
        ( 107 ) -> "One Hundred Seven"
    NumberUtility.RoundToNearest( number: number, nearest: number ): number
        ( 9.015, 0.01 ) -> 9.02
    NumberUtility.RoundDownToNearest( number: number, nearest: number ): number
        ( 9.015, 0.01 ) -> 9.01
    NumberUtility.FormatSecondsToClockHours( seconds: number ): string -> "hours:minutes"
    NumberUtility.FormatSecondsToHours( seconds: number ): string -> "hours:minutes:seconds"
    NumberUtility.FormatSecondsToTextHours( seconds: number ): string
        ( 3690 ) -> "01h 01m 30s"
    NumberUtility.FormatSecondsToMinutes( seconds: number ): string -> "minutes:seconds"
]]

---------------------------------------------------------------------


-- Constants
local UNDER_TWENTY_WORDS = {
	[0] = "";			[1] = "One";		[2] = "Two"; 		[3] = "Three"; 		[4] = "Four";
	[5] = "Five";		[6] = "Six"; 		[7] = "Seven"; 		[8] = "Eight"; 		[9] = "Nine";
	[10] = "Ten";		[11] = "Eleven";	[12] = "Twelve";	[13] = "Thirteen";	[14] = "Fourteen";
	[15] = "Fifteen";	[16] = "Sixteen";	[17] = "Seventeen";	[18] = "Eighteen";	[19] = "Nineteen";
}
local TEN_WORDS = {
	[1] = "";		[2] = "Twenty";		[3] = "Thirty";	[4] = "Forty";	[5] = "Fifty";
	[6] = "Sixty";	[7] = "Seventy";	[8] = "Eighty";	[9] = "Ninety";
}
local THOUSAND_WORDS = {
	[0] = "";	[1] = "Thousand";	[2] = "Million";	[3] = "Billion";	[4] = "Trillion";
}
local MAX_FORMAT_WITH_COMMAS_NUMBER = 1000000000000000 - 1

-- Knit
local t = require( script.Parent.t )

-- Roblox Services

-- Variables


---------------------------------------------------------------------

local function NumberToStringHelper( number: number ): string
	if ( number == 0 ) then
		return ""
	elseif ( number < 20 ) then
		return UNDER_TWENTY_WORDS[ number ] .. " "
	elseif( number < 100 ) then
		return TEN_WORDS[ math.floor(number/10) ] .. " " .. NumberToStringHelper( number%10 )
	else
		return UNDER_TWENTY_WORDS[ math.floor(number / 100) ] .. " Hundred " .. NumberToStringHelper( number % 100 )
	end
end


local function TrimString( str )
	local clipped
	repeat
		str, clipped = str:gsub( "%s$", "" )
	until ( clipped <= 0 )
	return str
end


local NumberUtility = {}


local tFormatSecondsToMinutes = t.tuple( t.numberPositive )
function NumberUtility.FormatSecondsToMinutes( seconds: number ): string
    assert( tFormatSecondsToMinutes(seconds) )
	return string.format( "%02.f", math.floor(seconds/60) ) .. ":" .. string.format( "%02.f", math.floor(seconds%60) )
end


local tFormatSecondsToTextHours = t.tuple( t.numberPositive )
function NumberUtility.FormatSecondsToTextHours( seconds: number ): string
    assert( tFormatSecondsToTextHours(seconds) )
    local seconds = tonumber( seconds )
	if ( seconds<=0 ) then
		return "00h 00m 00s"
	else
		local hours = string.format( "%02.f", math.floor(seconds/3600) )
		local minutes = string.format( "%02.f", math.floor(seconds/60 - (hours*60)) )
		local seconds = string.format( "%02.f", math.floor(seconds - (hours*3600) - (minutes*60)) )
		return tostring( hours ) .. "h " .. tostring( minutes ) .. "m " .. tostring( seconds ) .. "s"
	end
end


local tFormatSecondsToHours = t.tuple( t.numberPositive )
function NumberUtility.FormatSecondsToHours( seconds: number ): string
    assert( tFormatSecondsToHours(seconds) )
    local seconds = tonumber( seconds )
	if ( seconds<=0 ) then
		return "00:00:00"
	else
		local hours = string.format( "%02.f", math.floor(seconds/3600) )
		local minutes = string.format( "%02.f", math.floor(seconds/60 - (hours*60)) )
		local seconds = string.format( "%02.f", math.floor(seconds - (hours*3600) - (minutes*60)) )
		return tostring( hours ) .. ":" .. tostring( minutes ) .. ":" .. tostring( seconds )
	end
end


local tFormatSecondsToClockHours = t.tuple( t.numberPositive )
function NumberUtility.FormatSecondsToClockHours( seconds: number ): string
    assert( tFormatSecondsToClockHours(seconds) )
    local seconds = tonumber( seconds )
	if ( seconds<=0 ) then
		return "00:00"
	else
		local hours = string.format( "%02.f", math.floor(seconds/3600) )
		local minutes = string.format( "%02.f", math.floor(seconds/60 - (hours*60)) )
		return tostring( hours ) .. ":" .. tostring( minutes )
	end
end


local tFormatWithCommas = t.tuple( t.number )
function NumberUtility.FormatWithCommas( number: number ): string
    assert( tFormatWithCommas(number) )
    local formatted, k = number, nil
	while true do
		formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", "%1,%2" )
		if (k==0) then
			break
		end
	end
	return formatted
end


-- TODO: Turn this into a maxFloat, suffix for loop
local tFormatCurrency = t.tuple( t.number )
function NumberUtility.FormatCurrency( number: number ): string
    assert( tFormatCurrency(number) )
    number = math.clamp( number, 0, MAX_FORMAT_WITH_COMMAS_NUMBER )
	local suffix
	if ( number < 1000000 ) then
		---999,999
		return NumberUtility.FormatWithCommas( number )
	elseif ( number < 1000000 ) then
		--99.99K+
		suffix = "K+"
		number = number / 1000
	elseif ( number < 1000000000 ) then 
		--999.99M+
		suffix = "M+"
		number = number / 1000000
	elseif ( number < 1000000000000 ) then 
		--999.99B+
		suffix = "B+"
		number = number / 1000000000
	elseif ( number < 1000000000000000 ) then
		--999.99T+
		suffix = "T+"
		number = number / 1000000000000
	end
	return ( string.format("%.2f", NumberUtility.RoundDownToNearest(number,0.01)) .. suffix ) or ""
end


local tRoundToNearest = t.tuple( t.number, t.numberPositive )
function NumberUtility.RoundToNearest( float: number, nearest: number? ): number
    assert( tRoundToNearest(float, nearest) )
    return math.floor( float / nearest + 0.5 ) * nearest
end


local tRoundDownToNearest = t.tuple( t.number, t.numberPositive )
function NumberUtility.RoundDownToNearest( float: number, nearest: number? ): number
    assert( tRoundDownToNearest(float, nearest) )
    return math.floor( float / nearest ) * nearest
end


local tNumberToWord = t.tuple( t.number )
function NumberUtility.NumberToWord( number: number ): string
    assert( tNumberToWord(number) )
	local number = math.floor( number )
	if ( number == 0 ) then return "Zero" end
	local thousandIteration = 0
	local wordString = ""
	while ( number > 0 ) do
		if ( number % 1000 ~= 0 ) then
			wordString = NumberToStringHelper( number % 1000 ) .. THOUSAND_WORDS[ thousandIteration ] .. " " .. wordString
		end
		number = math.floor( number / 1000 )
		thousandIteration = thousandIteration + 1
	end
	return TrimString( wordString )
end


return NumberUtility