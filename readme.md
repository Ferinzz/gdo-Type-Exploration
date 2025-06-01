Trying to reverse engineer the type system for variants. 

For all of the types which are not dynamically allocated you can more or less freely convert these to and from variant.

	/*  atomic types */
	BOOL,
	INT,
	FLOAT,

	/* math types */
	VECTOR2,
	VECTOR2I,
	RECT2,
	RECT2I,
	VECTOR3,
	VECTOR3I,
	TRANSFORM2D,
	VECTOR4,
	VECTOR4I,
	PLANE,
	QUATERNION,
	AABB,
	BASIS,
	TRANSFORM3D,
	PROJECTION,

	/* misc types */
	COLOR,
	NODE_PATH,
	RID,
	OBJECT,

Since these aren't dynamic or ref counted(?) they can be easily created and/or converted to or from a variant type.
Anything less than 128 bits will fit directly into the variant's memory. Anything larger will be a pointer to the memory.
For float you can get it by doing cast(f64)variant.data[1]
For TRANSFORM2D you would derefence the pointer (cast(^[4]f32)variant.data[1])^ or just use the pointer if you trust the lifetime.
For rect2 all the data fits in 128, so you just transmute to the correct layout transmute([4]f32)variant.data[1:2] (need to double check the syntax. Should be this, or close.)


The variant types which will need to be created/destroyed by Godot itself are below. Use the correct Godot constructor for them or there will be issues..`
	/* others */
	STRING_NAME,
	STRING,
	CALLABLE,
	SIGNAL,
	DICTIONARY,
	ARRAY,

	/* typed arrays */
	PACKED_BYTE_ARRAY,
	PACKED_INT32_ARRAY,
	PACKED_INT64_ARRAY,
	PACKED_FLOAT32_ARRAY,
	PACKED_FLOAT64_ARRAY,
	PACKED_STRING_ARRAY,
	PACKED_VECTOR2_ARRAY,
	PACKED_VECTOR3_ARRAY,
	PACKED_COLOR_ARRAY,
	PACKED_VECTOR4_ARRAY,

Get the constructor when loading the API via InterfaceVariantGetPtrConstructor. Specify the index because the constructors are often overloaded. See arrayhelper for examples.

You can actually get the pointer to the array if you look into variant.data[1] as if it were an array of pointers. should be something that looks a bit messy (((cast(^[8]^[x]T)uninitptr.data[1]))[3])

It also doesn't provide the array length as it passes it via a variant. Meaning you'll need to bind to a built-in method to get that information. :/ There's a spare 96bits in the variant. PLEASE.
Anyways.
Make yourself a variable to hold the pointer
packedf32size: GDE.PtrBuiltInMethod,
At runtime you'll need to bind it by specifying the built-in name, the method name, and method hash.
    arrayClass:= new(GDE.StringName)
    GDW.stringconstruct.stringNameNewLatin(&arrayClass, "PackedFloat32Array", false)
    arraySize:= new(GDE.StringName)
    GDW.stringconstruct.stringNameNewLatin(&arraySize, "size", false)
    GDW.arrayhelp.packedf32size = GDW.api.builtinMethodBindCall(.PACKED_FLOAT32_ARRAY, &arraySize, 3173160232)

Then you can use it.
GDW.arrayhelp.packedf32size(&uninitptr.data, nil, &returnedSize, 0)
(Don't forget to delete the stringName)

Debug mode :
Shows that when using create on the variant it initializes to 0x0000 for everything.
When you do a type to variant it takes those two values, casts the p_value to a variant??? starts the memnew_placement method. Then somehow reaches 
variant.cpp line 2555
Variant::Variant(const PackedFloat32Array &p_float32_array) :
		type(PACKED_FLOAT32_ARRAY) {
	_data.packed_array = PackedArrayRef<float>::create(p_float32_array);
}
p_float_array is a type with the size of the array as the first argument and the array raw data continuing it.
Seems like to address the size issue we will need our array format to be 
size at [0]u64
rawdata begins at [1]T
with 1 being offset based on the type. If <64b will need to offset by one additional location.
"This" at this point is the dest variant.

But this is actually supposed to use a packedarrayref<T> so my rawdata array gets mangled at the memnew step??? It's supposed to take a size and const char *p_description.
p_description is mangled size becomes 32. Which is size of the struct we're in? Probably?

malloc does some stuff and returns a new address.

Confirmed pretty much everything I think.

The address that you should give to Godot's array methods is u64 to the right of where the array begins. The first 64bits of the memory should be reserved for size.

Use the packed*array type with the helper methods. Get, set, resize etc.

The pointer that Godot will provide to you is set at the beginning of the data, which is 64bits to the right of where you can get the size.

Godot does multiple size checks for a single simple change. Try to avoid relying on Godot too much if you won't want that.

The variant doesn't hold the array directly. It will hold a pointer to a struct that manages the ref count which also holds the array pointer.

Keep in mind that Godot expects arrays to be copy on write. The moment you make any change to the array it will cause a malloc and the variant within that instance will be pointing to the new memory address? Meaning once you make a change to the array you should consider all other references to the array you received out of sync. (This sounds like a mess which could cause a bunch of weird out of sync bugs? o.O)
I should see if the same variant is passed through different instances.. Maybe if one is updated to the new array address they can all be updated? Though I assume each variant is created uniquely, which is why you need the ref count to begin with.

If it needs to delete previous iterations of the arrays, how does it know to delete the original when using built-in methods? :thinking: Might need to document what the create functions actually do.
--Testing : Use Create0 to build a i64 array.
--Result : For some reason goes from create immediately to destroy. Likely be because there is no refCount and it starts with a count of 0.

--Testing : Use create 1 to build a i64 array. This takes the destination pointer and a source array to populate our struct with a pointer to the prev array.
--Result : It needs to check the refCounter to increment. As this was not initialized it will take a "random" point in memory.

Conclusion : DO NOT use the built-ins' create functions to create arrays. They will not create the required refCounter.

cowData shows a memory layout with
refcounter :: size :: data
Have I just been lucky that the ref count is 0? Though I feel like I've seen it get messed up before. Meaning the array I should be building needs another X in size to make sure it doesn't accidentally get random memory? No, because part of the process to make a variant os to make the ref count. Meaning Godot expects the original array's memory to be owned by the source creator.

You can't work with Varirants directly to do set actions because the method for that requires the packed*array type. The struct with the poitner to the array data as the second variable.

So the ref counter is to track the specific variant itself.?

Theory : A side effect of forced copy on write is that if you make updates through a variant and want to send that back you'd end up needing to make two copies.

If you have allocated memory left IN BUCKETS at exit it will log a warning about this. See type list here -> https://github.com/godotengine/godot/blob/45fc515ae3574e9c1f9deacaa6960dec68a7d38b/core/variant/variant.cpp#L1385

Packed arrays don't get a warning though.