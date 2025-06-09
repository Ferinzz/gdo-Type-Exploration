package gdextension

//Will likely need to make some build specific definitions since the size of things changes based on the Godot build used.

/******************/
/******************/
/*******DEFS********/
/******************/
/******************/

//Check Godot's docs for more info about each variant type: https://docs.godotengine.org/en/stable/classes/index.html#variant-types
//Set to 40 if double is double precision
//Data itself is in the _data union : https://github.com/godotengine/godot/blob/45fc515ae3574e9c1f9deacaa6960dec68a7d38b/core/variant/variant.h#L263
//After testing won't even need to use Godot's functions. index 1 is the type enum, index 2 is the _data, I assume index 3 is ref counting or array length?
Variant :: struct #align(8) {
    VType: VariantType,
    data: [2]u64
}


/*This is what Godot's data is represented as in C++.
Could use this in Odin if we made it a #raw_union
Otherwise allocations from Godot will be represented as nil
VariantData :: union #align(16) {
		Bool,
		i64,
		f64,
		^Transform2d,
		^AABB,
		^Basis,
		^Transform3D,
		^Projection,
		rawptr, //pointer to packedarrayrefbase, Godot specific type. Do Not Handle Directly.
        Vector2,
        Vector2i,
        Vector3i,
        Vector3,
        Vector4,
        Vector4i,
		//Won't be handling the object stuff directly.
        //Below is the original Godot C++ code which reserves its struct size.
		//[sizeof(ObjData) > (sizeof(real_t) * 4) ? sizeof(ObjData) : (sizeof(real_t) * 4)]{ 0 },
	} 
*/

//optional in Godot. These are mainly to define pointer etc variable lengths in C.
Int     :: int    
Bool    :: b8
float   :: f64


//I'm sorry. I made all of these distinct. Godot has so many overlapping types in their Variant system that it makes the conversion procs easier.


//The use 16 if your Godot version was built with double precision support, which is not the default.
//else use 8
Vector2 :: distinct [2]f32

Vector2i :: distinct [2]i32


//Original has 2 Vector2
Rec2 :: distinct [4]f32

//Original has 2 Vector2i
Rec2i :: distinct [4]i32

Vector3 :: distinct [3]f32

Vector3i :: distinct [3]i32


Vector4 :: distinct [4]f32

Vector4i :: distinct [4]i32

//Vector3 + d
Plane :: distinct [4]f32

//Quaternion is quaternion
Quaternion :: distinct quaternion128

/*Represents an axis-aligned bounding box in a 3D space.
It is defined by its position and size, which are Vector3.*/
AABB :: distinct [6]f32

//3×3 matrix used to represent 3D rotation, scale, and shear.
Basis :: distinct matrix[3,3]f32

//Note: Godot uses a right-handed coordinate system, which is a common standard. For directions,
//the convention for built-in types like Camera3D is for -Z to point forward (+X is right, +Y is up, and +Z is back). 


/*4×4 matrix used for 3D projective transformations. It can represent transformations such as
translation, rotation, scaling, shearing, and perspective division. It consists of four Vector4 columns.
*/
Projection :: distinct matrix[4,4]f32

/*2×3 matrix. three Vector2 values: x, y, and origin.
Will need to test to determine if major or minor. Likely reimplements C# version.
 */
Transform2d :: distinct matrix[2,3]f32

/*3×4 matrix. A Basis, scale and shear. Combine with origin to do translations.
Will need to test to determine if major or minor. Likely reimplements C# version.
*/
Transform3D :: distinct matrix[3,4]f32

//Color represented in RGBA
Color :: distinct Vector4

//The value we get back for a string name is just the pointer to the Godot's interned string pool.
//If you've use the name once you'll already created a string name with the specific text you'll have already added that string to the pool.
//What we have access to is just the pointer.
StringName :: distinct [1]u64

/*Pointer to a string stored in Godot. Format Unicode.
Variable size.*/
gdstring :: distinct [1]u64

/*https://docs.godotengine.org/en/stable/classes/class_nodepath.html
A filesystem representation of the node tree. Is not a direct pointer to the Node.
Represented by a String.*/
NodePath :: distinct [1]u64

/*The RID Variant type is used to access a low-level resource by its unique ID. RIDs are opaque,
which means they do not grant access to the resource by themselves. They are used by the low-level
server classes, such as DisplayServer, RenderingServer, TextServer, etc.
*/
RID :: distinct [1]u128

Object :: distinct [2]u64

/*Represents a function. It can either be a method within an Object instance,
or a custom callable used for different purposes*/
Callable :: distinct [4]u64

/*Represents a signal of an Object instance. Like all Variant types,
it can be stored in variables and passed to functions. Signals allow all connected
Callables (and by extension their respective objects) to listen and react to events,
without directly referencing one another.*/
Signal :: distinct [4]u64

/*Dictionaries are associative containers that contain values referenced by unique keys.
Dictionaries will preserve the insertion order when adding new entries.*/
Dictionary :: distinct [1]u64

/*An array of Variants.*/
Array :: distinct [1]u64

/*First value is not used by anything other tha C#. Second value is where the data begins.
The size and ref count are offset -uintptr to the left of the arrey start.
Use Godot's built-ins to make and manage these. Otherwise you risk heap corruption.
*/
PackedByteArray :: distinct  [2]u64

PackedInt32Array :: distinct  [2]u64

PackedInt64Array :: distinct  [2]u64

PackedFloat32Array :: distinct [2]u64

PackedFloat64Array :: distinct  [2]u64

PackedStringArray :: distinct  [2]u64

PackedVector2Array :: distinct  [2]u64

PackedVector3Array :: distinct  [2]u64

PackedColorArray :: distinct  [2]u64

PackedVector4Array :: distinct  [2]u64

packedArray :: struct($T: typeid) { 
    proxy: rawptr,
    data: [^]T
}



PropertyHint :: enum {
    PROPERTY_HINT_NONE
}

PropertyUsageFlags :: enum {
    PROPERTY_USAGE_NONE,
    PROPERTY_USAGE_STORAGE = 2,
    PROPERTY_USAGE_EDITOR = 4,
    PROPERTY_USAGE_DEFAULT = PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_EDITOR
}

types := [?]typeid {
typeid_of(Int),
typeid_of(Bool),
typeid_of(float),
typeid_of(Vector2),
typeid_of(Vector2i),
typeid_of(Rec2),
typeid_of(Rec2i),
typeid_of(Vector3),
typeid_of(Vector3i),
typeid_of(Transform2d),
typeid_of(Vector4),
typeid_of(Vector4i),
typeid_of(Plane),
typeid_of(Quaternion),
typeid_of(AABB),
typeid_of(Basis),
typeid_of(Projection),
typeid_of(Color),
typeid_of(StringName),
typeid_of(gdstring),
typeid_of(NodePath),
typeid_of(RID),
typeid_of(Object),
typeid_of(Callable),
typeid_of(Signal),
typeid_of(Dictionary),
typeid_of(Array),
typeid_of(PackedByteArray),
typeid_of(PackedInt32Array),
typeid_of(PackedInt64Array),
typeid_of(PackedFloat32Array),
typeid_of(PackedFloat64Array),
typeid_of(PackedStringArray),
typeid_of(PackedVector2Array),
typeid_of(PackedVector3Array),
typeid_of(PackedColorArray),
typeid_of(PackedVector4Array),
}