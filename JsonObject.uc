//==================================================================
// Json in UT2004? Why not?!
// Can be utilized to tidy up communication protocols, as
// well as making your code more resilient to version changes.
//
// Made in 2022, for Unreal Universe
// Coded by Infy#1771
// http://discord.unrealuniverse.net
//==================================================================
class JsonObject extends Object;

// todo in class rather than struct?
// just not really sure how bad that would be for memory usage
struct KeyValuePair
{
	var string Key;
	var string Value;
};

struct ArrayKeyValuePair
{
	var string Key;
	var array<string> Values;
};

var array<KeyValuePair> Values;
var array<ArrayKeyValuePair> ArrayValues;

function KeyValuePair GetKeyValuePair(string Key, optional bool bCaseSensitive)
{
	local int i;
	local KeyValuePair Pair;
	
	for (i=0; i < Values.Length; i++)
	{
		if(bCaseSensitive)
		{
			if(Values[i].Key == Key)
			{
				Pair = Values[i];
				break;
			}
		}
		else
		{
			if(Values[i].Key ~= Key)
			{
				Pair = Values[i];
				break;
			}
		}
	}
	
	return Pair;
}

function string GetValue(string Key, optional bool bCaseSensitive)
{
	return (GetKeyValuePair(Key, bCaseSensitive)).Value;
}

function ArrayKeyValuePair GetArrayKeyValuePair(string Key, optional bool bCaseSensitive)
{
	local int i;
	local ArrayKeyValuePair Pair;
	
	for (i=0; i < ArrayValues.Length; i++)
	{
		if(bCaseSensitive)
		{
			if(ArrayValues[i].Key == Key)
			{
				Pair = ArrayValues[i];
				break;
			}
		}
		else
		{
			if(ArrayValues[i].Key ~= Key)
			{
				Pair = ArrayValues[i];
				break;
			}
		}
	}
	
	return Pair;
}

function array<string> GetArrayValue(string Key, optional bool bCaseSensitive)
{
	return (GetArrayKeyValuePair(Key, bCaseSensitive)).Values;
}

function AddValue(string Key, string Value)
{
	local KeyValuePair Pair;
	local int NewIndex;
	
	NewIndex = Values.length;
	Values.Length = NewIndex + 1;
	Values[NewIndex].Key = Key;
	Values[NewIndex].Value = Value;
}

// todo add string
// todo getint / getfloat
// todo add array
