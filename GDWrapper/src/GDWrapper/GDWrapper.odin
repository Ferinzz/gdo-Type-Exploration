package GDWrapper

import GDE "gdextension"

Library : GDE.ClassLibraryPtr = nil


//*****************************\\
//******Pointers to Godot******\\
//******Utility Functions******\\
//*****************************\\

//You're going to use the p_get_proc_address a lot to get most of the default Godot interface functions.
API :: struct  {
    p_get_proc_address: GDE.InterfaceGetProcAddress,
    classDBRegisterExtClass: GDE.InterfaceClassdbRegisterExtensionClass4,
    classDBConstructObj: GDE.InterfaceClassdbConstructObject,
    object_set_instance: GDE.InterfaceObjectSetInstance,
    object_set_instance_binding: GDE.InterfaceObjectSetInstanceBinding,
    //Variant related function pointers.
    classdbRegisterExtensionClassMethod: GDE.InterfaceClassdbRegisterExtensionClassMethod,

    //Custom properties.
    classDBRegisterExtensionClassProperty: GDE.InterfaceClassdbRegisterExtensionClassProperty,
    classBDRegistClassSignal: GDE.InterfaceClassdbRegisterExtensionClassSignal,


    //Use to get the method pointers for Godot's objects. ie : get the set_position function from Node2D
    classDBGetMethodBind: GDE.InterfaceClassdbGetMethodBind,

    //Functions related to method bindings on Godot side.
    objectMethodBindCall: GDE.InterfaceObjectMethodBindCall,
    objectMethodBindPtrCall: GDE.InterfaceObjectMethodBindPtrcall,
    builtinMethodBindCall: GDE.InterfaceVariantGetPtrBuiltinMethod,
    indexGetBind: GDE.GDExtensionInterfaceVariantGetPtrIndexedGetter,
    indexSetBind: GDE.GDExtensionInterfaceVariantGetPtrIndexedSetter
}

api: API


//Use these to build a C++ String or StringName that Godot can use.
StringConstruct :: struct {
    stringNameNewLatin: GDE.InterfaceStringNameNewWithLatin1Chars,
    stringNewUTF8: GDE.InterfaceStringNewWithUtf8Chars,
    stringNewLatin: GDE.InterfaceStringNewWithLatin1Chars,
}

stringconstruct : StringConstruct

Destructors :: struct {
    stringNameDestructor: GDE.PtrDestructor,
    stringDestruction: GDE.PtrDestructor,
    variantDestroy: GDE.InterfaceVariantDestroy
}

destructors: Destructors

loadAPI :: proc(p_get_proc_address : GDE.InterfaceGetProcAddress){

    // Get helper functions first.
    //Gets a pointer to the function that will return the pointer to the function that destroys the specific variable type.
    variant_get_ptr_destructor: GDE.InterfaceVariantGetPtrDestructor  = cast(GDE.InterfaceVariantGetPtrDestructor)p_get_proc_address("variant_get_ptr_destructor")
    //Gets a pointer to the function that will return the pointer to the function that will evaluate the variable types under the specified condition.
    variantGetPtrOperatorEvaluator: GDE.InterfaceVariantGetPtrOperatorEvaluator = cast(GDE.InterfaceVariantGetPtrOperatorEvaluator)p_get_proc_address("variant_get_ptr_operator_evaluator")
    variantGetPtrConstructor: GDE.InterfaceVariantGetPtrConstructor = cast(GDE.InterfaceVariantGetPtrConstructor)p_get_proc_address("variant_get_ptr_constructor")

    //Operators
    //Do not get confused with the function that we run on our end that will return whether a StringName is equal. This just runs the compare on Godot Side.
    //operator.stringNameEqual = variantGetPtrOperatorEvaluator(.VARIANT_OP_EQUAL, .STRING_NAME, .STRING_NAME)

    //API.
    api.p_get_proc_address = p_get_proc_address
    api.classDBRegisterExtClass = cast(GDE.InterfaceClassdbRegisterExtensionClass4)p_get_proc_address("classdb_register_extension_class4")
    api.classDBConstructObj = cast(GDE.InterfaceClassdbConstructObject)p_get_proc_address("classdb_construct_object")
    api.object_set_instance = cast(GDE.InterfaceObjectSetInstance)p_get_proc_address("object_set_instance")
    api.object_set_instance_binding = cast(GDE.InterfaceObjectSetInstanceBinding)p_get_proc_address("object_set_instance_binding")
    //api.mem_alloc = cast(GDE.InterfaceMemAlloc)p_get_proc_address("mem_alloc")
    //api.mem_free = cast(GDE.InterfaceMemFree)p_get_proc_address("mem_free")
    api.classdbRegisterExtensionClassMethod = cast(GDE.InterfaceClassdbRegisterExtensionClassMethod)p_get_proc_address("classdb_register_extension_class_method")
    api.classDBRegisterExtensionClassProperty = cast(GDE.InterfaceClassdbRegisterExtensionClassProperty)p_get_proc_address("classdb_register_extension_class_property")
    //Really nice that you can (hopefully) just cast the pointer to the function's proc type. Signature?
    api.classDBGetMethodBind = cast(GDE.InterfaceClassdbGetMethodBind)p_get_proc_address("classdb_get_method_bind")
    //api.objectMethodBindPtrCall = cast(proc(p_method_bind: GDE.MethodBindPtr, p_instance: GDE.ObjectPtr, p_args: GDE.ConstTypePtrargs, r_ret: GDE.TypePtr))p_get_proc_address("object_method_bind_ptrcall")
    api.objectMethodBindPtrCall = cast(GDE.InterfaceObjectMethodBindPtrcall)p_get_proc_address("object_method_bind_ptrcall")
    api.classBDRegistClassSignal = cast(GDE.InterfaceClassdbRegisterExtensionClassSignal)p_get_proc_address("classdb_register_extension_class_signal")
    api.objectMethodBindCall = cast(GDE.InterfaceObjectMethodBindCall)p_get_proc_address("object_method_bind_call")
    api.builtinMethodBindCall = cast(GDE.InterfaceVariantGetPtrBuiltinMethod)p_get_proc_address("variant_get_ptr_builtin_method")

    //constructors.
    stringconstruct.stringNameNewLatin = cast(GDE.InterfaceStringNameNewWithLatin1Chars)p_get_proc_address("string_name_new_with_latin1_chars")
    stringconstruct.stringNewUTF8 = cast(GDE.InterfaceStringNewWithUtf8Chars)api.p_get_proc_address("string_new_with_utf8_chars")
    stringconstruct.stringNewLatin = cast(GDE.InterfaceStringNewWithLatin1Chars)api.p_get_proc_address("string_new_with_latin1_chars")


    variantgetters.getVariantFromTypeConstructor = cast(GDE.InterfaceGetVariantFromTypeConstructor)p_get_proc_address("get_variant_from_type_constructor")
    variantgetters.getVariantToTypeConstuctor = cast(GDE.InterfaceGetVariantToTypeConstructor)p_get_proc_address("get_variant_to_type_constructor")
    variantgetters.variantGetType = cast(GDE.InterfaceVariantGetType)p_get_proc_address("variant_get_type")
    variantfrom.FloatToVariant = variantgetters.getVariantFromTypeConstructor(.FLOAT)
    variantto.floatFromVariant = variantgetters.getVariantToTypeConstuctor(.FLOAT)
    variantto.intFromVariant = variantgetters.getVariantToTypeConstuctor(.INT)
    variantto.packedf32arrayFromVariant = variantgetters.getVariantToTypeConstuctor(.PACKED_FLOAT32_ARRAY)
    
    //constructor.vector2ConstructorXY = variantGetPtrConstructor(.VECTOR2, 3) // See extension_api.json for indices. ??? So... a Vector2 isn't generic like it is in Raylib. It has specific names for each use case. Madness.
    //What happens if you don't use the correct index? Does Godot throw a fit because the names aren't exactly the same?
    //Is this what a dynamic language ends up being?
    variantfrom.StringNameToVariant = variantgetters.getVariantFromTypeConstructor(.STRING_NAME)
    variantfrom.Vec2ToVariant = variantgetters.getVariantFromTypeConstructor(.VECTOR2)
    variantfrom.boolToVariant = variantgetters.getVariantFromTypeConstructor(.BOOL)
    variantfrom.rec2ToVariant = variantgetters.getVariantFromTypeConstructor(.RECT2)
    variantfrom.Transform2dToVariant = variantgetters.getVariantFromTypeConstructor(.TRANSFORM2D)
    variantfrom.packedf32arrayToVariant = variantgetters.getVariantFromTypeConstructor(.PACKED_FLOAT32_ARRAY)

    api.indexGetBind = cast(GDE.GDExtensionInterfaceVariantGetPtrIndexedGetter)p_get_proc_address("variant_get_ptr_indexed_getter")
    api.indexSetBind = cast(GDE.GDExtensionInterfaceVariantGetPtrIndexedSetter)p_get_proc_address("variant_get_ptr_indexed_setter")
    arrayhelp.packedf32GetIndex = api.indexGetBind(.PACKED_FLOAT32_ARRAY)
    arrayhelp.packedf32SetIndex = api.indexSetBind(.PACKED_FLOAT32_ARRAY)
    
    //constructor.variantNil = cast(GDE.InterfaceVariantNewNil)api.p_get_proc_address("variant_new_nil")
    //constructor.variantToVec2Constructor = cast(GDE.TypeFromVariantConstructorFunc)api.getVariantToTypeConstuctor(.VECTOR2)

    //Destructors.
    destructors.stringNameDestructor = cast(GDE.PtrDestructor)variant_get_ptr_destructor(.STRING_NAME)
    destructors.stringDestruction = cast(GDE.PtrDestructor)variant_get_ptr_destructor(.STRING)
    destructors.variantDestroy = cast(GDE.InterfaceVariantDestroy)p_get_proc_address("variant_destroy")

    
}

/* Get a binding to a method from Godot's class DB.
* Pass in the class and method name as strings. The function will convert Odin strings to Godot's StringName.
* 
* className : a string with the name of the Godot class
* methodName : a string with the name of a method in the Godot class
* hash : the hash of the method. find it in the json. Careful of buildmode it's under.
* 
*/
classDBGetMethodBind :: proc(className, methodName: cstring, hash: int, loc := #caller_location) -> (methodBind: GDE.MethodBindPtr) {
    //context = runtime.default_context()

    native_class_name: GDE.StringName;
    method_name: GDE.StringName;
    
    stringconstruct.stringNameNewLatin(&native_class_name, className, false)
    stringconstruct.stringNameNewLatin(&method_name, methodName, false)
    
    methodBind = api.classDBGetMethodBind(&native_class_name, &method_name, hash)
    
    destructors.stringNameDestructor(&native_class_name)
    destructors.stringNameDestructor(&method_name)

    return methodBind
}