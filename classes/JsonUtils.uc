//==================================================================
// Json in UT2004? Why not?!
// Made by Infy - 2022 - 2025
// http://discord.unrealuniverse.net
//==================================================================
class JsonUtils extends Object;

// Strip illegal characters that break JSON parsing
static final function string StripIllegalCharacters(string Input)
{
    local string CurrentChar, SanitizedInput;
    local int CurrentCharCode;
    local bool bIllegalCharacter;
    local int i;

    for(i = 0; i < Len(Input); i++)
    {
        CurrentChar = Mid(Input, i, 1);
        CurrentCharCode = GetChrCode(CurrentChar);
        bIllegalCharacter = CurrentCharCode < 32;

        if(!bIllegalCharacter)
        {
            SanitizedInput $= CurrentChar;
        }
    }
    
    return SanitizedInput;
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