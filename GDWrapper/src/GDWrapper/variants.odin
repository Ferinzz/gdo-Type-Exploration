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
        mem.copy(&p_variant.data, p_from, 8)
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
    BoolFromVariant       :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Bool) {
        assert(p_variant.VType == .BOOL)
        mem.copy(p_from, &p_variant.data,  8)
    }
    IntFromVariant       :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Int) {
        p_variant.VType = .INT
        mem.copy(p_from, &p_variant.data, 8)
    }
    FloatFromVariant      :: proc(p_variant: ^GDE.Variant, p_from: ^f64) {
        assert(p_variant.VType == .FLOAT)
        mem.copy(p_from, &p_variant.data, 8)
    }
    
    StringFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.gdstring) {
        @(static) string2v: GDE.TypeFromVariantConstructorFunc
        if string2v == nil do string2v = variantgetters.getVariantToTypeConstuctor(.STRING)
        assert(p_variant.VType == .STRING)
        string2v(p_variant, p_from)
    }
    Vec2FromVariant       :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector2) {
        assert(p_variant.VType == .VECTOR2)
        mem.copy(p_from, &p_variant.data, 8)
    }
    Vec2iFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector2i) {
        assert(p_variant.VType == .VECTOR2I)
        mem.copy(p_from, &p_variant.data, 8)
    }
    Recf32FromVariant     :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Rec2) {
        assert(p_variant.VType == .RECT2)
        mem.copy(p_from, &p_variant.data, 16)
    }
    
    Rec2iFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Rec2i) {
        assert(p_variant.VType == .RECT2I)
        mem.copy(p_from, &p_variant.data, 16)
    }
    Vec3FromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector3) {
        assert(p_variant.VType == .VECTOR3)
        mem.copy(p_from, &p_variant.data, 12)
    }
    Vec3iFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector3i) {
        assert(p_variant.VType == .VECTOR3I)
        mem.copy(p_from, &p_variant.data, 12)
    }
    Vec4FromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector4) {
        assert(p_variant.VType == .VECTOR4)
        mem.copy(p_from, &p_variant.data, 16)
    }
    Vec4iFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Vector4i) {
        assert(p_variant.VType == .VECTOR4I)
        mem.copy(p_from, &p_variant.data, 16)
    }
    PlaneFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Plane) {
        assert(p_variant.VType == .PLANE)
        mem.copy(p_from, &p_variant.data, 16)
    }
    QuaternionFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Quaternion) {
        assert(p_variant.VType == .QUATERNION)
        mem.copy(p_from, &p_variant.data, 16)
    }
    AABBFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.AABB) {
        @(static) aabb2v: GDE.TypeFromVariantConstructorFunc
        if aabb2v == nil do aabb2v = variantgetters.getVariantToTypeConstuctor(.AABB)
        assert(p_variant.VType == .AABB)
        aabb2v(p_variant, p_from)
    }
    BasisFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Basis) {
        @(static) basis2v: GDE.TypeFromVariantConstructorFunc
        if basis2v == nil do basis2v = variantgetters.getVariantToTypeConstuctor(.BASIS)
        assert(p_variant.VType == .BASIS)
        basis2v(p_variant, p_from)
    }
    Transform3dFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Transform3D) {
        @(static) trans3d2v: GDE.TypeFromVariantConstructorFunc
        if trans3d2v == nil do trans3d2v = variantgetters.getVariantToTypeConstuctor(.TRANSFORM3D)
        assert(p_variant.VType == .TRANSFORM3D)
        trans3d2v(p_variant, p_from)
    }
    ProjectionFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Projection) {
        @(static) proj2v: GDE.TypeFromVariantConstructorFunc
        if proj2v == nil do proj2v = variantgetters.getVariantToTypeConstuctor(.PROJECTION)
        assert(p_variant.VType == .PROJECTION)
        proj2v(p_variant, p_from)
    }
    Transform2dFromVariant    :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Transform2d) {
        @(static) trans2d2V: GDE.TypeFromVariantConstructorFunc
        if trans2d2V == nil do trans2d2V = variantgetters.getVariantToTypeConstuctor(.TRANSFORM2D)
        assert(p_variant.VType == .TRANSFORM2D)
        trans2d2V(p_variant, p_from)
    }

    ColorFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Color) {
        assert(p_variant.VType == .COLOR)
        mem.copy(p_from, &p_variant.data, 16)
    }
    StringNameFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.StringName) {
        @(static) stringname2V: GDE.TypeFromVariantConstructorFunc
        if stringname2V == nil do stringname2V = variantgetters.getVariantToTypeConstuctor(.STRING_NAME)
        assert(p_variant.VType == .STRING_NAME)
        stringname2V(p_variant, p_from)
    }
    
    NodePathFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.NodePath) {
        @(static) nodepath2v: GDE.TypeFromVariantConstructorFunc
        if nodepath2v == nil do nodepath2v = variantgetters.getVariantToTypeConstuctor(.NODE_PATH)
        assert(p_variant.VType == .NODE_PATH)
        nodepath2v(p_variant, p_from)
    }
    RidFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.RID) {
        @(static) rid2v: GDE.TypeFromVariantConstructorFunc
        if rid2v == nil do rid2v = variantgetters.getVariantToTypeConstuctor(.RID)
        assert(p_variant.VType == .RID)
        rid2v(p_variant, p_from)
    }
    ObjectFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Object) {
        @(static) object2v: GDE.TypeFromVariantConstructorFunc
        if object2v == nil do object2v = variantgetters.getVariantToTypeConstuctor(.OBJECT)
        assert(p_variant.VType == .OBJECT)
        object2v(p_variant, p_from)
    }
    CallableFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Callable) {
        @(static) callabele2v: GDE.TypeFromVariantConstructorFunc
        if callabele2v == nil do callabele2v = variantgetters.getVariantToTypeConstuctor(.CALLABLE)
        assert(p_variant.VType == .CALLABLE)
        callabele2v(p_variant, p_from)
    }
    SignalFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Signal) {
        @(static) signale2v: GDE.TypeFromVariantConstructorFunc
        if signale2v == nil do signale2v = variantgetters.getVariantToTypeConstuctor(.SIGNAL)
        assert(p_variant.VType == .SIGNAL)
        signale2v(p_variant, p_from)
    }
    DictionaryFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Dictionary) {
        @(static) dictionary2v: GDE.TypeFromVariantConstructorFunc
        if dictionary2v == nil do dictionary2v = variantgetters.getVariantToTypeConstuctor(.DICTIONARY)
        assert(p_variant.VType == .DICTIONARY)
        dictionary2v(p_variant, p_from)
    }

    ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.Array) {
        @(static) array2v: GDE.TypeFromVariantConstructorFunc
        if array2v == nil do array2v = variantgetters.getVariantToTypeConstuctor(.ARRAY)
        assert(p_variant.VType == .ARRAY)
        array2v(p_variant, p_from)
    }
    PackedByteArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedByteArray) {
        @(static) packedbyte2v: GDE.TypeFromVariantConstructorFunc
        if packedbyte2v == nil do packedbyte2v = variantgetters.getVariantToTypeConstuctor(.PACKED_BYTE_ARRAY)
        assert(p_variant.VType == .PACKED_BYTE_ARRAY)
        packedbyte2v(p_variant, p_from)
    }
    Packedi32ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedInt32Array) {
        @(static) packedi322v: GDE.TypeFromVariantConstructorFunc
        if packedi322v == nil do packedi322v = variantgetters.getVariantToTypeConstuctor(.PACKED_INT32_ARRAY)
        assert(p_variant.VType == .PACKED_INT32_ARRAY)
        packedi322v(p_variant, p_from)
    }
    Packedi64ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedInt64Array) {
        @(static) packedi642v: GDE.TypeFromVariantConstructorFunc
        if packedi642v == nil do packedi642v = variantgetters.getVariantToTypeConstuctor(.PACKED_INT64_ARRAY)
        assert(p_variant.VType == .PACKED_INT64_ARRAY)
        packedi642v(p_variant, p_from)
    }
    Packedf32ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedFloat32Array) {
        @(static) packedf322v: GDE.TypeFromVariantConstructorFunc
        if packedf322v == nil do packedf322v = variantgetters.getVariantToTypeConstuctor(.PACKED_FLOAT32_ARRAY)
        assert(p_variant.VType == .PACKED_FLOAT32_ARRAY)
        packedf322v(p_variant, p_from)
    }
    Packedf64ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedFloat64Array) {
        @(static) packedf642v: GDE.TypeFromVariantConstructorFunc
        if packedf642v == nil do packedf642v = variantgetters.getVariantToTypeConstuctor(.PACKED_FLOAT64_ARRAY)
        assert(p_variant.VType == .PACKED_INT64_ARRAY)
        packedf642v(p_variant, p_from)
    }
    PackedStringArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedStringArray) {
        @(static) packedstring2v: GDE.TypeFromVariantConstructorFunc
        if packedstring2v == nil do packedstring2v = variantgetters.getVariantToTypeConstuctor(.PACKED_STRING_ARRAY)
        assert(p_variant.VType == .PACKED_STRING_ARRAY)
        packedstring2v(p_variant, p_from)
    }
    PackedVec2ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedVector2Array) {
        @(static) packedvec22v: GDE.TypeFromVariantConstructorFunc
        if packedvec22v == nil do packedvec22v = variantgetters.getVariantToTypeConstuctor(.PACKED_VECTOR2_ARRAY)
        assert(p_variant.VType == .PACKED_VECTOR2_ARRAY)
        packedvec22v(p_variant, p_from)
    }
    PackedVec3ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedVector3Array) {
        @(static) packedvec32v: GDE.TypeFromVariantConstructorFunc
        if packedvec32v == nil do packedvec32v = variantgetters.getVariantToTypeConstuctor(.PACKED_VECTOR3_ARRAY)
        assert(p_variant.VType == .PACKED_VECTOR3_ARRAY)
        packedvec32v(p_variant, p_from)
    }
    PackedColorArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedColorArray) {
        @(static) packedcolor2v: GDE.TypeFromVariantConstructorFunc
        if packedcolor2v == nil do packedcolor2v = variantgetters.getVariantToTypeConstuctor(.PACKED_COLOR_ARRAY)
        assert(p_variant.VType == .PACKED_COLOR_ARRAY)
        packedcolor2v(p_variant, p_from)
    }
    PackedVec4ArrayFromVariant :: proc(p_variant: ^GDE.Variant, p_from: ^GDE.PackedVector4Array) {
        @(static) packedvec42v: GDE.TypeFromVariantConstructorFunc
        if packedvec42v == nil do packedvec42v = variantgetters.getVariantToTypeConstuctor(.PACKED_VECTOR4_ARRAY)
        assert(p_variant.VType == .PACKED_VECTOR4_ARRAY)
        packedvec42v(p_variant, p_from)
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

