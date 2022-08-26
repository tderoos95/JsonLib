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

const ObjectStartCharacter = "{";
const ObjectEndCharacter = "}";
const QuotationMarkCharacter = "\"";
const ValueAssignCharacter = ":";
const ValueSeparatorCharacter = ",";
const ArrayOpenCharacter = "[";
const ArrayCloseCharacter = "]";

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

function string GetString(string Key, optional bool bCaseSensitive)
{
	local string ActualValue;
	
	ActualValue = GetValue(Key, bCaseSensitive);
	// Remove quotation marks
	ActualValue = Mid(ActualValue, 1, Len(ActualValue) - 2);

	return ActualValue;
}

function int GetInt(string Key, optional bool bCaseSensitive)
{
	return int(GetValue(Key, bCaseSensitive));
}

function float GetFloat(string Key, optional bool bCaseSensitive)
{
	return float(GetValue(Key, bCaseSensitive));
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

function array<string> GetArrayString(string Key, optional bool bCaseSensitive)
{
	local array<string> ActualValues;
	local int i;
	
	ActualValues = GetArrayValue(Key, bCaseSensitive);

	for (i=0; i < ActualValues.Length; i++)
	{
		// Remove quotation marks
		ActualValues[i] = Mid(ActualValues[i], 1, Len(ActualValues[i]) - 2);
	}
	
	return ActualValues;
}

function array<int> GetArrayInt(string Key, optional bool bCaseSensitive)
{
	local array<string> StringValues;
	local array<int> IntValues;
	local int i, NewIndex;
	
	StringValues = GetArrayValue(Key, bCaseSensitive);
	
	for (i=0; i < StringValues.Length; i++)
	{
		NewIndex = IntValues.Length;
		IntValues.Length = NewIndex + 1;
		IntValues[NewIndex] = int(StringValues[i]);
	}
	
	return IntValues;
}

function array<float> GetArrayFloat(string Key, optional bool bCaseSensitive)
{
	local array<string> StringValues;
	local array<float> FloatValues;
	local int i, NewIndex;
	
	StringValues = GetArrayValue(Key, bCaseSensitive);
	
	for (i=0; i < StringValues.Length; i++)
	{
		NewIndex = FloatValues.Length;
		FloatValues.Length = NewIndex + 1;
		FloatValues[NewIndex] = float(StringValues[i]);
	}
	
	return FloatValues;
}

function AddValue(string Key, string Value)
{
	local int NewIndex;
	
	NewIndex = Values.length;
	Values.Length = NewIndex + 1;
	Values[NewIndex].Key = Key;
	Values[NewIndex].Value = Value;
}

function AddString(string Key, string Value)
{
	Value = QuotationMarkCharacter $ Value $ QuotationMarkCharacter;
	AddValue(Key, Value);
}

function AddInt(string Key, int Value)
{
	AddValue(Key, string(Value));
}

function AddFloat(string Key, float Value)
{
	AddValue(Key, string(Value));
}

public function AddArrayValue(string Key, array<string> ArrayToAdd)
{
	local int NewIndex;
	
	NewIndex = ArrayValues.length;
	ArrayValues.Length = NewIndex + 1;
	ArrayValues[NewIndex].Key = Key;
	ArrayValues[NewIndex].Values = ArrayToAdd;
}

public function AddArrayString(string Key, array<string> ArrayToAdd)
{
	local array<string> TransformedArray;
	local int i, NewIndex;

	for(i = 0; i < ArrayToAdd.Length; i++)
	{
		NewIndex = TransformedArray.length;
		TransformedArray.Length = NewIndex + 1;
		TransformedArray[NewIndex] = QuotationMarkCharacter $ ArrayToAdd[i] $ QuotationMarkCharacter;
	}
	
	AddArrayValue(Key, TransformedArray);
}

public function AddArrayInt(string Key, array<int> ArrayToAdd)
{
	local array<string> TransformedArray;
	local int i, NewIndex;

	for(i = 0; i < ArrayToAdd.Length; i++)
	{
		NewIndex = TransformedArray.length;
		TransformedArray.Length = NewIndex + 1;
		TransformedArray[NewIndex] = string(ArrayToAdd[i]);
	}
	
	AddArrayValue(Key, TransformedArray);
}

public function AddArrayFloat(string Key, array<float> ArrayToAdd)
{
	local array<string> TransformedArray;
	local int i, NewIndex;

	for(i = 0; i < ArrayToAdd.Length; i++)
	{
		NewIndex = TransformedArray.length;
		TransformedArray.Length = NewIndex + 1;
		TransformedArray[NewIndex] = string(ArrayToAdd[i]);
	}
	
	AddArrayValue(Key, TransformedArray);
}


public function string ToString()
{
	local string Result;
	local int i;
	
	Result = ObjectStartCharacter;
	
	for(i = 0; i < Values.Length; i++)
	{
		if(i > 0)
		{
			Result $= ValueSeparatorCharacter;
		}
		
		// Add variable name
		Result $= QuotationMarkCharacter;
		Result $= Values[i].Key;
		Result $= QuotationMarkCharacter;
		
		// Add variable value
		Result $= ValueAssignCharacter;
		Result $= Values[i].Value;
	}

	for(i = 0; i < ArrayValues.Length; i++)
	{
		Result $= ValueSeparatorCharacter;
		
		// Add variable name
		Result $= QuotationMarkCharacter;
		Result $= ArrayValues[i].Key;
		Result $= QuotationMarkCharacter;
		
		// Add variable value
		Result $= ValueAssignCharacter;
		Result $= ArrayValueToString(ArrayValues[i].Values);
	}
	
	Result $= ObjectEndCharacter;
	
	return Result;
}

function string ArrayValueToString(array<string> ArrayToSerialize)
{
	local string Result;
	local int i;
	
	Result = ArrayOpenCharacter;
	
	for(i = 0; i < ArrayToSerialize.Length; i++)
	{
		if(i > 0)
		{
			Result $= ValueSeparatorCharacter;
		}
		
		Result $= ArrayToSerialize[i];
	}
	
	Result $= ArrayCloseCharacter;
	
	return Result;
}