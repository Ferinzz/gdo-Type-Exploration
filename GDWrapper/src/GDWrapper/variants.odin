package GDWrapper

import GDE "gdextension"
import "base:runtime"
import "core:mem"

/*
* Variants are Godot's special class of types.
* Under the hood it's
* an enum Type that holds the type
* a union _data which holds either the variable information or the pointer to the mem location
* In the class there's also an array that holds true/false to say whether the Variant type needs to be deinit. We could have this as a bitfield on our end.
* Reference for definitions : https://github.com/godotengine/godot/blob/45fc515ae3574e9c1f9deacaa6960dec68a7d38b/core/variant/variant.h
* In Godot there isn't a single function to do the type conversions to/from a Variant, so each needs to be fetched and stored independently.
* Some types can be directly converted as they are not ref counted or added to a bucket of memory.
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




variant_from :: proc {
    BooltoVariant,
    InttoVariant,
    FloattoVariant,
    StringtoVariant,
    Vec2toVariant,
    Vec2itoVariant,
    Recf32toVariant,
    Rec2itoVariant,
    Vec3toVariant,
    Vec3itoVariant,
    Transform2dtoVariant,
    Vec4toVariant,
    Vec4itoVariant,
    PlanetoVariant,
    QuaterniontoVariant,
    AABBtoVariant,
    BasistoVariant,
    Transform3dtoVariant,
    ProjectiontoVariant,

    ColortoVariant,
    StringNametoVariant,
    NodePathtoVariant,
    RidtoVariant,
    ObjecttoVariant,
    CallabletoVariant,
    SignaltoVariant,
    DictionarytoVariant,

    ArraytoVariant,
    PackedByteArraytoVariant,
    Packedi32ArraytoVariant,
    Packedi64ArraytoVariant,
    Packedf32ArraytoVariant,
    Packedf64ArraytoVariant,
    PackedStringArraytoVariant,
    PackedVec2ArraytoVariant,
    PackedColorArraytoVariant,
    PackedVec4ArraytoVariant,

}

variant_to :: proc {
    BoolFromVariant,
    IntFromVariant,
    FloatFromVariant,
    StringFromVariant,
    Vec2FromVariant,
    Vec2iFromVariant,
    Recf32FromVariant,
    Rec2iFromVariant,
    Vec3FromVariant,
    Vec3iFromVariant,
    Transform2dFromVariant,
    Vec4FromVariant,
    Vec4iFromVariant,
    PlaneFromVariant,
    QuaternionFromVariant,
    AABBFromVariant,
    BasisFromVariant,
    Transform3dFromVariant,
    ProjectionFromVariant,
    ColorFromVariant,
    
    
    StringNameFromVariant,
    NodePathFromVariant,
    RidFromVariant,
    ObjectFromVariant,
    CallableFromVariant,
    SignalFromVariant,


    DictionaryFromVariant,
    ArrayFromVariant,
    PackedByteArrayFromVariant,
    Packedi32ArrayFromVariant,
    Packedi64ArrayFromVariant,
    Packedf32ArrayFromVariant,
    Packedf64ArrayFromVariant,
    PackedStringArrayFromVariant,
    PackedVec2ArrayFromVariant,
    PackedColorArrayFromVariant,
    PackedVec4ArrayFromVariant,

}

//We aren't preloading these so that it doesn't take time at launch.
//This also helps with ease of writing.
//This is done at the cost of one extra if statement.
//You can always separate these out to make it more direct.
    BooltoVariant       :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Bool) {
        p_variant.VType = .BOOL
        p_variant.data[0] = 0
        mem.copy(&p_variant.data[0], p_from, 1)
    }
    InttoVariant       :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Int) {
        p_variant.VType = .INT
        mem.copy(&p_variant.data, p_from, 8)
    }
    FloattoVariant      :: proc(p_variant: ^GDE.Variant, p_from: ^f64) {
        p_variant.VType = .FLOAT
        mem.copy(&p_variant.data, p_from, 8)
    }
    
    StringtoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.gdstring) {
        @(static) string2v: GDE.VariantFromTypeConstructorFunc
        if string2v == nil do string2v = variantgetters.getVariantFromTypeConstructor(.STRING)
        string2v(p_variant, p_from)
    }
    Vec2toVariant       :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector2) {
        p_variant.VType = .VECTOR2
        mem.copy(&p_variant.data, p_from, 8)
    }
    Vec2itoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector2i) {
        p_variant.VType = .VECTOR2I
        mem.copy(&p_variant.data, p_from, 8)
    }
    Recf32toVariant     :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Rec2) {
        p_variant.VType = .RECT2
        mem.copy(&p_variant.data, p_from, 16)
    }
    
    Rec2itoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Rec2i) {
        p_variant.VType = .RECT2I
        mem.copy(&p_variant.data, p_from, 16)
    }
    Vec3toVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector3) {
        p_variant.VType = .VECTOR3
        mem.copy(&p_variant.data, p_from, 12)
    }
    Vec3itoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector3i) {
        p_variant.VType = .VECTOR3I
        mem.copy(&p_variant.data, p_from, 12)
    }
    Vec4toVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector4) {
        p_variant.VType = .VECTOR4
        mem.copy(&p_variant.data, p_from, 16)
    }
    Vec4itoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector4i) {
        p_variant.VType = .VECTOR4I
        mem.copy(&p_variant.data, p_from, 16)
    }
    PlanetoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Plane) {
        p_variant.VType = .PLANE
        mem.copy(&p_variant.data, p_from, 16)
    }
    QuaterniontoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Quaternion) {
        p_variant.VType = .QUATERNION
        mem.copy(&p_variant.data, p_from, 16)
    }
    AABBtoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.AABB) {
        @(static) aabb2v: GDE.VariantFromTypeConstructorFunc
        if aabb2v == nil do aabb2v = variantgetters.getVariantFromTypeConstructor(.AABB)
        aabb2v(p_variant, p_from)
    }
    BasistoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Basis) {
        @(static) basis2v: GDE.VariantFromTypeConstructorFunc
        if basis2v == nil do basis2v = variantgetters.getVariantFromTypeConstructor(.BASIS)
        basis2v(p_variant, p_from)
    }
    Transform3dtoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Transform3D) {
        @(static) trans3d2v: GDE.VariantFromTypeConstructorFunc
        if trans3d2v == nil do trans3d2v = variantgetters.getVariantFromTypeConstructor(.TRANSFORM3D)
        trans3d2v(p_variant, p_from)
    }
    ProjectiontoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Projection) {
        @(static) proj2v: GDE.VariantFromTypeConstructorFunc
        if proj2v == nil do proj2v = variantgetters.getVariantFromTypeConstructor(.PROJECTION)
        proj2v(p_variant, p_from)
    }
    Transform2dtoVariant    :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Transform2d) {
        @(static) trans2d2V: GDE.VariantFromTypeConstructorFunc
        if trans2d2V == nil do trans2d2V = variantgetters.getVariantFromTypeConstructor(.TRANSFORM2D)
        trans2d2V(p_variant, p_from)
    }

    ColortoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Color) {
        p_variant.VType = .COLOR
        mem.copy(&p_variant.data, p_from, 16)
    }
    StringNametoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.StringName) {
        @(static) stringname2V: GDE.VariantFromTypeConstructorFunc
        if stringname2V == nil do stringname2V = variantgetters.getVariantFromTypeConstructor(.STRING_NAME)
        stringname2V(p_variant, p_from)
    }
    
    NodePathtoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.NodePath) {
        @(static) nodepath2v: GDE.VariantFromTypeConstructorFunc
        if nodepath2v == nil do nodepath2v = variantgetters.getVariantFromTypeConstructor(.NODE_PATH)
        nodepath2v(p_variant, p_from)
    }
    RidtoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.RID) {
        @(static) rid2v: GDE.VariantFromTypeConstructorFunc
        if rid2v == nil do rid2v = variantgetters.getVariantFromTypeConstructor(.RID)
        rid2v(p_variant, p_from)
    }
    ObjecttoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Object) {
        @(static) object2v: GDE.VariantFromTypeConstructorFunc
        if object2v == nil do object2v = variantgetters.getVariantFromTypeConstructor(.OBJECT)
        object2v(p_variant, p_from)
    }
    CallabletoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Callable) {
        @(static) callabele2v: GDE.VariantFromTypeConstructorFunc
        if callabele2v == nil do callabele2v = variantgetters.getVariantFromTypeConstructor(.CALLABLE)
        callabele2v(p_variant, p_from)
    }
    SignaltoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Signal) {
        @(static) signale2v: GDE.VariantFromTypeConstructorFunc
        if signale2v == nil do signale2v = variantgetters.getVariantFromTypeConstructor(.SIGNAL)
        signale2v(p_variant, p_from)
    }
    DictionarytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Dictionary) {
        @(static) dictionary2v: GDE.VariantFromTypeConstructorFunc
        if dictionary2v == nil do dictionary2v = variantgetters.getVariantFromTypeConstructor(.DICTIONARY)
        dictionary2v(p_variant, p_from)
    }

    ArraytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Array) {
        @(static) array2v: GDE.VariantFromTypeConstructorFunc
        if array2v == nil do array2v = variantgetters.getVariantFromTypeConstructor(.ARRAY)
        array2v(p_variant, p_from)
    }
    PackedByteArraytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedByteArray) {
        @(static) packedbyte2v: GDE.VariantFromTypeConstructorFunc
        if packedbyte2v == nil do packedbyte2v = variantgetters.getVariantFromTypeConstructor(.PACKED_BYTE_ARRAY)
        packedbyte2v(p_variant, p_from)
    }
    Packedi32ArraytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedInt32Array) {
        @(static) packedi322v: GDE.VariantFromTypeConstructorFunc
        if packedi322v == nil do packedi322v = variantgetters.getVariantFromTypeConstructor(.PACKED_INT32_ARRAY)
        packedi322v(p_variant, p_from)
    }
    Packedi64ArraytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedInt64Array) {
        @(static) packedi642v: GDE.VariantFromTypeConstructorFunc
        if packedi642v == nil do packedi642v = variantgetters.getVariantFromTypeConstructor(.PACKED_INT64_ARRAY)
        packedi642v(p_variant, p_from)
    }
    Packedf32ArraytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedFloat32Array) {
        @(static) packedf322v: GDE.VariantFromTypeConstructorFunc
        if packedf322v == nil do packedf322v = variantgetters.getVariantFromTypeConstructor(.PACKED_FLOAT32_ARRAY)
        packedf322v(p_variant, p_from)
    }
    Packedf64ArraytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedFloat64Array) {
        @(static) packedf642v: GDE.VariantFromTypeConstructorFunc
        if packedf642v == nil do packedf642v = variantgetters.getVariantFromTypeConstructor(.PACKED_FLOAT64_ARRAY)
        packedf642v(p_variant, p_from)
    }
    PackedStringArraytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedStringArray) {
        @(static) packedstring2v: GDE.VariantFromTypeConstructorFunc
        if packedstring2v == nil do packedstring2v = variantgetters.getVariantFromTypeConstructor(.PACKED_STRING_ARRAY)
        packedstring2v(p_variant, p_from)
    }
    PackedVec2ArraytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedVector2Array) {
        @(static) packedvec22v: GDE.VariantFromTypeConstructorFunc
        if packedvec22v == nil do packedvec22v = variantgetters.getVariantFromTypeConstructor(.PACKED_VECTOR2_ARRAY)
        packedvec22v(p_variant, p_from)
    }
    PackedVec3ArraytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedVector3Array) {
        @(static) packedvec32v: GDE.VariantFromTypeConstructorFunc
        if packedvec32v == nil do packedvec32v = variantgetters.getVariantFromTypeConstructor(.PACKED_VECTOR3_ARRAY)
        packedvec32v(p_variant, p_from)
    }
    PackedColorArraytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedColorArray) {
        @(static) packedcolor2v: GDE.VariantFromTypeConstructorFunc
        if packedcolor2v == nil do packedcolor2v = variantgetters.getVariantFromTypeConstructor(.PACKED_COLOR_ARRAY)
        packedcolor2v(p_variant, p_from)
    }
    PackedVec4ArraytoVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedVector4Array) {
        @(static) packedvec42v: GDE.VariantFromTypeConstructorFunc
        if packedvec42v == nil do packedvec42v = variantgetters.getVariantFromTypeConstructor(.PACKED_VECTOR4_ARRAY)
        packedvec42v(p_variant, p_from)
    }



    ///////////////////////////////////
    BoolFromVariant       :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Bool, loc := #caller_location) {
        assert(p_variant.VType == .BOOL, loc = loc)
        mem.copy(p_dest, &p_variant.data,  8)
    }
    IntFromVariant       :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Int, loc := #caller_location) {
        assert(p_variant.VType == .INT, loc = loc)
        p_variant.VType = .INT
        mem.copy(p_dest, &p_variant.data, 8)
    }
    FloatFromVariant      :: proc(p_variant: ^GDE.Variant, p_dest: ^f64, loc := #caller_location) {
        assert(p_variant.VType == .FLOAT, loc = loc)
        mem.copy(p_dest, &p_variant.data, 8)
    }
    
    StringFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.gdstring, loc := #caller_location) {
        @(static) string2v: GDE.TypeFromVariantConstructorFunc
        if string2v == nil do string2v = variantgetters.getVariantToTypeConstuctor(.STRING)
        assert(p_variant.VType == .STRING, loc = loc)
        string2v(p_dest, p_variant)
    }
    Vec2FromVariant       :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Vector2, loc := #caller_location) {
        assert(p_variant.VType == .VECTOR2, loc = loc)
        mem.copy(p_dest, &p_variant.data, 8)
    }
    Vec2iFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Vector2i, loc := #caller_location) {
        assert(p_variant.VType == .VECTOR2I, loc = loc)
        mem.copy(p_dest, &p_variant.data, 8)
    }
    Recf32FromVariant     :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Rec2, loc := #caller_location) {
        assert(p_variant.VType == .RECT2, loc = loc)
        mem.copy(p_dest, &p_variant.data, 16)
    }
    
    Rec2iFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Rec2i, loc := #caller_location) {
        assert(p_variant.VType == .RECT2I, loc = loc)
        mem.copy(p_dest, &p_variant.data, 16)
    }
    Vec3FromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Vector3, loc := #caller_location) {
        assert(p_variant.VType == .VECTOR3, loc = loc)
        mem.copy(p_dest, &p_variant.data, 12)
    }
    Vec3iFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Vector3i, loc := #caller_location) {
        assert(p_variant.VType == .VECTOR3I, loc = loc)
        mem.copy(p_dest, &p_variant.data, 12)
    }
    Vec4FromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Vector4, loc := #caller_location) {
        assert(p_variant.VType == .VECTOR4, loc = loc)
        mem.copy(p_dest, &p_variant.data, 16)
    }
    Vec4iFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Vector4i, loc := #caller_location) {
        assert(p_variant.VType == .VECTOR4I, loc = loc)
        mem.copy(p_dest, &p_variant.data, 16)
    }
    PlaneFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Plane, loc := #caller_location) {
        assert(p_variant.VType == .PLANE, loc = loc)
        mem.copy(p_dest, &p_variant.data, 16)
    }
    QuaternionFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Quaternion, loc := #caller_location) {
        assert(p_variant.VType == .QUATERNION, loc = loc)
        mem.copy(p_dest, &p_variant.data, 16)
    }
    AABBFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.AABB, loc := #caller_location) {
        assert(p_variant.VType == .AABB, loc = loc)
        @(static) aabb2v: GDE.TypeFromVariantConstructorFunc
        if aabb2v == nil do aabb2v = variantgetters.getVariantToTypeConstuctor(.AABB)
        aabb2v(p_dest, p_variant)
    }
    BasisFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Basis, loc := #caller_location) {
        assert(p_variant.VType == .BASIS, loc = loc)
        @(static) basis2v: GDE.TypeFromVariantConstructorFunc
        if basis2v == nil do basis2v = variantgetters.getVariantToTypeConstuctor(.BASIS)
        basis2v(p_dest, p_variant)
    }
    Transform3dFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Transform3D, loc := #caller_location) {
        assert(p_variant.VType == .TRANSFORM3D, loc = loc)
        @(static) trans3d2v: GDE.TypeFromVariantConstructorFunc
        if trans3d2v == nil do trans3d2v = variantgetters.getVariantToTypeConstuctor(.TRANSFORM3D)
        trans3d2v(p_dest, p_variant)
    }
    ProjectionFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Projection, loc := #caller_location) {
        assert(p_variant.VType == .PROJECTION, loc = loc)
        @(static) proj2v: GDE.TypeFromVariantConstructorFunc
        if proj2v == nil do proj2v = variantgetters.getVariantToTypeConstuctor(.PROJECTION)
        proj2v(p_dest, p_variant)
    }
    Transform2dFromVariant    :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Transform2d, loc := #caller_location) {
        assert(p_variant.VType == .TRANSFORM2D, loc = loc)
        @(static) trans2d2V: GDE.TypeFromVariantConstructorFunc
        if trans2d2V == nil do trans2d2V = variantgetters.getVariantToTypeConstuctor(.TRANSFORM2D)
        trans2d2V(p_dest, p_variant)
    }

    ColorFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Color, loc := #caller_location) {
        assert(p_variant.VType == .COLOR, loc = loc)
        mem.copy(p_dest, &p_variant.data, 16)
    }
    StringNameFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.StringName, loc := #caller_location) {
        assert(p_variant.VType == .STRING_NAME, loc = loc)
        @(static) stringname2V: GDE.TypeFromVariantConstructorFunc
        if stringname2V == nil do stringname2V = variantgetters.getVariantToTypeConstuctor(.STRING_NAME)
        stringname2V(p_dest, p_variant)
    }
    
    NodePathFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.NodePath, loc := #caller_location) {
        assert(p_variant.VType == .NODE_PATH, loc = loc)
        @(static) nodepath2v: GDE.TypeFromVariantConstructorFunc
        if nodepath2v == nil do nodepath2v = variantgetters.getVariantToTypeConstuctor(.NODE_PATH)
        nodepath2v(p_dest, p_variant)
    }
    RidFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.RID, loc := #caller_location) {
        assert(p_variant.VType == .RID, loc = loc)
        @(static) rid2v: GDE.TypeFromVariantConstructorFunc
        if rid2v == nil do rid2v = variantgetters.getVariantToTypeConstuctor(.RID)
        rid2v(p_dest, p_variant)
    }
    ObjectFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Object, loc := #caller_location) {
        assert(p_variant.VType == .OBJECT, loc = loc)
        @(static) object2v: GDE.TypeFromVariantConstructorFunc
        if object2v == nil do object2v = variantgetters.getVariantToTypeConstuctor(.OBJECT)
        object2v(p_dest, p_variant)
    }
    CallableFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Callable, loc := #caller_location) {
        assert(p_variant.VType == .CALLABLE, loc = loc)
        @(static) callabele2v: GDE.TypeFromVariantConstructorFunc
        if callabele2v == nil do callabele2v = variantgetters.getVariantToTypeConstuctor(.CALLABLE)
        callabele2v(p_dest, p_variant)
    }
    SignalFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Signal, loc := #caller_location) {
        assert(p_variant.VType == .SIGNAL, loc = loc)
        @(static) signale2v: GDE.TypeFromVariantConstructorFunc
        if signale2v == nil do signale2v = variantgetters.getVariantToTypeConstuctor(.SIGNAL)
        signale2v(p_dest, p_variant)
    }
    DictionaryFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Dictionary, loc := #caller_location) {
        assert(p_variant.VType == .DICTIONARY, loc = loc)
        @(static) dictionary2v: GDE.TypeFromVariantConstructorFunc
        if dictionary2v == nil do dictionary2v = variantgetters.getVariantToTypeConstuctor(.DICTIONARY)
        dictionary2v(p_dest, p_variant)
    }

    ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.Array, loc := #caller_location) {
        assert(p_variant.VType == .ARRAY, loc = loc)
        @(static) array2v: GDE.TypeFromVariantConstructorFunc
        if array2v == nil do array2v = variantgetters.getVariantToTypeConstuctor(.ARRAY)
        array2v(p_dest, p_variant)
    }
    PackedByteArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.PackedByteArray, loc := #caller_location) {
        assert(p_variant.VType == .PACKED_BYTE_ARRAY, loc = loc)
        @(static) packedbyte2v: GDE.TypeFromVariantConstructorFunc
        if packedbyte2v == nil do packedbyte2v = variantgetters.getVariantToTypeConstuctor(.PACKED_BYTE_ARRAY)
        packedbyte2v(p_dest, p_variant)
    }
    Packedi32ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.PackedInt32Array, loc := #caller_location) {
        assert(p_variant.VType == .PACKED_INT32_ARRAY, loc = loc)
        @(static) packedi322v: GDE.TypeFromVariantConstructorFunc
        if packedi322v == nil do packedi322v = variantgetters.getVariantToTypeConstuctor(.PACKED_INT32_ARRAY)
        packedi322v(p_dest, p_variant)
    }
    Packedi64ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.PackedInt64Array, loc := #caller_location) {
        assert(p_variant.VType == .PACKED_INT64_ARRAY, loc = loc)
        @(static) packedi642v: GDE.TypeFromVariantConstructorFunc
        if packedi642v == nil do packedi642v = variantgetters.getVariantToTypeConstuctor(.PACKED_INT64_ARRAY)
        packedi642v(p_dest, p_variant)
    }
    Packedf32ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.PackedFloat32Array, loc := #caller_location) {
        assert(p_variant.VType == .PACKED_FLOAT32_ARRAY, loc = loc)
        @(static) packedf322v: GDE.TypeFromVariantConstructorFunc
        if packedf322v == nil do packedf322v = variantgetters.getVariantToTypeConstuctor(.PACKED_FLOAT32_ARRAY)
        packedf322v(p_dest, p_variant)
    }
    Packedf64ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.PackedFloat64Array, loc := #caller_location) {
        assert(p_variant.VType == .PACKED_INT64_ARRAY, loc = loc)
        @(static) packedf642v: GDE.TypeFromVariantConstructorFunc
        if packedf642v == nil do packedf642v = variantgetters.getVariantToTypeConstuctor(.PACKED_FLOAT64_ARRAY)
        packedf642v(p_dest, p_variant)
    }
    PackedStringArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.PackedStringArray, loc := #caller_location) {
        assert(p_variant.VType == .PACKED_STRING_ARRAY, loc = loc)
        @(static) packedstring2v: GDE.TypeFromVariantConstructorFunc
        if packedstring2v == nil do packedstring2v = variantgetters.getVariantToTypeConstuctor(.PACKED_STRING_ARRAY)
        packedstring2v(p_dest, p_variant)
    }
    PackedVec2ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.PackedVector2Array, loc := #caller_location) {
        assert(p_variant.VType == .PACKED_VECTOR2_ARRAY, loc = loc)
        @(static) packedvec22v: GDE.TypeFromVariantConstructorFunc
        if packedvec22v == nil do packedvec22v = variantgetters.getVariantToTypeConstuctor(.PACKED_VECTOR2_ARRAY)
        packedvec22v(p_dest, p_variant)
    }
    PackedVec3ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.PackedVector3Array, loc := #caller_location) {
        assert(p_variant.VType == .PACKED_VECTOR3_ARRAY, loc = loc)
        @(static) packedvec32v: GDE.TypeFromVariantConstructorFunc
        if packedvec32v == nil do packedvec32v = variantgetters.getVariantToTypeConstuctor(.PACKED_VECTOR3_ARRAY)
        packedvec32v(p_dest, p_variant)
    }
    PackedColorArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.PackedColorArray, loc := #caller_location) {
        assert(p_variant.VType == .PACKED_COLOR_ARRAY, loc = loc)
        @(static) packedcolor2v: GDE.TypeFromVariantConstructorFunc
        if packedcolor2v == nil do packedcolor2v = variantgetters.getVariantToTypeConstuctor(.PACKED_COLOR_ARRAY)
        packedcolor2v(p_dest, p_variant)
    }
    PackedVec4ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_dest: ^GDE.PackedVector4Array, loc := #caller_location) {
        assert(p_variant.VType == .PACKED_VECTOR4_ARRAY, loc = loc)
        @(static) packedvec42v: GDE.TypeFromVariantConstructorFunc
        if packedvec42v == nil do packedvec42v = variantgetters.getVariantToTypeConstuctor(.PACKED_VECTOR4_ARRAY)
        packedvec42v(p_dest, p_variant)
    }




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
    packedi32Destroy: GDE.PtrDestructor,
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