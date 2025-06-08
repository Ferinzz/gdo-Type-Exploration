package GDWrapper

import GDE "gdextension"
import "base:intrinsics"

//Will be figuring out how to do the type operators in this file.
//Difficulty is the fact that Each operator combination between types will have its own logic.
//Since arrays are copy on write there should be no changes to the array we're looking at.
//If the pointers are the same, the data is the same?


//Give me the pointer each and every time.
//Use types from GDDEfs.odin
variantEvaluate :: proc(p_operator: GDE.VariantOperator, p_type_a: ^GDE.Variant,
                p_type_b: ^GDE.Variant, r_return: $T) where intrinsics.type_is_pointer(T) {
    variant_op: GDE.PtrOperatorEvaluator = api.variantGetPtrOperatorEvaluator(p_operator, p_type_a.VType, p_type_b.VType)

    variant_op(p_type_a, p_type_b, r_return)

}

//Long term could use Odin operators to handle the local variant data instead of relying on Godot.
//Looking at Godot, there are several pages worth of operators. For now, just getting things going this is fine.


