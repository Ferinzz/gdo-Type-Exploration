package GDWrapper

import GDE "gdextension"
import "base:runtime"

/*
* Variants are Godot's special class of types.
* Under the hood it's
* an enum Type that holds the type
* a union _data which holds either the variable information or the pointer to the mem location
* In the class there's also an array that holds true/false to say whether the Variant type needs to be deinit. We could have this as a bitfield on our end.
* Reference for definitions : https://github.com/godotengine/godot/blob/45fc515ae3574e9c1f9deacaa6960dec68a7d38b/core/variant/variant.h
* In Godot there isn't a single function to do the type conversions to/from a Variant, so each needs to be fetched and stored independently.
*/

//Variant types found in the enum GDE.VariantType ref original C bindings for updates to the list.

//Use this to get the appropriate variatn conversion functions.
VariantGetters :: struct {
    getVariantFromTypeConstructor: GDE.InterfaceGetVariantFromTypeConstructor,
    getVariantToTypeConstuctor: GDE.InterfaceGetVariantToTypeConstructor,
    variantGetType: GDE.InterfaceVariantGetType,
}

variantgetters: VariantGetters



//Convert your variable to Godot's Variant type.
VariantFrom :: struct {
	
    FloatToVariant: GDE.VariantFromTypeConstructorFunc,
    StringNameToVariant: GDE.VariantFromTypeConstructorFunc,
    Vec2ToVariant: GDE.VariantFromTypeConstructorFunc,
    boolToVariant: GDE.VariantFromTypeConstructorFunc,
    rec2ToVariant: GDE.VariantFromTypeConstructorFunc,
    Transform2dToVariant: GDE.VariantFromTypeConstructorFunc,
    packedf32arrayToVariant: GDE.VariantFromTypeConstructorFunc,
    
}
variantfrom: VariantFrom

ArrayHelp :: struct {
    //Godot needs to allocate memory for the array and track it on its side.
    packedi32create0: GDE.PtrConstructor,
    packedi32create1: GDE.PtrConstructor, //create from another packedf32
    packedi32create2: GDE.PtrConstructor, //create from an Array.
    packedi32size: GDE.PtrBuiltInMethod,
    packedi32REsize: GDE.PtrBuiltInMethod,
    packedi32Append: GDE.PtrBuiltInMethod,
    packedi32Get: GDE.PtrBuiltInMethod,
    packedi32Set: GDE.PtrBuiltInMethod,
    packedi32GetIndex: GDE.PtrIndexedGetter,
    packedi32SetIndex: GDE.PtrIndexedGetter,
}

arrayhelp: ArrayHelp

//Convert Godot's Variant type to a C type.
variantTo :: struct {
    floatFromVariant: GDE.TypeFromVariantConstructorFunc,
    intFromVariant: GDE.TypeFromVariantConstructorFunc,
    Vec2FromVariant: GDE.TypeFromVariantConstructorFunc,
    packedf32arrayFromVariant: GDE.TypeFromVariantConstructorFunc,
    
}

variantto: variantTo

/*
* Conversion functions will need to depend on the type or enum passed.
*/

variantToType :: proc(p_variant: ^GDE.Variant, r_value: $T) {
    context = runtime.default_context()

    switch type in p_variant[0] {
    case NIL :
    
	/*  atomic types */
	case BOOL :
        if p_variant[0] == type_of(r_value) {
            r_value^ = cast(b8)Variant[1]
            return
        }
	case INT :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case FLOAT :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case STRING :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
    
	/* math types */
	case VECTOR2 :
        if p_variant[0] == i32(type) {
            r_value^ = transmute(GDE.Vector2)r_variant[1]
        }
	case VECTOR2I :
        if p_variant[0] == i32(type) {
            r_value^ = transmute(Vector2i)r_variant[1]
        }
	case RECT2 :
        if p_variant[0] == i32(type) {
            r_value = r_variant[1]
        }
	case RECT2I :
        if p_variant[0] == i32(type) {
            r_value = r_variant[1]
        }
	case VECTOR3 :
        if p_variant[0] == i32(type) {
            r_value = r_variant[1]
        }
	case VECTOR3I :
        if p_variant[0] == i32(type) {
            r_value = r_variant[1]
        }
	case TRANSFORM2D :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case VECTOR4 :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case VECTOR4I :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case PLANE :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case QUATERNION :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case AABB :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case BASIS :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case TRANSFORM3D :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case PROJECTION :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
    
	/* misc types */
	case COLOR :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case STRING_NAME :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case NODE_PATH :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case RID :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case OBJECT :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case CALLABLE :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case SIGNAL :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case DICTIONARY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case ARRAY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
    
	/* typed arrays */
	case PACKED_BYTE_ARRAY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case PACKED_INT32_ARRAY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case PACKED_INT64_ARRAY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case PACKED_FLOAT32_ARRAY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case PACKED_FLOAT64_ARRAY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case PACKED_STRING_ARRAY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case PACKED_VECTOR2_ARRAY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case PACKED_VECTOR3_ARRAY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case PACKED_COLOR_ARRAY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
	case PACKED_VECTOR4_ARRAY :
        if p_variant[0] == i32(type) {
            r_value^ = r_variant[1]
        }
    
	case VARIANT_MAX:
    }
}


/* NOTES. Not all variants are ref counted.
* The ones which are not should be safer to create/copy on Odin side.
* int, float, bool --- Plain values
* Vector2, Vector3, Color, Rect2, etc. --- Value types — fast, small
* Transform2D, Transform3D, Basis, Quaternion --- Math/value types
* 
* StringName	Internally pooled and reused, but not ref-counted per se
* 
* Potentially unsafe since we don't have ownership of the memory.
* Variant (nested)	Special case — copies the value recursively 
* Callable, Signal, NodePath --- May internally point to data, but not ref-counted in the usual sense
*/

/* NOTES. Ref counted. Should not be managed on Odin side if possible?
* ^Object --- If the object derives from RefCounted, it's reference-counted via Ref<Object> when wrapped in a Variant.
* Ref<T> --- Any Ref<T> is reference-counted (e.g., Ref<Texture2D>, Ref<ShaderMaterial>, etc.)
* Array --- Internally reference-counted to allow cheap copies
* Dictionary --- Same as Array — shared internal storage, copy-on-write
* String --- Internally ref-counted (copy-on-write mechanism)
* PackedArray --- (e.g., PackedInt32Array) Internally ref-counted as well
* RID --- Not strictly reference-counted, but internally managed through a resource system — not freed directly by user code
*/

variantTypeMatch :: proc(p_variant: GDE.Variant, compare: $T) -> bool {
    switch cast(GDE.VariantType)GDE.Variant[0] {
        case NIL:
	    case BOOL:
	    case INT:
	    case FLOAT:
	    case STRING:
	    case VECTOR2:
	    case VECTOR2I:
	    case RECT2:
	    case RECT2I:
	    case VECTOR3:
	    case VECTOR3I:
	    case TRANSFORM2D:
	    case VECTOR4:
	    case VECTOR4I:
	    case PLANE:
	    case QUATERNION:
	    case AABB:
	    case BASIS:
	    case TRANSFORM3D:
	    case PROJECTION:
	    case COLOR:
	    case STRING_NAME:
	    case NODE_PATH:
	    case RID:
	    case OBJECT:
	    case CALLABLE:
	    case SIGNAL:
	    case DICTIONARY:
	    case ARRAY:
	    case PACKED_BYTE_ARRAY:
	    case PACKED_INT32_ARRAY:
	    case PACKED_INT64_ARRAY:
	    case PACKED_FLOAT32_ARRAY:
	    case PACKED_FLOAT64_ARRAY:
	    case PACKED_STRING_ARRAY:
	    case PACKED_VECTOR2_ARRAY:
	    case PACKED_VECTOR3_ARRAY:
	    case PACKED_COLOR_ARRAY:
	    case PACKED_VECTOR4_ARRAY:
	    case VARIANT_MAX:
    }
}

//What do I want to do?
//I want to be able to get a type based on the enum location.
//Should be individual functions based on type.
//can return the value durectly from the variant data for most cases.
//can take pointer for others.
//Must use Godot methods for ref counted.

//I want to be able to cast my own types to a variant.
//Different proc depending on type.
//can create the variant durectly from the type data for most cases.
//can take pointer for others.
//Must use Godot methods for ref counted.

