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


The variant types which will need to be created/destroyed by Godot itself are below. Use the correct Godot constructor for them or there will be issues..
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

You can actually get the pointer to the array if you look into variant.data[1] as if it were an array of pointers. should be something that looks a bit messy (((cast(^[8]^[x]f32)uninitptr.data[1]))[3])

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

