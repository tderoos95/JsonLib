//==================================================================
// Json in UT2004? Why not?!
// Can be utilized to tidy up communication protocols, as
// well as making your code more resilient to version changes.
//
// Made in 2022, for Unreal Universe
// Coded by Infy#1771
// http://discord.unrealuniverse.net
//==================================================================
class JsonConvert extends Object;

const ObjectStartCharacter = "{";
const ObjectEndCharacter = "}";
const QuotationMarkCharacter = "\"";
const AssignValueCharacter = ":";
const ValueSeparatorCharacter = ",";
const ArrayOpenCharacter = "[";
const ArrayCloseCharacter = "]";
const EscapeCharacter = "\\";

static function bool StartsWith(string Text, string Find, optional bool bCaseSensitive)
{
	if(bCaseSensitive)
		return Left(Text, Len(Find)) == Find;
	else return Left(Text, Len(Find)) ~= Find;
}

static function bool EndsWith(string Text, string Find, optional bool bCaseSensitive)
{
	if(bCaseSensitive)
		return Right(Text, Len(Find)) == Find;
	else return Right(Text, Len(Find)) ~= Find;
}

public static function JsonObject Deserialize(string JsonString)
{
	return static.DeserializeIntoExistingObject(new class'JsonObject', JsonString);
}

public static function JsonObject DeserializeIntoExistingObject(Jsonobject Json, string JsonString)
{
	local string CurrentKey, CurrentValue;
	local array<string> CurrentValues;
	local int ProcessedLength, NewEntryIndex;
	local bool bIsArray;

	// remove object start/end characters
	if(StartsWith(JsonString, ObjectStartCharacter))
		JsonString = Mid(JsonString, 1);
	if(EndsWith(JsonString, ObjectEndCharacter))
		JsonString = Left(JsonString, Len(JsonString) - 1);
	
	while(Len(JsonString) > 0)
	{
		CurrentKey = ExtractNextName(JsonString, ProcessedLength);
		
		if(CurrentKey == "")
		{
			Log("Data processing error in:" @ JsonString, 'JsonLib');
			Log("Unexpected end of Json structure!", 'JsonLib');
			break;
		}
		
		JsonString = Mid(JsonString, ProcessedLength+1);
		bIsArray = StartsWith(JsonString, ArrayOpenCharacter);
		
		if(bIsArray)
		{
			CurrentValues = ProcessStringAsArray(JsonString, ProcessedLength);
			
			NewEntryIndex = Json.ArrayValues.Length;
			Json.ArrayValues.Length = NewEntryIndex+1;
			Json.ArrayValues[NewEntryIndex].Key = CurrentKey;
			Json.ArrayValues[NewEntryIndex].Values = CurrentValues;
			
			JsonString = Mid(JsonString, ProcessedLength);
		}
		else
		{
			CurrentValue = ExtractNextValue(JsonString, ProcessedLength);
		
			// store key value pair inside object
			NewEntryIndex = CreateNewValueEntry(Json);
			Json.Values[NewEntryIndex].Key = CurrentKey;
			Json.Values[NewEntryIndex].Value = CurrentValue;
			
			JsonString = Mid(JsonString, ProcessedLength);
		}
	}
	
	return Json;
}

static function int CreateNewValueEntry(JsonObject Json)
{
	local int NewEntryIndex;
	
	NewEntryIndex = Json.Values.Length;
	Json.Values.Length = NewEntryIndex+1;
	
	return NewEntryIndex;
}

// names are always inbetween quotation marks, i.e.: "MyName":
// can also be used for extracting string values, i.e.: "MyValue"
// supports escape characters
private static function string ExtractNextName(string JsonString, out int ProcessedLength)
{
	local string ExtractedName;
	local string CurrentChar;
	local bool bInName, bEscapeNextChar;
	local int i;
	
	ProcessedLength = 0;
	
	for (i=0; i < Len(JsonString); i++)
	{
		CurrentChar = Mid(JsonString, i, 1);
		ProcessedLength++;

		if(!bInName)
		{
			if(CurrentChar == QuotationMarkCharacter)
				bInName = true;
			
			continue;
		}
		
		if(CurrentChar == EscapeCharacter)
		{
			if(bEscapeNextChar)
			{
				ExtractedName $= CurrentChar;
				bEscapeNextChar = false;
			}
			else
				bEscapeNextChar = true;
			
			continue;
		}
		
		if(CurrentChar == QuotationMarkCharacter)
		{
			if(!bEscapeNextChar)
			{
				bInName = false;
				break;
			}
			else
				bEscapeNextChar = false;
		}
		
		ExtractedName $= CurrentChar;
	}
	
	return ExtractedName;
}

private static function string ExtractNextValue(string JsonString, out int ProcessedLength)
{
	local string ExtractedValue, CurrentChar;
	local bool bIsString;
	local int i;
	
	ProcessedLength = 0;
	bIsString = StartsWith(JsonString, QuotationMarkCharacter);
	
	if(bIsString)
		return QuotationMarkCharacter $ ExtractNextName(JsonString, ProcessedLength) $ QuotationMarkCharacter;
	
	for (i=0; i < Len(JsonString); i++)
	{
		CurrentChar = Mid(JsonString, i, 1);
		ProcessedLength++;
		
		if(CurrentChar == ValueSeparatorCharacter)
			break;
		
		ExtractedValue $= CurrentChar;
	}
	
	return ExtractedValue;
}

// Processes string as array, does not escape characters. If you need to escape 
// characters, use ExtractNextName in conjunction with ProcessStringAsArray.
private static function array<string> ProcessStringAsArray(string JsonString, out int ProcessedLength)
{
	local bool bInArray, bInString, bEscapeNextChar;
	local array<string> ExtractedValues;
	local string ExtractedValue, CurrentChar;
	local int i;
	
	ProcessedLength = 0;
	
	// [0,1,2]
	// ["String1","String2","String3"]
	for (i=0; i < Len(JsonString); i++)
	{
		CurrentChar = Mid(Jsonstring, i, 1);
		ProcessedLength++;
		
		if(!bInArray)
		{
			if(CurrentChar == ArrayOpenCharacter)
				bInArray = true;
			continue;
		}
		
		if(CurrentChar == ArrayCloseCharacter)
		{
			bInArray = false;
			StoreInArray(ExtractedValues, ExtractedValue);
			break;
		}
		
		if(CurrentChar == ValueSeparatorCharacter)
		{
			if(bInString)
			{
				ExtractedValue $= CurrentChar;
				continue;
			}
			
			StoreInArray(ExtractedValues, ExtractedValue);
			ExtractedValue = ""; // clear for next value
			continue;
		}
		
		if(CurrentChar == QuotationMarkCharacter)
		{
			if(bInString)
			{
				if(bEscapeNextChar)
				{
					ExtractedValue $= CurrentChar;
					bEscapeNextChar = false;
				}
				else
				{
					ExtractedValue $= QuotationMarkCharacter;
					bInString = false;
				}
			}
			else
			{
				ExtractedValue $= QuotationMarkCharacter;
				bInString = true;
			}
			
			continue;
		}
		
		if(CurrentChar == EscapeCharacter)
		{
			ExtractedValue $= CurrentChar;

			if(bEscapeNextChar)
				bEscapeNextChar = false;
			else bEscapeNextChar = true;
			
			continue;
		}
		
		ExtractedValue $= CurrentChar;
	}
	
	return ExtractedValues;
}


private static final function StoreInArray(out array<string> Array, string ValueToStore)
{
	local int NewValueEntry;
	
	NewValueEntry = Array.Length;
	Array.Length = NewValueEntry+1;
	Array[NewValueEntry] = ValueToStore;
}