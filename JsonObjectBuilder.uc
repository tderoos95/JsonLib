//==================================================================
// Json in UT2004? Why not?!
// Can be utilized to tidy up communication protocols, as
// well as making your code more resilient to version changes.
//
// Made in 2022, for Unreal Universe
// Coded by Infy#1771
// http://discord.unrealuniverse.net
//==================================================================
class JsonObjectBuilder extends Info;

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

var array<KeyValuePair> Values;
var bool bBusy;

public function PreBeginPlay()
{
	Super.PreBeginPlay();
	bBusy = true;
}

public function Clear()
{
	Values.Length = 0;
}

public function int CreateNewValueEntry()
{
	local int NewEntryIndexIndex;
	
	NewEntryIndexIndex = Values.Length;
	Values.Length = NewEntryIndexIndex+1;
	
	return NewEntryIndexIndex;
}

public function AddString(string Key, string Value)
{
	local int NewEntryIndexIndex;
	
	NewEntryIndexIndex = CreateNewValueEntry();
	Values[NewEntryIndexIndex].Key = Key;
	Values[NewEntryIndexIndex].Value = QuotationMarkCharacter $ Value $ QuotationMarkCharacter;
}

public function AddInt(string Key, int Value)
{
	local int NewEntryIndexIndex;
	
	NewEntryIndexIndex = CreateNewValueEntry();
	Values[NewEntryIndexIndex].Key = Key;
	Values[NewEntryIndexIndex].Value = string(Value);
}

public function AddFloat(string Key, float Value)
{
	local int NewEntryIndexIndex;
	
	NewEntryIndexIndex = CreateNewValueEntry();
	Values[NewEntryIndexIndex].Key = Key;
	Values[NewEntryIndexIndex].Value = string(Value);
}

public function AddArrayString(string Key, array<string> ArrayToAdd)
{
	local string ArrayAsString;
	local int NewEntryIndex;
	local int i;
	
	ArrayAsString = ArrayOpenCharacter;
	
	for(i = 0; i < ArrayToAdd.Length; i++)
	{
		if(i > 0)
		{
			ArrayAsString $= ValueSeparatorCharacter;
		}
		
		ArrayAsString $= QuotationMarkCharacter; 
		ArrayAsString $= ArrayToAdd[i]; 
		ArrayAsString $= QuotationMarkCharacter; 
	}
	
	ArrayAsString $= ArrayCloseCharacter;
	
	NewEntryIndex = CreateNewValueEntry();
	Values[NewEntryIndex].Key = Key;
	Values[NewEntryIndex].Value = ArrayAsString;
}

public function AddArrayInt(string Key, array<int> ArrayToAdd)
{
	local int NewEntryIndex;
	local int i;
	local string ArrayAsString;
	
	ArrayAsString = ArrayOpenCharacter;
	
	for(i = 0; i < ArrayToAdd.Length; i++)
	{
		if(i > 0)
		{
			ArrayAsString $= ValueSeparatorCharacter;
		}

		ArrayAsString $= ArrayToAdd[i]; 
	}
	
	ArrayAsString $= ArrayCloseCharacter;
	
	NewEntryIndex = CreateNewValueEntry();
	Values[NewEntryIndex].Key = Key;
	Values[NewEntryIndex].Value = ArrayAsString;
}

public function AddArrayFloat(string Key, array<float> ArrayToAdd)
{
	local int NewEntryIndex;
	local int i;
	local string ArrayAsString;
	
	ArrayAsString = ArrayOpenCharacter;
	
	for(i = 0; i < ArrayToAdd.Length; i++)
	{
		if(i > 0)
		{
			ArrayAsString $= ValueSeparatorCharacter;
		}

		ArrayAsString $= ArrayToAdd[i]; 
	}
	
	ArrayAsString $= ArrayCloseCharacter;
	
	NewEntryIndex = CreateNewValueEntry();
	Values[NewEntryIndex].Key = Key;
	Values[NewEntryIndex].Value = ArrayAsString;
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
	
	Result $= ObjectEndCharacter;
	bBusy = false;
	
	return Result;
}