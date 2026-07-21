//==================================================================
// Json in UT2004? Why not?!
// Made by Infy - 2022 - 2025
// http://discord.unrealuniverse.net
//==================================================================
class JsonUtils extends Object;

static final function int GetChrCode(string Char)
{
    local int i;

    for(i = 0; i < 256; i++)
    {
        if(Char == Chr(i))
        {
            return i;
        }
    }

    return -1;
}

static final function int HexToInt(string HexDigits)
{
    local int i, Length, Result, Digit;
    local string CurrentChar;

    Length = Len(HexDigits);

    for(i = 0; i < Length; i++)
    {
        CurrentChar = Locs(Mid(HexDigits, i, 1));
        Digit = InStr("0123456789abcdef", CurrentChar);

        if(Digit < 0)
            return -1;

        Result = Result * 16 + Digit;
    }

    return Result;
}