//==================================================================
// Json in UT2004? Why not?!
// Made by Infy - 2022 - 2025
// http://discord.unrealuniverse.net
//==================================================================
// Opt-in build-path profiling. Counts work done (deterministic) rather than
// timing it -- Clock/UnClock on microsecond ops is unreliable. Inert unless a
// host sets bEnabled.
class JsonProfiler extends Object;

var bool bEnabled;

var int StripCalls;
var float StripChars;   // chars scanned by StripIllegalCharacters
var float StripIters;   // GetChrCode Chr() comparisons (the O(256) cost)

var int EscapeCalls;
var float EscapeChars;  // chars passed through EscapeCharacters

var int ToStringCalls;
var float ToStringChars; // output length built by ToString
var int ToStringDepth;

static function bool Active()
{
    return default.bEnabled;
}

static function RecordStrip(int Chars, int Iters)
{
    default.StripCalls++;
    default.StripChars += Chars;
    default.StripIters += Iters;
}

static function RecordEscape(int Chars)
{
    default.EscapeCalls++;
    default.EscapeChars += Chars;
}

static function RecordToString(int OutLen)
{
    default.ToStringCalls++;
    default.ToStringChars += OutLen;
}

static function Reset()
{
    default.StripCalls = 0; default.StripChars = 0; default.StripIters = 0;
    default.EscapeCalls = 0; default.EscapeChars = 0;
    default.ToStringCalls = 0; default.ToStringChars = 0;
    default.ToStringDepth = 0;
}
