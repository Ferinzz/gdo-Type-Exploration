package main

import "core:fmt"
import sics "base:intrinsics"
import GDW "GDWrapper"
import GDE "GDWrapper/gdextension"
import "base:runtime"
import str "core:strings"
import s "core:slice"

@export
godot_entry_init :: proc(p_get_proc_address : GDE.InterfaceGetProcAddress, p_library: GDE.ClassLibraryPtr, r_initialization: ^GDE.Initialization) {
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
    
    boolean: GDE.Bool = false
    GDW.variantfrom.boolToVariant(&variant, &boolean)
    fmt.printfln("THEVARIANT: %b", variant.data[:])
    fmt.printfln("THEVALUE: %b", boolean)
    
    mypacked:= make([dynamic]f32)
    append_elems(&mypacked, 3)
    uninitptr: GDE.Variant
    packed: GDE.PackedVector2Array 
    proxy: = new(u64)
    fmt.println(size_of(packed))
    packed = {proxy = proxy, data = raw_data(mypacked[:])}
    packed2: GDE.PackedFloat32Array = {0}
    GDW.variantfrom.packedf32arrayToVariant(&uninitptr, &packed)
    fmt.printfln("THEVARIANTpacked: %b", uninitptr.data[:])
    fmt.printfln("THEVARIANTpacked: 23", transmute(rawptr)uninitptr.data[1])
    fmt.println("THEVALUEpacked: ", packed)
    fmt.printfln("THEVARIANTpacked: 23", (cast([^]rawptr)(transmute(rawptr)uninitptr.data[1])))


    
    returned : GDE.PackedVector2Array
    GDW.variantto.packedf32arrayFromVariant(&returned, &uninitptr)
    fmt.printfln("THEVARIANTpacked: %b", uninitptr.data[:])
    fmt.printfln("THEVARIANTpacked: %b", (cast([^]f32)(transmute(rawptr)uninitptr.data[1]))[0])
    fmt.println("THEVALUEpacked: ", returned)

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
    fmt.println(variant.data[1] == parent_class_name[0])

    fmt.println("ENUM MAX: ", i32(GDE.VariantType.VARIANT_MAX))

    
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
    GDW.stringconstruct.stringNameNewLatin(&arrayClass, "PackedFloat32Array", false)
    arraySize:= new(GDE.StringName)
    GDW.stringconstruct.stringNameNewLatin(&arraySize, "size", false)
    GDW.arrayhelp.packedf32size = GDW.api.builtinMethodBindCall(.PACKED_FLOAT32_ARRAY, &arraySize, 3173160232)

    GDW.stringconstruct.stringNameNewLatin(&arraySize, "resize", false)
    GDW.arrayhelp.packedf32REsize = GDW.api.builtinMethodBindCall(.PACKED_FLOAT32_ARRAY, &arraySize, 848867239)
    
    GDW.stringconstruct.stringNameNewLatin(&arraySize, "append", false)
    GDW.arrayhelp.packedf32Append = GDW.api.builtinMethodBindCall(.PACKED_FLOAT32_ARRAY, &arraySize, 4094791666)

    GDW.stringconstruct.stringNameNewLatin(&arraySize, "get", false)
    GDW.arrayhelp.packedf32Get = GDW.api.builtinMethodBindCall(.PACKED_FLOAT32_ARRAY, &arraySize, 1401583798)

    GDW.stringconstruct.stringNameNewLatin(&arraySize, "set", false)
    GDW.arrayhelp.packedf32Set = GDW.api.builtinMethodBindCall(.PACKED_FLOAT32_ARRAY, &arraySize, 1113000516)

    
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

    
    mypacked:= make([dynamic]f32)
    append_elems(&mypacked, 42, 64, 92, 32)
    fmt.println(mypacked)
    uninitptr: GDE.Variant
    packed: GDE.PackedVector2Array 
    proxy1: u64= 32
    fmt.println(size_of(packed))
    fmt.println("array made")
    packed = {proxy = &proxy1, data = raw_data(mypacked)}
    packed2: GDE.PackedFloat32Array = {0}
    GDW.variantfrom.packedf32arrayToVariant(&uninitptr.data, &packed)
    //fmt.printfln("THEVARIANTpacked: %b", uninitptr.data[:])
    //fmt.printfln("THEVARIANTpacked: %b", (cast([^]f32)(transmute(rawptr)uninitptr.data[1]))[0])
    fmt.println("THEVALUEpacked: ", packed)

    returnedSize: int
    GDW.arrayhelp.packedf32size(&uninitptr.data, nil, &returnedSize, 0)
    fmt.println("Size of array: ",returnedSize)

    newSize: GDE.Int = 1
    newValue: f32 = 22
    args:= [?]rawptr {&newSize}
    args2:= [?]rawptr {&newValue}
    //fmt.println((cast(^GDE.Int)args[0])^)
    GDW.arrayhelp.packedf32REsize(&uninitptr.data, raw_data(args[:]), &returnedSize, 1)
    fmt.println("Size of array: ",returnedSize)

    didSet: GDE.Bool = true
    GDW.arrayhelp.packedf32Append(&uninitptr.data, raw_data(args2[:]), &didSet, 1)
    fmt.println("did set: ", didSet)

    GDW.arrayhelp.packedf32size(&uninitptr.data[1], raw_data(args[:]), &returnedSize, 1)
    fmt.println("Size of array: ",returnedSize)
//
    //newSize=0
    retValue: f32 = 22
    //GDW.arrayhelp.packedf32GetIndex(&uninitptr.data[1], 0, &retValue)
    //fmt.println("return 1: ", retValue)
    //
    //GDW.arrayhelp.packedf32GetIndex(&uninitptr.data[1], 1, &retValue)
    //fmt.println("return 1: ", retValue)
//
    //GDW.arrayhelp.packedf32Set(&uninitptr.data[1], raw_data(args2[:]), nil, 2)
    ////fmt.println("Size of array: ",returnedSize)
    //GDW.arrayhelp.packedf32SetIndex(&uninitptr.data[1], 0, &retValue)
    //
    index:int=1
    GDW.arrayhelp.packedf32GetIndex(&uninitptr.data, index, &retValue)
    fmt.println("return 2: ", retValue)
    
    fmt.println((((cast(^[5]rawptr)(transmute(rawptr)uninitptr.data[1])))))
    //fmt.println(((cast(^[8]^[x]f32)(transmute(rawptr)uninitptr.data[1]))[0]))
    //fmt.println(packed.data[0])

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
    //self.speed = 1
    //self.timePassed = 0
    //self.time_emit = 0
    //GDW.stringconstruct.stringNameNewLatin(&self.position_changed, "position_changed", false)
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