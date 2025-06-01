package main

import "core:fmt"
import sics "base:intrinsics"
import GDW "GDWrapper"
import GDE "GDWrapper/gdextension"
import "base:runtime"
import str "core:strings"
import s "core:slice"

@export
godot_entry_init :: proc "c" (p_get_proc_address : GDE.InterfaceGetProcAddress, p_library: GDE.ClassLibraryPtr, r_initialization: ^GDE.Initialization) {
    context = runtime.default_context()
    
    GDW.Library = p_library
    GDW.loadAPI(p_get_proc_address)

    r_initialization.initialize     = initialize_gdexample_module
    r_initialization.deinitialize   = deinitialize_gdexample_module

}


//*************************\\
//*****Class Variables*****\\
//*************************\\

//Struct to hold node data.
//This struct should hold the class variables. (following the C guide)
GDExample :: struct{
    //REQUIRED
    object: GDE.ObjectPtr,
    amplitude: f64,
}

//****************************\\
//******Functions/Methods*****\\
//****************************\\

//TODO: make these functions automatically.
ClassSetAmplitude :: proc "c" (self: ^GDExample, amplitude: f64) {
    self.amplitude = amplitude
}

ClassGetAmplitude :: proc "c" (self: ^GDExample) -> f64 {
    return self.amplitude
}

//required fields. 
//classname
//parentname
//creationinfo4 - I feel like this should be defined by the user. Not going to be able to assume much.
//Create instance and Free instance should be written by the user. Can't assume how they want to handle the memory.
//Can we create an allocator dynamically? Allow for us to free all at once when the instanc needs to be culled.
//TODO: figure out if you can create multiple classes from a single init module.
initialize_gdexample_module :: proc "c" (p_userdata: rawptr, p_level:  GDE.InitializationLevel){

    if p_level != .INITIALIZATION_SCENE{
        return
    }
    
    context = runtime.default_context()

    fmt.println("AAAAAAAAAaaaaaaahhhh")

    
    // Get ClassDB methods here because the classes we need are all properly registered now.
    // See extension_api.json for hashes.
    native_class_name: GDE.StringName;
    method_name: GDE.StringName;

    types := [3]typeid{int, f64, GDE.Vector2}

    fmt.println(s.linear_search(types[:], typeid_of(GDE.Vector2)))

    fmt.println(types)

    //GDW.methods.objectEmitSignal = GDW.classDBGetMethodBind("Object", "emit_signal", 4047867050)
    //GDW.methods.node2dGetPos = GDW.classDBGetMethodBind("Node2D", "get_position", 3341600327)
    //GDW.methods.node2dSetPosition = GDW.classDBGetMethodBind("Node2D", "set_position", 743155724)
    variant: GDE.Variant
    value: f64 = 32
    GDW.variantfrom.FloatToVariant(&variant, &value)
    fmt.printfln("THEVARIANT: %b", variant.data[:])
    fmt.printfln("THEVALUE: %b", transmute([1]u64)value)

    //will know what to do whether passed as a struct or as an array.
    vec2:= [2]f32 {1, 2}
    GDW.variantfrom.Vec2ToVariant(&variant, &vec2)
    fmt.printfln("THEVARIANT: %b", variant.data[:])
    fmt.printfln("THEVALUE: %b", vec2[:])

    vec22:GDE.Vector2
    vec22 = {1, 2}
    GDW.variantfrom.Vec2ToVariant(&variant, &vec22)
    fmt.printfln("THEVARIANT: %b", variant.data[:])
    fmt.printfln("THEVALUE: %b", vec22[:])
    
    rec2:GDE.Rec2
    rec2 = {1, 2,3,4}
    GDW.variantfrom.rec2ToVariant(&variant, &rec2)
    fmt.printfln("THEVARIANTrec2: %b", variant.data[:])
    fmt.printfln("THEVALUErec2: %b", rec2[:])

    trans2:GDE.Transform2d
    trans2 = {1, 2, 3, 4, 5, 6}
    GDW.variantfrom.Transform2dToVariant(&variant, &trans2)
    fmt.printfln("THEVARIANTtrans2: %b", variant.data[:])
    fmt.printfln("THEVARIANTtrans2: ", (cast(^GDE.Transform2d)(transmute(rawptr)variant.data[1]))^)
    fmt.printfln("THEVALUEtrans2: %b", trans2[:])
    
    //Remember, this allocates on a pointer, so need to destroy it.
    GDW.destructors.variantDestroy(&variant)
    

    class_name: GDE.StringName
    parent_class_name: GDE.StringName
    //Name for my own class.
    //fmt.println("AAAAAAAAAaaaaaaahhhh")
    GDW.stringconstruct.stringNameNewLatin(&class_name, "GDExample", false)
    //fmt.println("AAAAAAAAAaaaaaaahhhh")
    //Name of the class that I'm inheritting from.
    GDW.stringconstruct.stringNameNewLatin(&parent_class_name, "Sprite2D", false)

    stringptr:GDE.gdstring
    //fmt.println("AAAAAAAAAfter methodBind")

    
    GDW.variantfrom.StringNameToVariant(&variant, &parent_class_name)
    fmt.printfln("THEVARIANT: %b", variant.data[:])
    fmt.printfln("THEVALUE: %b", parent_class_name[:])
    //fmt.println(variant.data[1] == parent_class_name[0])

    fmt.println("ENUM MAX: ", i32(GDE.VariantType.VARIANT_MAX))

    GDW.destructors.variantDestroy(&variant)

    
    iconString: GDE.gdstring
    icon:= "res://icon.svg"
    mystring:=str.clone_to_cstring(icon)
    //^^^^^There is a string maker that takes lenght, so might not need to be cloning these.
    
    //Does indeed create a string in some kind of memory.
    GDW.stringconstruct.stringNewLatin(&iconString, mystring)
    //Pointers just need to be packed data of the correct bit length. The type gdstring was declared above.
    //Though maybe Godot expects a struct format for their templates.
    //stringgd: gdstring
    //GDW.stringconstruct.stringNewLatin(&stringgd, "res://icon.svg")
    //But odin takes care of sizing based on 32 or 64 bit, so just us rawptr.
    
    //fmt.println("AAAAAAAAAfter string")
    //To get access to the string you need to cast it to another pointer type then dereference.
    //To properly handle this directly we'd need to be able to know the underlying memory setup of a C++ string.
    //fmt.println((cast(^i8)stringraw)^)

    //Will need to get more info about how these settings affect classes. Ex runtime?
    class_info: GDE.ClassCreationInfo4 = {
        is_virtual = false,
        is_abstract = false,
        is_exposed = true,
        is_runtime = false,
        icon_path = &iconString, //For some reason does not work with UTF8 strings??
        set_func = nil,
        get_func = nil,
        get_property_list_func = nil,
        free_property_list_func = nil,
        property_can_revert_func = nil,
        property_get_revert_func = nil,
        validate_property_func = nil,
        notification_func = nil,
        to_string_func = nil,
        reference_func = nil,
        unreference_func = nil,
        create_instance_func = gdexampleClassCreateInstance,
        free_instance_func = gdexampleClassFreeInstance,
        recreate_instance_func = nil,
        get_virtual_func = nil,
        get_virtual_call_data_func = nil,
        call_virtual_with_data_func = nil,
        class_userdata = nil, 
    }
    //fmt.println("AAAAAAAAAaafter struct")


    //Register Class
    GDW.api.classDBRegisterExtClass(GDW.Library, &class_name, &parent_class_name, &class_info)
    //fmt.println("AAAAAAAAAaaaaaaahhhh", &GDW.Library, &class_name, &parent_class_name, &class_info)
    
    gdexample_class_bind_method()
    //fmt.println("binding completed")


    GDW.destructors.stringNameDestructor(&class_name)
    GDW.destructors.stringNameDestructor(&parent_class_name)
    GDW.destructors.stringDestruction(&iconString)

}

deinitialize_gdexample_module :: proc "c" (p_userdata: rawptr, p_level: GDE.InitializationLevel){

}


gdexample_class_bind_method :: proc "c" () {
    context = runtime.default_context()
    //fmt.println("bind methods")

    arrayClass:= new(GDE.StringName)
    GDW.stringconstruct.stringNameNewLatin(&arrayClass, "PackedInt64Array", false)
    arraySize:= new(GDE.StringName)
    GDW.stringconstruct.stringNameNewLatin(&arraySize, "size", false)
    GDW.arrayhelp.packedi32size = GDW.api.builtinMethodBindCall(.PACKED_INT64_ARRAY, &arraySize, 3173160232)

    GDW.stringconstruct.stringNameNewLatin(&arraySize, "resize", false)
    GDW.arrayhelp.packedi32REsize = GDW.api.builtinMethodBindCall(.PACKED_INT64_ARRAY, &arraySize, 848867239)
    
    GDW.stringconstruct.stringNameNewLatin(&arraySize, "append", false)
    GDW.arrayhelp.packedi32Append = GDW.api.builtinMethodBindCall(.PACKED_INT64_ARRAY, &arraySize, 694024632)

    GDW.stringconstruct.stringNameNewLatin(&arraySize, "get", false)
    GDW.arrayhelp.packedi32Get = GDW.api.builtinMethodBindCall(.PACKED_INT64_ARRAY, &arraySize, 4103005248)

    GDW.stringconstruct.stringNameNewLatin(&arraySize, "set", false)
    GDW.arrayhelp.packedi32Set = GDW.api.builtinMethodBindCall(.PACKED_INT64_ARRAY, &arraySize, 3638975848)

    
    //GDW.arrayhelp.packedf32Get(&uninitptr.data[1], raw_data(args[:]), &newValue, 1)
    //fmt.println("value at index: ",newValue)
    //fmt.println("original arrat: ", mypacked)
    //fmt.println("arrat pointer: ", packed.unsafe_data[0])
    //GDW.bindMethod0r("GDExample", "get_amplitude", ClassGetAmplitude, .FLOAT)
    //GDW.bindMethod1("GDExample", "set_amplitude", ClassSetAmplitude, "amplitude", .FLOAT)
}


//Create instance will always run on program launch regardless if it's in the scene or not.
//This will also run when the scene starts. Once for each instance of the Node present in the tree.
gdexampleClassCreateInstance :: proc "c" (p_class_user_data: rawptr, p_notify_postinitialize: GDE.Bool) -> GDE.ObjectPtr {
    context = runtime.default_context()

    //fmt.println("2222222222")
    
    //create native Godot object.
    //Here we create an object that is part of Godot core library.
    class_name : GDE.StringName
    GDW.stringconstruct.stringNameNewLatin(&class_name, "Sprite2D", false)
    object: GDE.ObjectPtr = GDW.api.classDBConstructObj(&class_name)
    GDW.destructors.stringNameDestructor(&class_name)

    //Create extension object.
    //Can replace mem_alloc with new(). Just need to create the struct and pass a pointer.
    //self: ^GDExample = cast(^GDExample)GDW.api.mem_alloc(size_of(GDExample))
    self: ^GDExample = new(GDExample)

    //constructor is called after creation. Sets the defaults.
    //Pretty sure the doc info about defaults uses this.
    class_constructor(self)
    self.object = object

    //Set extension instance in the native Godot object.
    GDW.stringconstruct.stringNameNewLatin(&class_name, "GDExample", false)
    GDW.api.object_set_instance(object, &class_name, self)
    GDW.api.object_set_instance_binding(object, GDW.Library, self, classBindingCallbacks)

    //Heap cleanup.
    GDW.destructors.stringNameDestructor(&class_name)

    //uninitptr: GDE.Variant

    return object
}

//WARNING : Free any heap memory allocated within this context.
//There's also a destructor, so what's the difference?
//Does destructor just clear the variable data and this is supposed to clear the class itself?
//Maybe it's so that destructor can be run when making editor changes like reset?
gdexampleClassFreeInstance :: proc "c" (p_class_userdata: rawptr, p_instance: GDE.ClassInstancePtr) {
    context = runtime.default_context()
    if (p_instance == nil){
        return
    }
    self : ^GDExample = cast(^GDExample)p_instance
    class_destructor(self)
    free(self)
}


//This is where you would set your defaults.
//Seeing as both the create and construct are called when something is made I wonder if this is just redundency or trying to make things more C++ styled despite it not needing to be.
//Odin defaults everything to 0 regardless, so maybe not as horrible if you forget some?
//Using the reset button doesn't even call this thing.
class_constructor :: proc "c" (self: ^GDExample) {
    context = runtime.default_context()
    //fmt.println("class constructor")
    self.amplitude = 10

    
    uninitptr: GDE.Variant
    godotMake: GDE.PackedVector2Array
    myArray:= make([dynamic]f32)
    append_elem(&myArray, 563)
    storage:rawptr
    

    multiray:= [?]rawptr {raw_data(myArray)}

    //fmt.println(godotMake)
    //GDW.arrayhelp.packedf32create0(&godotMake, nil)
    fmt.println(godotMake)

    
    //Need to setup a dynamic(?) array with the first u64 containing the size.
    sizeIncluded:=make([dynamic]u64)
    resize(&sizeIncluded, 5)
    //defer delete(sizeIncluded)

    sizeIncluded[0] = 4
    sizeIncluded[1] = 4
    sizeIncluded[2] = 4
    sizeIncluded[3] = 4
    sizeIncluded[4] = 4

    fmt.println("size value: ", (transmute([dynamic]u32)sizeIncluded)[:1])
    fmt.println("value: ", sizeIncluded[2])
    godotMake.data = raw_data(transmute([dynamic]f32)sizeIncluded)

    //godotMake:= GDW.api.mem_alloc(size_of(GDE.PackedVector2Array))
    //fmt.println((cast(^GDE.PackedVector2Array)godotMake)^)
    ray:=[?]rawptr{&godotMake}
    fmt.println(uninitptr)
    newSize: u64 = 1
    newValue: i64 = 97
    args:= [?]rawptr {&newSize}
    args2:= [?]rawptr {&newValue}
    index:u64=0
    set:= [?]rawptr {&index, &newValue}
    returnedSize: u64
    

    newpackedmake:= [?]rawptr{storage, &sizeIncluded[1]}
    fmt.println("address of 1: ", &sizeIncluded[1])
    fmt.println("address of 1: (size)", &sizeIncluded[0])
    fmt.println("My array data: ", newpackedmake)
    
    from:= []rawptr {&newpackedmake}

    testCreate:= [?]rawptr{storage, nil}
    GDW.arrayhelp.packedi32create1(&testCreate, raw_data(from[:]))
    fmt.println("My array data: ", newpackedmake)
    
    fmt.println(uninitptr)
    fmt.println("My array data: ", sizeIncluded)
    //fmt.println((cast(^[4]u64)((transmute(^[6]rawptr)uninitptr.data[1])[3]))^)

    fmt.println("variant pointer: ", &uninitptr)
    GDW.arrayhelp.packedi32size(&newpackedmake, nil, &returnedSize, 0)
    fmt.println("Size: ", returnedSize)
    //fmt.println((cast(^[4]u64)((transmute(^[6]rawptr)uninitptr.data[1])[3]))^)

    //GDW.arrayhelp.packedi32Set(&newpackedmake, raw_data(set[:]), nil, 2)
    GDW.arrayhelp.packedi32Get(&newpackedmake, raw_data(set[:]), &returnedSize, 1)
    fmt.println("Get Got: ", returnedSize)

    fmt.println("variant pointer: ", uninitptr)
    GDW.variantfrom.packedf32arrayToVariant(&uninitptr, &newpackedmake)
    fmt.println("variant pointer: ", uninitptr)

    fmt.println("My array data: ", newpackedmake)
    fmt.println("data: ",cast(^[4]i64)((cast(^[8]rawptr)uninitptr.data[1])[3]))
    //fmt.println("data: ", (((cast(^[4]^[4]i64)uninitptr.data[1]))[3]))

    //You can get to the array directly, but Godot has no GDExtension function to act directly on an array.
    //GDW.arrayhelp.packedi32Get(cast(^[4]i64)((cast(^[8]rawptr)uninitptr.data[1])[3]), raw_data(set[:]), nil, 2)
    GDW.destructors.variantDestroy(&uninitptr)

}

class_destructor  :: proc  "c" (self: ^GDExample) {
    context = runtime.default_context()

   //GDW.destructors.stringNameDestructor(&self.position_changed)
}


classBindingCallbacks: GDE.InstanceBindingCallbacks = {
    create_callback    = nil,
    free_callback      = nil,
    reference_callback = nil
}