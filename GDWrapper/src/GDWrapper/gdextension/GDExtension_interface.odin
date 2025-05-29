package gdextension


import "core:c"

/*
* The names on these bindings are not strict. The function names that Godot needs to fetch are in the comments as @name.
* Feel free to rename whatever you need to be shorter.
* Most pointers are either rawptr or multipointers [^]rawptr. I haven't made anything distinct as it's not necessary to be too strict.?
*/

/* VARIANT TYPES */

//VARIANT_MAX is used in Godot as a bounds value. There's some functions and arrays that use this to set/check for out of bounds settings.
VariantType ::  enum {
	NIL,

	/*  atomic types */
	BOOL,
	INT,
	FLOAT,
	STRING,

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
	STRING_NAME,
	NODE_PATH,
	RID,
	OBJECT,
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

	VARIANT_MAX
} 

VariantOperator :: enum {
	/* comparison */
	VARIANT_OP_EQUAL,
	VARIANT_OP_NOT_EQUAL,
	VARIANT_OP_LESS,
	VARIANT_OP_LESS_EQUAL,
	VARIANT_OP_GREATER,
	VARIANT_OP_GREATER_EQUAL,

	/* mathematic */
	VARIANT_OP_ADD,
	VARIANT_OP_SUBTRACT,
	VARIANT_OP_MULTIPLY,
	VARIANT_OP_DIVIDE,
	VARIANT_OP_NEGATE,
	VARIANT_OP_POSITIVE,
	VARIANT_OP_MODULE,
	VARIANT_OP_POWER,

	/* bitwise */
	VARIANT_OP_SHIFT_LEFT,
	VARIANT_OP_SHIFT_RIGHT,
	VARIANT_OP_BIT_AND,
	VARIANT_OP_BIT_OR,
	VARIANT_OP_BIT_XOR,
	VARIANT_OP_BIT_NEGATE,

	/* logic */
	VARIANT_OP_AND,
	VARIANT_OP_OR,
	VARIANT_OP_XOR,
	VARIANT_OP_NOT,

	/* containment */
	VARIANT_OP_IN,
	VARIANT_OP_MAX

}


//use as markers to know what type to expect.
//Note from Godot
// In this API there are multiple functions which expect the caller to pass a pointer
// on return value as parameter.
// In order to make it clear if the caller should initialize the return value or not
// we have two flavor of types:
// - `XXXPtr` for pointer on an initialized value
// - `UninitializedXXXPtr` for pointer on uninitialized value
//
// Notes:
// - Not respecting those requirements can seems harmless, but will lead to unexpected
//   segfault or memory leak (for instance with a specific compiler/OS, or when two
//   native extensions start doing ptrcall on each other).
// - Initialization must be done with the function pointer returned by `variant_get_ptr_constructor`,
//   zero-initializing the variable should not be considered a valid initialization method here !
// - Some types have no destructor (see `extension_api.json`'s `has_destructor` field), for
//   them it is always safe to skip the constructor for the return value if you are in a hurry ;-)


VariantPtr 							:: rawptr       
ConstVariantPtr 					:: rawptr 
ConstVariantPtrargs 				:: [^]rawptr 
UninitializedVariantPtr 			:: rawptr       
StringNamePtr 						:: rawptr       
ConstStringNamePtr 					:: rawptr 
UninitializedStringNamePtr          :: rawptr       
StringPtr 							:: rawptr
ConstStringPtr 						:: rawptr
UninitializedStringPtr 				:: rawptr
ObjectPtr 							:: rawptr
ConstObjectPtr 						:: rawptr
UninitializedObjectPtr 				:: rawptr
TypePtr 							:: rawptr
ConstTypePtr 						:: rawptr 
UninitializedTypePtr 				:: rawptr
MethodBindPtr 						:: rawptr
GDObjectInstanceID 					:: u64  

RefPtr 								:: rawptr
ConstRefPtr 						:: rawptr 
ClassLibraryPtr  					:: rawptr
ConstTypePtrargs					:: [^]rawptr


InitializationLevel :: enum {
	INITIALIZATION_CORE,
	INITIALIZATION_SERVERS,
	INITIALIZATION_SCENE,
	INITIALIZATION_EDITOR,
	MAX_INITIALIZATION_LEVEL,
}

/* VARIANT DATA I/O */

CallErrorType :: enum {
	CALL_OK,
	CALL_ERROR_INVALID_METHOD,
	CALL_ERROR_INVALID_ARGUMENT, // Expected a different variant type.
	CALL_ERROR_TOO_MANY_ARGUMENTS, // Expected lower number of arguments.
	CALL_ERROR_TOO_FEW_ARGUMENTS, // Expected higher number of arguments.
	CALL_ERROR_INSTANCE_IS_NULL,
	CALL_ERROR_METHOD_NOT_CONST, // Used for const call.
}

CallError :: struct {
	error: CallErrorType,
	argument: i32,
	expected: i32,
}

VariantFromTypeConstructorFunc	:: proc(UninitializedVariantPtr, TypePtr);
TypeFromVariantConstructorFunc	:: proc(UninitializedTypePtr, VariantPtr);
VariantGetInternalPtrFunc 		:: proc(VariantPtr) -> rawptr;
PtrOperatorEvaluator 			:: proc(p_left: ConstTypePtr, 		 p_right: ConstTypePtr, 	  r_result: TypePtr);
PtrBuiltInMethod 				:: proc(p_base: TypePtr, 			 p_args: ConstTypePtrargs, r_return:  TypePtr, p_argument_count: i64);
PtrConstructor 					:: proc(p_base: UninitializedTypePtr, p_args: ConstTypePtrargs);
PtrDestructor 					:: proc(p_base: TypePtr);
PtrSetter 						:: proc(p_base: TypePtr, 	 p_value: ConstTypePtr);
PtrGetter 						:: proc(p_base: ConstTypePtr, r_value:  TypePtr);
PtrIndexedSetter 				:: proc(p_base: TypePtr, 	 p_index: Int, 		  p_value: ConstTypePtr);
PtrIndexedGetter 				:: proc(p_base: ConstTypePtr, p_index:  Int, 		  r_value: TypePtr);
PtrKeyedSetter 					:: proc(p_base: TypePtr, 	 p_key: ConstTypePtr,  p_value: ConstTypePtr);
PtrKeyedGetter 					:: proc(p_base: ConstTypePtr, p_key:  ConstTypePtr, r_value: TypePtr);
PtrKeyedChecker 				:: proc(p_base: ConstVariantPtr, p_key:  ConstVariantPtr) -> u32;
PtrUtilityFunction 				:: proc(r_return: TypePtr,    p_args: ConstTypePtrargs, p_argument_count: i64);


ClassCreationInfo2 :: struct {
	is_virtual: Bool,
	is_abstract: Bool,
	is_exposed: Bool,
	set_func: ClassSet,
	get_func: ClassGet,
	get_property_list_func: ClassGetPropertyList,
	free_property_list_func: ClassFreePropertyList,
	property_can_revert_func: ClassPropertyCanRevert,
	property_get_revert_func: ClassPropertyGetRevert,
	validate_property_func: ClassValidateProperty,
	notification_func: ClassNotification2,
	to_string_func: ClassToString,
	reference_func: ClassReference,
	unreference_func: ClassUnreference,
	create_instance_func: ClassCreateInstance, // (Default) constructor; mandatory. If the class is not instantiable, consider making it virtual or abstract,
	free_instance_func: ClassFreeInstance, // Destructor; mandatory,
	recreate_instance_func: ClassRecreateInstance,
	// Queries a virtual function by name and returns a callback to invoke the requested virtual function.
	 get_virtual_func: ClassGetVirtual,
	// Paired with `call_virtual_with_data_func`, this is an alternative to `get_virtual_func` for extensions that
	// need or benefit from extra data when calling virtual functions.
	// Returns user data that will be passed to `call_virtual_with_data_func`.
	// Returning `NULL` from this function signals to Godot that the virtual function is not overridden.
	// Data returned from this function should be managed by the extension and must be valid until the extension is deinitialized.
	// You should supply either `get_virtual_func`, or `get_virtual_call_data_func` with `call_virtual_with_data_func`.
	 get_virtual_call_data_func: ClassGetVirtualCallData,
	// Used to call virtual functions when `get_virtual_call_data_func` is not null.
	 call_virtual_with_data_func: ClassCallVirtualWithData,
	get_rid_func: ClassGetRID,
	class_userdata: rawptr, // Per-class user data, later accessible in instance bindings.
} ; // Deprecated. Use ClassCreationInfo4 instead.

ClassCreationInfo4 :: struct {
	is_virtual:            Bool, //For inheritance where instantiation is not allowed. ??
	is_abstract:           Bool, //Can't instantiate directly. ??
	is_exposed:            Bool, //Will be visible in the editor true/false
	is_runtime:            Bool, //Class isn't created compiled but created at runtime.
	icon_path:             ConstStringPtr, //For some reason does not work with stringnewutf8?? What does the string builder do o.O
	set_func:             ClassSet, //Fallback function that Godot will call if it can't find the getter/setter for a registered property.
	get_func:             ClassGet, //Fallback function that Godot will call if it can't find the getter/setter for a registered property.
	get_property_list_func:ClassGetPropertyList, //Provide a list of properties to Godot so that it can know what values exist. Mostly useful for runtime info.
	free_property_list_func: ClassFreePropertyList2, //Provide the list for Godot to call into to free memory.
	property_can_revert_func: ClassPropertyCanRevert, //Create a list based on StringNames to specify if a value can be reverted in the editor.
	property_get_revert_func: ClassPropertyGetRevert, //A function to return the default value of a property when reverted.
	validate_property_func:	ClassValidateProperty, //Validates property edits?
	notification_func:     ClassNotification2, //Called when the object receives a NOTIFICATION_*. Like _notification in GDScript.
	to_string_func:        ClassToString, //Custom function to create strings. For debugging/printing/etc.
	reference_func:        ClassReference, //If the class can/should be ref counted, provide a funtion for Godot to call and increment the ref
	unreference_func:      ClassUnreference, //decrement the ref count and deallocate when necessary.
	create_instance_func:  ClassCreateInstance2, // (Default) constructor; mandatory. If the class is not instantiable, consider making it virtual or abstract.
	free_instance_func:    ClassFreeInstance, // Destructor; mandatory.
	recreate_instance_func:ClassRecreateInstance,
	// Queries a virtual function by name and returns a callback to invoke the requested virtual function.
	get_virtual_func:      ClassGetVirtual2,
	// Paired with `call_virtual_with_data_func`, this is an alternative to `get_virtual_func` for extensions that
	// need or benefit from extra data when calling virtual functions.
	// Returns user data that will be passed to `call_virtual_with_data_func`.
	// Returning `NULL` from this function signals to Godot that the virtual function is not overridden.
	// Data returned from this function should be managed by the extension and must be valid until the extension is deinitialized.
	// You should supply either `get_virtual_func`, or `get_virtual_call_data_func` with `call_virtual_with_data_func`.
	get_virtual_call_data_func:ClassGetVirtualCallData2,
	// Used to call virtual functions when `get_virtual_call_data_func` is not null.
	call_virtual_with_data_func:ClassCallVirtualWithData,
	class_userdata: rawptr, // Per-class user data, later accessible in instance bindings. //A pointer to whatever you want to pass to the functions. Godot doesn't interact directly but will add it to a bunch of functions it calls.
} 


InstanceBindingCallbacks :: struct {
	create_callback: 	 InstanceBindingCreateCallback,
	free_callback: 		 InstanceBindingFreeCallback,
	 reference_callback: InstanceBindingReferenceCallback,
}

InstanceBindingCreateCallback 	:: proc(p_token: rawptr, p_instance: rawptr) -> rawptr;
InstanceBindingFreeCallback 		:: proc(p_token: rawptr, p_instance: rawptr, p_binding: rawptr);
InstanceBindingReferenceCallback :: proc(p_token: rawptr, p_binding: rawptr, p_reference: Bool) -> Bool;


/* EXTENSION CLASSES */

ClassInstancePtr :: rawptr;

ClassSet 					:: proc "c" ( p_instance: ClassInstancePtr,  p_name: ConstStringNamePtr,  p_value: ConstVariantPtr) -> Bool
ClassGet 					:: proc "c" ( p_instance: ClassInstancePtr,  p_name: ConstStringNamePtr,  r_ret: VariantPtr) -> Bool
ClassGetRID  				:: proc "c" ( p_instance: ClassInstancePtr) -> u64

ClassGetPropertyList 		:: proc "c" ( p_instance: ClassInstancePtr, r_count: ^u32) -> [^]PropertyInfo;
ClassFreePropertyList 		:: proc "c" ( p_instance: ClassInstancePtr,  p_list: ^PropertyInfo);
ClassFreePropertyList2 		:: proc "c" ( p_instance: ClassInstancePtr, p_list: ^PropertyInfo , p_count: u32);
ClassPropertyCanRevert 		:: proc "c" (p_instance: ClassInstancePtr,  p_name: ConstStringNamePtr) -> Bool
ClassPropertyGetRevert 		:: proc "c" (p_instance: ClassInstancePtr,  p_name: ConstStringNamePtr,  r_ret: VariantPtr) -> Bool
ClassValidateProperty 		:: proc "c" (p_instance: ClassInstancePtr,  p_property: ^PropertyInfo) -> Bool
ClassNotification 			:: proc "c" ( p_instance:ClassInstancePtr,  p_what: i32); // Deprecated. Use ClassNotification2 instead.
ClassNotification2 			:: proc "c" ( p_instance:ClassInstancePtr, p_what: i32,  p_reversed: Bool);
ClassToString 				:: proc "c" ( p_instance:ClassInstancePtr, r_is_valid: Bool, p_out: StringPtr);
ClassReference 				:: proc "c" ( p_instance:ClassInstancePtr);
ClassUnreference 			:: proc "c" ( p_instance:ClassInstancePtr);
ClassCallVirtual 			:: proc "c" ( p_instance:ClassInstancePtr, p_args: ConstTypePtr ,  r_ret: TypePtr);
ClassCreateInstance 		:: proc "c" ( p_class_userdata: rawptr) -> ObjectPtr;
ClassCreateInstance2 		:: proc "c" (p_class_userdata: rawptr, p_notify_postinitialize: Bool) -> ObjectPtr;
ClassFreeInstance 			:: proc "c" (p_class_userdata: rawptr, p_instance: ClassInstancePtr);
ClassRecreateInstance 		:: proc "c" (p_class_userdata: rawptr, p_object: ObjectPtr) -> ClassInstancePtr;
ClassGetVirtual 			:: proc "c" (p_class_userdata: rawptr, p_name: ConstStringNamePtr) -> ClassCallVirtual;
ClassGetVirtual2 			:: proc "c" (p_class_userdata: rawptr, p_name: ConstStringNamePtr, p_hash: u32) -> ClassCallVirtual;
ClassGetVirtualCallData 	:: proc "c" (p_class_userdata: rawptr,  p_name: ConstStringNamePtr) -> rawptr;
ClassGetVirtualCallData2 	:: proc "c" (p_class_userdata: rawptr,  p_name: ConstStringNamePtr, p_hash: u32) -> rawptr;
ClassCallVirtualWithData  	:: proc "c" ( p_instance: ClassInstancePtr,  p_name: ConstStringNamePtr, p_virtual_call_userdata: rawptr,  p_args: ConstTypePtrargs, r_ret: TypePtr);



PropertyInfo  :: struct {
	type:       VariantType,
	name:       StringNamePtr,
	class_name: StringNamePtr,
	hint:       u32, // Bitfield of `PropertyHint` (defined in `extension_api.json`).
	hint_string:StringPtr,
	usage:      u32, // Bitfield of `PropertyUsageFlags` (defined in `extension_api.json`).
}


/* Method */

ClassMethodFlags :: enum {
	NORMAL  = 1,
	EDITOR  = 2,
	CONST   = 4,
	VIRTUAL = 8,
	VARARG  = 16,
	STATIC  = 32,
	DEFAULT = NORMAL,
}

ClassMethodArgumentMetadata :: enum c.int {
	NONE,
	INT_IS_INT8,
	INT_IS_INT16,
	INT_IS_INT32,
	INT_IS_INT64,
	INT_IS_UINT8,
	INT_IS_UINT16,
	INT_IS_UINT32,
	INT_IS_UINT64,
	REAL_IS_FLOAT,
	REAL_IS_DOUBLE,
	INT_IS_CHAR16,
	INT_IS_CHAR32,
}

ClassMethodCall			:: proc "c" (method_userdata: rawptr, p_instance: ClassInstancePtr, p_args: ConstVariantPtrargs, p_argument_count: Int, r_return: VariantPtr, r_error: ^CallError);
ClassMethodValidatedCall :: proc "c" (method_userdata: rawptr, p_instance: ClassInstancePtr, p_args: ConstVariantPtrargs, r_return: VariantPtr);
ClassMethodPtrCall		:: proc "c" (method_userdata: rawptr, p_instance: ClassInstancePtr, p_args: ConstTypePtrargs, r_ret: TypePtr);


ClassMethodInfo :: struct {
	name: StringNamePtr,
	method_userdata: rawptr,
	call_func: ClassMethodCall,
	ptrcall_func: ClassMethodPtrCall,
	method_flags: u32, // Bitfield of `ClassMethodFlags`.

	/* If `has_return_value` is false, `return_value_info` and `return_value_metadata` are ignored.
	 *
	 * @todo Consider dropping `has_return_value` and making the other two properties match `MethodInfo` and `ClassVirtualMethod` for consistency in future version of this struct.
	 */
	has_return_value: Bool,
	return_value_info: ^PropertyInfo,
	return_value_metadata: ClassMethodArgumentMetadata,

	/* Arguments: `arguments_info` and `arguments_metadata` are array of size `argument_count`.
	 * Name and hint information for the argument can be omitted in release builds. Class name should always be present if it applies.
	 *
	 * @todo Consider renaming `arguments_info` to `arguments` for consistency in future version of this struct.
	 */
	argument_count: u32,
	arguments_info: [^]PropertyInfo,
	arguments_metadata: ^ClassMethodArgumentMetadata,

	/* Default arguments: `default_arguments` is an array of size `default_argument_count`. */
	default_argument_count: u32,
	default_arguments: ^VariantPtr,
}
/*
typedef struct {
	StringNamePtr name;
	uint32_t method_flags; // Bitfield of `ClassMethodFlags`.

	PropertyInfo return_value;
	ClassMethodArgumentMetadata return_value_metadata;

	uint32_t argument_count;
	PropertyInfo *arguments;
	ClassMethodArgumentMetadata *arguments_metadata;
} ClassVirtualMethodInfo;*/


Initialization :: struct {
	    /* Minimum initialization level required.
	     * If Core or Servers, the extension needs editor or game restart to take effect */
	minimum_initialization_level: InitializationLevel,
	    /* Up to the user to supply when initializing */
	userdata: rawptr,
	    /* This function will be called multiple times for each initialization level. */
	initialize:   proc "c" (userdata: rawptr, p_level: InitializationLevel),
	deinitialize: proc "c" (userdata: rawptr, p_level: InitializationLevel),
}

InterfaceGetProcAddress :: #type proc "c" (function_name: cstring) -> rawptr

/**
 * @name string_name_new_with_latin1_chars
 * @since 4.2
 *
 * Creates a StringName from a Latin-1 encoded C string.
 *
 * If `p_is_static` is true, then:
 * - The StringName will reuse the `p_contents` buffer instead of copying it.
 *   You must guarantee that the buffer remains valid for the duration of the application (e.g. string literal).
 * - You must not call a destructor for this StringName. Incrementing the initial reference once should achieve this.
 *
 * `p_is_static` is purely an optimization and can easily introduce undefined behavior if used wrong. In case of doubt, set it to false.
 *
 * @param r_dest A pointer to uninitialized storage, into which the newly created StringName is constructed.
 * @param p_contents A pointer to a C string (null terminated and Latin-1 or ASCII encoded).
 * @param p_is_static Whether the StringName reuses the buffer directly (see above).
 */
InterfaceStringNameNewWithLatin1Chars :: proc "c" (r_dest: UninitializedStringNamePtr, p_contents: cstring, p_is_static: Bool)

/**
 * @name string_name_new_with_utf8_chars
 * @since 4.2
 *
 * Creates a StringName from a UTF-8 encoded C string.
 *
 * @param r_dest A pointer to uninitialized storage, into which the newly created StringName is constructed.
 * @param p_contents A pointer to a C string (null terminated and UTF-8 encoded).
 */
InterfaceStringNameNewWithUtf8Chars :: proc "c" (r_dest: UninitializedStringNamePtr, p_contents: cstring);

/**
 * @name classdb_construct_object
 * @since 4.1
 * @deprecated in Godot 4.4. Use `classdb_construct_object2` instead.
 *
 * Constructs an Object of the requested class.
 *
 * The passed class must be a built-in godot class, or an already-registered extension class. In both cases, object_set_instance() should be called to fully initialize the object.
 *
 * @param p_classname A pointer to a StringName with the class name.
 *
 * @return A pointer to the newly created Object.
 */
InterfaceClassdbConstructObject :: proc(p_classname: ConstStringNamePtr) -> ObjectPtr


/**
 * @name variant_get_ptr_destructor
 * @since 4.1
 *
 * Gets a pointer to a function than can call the destructor for a type of Variant.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function than can call the destructor for a type of Variant.
 */
InterfaceVariantGetPtrDestructor :: proc "c" (p_type: VariantType) -> PtrDestructor;


InterfaceClassdbRegisterExtensionClass2 :: proc "c" ( p_library: ClassLibraryPtr,  p_class_name: ConstStringNamePtr,  p_parent_class_name: ConstStringNamePtr, p_extension_funcs: ^ClassCreationInfo2)
InterfaceClassdbRegisterExtensionClass4 :: proc "c" ( p_library: ClassLibraryPtr,  p_class_name: ConstStringNamePtr,  p_parent_class_name: ConstStringNamePtr, p_extension_funcs: ^ClassCreationInfo4);


/**
 * @name classdb_register_extension_class_method
 * @since 4.1
 *
 * Registers a method on an extension class in the ClassDB.
 *
 * Provided struct can be safely freed once the function returns.
 *
 * @param p_library A pointer the library received by the 's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 * @param p_method_info A pointer to a ClassMethodInfo struct.
 */
InterfaceClassdbRegisterExtensionClassMethod :: proc(p_library: ClassLibraryPtr, p_class_name: ConstStringNamePtr, p_method_info: ^ClassMethodInfo);


/**
 * @name classdb_register_extension_class_property
 * @since 4.1
 *
 * Registers a property on an extension class in the ClassDB.
 *
 * Provided struct can be safely freed once the function returns.
 *
 * @param p_library A pointer the library received by the 's entry point function.
 * @param p_class_name A pointer to a StringName with the class name.
 * @param p_info A pointer to a PropertyInfo struct.
 * @param p_setter A pointer to a StringName with the name of the setter method.
 * @param p_getter A pointer to a StringName with the name of the getter method.
 */
InterfaceClassdbRegisterExtensionClassProperty :: proc(p_library: ClassLibraryPtr, p_class_name: ConstStringNamePtr,
				p_info: ^PropertyInfo, p_setter: ConstStringNamePtr, p_getter: ConstStringNamePtr);

/**
 * @name classdb_construct_object2
 * @since 4.4
 *
 * Constructs an Object of the requested class.
 *
 * The passed class must be a built-in godot class, or an already-registered extension class. In both cases, object_set_instance() should be called to fully initialize the object.
 *
 * "NOTIFICATION_POSTINITIALIZE" must be sent after construction.
 *
 * @param p_classname A pointer to a StringName with the class name.
 *
 * @return A pointer to the newly created Object.
 */
InterfaceClassdbConstructObject2 :: proc(p_classname: ConstStringNamePtr) -> ObjectPtr


/**
 * @name object_set_instance
 * @since 4.1
 *
 * Sets an extension class instance on a Object.
 *
 * @param p_o A pointer to the Object.
 * @param p_classname A pointer to a StringName with the registered extension class's name.
 * @param p_instance A pointer to the extension class instance.
 */
InterfaceObjectSetInstance :: proc( p_o: ObjectPtr, p_classname: ConstStringNamePtr, p_instance: ClassInstancePtr); /* p_classname should be a registered extension class and should extend the p_o object's class. */


/**
 * @name object_set_instance_binding
 * @since 4.1
 *
 * Sets an Object's instance binding.
 *
 * @param p_o A pointer to the Object.
 * @param p_library A token the library received by the 's entry point function.
 * @param p_binding A pointer to the instance binding.
 * @param p_callbacks A pointer to a InstanceBindingCallbacks struct.
 */
InterfaceObjectSetInstanceBinding :: proc(p_o: ObjectPtr, p_token: rawptr, p_binding: rawptr, p_callbacks: InstanceBindingCallbacks);


/* INTERFACE: Memory */

//definitions are here : https://github.com/godotengine/godot/blob/6c9765d87e142e786f0190783f41a0250a835c99/core/os/memory.h#L58
//Seems like they do a lot to have half decent types such as arrays etc.
//Basically wrote their own memory allocator to be more optimized.
//Just use Odin's new and delete/free. At least for the example this has been sufficient. When Godot needs to allocate for itself it will do so through constructors. (search for *new*)

//TODO: adapt to Odin memory management. Arena, custom allocator etc.
/**
 * @name mem_alloc
 * @since 4.1
 *
 * Allocates memory.
 *
 * @param p_bytes The amount of memory to allocate in bytes.
 *
 * @return A pointer to the allocated memory, or NULL if unsuccessful.
 */
InterfaceMemAlloc :: proc(p_bytes: uint) -> rawptr;

/**
 * @name mem_realloc
 * @since 4.1
 *
 * Reallocates memory.
 *
 * @param p_ptr A pointer to the previously allocated memory.
 * @param p_bytes The number of bytes to resize the memory block to.
 *
 * @return A pointer to the allocated memory, or NULL if unsuccessful.
 */
InterfaceMemRealloc :: proc(p_ptr: rawptr, p_bytes: uint) -> rawptr;

/**
 * @name mem_free
 * @since 4.1
 *
 * Frees memory.
 *
 * @param p_ptr A pointer to the previously allocated memory.
 */
InterfaceMemFree :: proc(p_ptr: rawptr);

InterfaceGlobalGetSingleton :: proc "c" (p_name: ConstStringNamePtr) -> ObjectPtr


//****************\\
//String Functions\\
//****************\\

//Use these functions to create C++ strings for Godot
//For cstrings other than Latin or UTF-8 convert your string to the correct encoding before making the cstring?

/**
 * @name variant_new_nil
 * @since 4.1
 *
 * Creates a new Variant containing nil.
 *
 * @param r_dest A pointer to the destination Variant.
 */
InterfaceVariantNewNil :: proc "c" (r_dest:UninitializedVariantPtr);

/* INTERFACE: String Utilities */

/**
 * @name string_new_with_latin1_chars
 * @since 4.1
 *
 * Creates a String from a Latin-1 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A cstring, a Latin-1 encoded C string (null terminated).
 * https://lemire.me/blog/2023/02/16/computing-the-utf-8-size-of-a-latin-1-string-quickly-avx-edition/
 * blog post discusses the latin1 encoding. Not certain why latin1 is preferred for a lot of Godot bindings.
 */
InterfaceStringNewWithLatin1Chars :: proc "c" (r_dest: UninitializedStringPtr, p_contents: cstring)



/**
 * @name string_new_with_utf8_chars
 * @since 4.1
 *
 * Creates a String from a UTF-8 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-8 encoded C string (null terminated).
 */
InterfaceStringNewWithUtf8Chars :: proc(r_dest: UninitializedStringPtr, p_contents: cstring);


/**
 * @name string_new_with_utf16_chars
 * @since 4.1
 *
 * Creates a String from a UTF-16 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-16 encoded C string (null terminated).
 */
InterfaceStringNewWithUtf16Chars :: proc(r_dest: UninitializedStringPtr, p_contents: cstring);

/**
 * @name string_new_with_utf32_chars
 * @since 4.1
 *
 * Creates a String from a UTF-32 encoded C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-32 encoded C string (null terminated).
 */
InterfaceStringNewWithUtf32Chars :: proc(r_dest: UninitializedStringPtr, p_contents: cstring);

/**
 * @name string_new_with_wide_chars
 * @since 4.1
 *
 * Creates a String from a wide C string.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a wide C string (null terminated).
 */
InterfaceStringNewWithWideChars :: proc(r_dest: UninitializedStringPtr, p_contents: cstring);

/**
 * @name string_new_with_latin1_chars_and_len
 * @since 4.1
 *
 * Creates a String from a Latin-1 encoded C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a Latin-1 encoded C string.
 * @param p_size The number of characters (= number of bytes).
 */
InterfaceStringNewWithLatin1CharsAndLen :: proc(r_dest: UninitializedStringPtr, p_contents: cstring, p_size: Int);

/**
 * @name string_new_with_utf8_chars_and_len
 * @since 4.1
 * @deprecated in Godot 4.3. Use `string_new_with_utf8_chars_and_len2` instead.
 *
 * Creates a String from a UTF-8 encoded C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-8 encoded C string.
 * @param p_size The number of bytes (not code units).
 */
InterfaceStringNewWithUtf8CharsAndLen :: proc(r_dest: UninitializedStringPtr, p_contents: cstring, p_size: Int);

/**
 * @name string_new_with_utf8_chars_and_len2
 * @since 4.3
 *
 * Creates a String from a UTF-8 encoded C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-8 encoded C string.
 * @param p_size The number of bytes (not code units).
 *
 * @return Error code signifying if the operation successful.
 */
InterfaceStringNewWithUtf8CharsAndLen2 :: proc(r_dest: UninitializedStringPtr, p_contents: cstring, p_size: Int) -> Int;

/**
 * @name string_new_with_utf16_chars_and_len
 * @since 4.1
 * @deprecated in Godot 4.3. Use `string_new_with_utf16_chars_and_len2` instead.
 *
 * Creates a String from a UTF-16 encoded C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-16 encoded C string.
 * @param p_size The number of characters (not bytes).
 */
InterfaceStringNewWithUtf16CharsAndLen :: proc(r_dest: UninitializedStringPtr, p_contents: cstring, p_char_count: Int);

/**
 * @name string_new_with_utf16_chars_and_len2
 * @since 4.3
 *
 * Creates a String from a UTF-16 encoded C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-16 encoded C string.
 * @param p_size The number of characters (not bytes).
 * @param p_default_little_endian If true, UTF-16 use little endian.
 *
 * @return Error code signifying if the operation successful.
 */
InterfaceStringNewWithUtf16CharsAndLen2 :: proc( r_dest: UninitializedStringPtr, p_contents: cstring, p_char_count: Int, p_default_little_endian: Bool) -> Int;

/**
 * @name string_new_with_utf32_chars_and_len
 * @since 4.1
 *
 * Creates a String from a UTF-32 encoded C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a UTF-32 encoded C string.
 * @param p_size The number of characters (not bytes).
 */
InterfaceStringNewWithUtf32CharsAndLen :: proc(r_dest: UninitializedStringPtr, p_contents: cstring, p_char_count: Int);

/**
 * @name string_new_with_wide_chars_and_len
 * @since 4.1
 *
 * Creates a String from a wide C string with the given length.
 *
 * @param r_dest A pointer to a Variant to hold the newly created String.
 * @param p_contents A pointer to a wide C string.
 * @param p_size The number of characters (not bytes).
 */
InterfaceStringNewWithWideCharsAndLen :: proc(r_dest: UninitializedStringPtr, p_contents: cstring, p_char_count: int);


/**
 * @name get_variant_from_type_constructor
 * @since 4.1
 *
 * Gets a pointer to a function that can create a Variant of the given type from a raw value.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function that can create a Variant of the given type from a raw value.
 */
InterfaceGetVariantFromTypeConstructor :: proc(p_type: VariantType) -> VariantFromTypeConstructorFunc;




/**
 * @name print_warning_with_message
 * @since 4.1
 *
 * Logs a warning with a message to Godot's built-in debugger and to the OS terminal.
 *
 * @param p_description The code triggering the warning.
 * @param p_message The message to show along with the warning.
 * @param p_function The function name where the warning occurred.
 * @param p_file The file where the warning occurred.
 * @param p_line The line where the warning occurred.
 * @param p_editor_notify Whether or not to notify the editor.
 */
InterfacePrintWarningWithMessage :: proc "c" (p_description,p_message,p_function,p_file: cstring, p_line: i32, p_editor_notify: Bool);



/**
 * @name get_variant_to_type_constructor
 * @since 4.1
 *
 * Gets a pointer to a function that can get the raw value from a Variant of the given type.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function that can get the raw value from a Variant of the given type.
 */
InterfaceGetVariantToTypeConstructor :: proc(p_type: VariantType) -> TypeFromVariantConstructorFunc;


/**
 * @name variant_get_type
 * @since 4.1
 *
 * Gets the type of a Variant.
 *
 * @param p_self A pointer to the Variant.
 *
 * @return The variant type.
 */
InterfaceVariantGetType :: proc(p_self: ConstVariantPtr) -> VariantType;


/**
 * @name variant_get_ptr_operator_evaluator
 * @since 4.1
 *
 * Gets a pointer to a function that can evaluate the given Variant operator on the given Variant types.
 *
 * @param p_operator The variant operator.
 * @param p_type_a The type of the first Variant.
 * @param p_type_b The type of the second Variant.
 *
 * @return A pointer to a function that can evaluate the given Variant operator on the given Variant types.
 */
 InterfaceVariantGetPtrOperatorEvaluator :: proc(p_operator: VariantOperator, p_type_a: VariantType, p_type_b: VariantType) -> PtrOperatorEvaluator;


 
/**
 * @name classdb_get_method_bind
 * @since 4.1
 *
 * Gets a pointer to the MethodBind in ClassDB for the given class, method and hash.
 *
 * @param p_classname A pointer to a StringName with the class name.
 * @param p_methodname A pointer to a StringName with the method name.
 * @param p_hash A hash representing the function signature.
 *
 * @return A pointer to the MethodBind from ClassDB.
 */
 InterfaceClassdbGetMethodBind :: proc "c" (p_classname: ConstStringNamePtr, p_methodname: ConstStringNamePtr, p_hash: Int) -> MethodBindPtr

 
/**
 * @name object_method_bind_ptrcall
 * @since 4.1
 *
 * Calls a method on an Object (using a "ptrcall").
 *
 * @param p_method_bind A pointer to the MethodBind representing the method on the Object's class.
 * @param p_instance A pointer to the Object.
 * @param p_args A pointer to a C array representing the arguments.
 * @param r_ret A pointer to the Object that will receive the return value.
 */
InterfaceObjectMethodBindPtrcall :: proc "c" (p_method_bind: MethodBindPtr, p_instance: ObjectPtr, p_args: ConstTypePtrargs, r_ret: TypePtr);


/**
* @name variant_get_ptr_constructor
* @since 4.1
*
* Gets a pointer to a function that can call one of the constructors for a type of Variant.
*
* @param p_type The Variant type.
* @param p_constructor The index of the constructor.
*
* @return A pointer to a function that can call one of the constructors for a type of Variant.
*/
InterfaceVariantGetPtrConstructor :: proc "c" (p_type: VariantType, p_constructor: i32) -> PtrConstructor


/**
* @name classdb_register_extension_class_signal
* @since 4.1
*
* Registers a signal on an extension class in the ClassDB.
*
* Provided structs can be safely freed once the function returns.
*
* @param p_library A pointer the library received by the 's entry point function.
* @param p_class_name A pointer to a StringName with the class name.
* @param p_signal_name A pointer to a StringName with the signal name.
* @param p_argument_info A pointer to a PropertyInfo struct.
* @param p_argument_count The number of arguments the signal receives.
*/
InterfaceClassdbRegisterExtensionClassSignal :: proc "c" (p_library: ClassLibraryPtr, p_class_name: ConstStringNamePtr, p_signal_name: ConstStringNamePtr, p_argument_info: ^PropertyInfo,  p_argument_count: Int);

/**
 * @name variant_destroy
 * @since 4.1
 *
 * Destroys a Variant.
 *
 * @param p_self A pointer to the Variant to destroy.
 */
InterfaceVariantDestroy :: proc "c" (p_self: VariantPtr);

/**
 * @name object_method_bind_call
 * @since 4.1
 *
 * Calls a method on an Object.
 *
 * @param p_method_bind A pointer to the MethodBind representing the method on the Object's class.
 * @param p_instance A pointer to the Object.
 * @param p_args A pointer to a C array of Variants representing the arguments.
 * @param p_arg_count The number of arguments.
 * @param r_ret A pointer to Variant which will receive the return value.
 * @param r_error A pointer to a CallError struct that will receive error information.
 */
InterfaceObjectMethodBindCall :: proc "c" (p_method_bind: MethodBindPtr, p_instance: ObjectPtr, p_args: ConstVariantPtrargs, p_arg_count: Int, r_ret: UninitializedVariantPtr, r_error: ^CallError);


/**
 * @name variant_get_ptr_builtin_method
 * @since 4.1
 *
 * Gets a pointer to a function that can call a builtin method on a type of Variant.
 *
 * @param p_type The Variant type.
 * @param p_method A pointer to a StringName with the method name.
 * @param p_hash A hash representing the method signature.
 *
 * @return A pointer to a function that can call a builtin method on a type of Variant.
 */
 InterfaceVariantGetPtrBuiltinMethod :: proc(p_type: VariantType, p_method: ConstStringNamePtr, p_hash: Int) -> PtrBuiltInMethod;

/**
 * @name variant_get_ptr_indexed_getter
 * @since 4.1
 *
 * Gets a pointer to a function that can get an index on the given Variant type.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function that can get an index on the given Variant type.
 */
GDExtensionInterfaceVariantGetPtrIndexedGetter :: proc(p_type: VariantType) -> PtrIndexedGetter;

/**
 * @name variant_get_ptr_indexed_setter
 * @since 4.1
 *
 * Gets a pointer to a function that can set an index on the given Variant type.
 *
 * @param p_type The Variant type.
 *
 * @return A pointer to a function that can set an index on the given Variant type.
 */
 GDExtensionInterfaceVariantGetPtrIndexedSetter :: proc(p_type: VariantType) -> PtrIndexedSetter;
