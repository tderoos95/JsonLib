//==================================================================
// Json in UT2004? Why not?!
// Can be utilized to tidy up communication protocols, as
// well as making your code more resilient to version changes.
//
// Made in 2022, for Unreal Universe
// Coded by Infy#1771
// http://discord.unrealuniverse.net
//==================================================================
class JsonObjectBuilderPool extends Object;

var array<JsonObjectBuilder> JsonBuilders;
var bool bAutoIncreaseCapacity;

public function InitializePool(int Capacity, optional bool _bAutoIncreaseCapacity)
{
	local int i;
	
	JsonBuilders.Length = Capacity;
	
	for (i=0; i < Capacity; i++)
	{
		JsonBuilders[i] = new Class'JsonObjectBuilder';
	}
	
	bAutoIncreaseCapacity = _bAutoIncreaseCapacity;
}

function JsonObjectBuilder GetAvailableJsonObjectBuilder()
{
	local int i;
	
	for(i=0; i < JsonBuilders.Length; i++)
	{
		if(!JsonBuilders[i].bBusy)
		{
			JsonBuilders[i].Clear();
			JsonBuilders[i].bBusy = true;
			return JsonBuilders[i];	
		}
	}
	
	if(bAutoIncreaseCapacity)
	{
		Log("JsonObjectBuilder pool capacity (" $ JsonBuilders.Length $ ") has been reached, increasing capacity by 1", 'JsonLib');
		i = JsonBuilders.Length;
		JsonBuilders.Length = i+1;
		JsonBuilders[i] = new Class'JsonObjectBuilder';
		return JsonBuilders[i];
	}
	
	return None;
}