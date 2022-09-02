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
var array<JsonObject> JsonObjects;

private function KeyValuePair GetKeyValuePair(string Key, optional bool bCaseSensitive)
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

public function string GetValue(string Key, optional bool bCaseSensitive)
{
	return (GetKeyValuePair(Key, bCaseSensitive)).Value;
}

public function string GetString(string Key, optional bool bCaseSensitive)
{
	local string ActualValue;
	
	ActualValue = GetValue(Key, bCaseSensitive);
	// Remove quotation marks
	ActualValue = Mid(ActualValue, 1, Len(ActualValue) - 2);

	return ActualValue;
}

public function bool GetBool(string Key, optional bool bCaseSensitive)
{
	return bool(GetValue(Key, bCaseSensitive));
}

public function int GetInt(string Key, optional bool bCaseSensitive)
{
	return int(GetValue(Key, bCaseSensitive));
}

public function float GetFloat(string Key, optional bool bCaseSensitive)
{
	return float(GetValue(Key, bCaseSensitive));
}

private function ArrayKeyValuePair GetArrayKeyValuePair(string Key, optional bool bCaseSensitive)
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

public function array<string> GetArrayString(string Key, optional bool bCaseSensitive)
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

public function array<int> GetArrayInt(string Key, optional bool bCaseSensitive)
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

public function array<float> GetArrayFloat(string Key, optional bool bCaseSensitive)
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

private function AddValue(string Key, string Value)
{
	local int NewIndex;
	
	NewIndex = Values.length;
	Values.Length = NewIndex + 1;
	Values[NewIndex].Key = Key;
	Values[NewIndex].Value = Value;
}

public function AddString(string Key, string Value)
{
	Value = QuotationMarkCharacter $ Value $ QuotationMarkCharacter;
	AddValue(Key, Value);
}

public function AddInt(string Key, int Value)
{
	AddValue(Key, string(Value));
}

public function AddFloat(string Key, float Value)
{
	AddValue(Key, string(Value));
}

public function AddJson(string Key, JsonObject Value)
{
	if(Value != None)
		AddValue(Key, Value.ToString());
	else AddValue(Key, "");
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

public function AddArrayJson(string Key, array<JsonObject> ArrayToAdd)
{
	local array<string> TransformedArray;
	local int i, NewIndex;

	for(i = 0; i < ArrayToAdd.Length; i++)
	{
		NewIndex = TransformedArray.length;
		TransformedArray.Length = NewIndex + 1;
		TransformedArray[NewIndex] = ArrayToAdd[i].ToString();
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
		if(Len(Result) > 0)
			Result $= ValueSeparatorCharacter;
		
		// Add variable name
		Result $= QuotationMarkCharacter;
		Result $= ArrayValues[i].Key;
		Result $= QuotationMarkCharacter;
		
		// Add variable value
		Result $= ValueAssignCharacter;
		Result $= ArrayValueToString(ArrayValues[i].Values);
	}

	for(i = 0; i < JsonObjects.Length; i++)
	{
		if(Len(Result) > 0)
			Result $= ValueSeparatorCharacter;
		
		// Add variable value
		Result $= ValueAssignCharacter;
		Result $= JsonObjects[i].ToString();
	}
	
	Result $= ObjectEndCharacter;
	
	return Result;
}

private function string ArrayValueToString(array<string> ArrayToSerialize)
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

public function RemoveValue(string Key, optional bool bCaseSensitive)
{
	local int i;
	
	for(i = 0; i < Values.Length; i++)
	{
		if(bCaseSensitive)
		{
			if(Values[i].Key == Key)
			{
				Values.Remove(i, 1);
				return;
			}
		}
		else
		{
			if(Values[i].Key ~= Key)
			{
				Values.Remove(i, 1);
				return;
			}
		}
	}
}

public function RemoveArrayValue(string Key, optional bool bCaseSensitive)
{
	local int i;
	
	for(i = 0; i < ArrayValues.Length; i++)
	{
		if(bCaseSensitive)
		{
			if(ArrayValues[i].Key == Key)
			{
				ArrayValues.Remove(i, 1);
				return;
			}
		}
		else
		{
			if(ArrayValues[i].Key ~= Key)
			{
				ArrayValues.Remove(i, 1);
				return;
			}
		}
	}
}

public function LogValues(optional Name Tag)
{
	local int i, x;
	
	log("** Json Values:", Tag);

	for(i = 0; i < Values.Length; i++)
	{
		log("* " $ Values[i].Key $ ": " $ Values[i].Value, Tag);
	}

	for(i = 0; i < ArrayValues.Length; i++)
	{
		log(ArrayValues[i].Key $ ":", Tag);

		for(x = 0; x < ArrayValues[i].Values.Length; x++)
			log("* " $ ArrayValues[i].Values[x], Tag);
	}

	log("** End Json Values", Tag);
}