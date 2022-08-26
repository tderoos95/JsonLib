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

var JsonObjectBuilderPool JsonBuilderPool;

var array<string> MyArrayString;
var array<int> MyArrayInt;
var array<float> MyArrayFloat;

var config string JsonToDeserialize;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	JsonBuilderPool = new class'JsonObjectBuilderPool';
	JsonBuilderPool.InitializePool(0, true);
}

function string GenerateTestJsonString()
{
	local JsonObjectBuilder JsonBuilder;
	
	JsonBuilder = JsonBuilderPool.GetAvailableJsonObjectBuilder();
	JsonBuilder.AddString("String", "MyValue");
	JsonBuilder.AddInt("Int", 1);
	JsonBuilder.AddFloat("Float", 1.000000);
	JsonBuilder.AddArrayString("ArrayString", MyArrayString);
	JsonBuilder.AddArrayInt("ArrayInt", MyArrayInt);
	JsonBuilder.AddArrayFloat("ArrayFloat", MyArrayFloat);
	
	return JsonBuilder.ToString();
}

function function PrintDeserializedJsonObject()
{
	local JsonObject Json;
	local array<string> MyStringArray, MyIntArray;
	
	Log("Deserializing string:" @ JsonToDeserialize, 'JsonTest');
	Json = class'JsonConvert'.static.Deserialize(JsonToDeserialize);
	Log("Result:", 'JsonTest');
	Log("*String:" @ Json.GetValue("String"), 'JsonTest');
	Log("*Int:" @ Json.GetValue("Int"), 'JsonTest');
	Log("*Float:" @ Json.GetValue("Float"), 'JsonTest');
	Log("*String2:" @ Json.GetValue("String2"), 'JsonTest'); 
	
	MyStringArray = Json.GetArrayValue("StringArray");
	MyIntArray = Json.GetArrayValue("IntArray");
	
	Log("*StringArray: (" $ MyStringArray.Length $ ")", 'JsonTest'); 
	PrintArray(MyStringArray);
	
	Log("*IntArray: (" $ MyIntArray.Length $ ")", 'JsonTest'); 
	PrintArray(MyIntArray);
}

function PrintArray(array<string> MyArray)
{
	local int i;
	
	for(i=0; i < MyArray.Length; i++)
		Log("**" $ MyArray[i], 'JsonTest');
}

function PostBeginPlay()
{
	local string JsonString;
	local Controller C;
	
	Super.PostBeginPlay();
	
	JsonString = GenerateTestJsonString();
	Log(JsonString, 'JsonTest');
	
	PrintDeserializedJsonObject();
	
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