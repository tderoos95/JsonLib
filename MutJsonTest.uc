//==================================================================
// Json in UT2004? Why not?!
// Can be utilized to tidy up communication protocols, as
// well as making your code more resilient to version changes.
//
// Made in 2022, for Unreal Universe
// Coded by Infy#1771
// http://discord.unrealuniverse.net
//==================================================================
class MutJsonTest extends Mutator
	config(JsonTest);

var array<string> MyArrayString;
var array<int> MyArrayInt;
var array<float> MyArrayFloat;

var config string ConfiguredJsonToDeserialize;

function JsonObject GenerateTestJsonObject()
{
	local JsonObject JsonObject;

	Log("*** Generate Json object");
	JsonObject = new class'JsonObject';
	JsonObject.AddString("String", "Hello World");
	JsonObject.AddInt("Int", 123);
	JsonObject.AddFloat("Float", 123.456);
	JsonObject.AddArrayString("ArrayString", MyArrayString);
	JsonObject.AddArrayInt("ArrayInt", MyArrayInt);
	JsonObject.AddArrayFloat("ArrayFloat", MyArrayFloat);

	return JsonObject;
}

function ReadJsonValues(JsonObject JsonObject)
{
	local array<string> ArrayString;
	local array<int> ArrayInt;
	local array<float> ArrayFloat;

	Log("**** Read Json object values", 'JsonLib');
	Log("String: " $ JsonObject.GetString("String"));
	Log("Int: " $ JsonObject.GetInt("Int"));
	Log("Float: " $ JsonObject.GetFloat("Float"));

	ArrayString = JsonObject.GetArrayString("ArrayString");
	Log("ArrayString:", 'JsonLib');
	PrintArrayString(ArrayString);

	ArrayInt = JsonObject.GetArrayInt("ArrayInt");
	Log("ArrayInt:", 'JsonLib');
	PrintArrayInt(ArrayInt);

	ArrayFloat = JsonObject.GetArrayFloat("ArrayFloat");
	Log("ArrayFloat:", 'JsonLib');
	PrintArrayFloat(ArrayFloat);
}

function JsonObject DeserializeJsonString(string JsonToDeserialize)
{
	Log("*** Deserializing json string:" @ JsonToDeserialize, 'JsonTest');
	return class'JsonConvert'.static.Deserialize(JsonToDeserialize);
}

function PrintDeserializedJsonObject(JsonObject JsonObject)
{
	local array<string> MyStringArray;
	local array<int> MyIntArray;
	local array<float> MyFloatArray;

	Log("Result:", 'JsonTest');
	Log("*RAW*String:" @ JsonObject.GetValue("String"), 'JsonTest');
	Log("String:" @ JsonObject.GetString("String"), 'JsonTest');
	Log("*Int:" @ JsonObject.GetInt("Int"), 'JsonTest');
	Log("*Float:" @ JsonObject.GetFloat("Float"), 'JsonTest');
	
	MyStringArray = JsonObject.GetArrayValue("ArrayString");
	Log("*RAW*ArrayString: (" $ MyStringArray.Length $ ")", 'JsonTest'); 
	PrintArrayString(MyStringArray);
	
	MyStringArray = JsonObject.GetArrayString("ArrayString");
	MyIntArray = JsonObject.GetArrayInt("ArrayInt");
	MyFloatArray = JsonObject.GetArrayFloat("ArrayFloat");
	
	Log("*ArrayString: (" $ MyStringArray.Length $ ")", 'JsonTest'); 
	PrintArrayString(MyStringArray);
	
	Log("*ArrayInt: (" $ MyIntArray.Length $ ")", 'JsonTest'); 
	PrintArrayInt(MyIntArray);

	Log("*ArrayFloat: (" $ MyFloatArray.Length $ ")", 'JsonTest'); 
	PrintArrayFloat(MyFloatArray);
}

function PrintArrayString(array<string> MyArray)
{
	local int i;
	
	for(i=0; i < MyArray.Length; i++)
		Log("**" $ MyArray[i], 'JsonTest');
}

function PrintArrayInt(array<int> MyArray)
{
	local int i;
	
	for(i=0; i < MyArray.Length; i++)
		Log("**" $ MyArray[i], 'JsonTest');
}

function PrintArrayFloat(array<float> MyArray)
{
	local int i;
	
	for(i=0; i < MyArray.Length; i++)
		Log("**" $ MyArray[i], 'JsonTest');
}

function PostBeginPlay()
{
	local string OriginalOutput, JsonString;
	local JsonObject JsonObject;
	local Controller C;
	
	Super.PostBeginPlay();
	
	JsonObject = GenerateTestJsonObject();
	JsonString = JsonObject.ToString();
	OriginalOutput = JsonString;

	Log(JsonString, 'JsonTest');
	ReadJsonValues(JsonObject);
	
	Log("*** Deserialize generated json string", 'JsonTest');
	JsonObject = DeserializeJsonString(JsonString);
	PrintDeserializedJsonObject(JsonObject);

	Log("*** Serialize deserialized json object", 'JsonTest');
	JsonString = JsonObject.ToString();
	Log(JsonString, 'JsonTest');

	Log("**************************************", 'JsonTest');
	Log("Serialize -> Deserialize -> Serialize", 'JsonTest');
	Log("Test passed: " $ eval(OriginalOutput == JsonString, "Yes", "No"), 'JsonTest');
	Log("**************************************", 'JsonTest');

	Log("*** Deserialize configured json string", 'JsonTest');
	JsonObject = DeserializeJsonString(ConfiguredJsonToDeserialize);
	PrintDeserializedJsonObject(JsonObject);

	for (C = Level.ControllerList; C != None; C = C.NextController)
	{
		if(PlayerController(C) != None)
			PlayerController(C).ClientMessage(JsonString);
	}
}

defaultproperties
{
	FriendlyName="** JsonTest"
	MyArrayString(0)="MyValue0"
	MyArrayString(1)="MyValue1"
	MyArrayInt(0)=0
	MyArrayInt(1)=1
	MyArrayFloat(0)=0.000000
	MyArrayFloat(1)=1.000000
}