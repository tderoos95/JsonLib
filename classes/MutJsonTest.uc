//==================================================================
// Json in UT2004? Why not?!
// Can be utilized to tidy up communication protocols, as
// well as making your code more resilient to version changes.
//
// Made in 2022, for Unreal Universe
// Coded by Infy95
// http://discord.unrealuniverse.net
//==================================================================
class MutJsonTest extends Mutator
	config(JsonTest);

var array<string> MyArrayString;
var array<int> MyArrayInt;
var array<float> MyArrayFloat;

var config string ConfiguredJsonToDeserialize;


function PostBeginPlay()
{
	Super.PostBeginPlay();
	PerformTests();
}

function JsonObject GenerateTestJsonObjectTest()
{
	local JsonObject JsonObject;

	Log("*** Generate Json object", 'JsonTest');
	JsonObject = new class'JsonObject';
	JsonObject.AddString("String", "Hello World");
	JsonObject.AddInt("Int", 123);
	JsonObject.AddFloat("Float", 123.456);
	JsonObject.AddArrayString("ArrayString", MyArrayString);
	JsonObject.AddArrayInt("ArrayInt", MyArrayInt);
	JsonObject.AddArrayFloat("ArrayFloat", MyArrayFloat);

	Log("*** Generated Json object", 'JsonTest');
	JsonObject.LogValues('JsonTest');

	return JsonObject;
}

function JsonObject DeserializeJsonString(string JsonToDeserialize)
{
	Log("*** Deserializing json string:" @ JsonToDeserialize, 'JsonTest');
	return class'JsonConvert'.static.Deserialize(JsonToDeserialize);
}

function PerformTests()
{
	local string OriginalOutput, JsonString;
	local JsonObject JsonObject;
	
	// Test 1: Generate Json object and log values to make sure they're present
	JsonObject = GenerateTestJsonObjectTest();
	
	// Test 2: Serialize Json object to string and log it
	JsonString = JsonObject.ToString();
	OriginalOutput = JsonString;
	Log(JsonString, 'JsonTest');

	// Test 3: Deserialize string and log values inside deserialized object 
	Log("*** Deserialize generated json string", 'JsonTest');
	JsonObject = DeserializeJsonString(JsonString);
	Jsonobject.LogValues('JsonTest');

	// Test 4: Serialize back to string, and compare to original serialized json
	Log("*** Serialize deserialized json object", 'JsonTest');
	JsonString = JsonObject.ToString();
	Log(JsonString, 'JsonTest');

	Log("**************************************", 'JsonTest');
	Log("Serialize -> Deserialize -> Serialize", 'JsonTest');
	Log("Test passed: " $ eval(OriginalOutput == JsonString, "Yes", "No"), 'JsonTest');
	Log("**************************************", 'JsonTest');

	// Test 5: Deserialize json string inside config file and log values
	Log("*** Deserialize configured json string", 'JsonTest');
	JsonObject = DeserializeJsonString(ConfiguredJsonToDeserialize);
	Jsonobject.LogValues('JsonTest');
}

defaultproperties
{
	FriendlyName="** JsonTest"
	MyArrayString(0)="Hello"
	MyArrayString(1)="World"
	MyArrayInt(0)=42
	MyArrayInt(1)=84
	MyArrayFloat(0)=0.500000
	MyArrayFloat(1)=1.000000
}