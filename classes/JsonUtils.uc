//==================================================================
// Json in UT2004? Why not?!
// Made by Infy - 2022 - 2025
// http://discord.unrealuniverse.net
//==================================================================
class JsonUtils extends Object;

// A UT2004 colour code is the escape byte plus three raw channel bytes, and a channel can hold any value -
// so a code only ever comes off as a whole unit, before anything judges those bytes one at a time.
// Nothing is stripped on your behalf when a value is serialized; call this when you want the markup gone.
static final function string StripColorCodes(string Text)
{
    local int p;

    p = InStr(Text, Chr(27));
    while(p != -1)
    {
        Text = Left(Text, p) $ Mid(Text, p + 4);
        p = InStr(Text, Chr(27));
    }

    return Text;
}

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