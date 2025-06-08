package gdextension

//Will likely need to make some build specific definitions since the size of things changes based on the Godot build used.

/******************/
/******************/
/*******DEFS********/
/******************/
/******************/


//Set to 40 if double is double precision
//Data itself is in the _data union : https://github.com/godotengine/godot/blob/45fc515ae3574e9c1f9deacaa6960dec68a7d38b/core/variant/variant.h#L263
//After testing won't even need to use Godot's functions. index 1 is the type enum, index 2 is the _data, I assume index 3 is ref counting or array length?
Variant :: struct #align(8) {
    VType: VariantType,
    data: [2]u64
}

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
//optional in Godot. These are mainly to define pointer etc variable lengths in C.

Int     :: int    
Bool    :: b8
float   :: f64


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

//original type has 3 Vector2s
Transform2d :: distinct [6]f32

Vector4 :: distinct [4]f32

Vector4i :: distinct [4]i32

//Vector3 + d
Plane :: distinct [4]f32

Quaternion :: distinct Vector4

//2 Vector3
AABB :: distinct [6]f32

//3 Vector3
Basis :: distinct [9]f32

//Basis + Vector3
Transfrom :: distinct [12]f32

//4 Vector4
Projection :: distinct [16]f32

Transform3D :: distinct [12]f32

Color :: distinct Vector4

//The value we get back for a string name is just the pointer to the Godot's interned string pool.
//If you've use the name once you'll already created a string name with the specific text you'll have already added that string to the pool.
//What we have access to is just the pointer.
StringName :: distinct [1]u64

gdstring :: distinct [1]u64

NodePath :: distinct [1]u64

//Not actually sure what this is or what it's for.
RID :: distinct [2]u64

Object :: distinct [2]u64

Callable :: distinct [4]u64

Signal :: distinct [4]u64

Dictionary :: distinct [1]u64

Array :: distinct [1]u64

//WARNING: packed array types are just structs of helper functions. I think.
PackedByteArray :: distinct  [2]u64

PackedInt32Array :: distinct  [2]u64

PackedInt64Array :: distinct  [2]u64

PackedFloat32Array :: struct{ data: u64}

PackedFloat64Array :: distinct  [2]u64

PackedStringArray :: distinct  [1]u64

PackedVector2Array :: packedArray(f32)

packedArray :: struct($T: typeid) { 
    proxy: rawptr,
    data: [^]T
}

PackedVector3Array :: distinct  [2]u64

PackedColorArray :: distinct  [2]u64

PackedVector4Array :: distinct  [2]u64



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
typeid_of(Transfrom),
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