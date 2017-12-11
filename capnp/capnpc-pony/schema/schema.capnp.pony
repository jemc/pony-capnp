
use "../.."

class val Node is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x28, 8*6); _struct = s'
  
  fun id(): U64 => get_id()
  fun get_id(): U64 => _struct.u64(0x0)
  
  fun displayName(): String => get_displayName()
  fun get_displayName(): String => try _struct.ptr_text(0)? else "" end
  
  fun displayNamePrefixLength(): U32 => get_displayNamePrefixLength()
  fun get_displayNamePrefixLength(): U32 => _struct.u32(0x8)
  
  fun scopeId(): U64 => get_scopeId()
  fun get_scopeId(): U64 => _struct.u64(0x10)
  
  fun nestedNodes(): CapnList[NodeNestedNode] => get_nestedNodes()
  fun get_nestedNodes(): CapnList[NodeNestedNode] => try _struct.ptr_list[NodeNestedNode](1)? else _struct.ptr_emptylist[NodeNestedNode]() end
  
  fun annotations(): CapnList[Annotation] => get_annotations()
  fun get_annotations(): CapnList[Annotation] => try _struct.ptr_list[Annotation](2)? else _struct.ptr_emptylist[Annotation]() end
  
  fun file(): None => get_file()
  fun get_file(): None => None
  fun as_file(): None? => _struct.assert_union(0xC, 0)?; None
  fun is_file(): Bool => _struct.check_union(0xC, 0)
  
  // fun struct(): NodeGROUPstruct => get_struct() // DISABLED: invalid Pony function name
  fun get_struct(): NodeGROUPstruct => if _struct.check_union(0xC, 1) then NodeGROUPstruct(_struct) else _struct.ptr_emptystruct[NodeGROUPstruct]() end
  fun as_struct(): NodeGROUPstruct? => _struct.assert_union(0xC, 1)?; NodeGROUPstruct(_struct)
  fun is_struct(): Bool => _struct.check_union(0xC, 1)
  
  fun enum(): NodeGROUPenum => get_enum()
  fun get_enum(): NodeGROUPenum => if _struct.check_union(0xC, 2) then NodeGROUPenum(_struct) else _struct.ptr_emptystruct[NodeGROUPenum]() end
  fun as_enum(): NodeGROUPenum? => _struct.assert_union(0xC, 2)?; NodeGROUPenum(_struct)
  fun is_enum(): Bool => _struct.check_union(0xC, 2)
  
  // fun interface(): NodeGROUPinterface => get_interface() // DISABLED: invalid Pony function name
  fun get_interface(): NodeGROUPinterface => if _struct.check_union(0xC, 3) then NodeGROUPinterface(_struct) else _struct.ptr_emptystruct[NodeGROUPinterface]() end
  fun as_interface(): NodeGROUPinterface? => _struct.assert_union(0xC, 3)?; NodeGROUPinterface(_struct)
  fun is_interface(): Bool => _struct.check_union(0xC, 3)
  
  fun const(): NodeGROUPconst => get_const()
  fun get_const(): NodeGROUPconst => if _struct.check_union(0xC, 4) then NodeGROUPconst(_struct) else _struct.ptr_emptystruct[NodeGROUPconst]() end
  fun as_const(): NodeGROUPconst? => _struct.assert_union(0xC, 4)?; NodeGROUPconst(_struct)
  fun is_const(): Bool => _struct.check_union(0xC, 4)
  
  fun annotation(): NodeGROUPannotation => get_annotation()
  fun get_annotation(): NodeGROUPannotation => if _struct.check_union(0xC, 5) then NodeGROUPannotation(_struct) else _struct.ptr_emptystruct[NodeGROUPannotation]() end
  fun as_annotation(): NodeGROUPannotation? => _struct.assert_union(0xC, 5)?; NodeGROUPannotation(_struct)
  fun is_annotation(): Bool => _struct.check_union(0xC, 5)
  
  fun parameters(): CapnList[NodeParameter] => get_parameters()
  fun get_parameters(): CapnList[NodeParameter] => try _struct.ptr_list[NodeParameter](5)? else _struct.ptr_emptylist[NodeParameter]() end
  
  fun isGeneric(): Bool => get_isGeneric()
  fun get_isGeneric(): Bool => _struct.bool(0x24, 0b00000001)

class val NodeGROUPstruct is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun dataWordCount(): U16 => get_dataWordCount()
  fun get_dataWordCount(): U16 => _struct.u16(0xE)
  
  fun pointerCount(): U16 => get_pointerCount()
  fun get_pointerCount(): U16 => _struct.u16(0x18)
  
  fun preferredListEncoding(): ElementSize => get_preferredListEncoding()
  fun get_preferredListEncoding(): ElementSize => ElementSize(_struct.u16(0x1A))
  
  fun isGroup(): Bool => get_isGroup()
  fun get_isGroup(): Bool => _struct.bool(0x1C, 0b00000001)
  
  fun discriminantCount(): U16 => get_discriminantCount()
  fun get_discriminantCount(): U16 => _struct.u16(0x1E)
  
  fun discriminantOffset(): U32 => get_discriminantOffset()
  fun get_discriminantOffset(): U32 => _struct.u32(0x20)
  
  fun fields(): CapnList[Field] => get_fields()
  fun get_fields(): CapnList[Field] => try _struct.ptr_list[Field](3)? else _struct.ptr_emptylist[Field]() end

class val NodeGROUPenum is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun enumerants(): CapnList[Enumerant] => get_enumerants()
  fun get_enumerants(): CapnList[Enumerant] => try _struct.ptr_list[Enumerant](3)? else _struct.ptr_emptylist[Enumerant]() end

class val NodeGROUPinterface is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun methods(): CapnList[Method] => get_methods()
  fun get_methods(): CapnList[Method] => try _struct.ptr_list[Method](3)? else _struct.ptr_emptylist[Method]() end
  
  fun superclasses(): CapnList[Superclass] => get_superclasses()
  fun get_superclasses(): CapnList[Superclass] => try _struct.ptr_list[Superclass](4)? else _struct.ptr_emptylist[Superclass]() end

class val NodeGROUPconst is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  // fun type(): Type => get_type() // DISABLED: invalid Pony function name
  fun get_type(): Type => try _struct.ptr_struct[Type](3)? else _struct.ptr_emptystruct[Type]() end
  
  fun value(): Value => get_value()
  fun get_value(): Value => try _struct.ptr_struct[Value](4)? else _struct.ptr_emptystruct[Value]() end

class val NodeGROUPannotation is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  // fun type(): Type => get_type() // DISABLED: invalid Pony function name
  fun get_type(): Type => try _struct.ptr_struct[Type](3)? else _struct.ptr_emptystruct[Type]() end
  
  fun targetsFile(): Bool => get_targetsFile()
  fun get_targetsFile(): Bool => _struct.bool(0xE, 0b00000001)
  
  fun targetsConst(): Bool => get_targetsConst()
  fun get_targetsConst(): Bool => _struct.bool(0xE, 0b00000010)
  
  fun targetsEnum(): Bool => get_targetsEnum()
  fun get_targetsEnum(): Bool => _struct.bool(0xE, 0b00000100)
  
  fun targetsEnumerant(): Bool => get_targetsEnumerant()
  fun get_targetsEnumerant(): Bool => _struct.bool(0xE, 0b00001000)
  
  fun targetsStruct(): Bool => get_targetsStruct()
  fun get_targetsStruct(): Bool => _struct.bool(0xE, 0b00010000)
  
  fun targetsField(): Bool => get_targetsField()
  fun get_targetsField(): Bool => _struct.bool(0xE, 0b00100000)
  
  fun targetsUnion(): Bool => get_targetsUnion()
  fun get_targetsUnion(): Bool => _struct.bool(0xE, 0b01000000)
  
  fun targetsGroup(): Bool => get_targetsGroup()
  fun get_targetsGroup(): Bool => _struct.bool(0xE, 0b10000000)
  
  fun targetsInterface(): Bool => get_targetsInterface()
  fun get_targetsInterface(): Bool => _struct.bool(0xF, 0b00000001)
  
  fun targetsMethod(): Bool => get_targetsMethod()
  fun get_targetsMethod(): Bool => _struct.bool(0xF, 0b00000010)
  
  fun targetsParam(): Bool => get_targetsParam()
  fun get_targetsParam(): Bool => _struct.bool(0xF, 0b00000100)
  
  fun targetsAnnotation(): Bool => get_targetsAnnotation()
  fun get_targetsAnnotation(): Bool => _struct.bool(0xF, 0b00001000)

class val NodeParameter is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x0, 8*1); _struct = s'
  
  fun name(): String => get_name()
  fun get_name(): String => try _struct.ptr_text(0)? else "" end

class val NodeNestedNode is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*1); _struct = s'
  
  fun name(): String => get_name()
  fun get_name(): String => try _struct.ptr_text(0)? else "" end
  
  fun id(): U64 => get_id()
  fun get_id(): U64 => _struct.u64(0x0)

class val Field is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x18, 8*4); _struct = s'
  
  fun name(): String => get_name()
  fun get_name(): String => try _struct.ptr_text(0)? else "" end
  
  fun codeOrder(): U16 => get_codeOrder()
  fun get_codeOrder(): U16 => _struct.u16(0x0)
  
  fun annotations(): CapnList[Annotation] => get_annotations()
  fun get_annotations(): CapnList[Annotation] => try _struct.ptr_list[Annotation](1)? else _struct.ptr_emptylist[Annotation]() end
  
  fun discriminantValue(): U16 => get_discriminantValue()
  fun get_discriminantValue(): U16 => 65535 xor _struct.u16(0x2)
  
  fun slot(): FieldGROUPslot => get_slot()
  fun get_slot(): FieldGROUPslot => if _struct.check_union(0x8, 0) then FieldGROUPslot(_struct) else _struct.ptr_emptystruct[FieldGROUPslot]() end
  fun as_slot(): FieldGROUPslot? => _struct.assert_union(0x8, 0)?; FieldGROUPslot(_struct)
  fun is_slot(): Bool => _struct.check_union(0x8, 0)
  
  fun group(): FieldGROUPgroup => get_group()
  fun get_group(): FieldGROUPgroup => if _struct.check_union(0x8, 1) then FieldGROUPgroup(_struct) else _struct.ptr_emptystruct[FieldGROUPgroup]() end
  fun as_group(): FieldGROUPgroup? => _struct.assert_union(0x8, 1)?; FieldGROUPgroup(_struct)
  fun is_group(): Bool => _struct.check_union(0x8, 1)
  
  fun ordinal(): FieldGROUPordinal => get_ordinal()
  fun get_ordinal(): FieldGROUPordinal => FieldGROUPordinal(_struct)

class val FieldGROUPslot is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun offset(): U32 => get_offset()
  fun get_offset(): U32 => _struct.u32(0x4)
  
  // fun type(): Type => get_type() // DISABLED: invalid Pony function name
  fun get_type(): Type => try _struct.ptr_struct[Type](2)? else _struct.ptr_emptystruct[Type]() end
  
  fun defaultValue(): Value => get_defaultValue()
  fun get_defaultValue(): Value => try _struct.ptr_struct[Value](3)? else _struct.ptr_emptystruct[Value]() end
  
  fun hadExplicitDefault(): Bool => get_hadExplicitDefault()
  fun get_hadExplicitDefault(): Bool => _struct.bool(0x10, 0b00000001)

class val FieldGROUPgroup is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun typeId(): U64 => get_typeId()
  fun get_typeId(): U64 => _struct.u64(0x10)

class val FieldGROUPordinal is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun implicit(): None => get_implicit()
  fun get_implicit(): None => None
  fun as_implicit(): None? => _struct.assert_union(0xA, 0)?; None
  fun is_implicit(): Bool => _struct.check_union(0xA, 0)
  
  fun explicit(): U16 => get_explicit()
  fun get_explicit(): U16 => if _struct.check_union(0xA, 1) then _struct.u16(0xC) else 0 end
  fun as_explicit(): U16? => _struct.assert_union(0xA, 1)?; _struct.u16(0xC)
  fun is_explicit(): Bool => _struct.check_union(0xA, 1)
// UNHANDLED: capnp/capnpc-pony/schema/schema.capnp:Field.noDiscriminant

class val Enumerant is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*2); _struct = s'
  
  fun name(): String => get_name()
  fun get_name(): String => try _struct.ptr_text(0)? else "" end
  
  fun codeOrder(): U16 => get_codeOrder()
  fun get_codeOrder(): U16 => _struct.u16(0x0)
  
  fun annotations(): CapnList[Annotation] => get_annotations()
  fun get_annotations(): CapnList[Annotation] => try _struct.ptr_list[Annotation](1)? else _struct.ptr_emptylist[Annotation]() end

class val Superclass is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*1); _struct = s'
  
  fun id(): U64 => get_id()
  fun get_id(): U64 => _struct.u64(0x0)
  
  fun brand(): Brand => get_brand()
  fun get_brand(): Brand => try _struct.ptr_struct[Brand](0)? else _struct.ptr_emptystruct[Brand]() end

class val Method is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x18, 8*5); _struct = s'
  
  fun name(): String => get_name()
  fun get_name(): String => try _struct.ptr_text(0)? else "" end
  
  fun codeOrder(): U16 => get_codeOrder()
  fun get_codeOrder(): U16 => _struct.u16(0x0)
  
  fun paramStructType(): U64 => get_paramStructType()
  fun get_paramStructType(): U64 => _struct.u64(0x8)
  
  fun resultStructType(): U64 => get_resultStructType()
  fun get_resultStructType(): U64 => _struct.u64(0x10)
  
  fun annotations(): CapnList[Annotation] => get_annotations()
  fun get_annotations(): CapnList[Annotation] => try _struct.ptr_list[Annotation](1)? else _struct.ptr_emptylist[Annotation]() end
  
  fun paramBrand(): Brand => get_paramBrand()
  fun get_paramBrand(): Brand => try _struct.ptr_struct[Brand](2)? else _struct.ptr_emptystruct[Brand]() end
  
  fun resultBrand(): Brand => get_resultBrand()
  fun get_resultBrand(): Brand => try _struct.ptr_struct[Brand](3)? else _struct.ptr_emptystruct[Brand]() end
  
  fun implicitParameters(): CapnList[NodeParameter] => get_implicitParameters()
  fun get_implicitParameters(): CapnList[NodeParameter] => try _struct.ptr_list[NodeParameter](4)? else _struct.ptr_emptylist[NodeParameter]() end

class val Type is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x18, 8*1); _struct = s'
  
  fun void(): None => get_void()
  fun get_void(): None => None
  fun as_void(): None? => _struct.assert_union(0x0, 0)?; None
  fun is_void(): Bool => _struct.check_union(0x0, 0)
  
  fun bool(): None => get_bool()
  fun get_bool(): None => None
  fun as_bool(): None? => _struct.assert_union(0x0, 1)?; None
  fun is_bool(): Bool => _struct.check_union(0x0, 1)
  
  fun int8(): None => get_int8()
  fun get_int8(): None => None
  fun as_int8(): None? => _struct.assert_union(0x0, 2)?; None
  fun is_int8(): Bool => _struct.check_union(0x0, 2)
  
  fun int16(): None => get_int16()
  fun get_int16(): None => None
  fun as_int16(): None? => _struct.assert_union(0x0, 3)?; None
  fun is_int16(): Bool => _struct.check_union(0x0, 3)
  
  fun int32(): None => get_int32()
  fun get_int32(): None => None
  fun as_int32(): None? => _struct.assert_union(0x0, 4)?; None
  fun is_int32(): Bool => _struct.check_union(0x0, 4)
  
  fun int64(): None => get_int64()
  fun get_int64(): None => None
  fun as_int64(): None? => _struct.assert_union(0x0, 5)?; None
  fun is_int64(): Bool => _struct.check_union(0x0, 5)
  
  fun uint8(): None => get_uint8()
  fun get_uint8(): None => None
  fun as_uint8(): None? => _struct.assert_union(0x0, 6)?; None
  fun is_uint8(): Bool => _struct.check_union(0x0, 6)
  
  fun uint16(): None => get_uint16()
  fun get_uint16(): None => None
  fun as_uint16(): None? => _struct.assert_union(0x0, 7)?; None
  fun is_uint16(): Bool => _struct.check_union(0x0, 7)
  
  fun uint32(): None => get_uint32()
  fun get_uint32(): None => None
  fun as_uint32(): None? => _struct.assert_union(0x0, 8)?; None
  fun is_uint32(): Bool => _struct.check_union(0x0, 8)
  
  fun uint64(): None => get_uint64()
  fun get_uint64(): None => None
  fun as_uint64(): None? => _struct.assert_union(0x0, 9)?; None
  fun is_uint64(): Bool => _struct.check_union(0x0, 9)
  
  fun float32(): None => get_float32()
  fun get_float32(): None => None
  fun as_float32(): None? => _struct.assert_union(0x0, 10)?; None
  fun is_float32(): Bool => _struct.check_union(0x0, 10)
  
  fun float64(): None => get_float64()
  fun get_float64(): None => None
  fun as_float64(): None? => _struct.assert_union(0x0, 11)?; None
  fun is_float64(): Bool => _struct.check_union(0x0, 11)
  
  fun text(): None => get_text()
  fun get_text(): None => None
  fun as_text(): None? => _struct.assert_union(0x0, 12)?; None
  fun is_text(): Bool => _struct.check_union(0x0, 12)
  
  fun data(): None => get_data()
  fun get_data(): None => None
  fun as_data(): None? => _struct.assert_union(0x0, 13)?; None
  fun is_data(): Bool => _struct.check_union(0x0, 13)
  
  fun list(): TypeGROUPlist => get_list()
  fun get_list(): TypeGROUPlist => if _struct.check_union(0x0, 14) then TypeGROUPlist(_struct) else _struct.ptr_emptystruct[TypeGROUPlist]() end
  fun as_list(): TypeGROUPlist? => _struct.assert_union(0x0, 14)?; TypeGROUPlist(_struct)
  fun is_list(): Bool => _struct.check_union(0x0, 14)
  
  fun enum(): TypeGROUPenum => get_enum()
  fun get_enum(): TypeGROUPenum => if _struct.check_union(0x0, 15) then TypeGROUPenum(_struct) else _struct.ptr_emptystruct[TypeGROUPenum]() end
  fun as_enum(): TypeGROUPenum? => _struct.assert_union(0x0, 15)?; TypeGROUPenum(_struct)
  fun is_enum(): Bool => _struct.check_union(0x0, 15)
  
  // fun struct(): TypeGROUPstruct => get_struct() // DISABLED: invalid Pony function name
  fun get_struct(): TypeGROUPstruct => if _struct.check_union(0x0, 16) then TypeGROUPstruct(_struct) else _struct.ptr_emptystruct[TypeGROUPstruct]() end
  fun as_struct(): TypeGROUPstruct? => _struct.assert_union(0x0, 16)?; TypeGROUPstruct(_struct)
  fun is_struct(): Bool => _struct.check_union(0x0, 16)
  
  // fun interface(): TypeGROUPinterface => get_interface() // DISABLED: invalid Pony function name
  fun get_interface(): TypeGROUPinterface => if _struct.check_union(0x0, 17) then TypeGROUPinterface(_struct) else _struct.ptr_emptystruct[TypeGROUPinterface]() end
  fun as_interface(): TypeGROUPinterface? => _struct.assert_union(0x0, 17)?; TypeGROUPinterface(_struct)
  fun is_interface(): Bool => _struct.check_union(0x0, 17)
  
  fun anyPointer(): TypeGROUPanyPointer => get_anyPointer()
  fun get_anyPointer(): TypeGROUPanyPointer => if _struct.check_union(0x0, 18) then TypeGROUPanyPointer(_struct) else _struct.ptr_emptystruct[TypeGROUPanyPointer]() end
  fun as_anyPointer(): TypeGROUPanyPointer? => _struct.assert_union(0x0, 18)?; TypeGROUPanyPointer(_struct)
  fun is_anyPointer(): Bool => _struct.check_union(0x0, 18)

class val TypeGROUPlist is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun elementType(): Type => get_elementType()
  fun get_elementType(): Type => try _struct.ptr_struct[Type](0)? else _struct.ptr_emptystruct[Type]() end

class val TypeGROUPenum is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun typeId(): U64 => get_typeId()
  fun get_typeId(): U64 => _struct.u64(0x8)
  
  fun brand(): Brand => get_brand()
  fun get_brand(): Brand => try _struct.ptr_struct[Brand](0)? else _struct.ptr_emptystruct[Brand]() end

class val TypeGROUPstruct is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun typeId(): U64 => get_typeId()
  fun get_typeId(): U64 => _struct.u64(0x8)
  
  fun brand(): Brand => get_brand()
  fun get_brand(): Brand => try _struct.ptr_struct[Brand](0)? else _struct.ptr_emptystruct[Brand]() end

class val TypeGROUPinterface is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun typeId(): U64 => get_typeId()
  fun get_typeId(): U64 => _struct.u64(0x8)
  
  fun brand(): Brand => get_brand()
  fun get_brand(): Brand => try _struct.ptr_struct[Brand](0)? else _struct.ptr_emptystruct[Brand]() end

class val TypeGROUPanyPointer is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun unconstrained(): TypeGROUPanyPointerGROUPunconstrained => get_unconstrained()
  fun get_unconstrained(): TypeGROUPanyPointerGROUPunconstrained => if _struct.check_union(0x8, 0) then TypeGROUPanyPointerGROUPunconstrained(_struct) else _struct.ptr_emptystruct[TypeGROUPanyPointerGROUPunconstrained]() end
  fun as_unconstrained(): TypeGROUPanyPointerGROUPunconstrained? => _struct.assert_union(0x8, 0)?; TypeGROUPanyPointerGROUPunconstrained(_struct)
  fun is_unconstrained(): Bool => _struct.check_union(0x8, 0)
  
  fun parameter(): TypeGROUPanyPointerGROUPparameter => get_parameter()
  fun get_parameter(): TypeGROUPanyPointerGROUPparameter => if _struct.check_union(0x8, 1) then TypeGROUPanyPointerGROUPparameter(_struct) else _struct.ptr_emptystruct[TypeGROUPanyPointerGROUPparameter]() end
  fun as_parameter(): TypeGROUPanyPointerGROUPparameter? => _struct.assert_union(0x8, 1)?; TypeGROUPanyPointerGROUPparameter(_struct)
  fun is_parameter(): Bool => _struct.check_union(0x8, 1)
  
  fun implicitMethodParameter(): TypeGROUPanyPointerGROUPimplicitMethodParameter => get_implicitMethodParameter()
  fun get_implicitMethodParameter(): TypeGROUPanyPointerGROUPimplicitMethodParameter => if _struct.check_union(0x8, 2) then TypeGROUPanyPointerGROUPimplicitMethodParameter(_struct) else _struct.ptr_emptystruct[TypeGROUPanyPointerGROUPimplicitMethodParameter]() end
  fun as_implicitMethodParameter(): TypeGROUPanyPointerGROUPimplicitMethodParameter? => _struct.assert_union(0x8, 2)?; TypeGROUPanyPointerGROUPimplicitMethodParameter(_struct)
  fun is_implicitMethodParameter(): Bool => _struct.check_union(0x8, 2)

class val TypeGROUPanyPointerGROUPunconstrained is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun anyKind(): None => get_anyKind()
  fun get_anyKind(): None => None
  fun as_anyKind(): None? => _struct.assert_union(0xA, 0)?; None
  fun is_anyKind(): Bool => _struct.check_union(0xA, 0)
  
  // fun struct(): None => get_struct() // DISABLED: invalid Pony function name
  fun get_struct(): None => None
  fun as_struct(): None? => _struct.assert_union(0xA, 1)?; None
  fun is_struct(): Bool => _struct.check_union(0xA, 1)
  
  fun list(): None => get_list()
  fun get_list(): None => None
  fun as_list(): None? => _struct.assert_union(0xA, 2)?; None
  fun is_list(): Bool => _struct.check_union(0xA, 2)
  
  fun capability(): None => get_capability()
  fun get_capability(): None => None
  fun as_capability(): None? => _struct.assert_union(0xA, 3)?; None
  fun is_capability(): Bool => _struct.check_union(0xA, 3)

class val TypeGROUPanyPointerGROUPparameter is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun scopeId(): U64 => get_scopeId()
  fun get_scopeId(): U64 => _struct.u64(0x10)
  
  fun parameterIndex(): U16 => get_parameterIndex()
  fun get_parameterIndex(): U16 => _struct.u16(0xA)

class val TypeGROUPanyPointerGROUPimplicitMethodParameter is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  
  fun parameterIndex(): U16 => get_parameterIndex()
  fun get_parameterIndex(): U16 => _struct.u16(0xA)

class val Brand is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x0, 8*1); _struct = s'
  
  fun scopes(): CapnList[BrandScope] => get_scopes()
  fun get_scopes(): CapnList[BrandScope] => try _struct.ptr_list[BrandScope](0)? else _struct.ptr_emptylist[BrandScope]() end

class val BrandScope is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x10, 8*1); _struct = s'
  
  fun scopeId(): U64 => get_scopeId()
  fun get_scopeId(): U64 => _struct.u64(0x0)
  
  fun bind(): CapnList[BrandBinding] => get_bind()
  fun get_bind(): CapnList[BrandBinding] => try if _struct.check_union(0x8, 0) then _struct.ptr_list[BrandBinding](0)? else error end else _struct.ptr_emptylist[BrandBinding]() end
  fun as_bind(): CapnList[BrandBinding]? => _struct.assert_union(0x8, 0)?; try _struct.ptr_list[BrandBinding](0)? else _struct.ptr_emptylist[BrandBinding]() end
  fun is_bind(): Bool => _struct.check_union(0x8, 0)
  
  fun inherit(): None => get_inherit()
  fun get_inherit(): None => None
  fun as_inherit(): None? => _struct.assert_union(0x8, 1)?; None
  fun is_inherit(): Bool => _struct.check_union(0x8, 1)

class val BrandBinding is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*1); _struct = s'
  
  fun unbound(): None => get_unbound()
  fun get_unbound(): None => None
  fun as_unbound(): None? => _struct.assert_union(0x0, 0)?; None
  fun is_unbound(): Bool => _struct.check_union(0x0, 0)
  
  // fun type(): Type => get_type() // DISABLED: invalid Pony function name
  fun get_type(): Type => try if _struct.check_union(0x0, 1) then _struct.ptr_struct[Type](0)? else error end else _struct.ptr_emptystruct[Type]() end
  fun as_type(): Type? => _struct.assert_union(0x0, 1)?; try _struct.ptr_struct[Type](0)? else _struct.ptr_emptystruct[Type]() end
  fun is_type(): Bool => _struct.check_union(0x0, 1)

class val Value is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x10, 8*1); _struct = s'
  
  fun void(): None => get_void()
  fun get_void(): None => None
  fun as_void(): None? => _struct.assert_union(0x0, 0)?; None
  fun is_void(): Bool => _struct.check_union(0x0, 0)
  
  fun bool(): Bool => get_bool()
  fun get_bool(): Bool => if _struct.check_union(0x0, 1) then _struct.bool(0x2, 0b00000001) else false end
  fun as_bool(): Bool? => _struct.assert_union(0x0, 1)?; _struct.bool(0x2, 0b00000001)
  fun is_bool(): Bool => _struct.check_union(0x0, 1)
  
  fun int8(): I8 => get_int8()
  fun get_int8(): I8 => if _struct.check_union(0x0, 2) then _struct.i8(0x2) else 0 end
  fun as_int8(): I8? => _struct.assert_union(0x0, 2)?; _struct.i8(0x2)
  fun is_int8(): Bool => _struct.check_union(0x0, 2)
  
  fun int16(): I16 => get_int16()
  fun get_int16(): I16 => if _struct.check_union(0x0, 3) then _struct.i16(0x2) else 0 end
  fun as_int16(): I16? => _struct.assert_union(0x0, 3)?; _struct.i16(0x2)
  fun is_int16(): Bool => _struct.check_union(0x0, 3)
  
  fun int32(): I32 => get_int32()
  fun get_int32(): I32 => if _struct.check_union(0x0, 4) then _struct.i32(0x4) else 0 end
  fun as_int32(): I32? => _struct.assert_union(0x0, 4)?; _struct.i32(0x4)
  fun is_int32(): Bool => _struct.check_union(0x0, 4)
  
  fun int64(): I64 => get_int64()
  fun get_int64(): I64 => if _struct.check_union(0x0, 5) then _struct.i64(0x8) else 0 end
  fun as_int64(): I64? => _struct.assert_union(0x0, 5)?; _struct.i64(0x8)
  fun is_int64(): Bool => _struct.check_union(0x0, 5)
  
  fun uint8(): U8 => get_uint8()
  fun get_uint8(): U8 => if _struct.check_union(0x0, 6) then _struct.u8(0x2) else 0 end
  fun as_uint8(): U8? => _struct.assert_union(0x0, 6)?; _struct.u8(0x2)
  fun is_uint8(): Bool => _struct.check_union(0x0, 6)
  
  fun uint16(): U16 => get_uint16()
  fun get_uint16(): U16 => if _struct.check_union(0x0, 7) then _struct.u16(0x2) else 0 end
  fun as_uint16(): U16? => _struct.assert_union(0x0, 7)?; _struct.u16(0x2)
  fun is_uint16(): Bool => _struct.check_union(0x0, 7)
  
  fun uint32(): U32 => get_uint32()
  fun get_uint32(): U32 => if _struct.check_union(0x0, 8) then _struct.u32(0x4) else 0 end
  fun as_uint32(): U32? => _struct.assert_union(0x0, 8)?; _struct.u32(0x4)
  fun is_uint32(): Bool => _struct.check_union(0x0, 8)
  
  fun uint64(): U64 => get_uint64()
  fun get_uint64(): U64 => if _struct.check_union(0x0, 9) then _struct.u64(0x8) else 0 end
  fun as_uint64(): U64? => _struct.assert_union(0x0, 9)?; _struct.u64(0x8)
  fun is_uint64(): Bool => _struct.check_union(0x0, 9)
  
  fun float32(): F32 => get_float32()
  fun get_float32(): F32 => if _struct.check_union(0x0, 10) then _struct.f32(0x4) else 0 end
  fun as_float32(): F32? => _struct.assert_union(0x0, 10)?; _struct.f32(0x4)
  fun is_float32(): Bool => _struct.check_union(0x0, 10)
  
  fun float64(): F64 => get_float64()
  fun get_float64(): F64 => if _struct.check_union(0x0, 11) then _struct.f64(0x8) else 0 end
  fun as_float64(): F64? => _struct.assert_union(0x0, 11)?; _struct.f64(0x8)
  fun is_float64(): Bool => _struct.check_union(0x0, 11)
  
  fun text(): String => get_text()
  fun get_text(): String => try if _struct.check_union(0x0, 12) then _struct.ptr_text(0)? else error end else "" end
  fun as_text(): String? => _struct.assert_union(0x0, 12)?; try _struct.ptr_text(0)? else "" end
  fun is_text(): Bool => _struct.check_union(0x0, 12)
  
  fun data(): Array[U8] val => get_data()
  fun get_data(): Array[U8] val => try if _struct.check_union(0x0, 13) then _struct.ptr_data(0)? else error end else recover val Array[U8] end end
  fun as_data(): Array[U8] val? => _struct.assert_union(0x0, 13)?; try _struct.ptr_data(0)? else recover val Array[U8] end end
  fun is_data(): Bool => _struct.check_union(0x0, 13)
  
  fun list(): CapnEntityPtr? => get_list()?
  fun get_list(): CapnEntityPtr? => try if _struct.check_union(0x0, 14) then _struct.ptr(0)? /* TODO: better type? */ else error end else error end
  fun as_list(): CapnEntityPtr? => _struct.assert_union(0x0, 14)?; try _struct.ptr(0)? /* TODO: better type? */ else error end
  fun is_list(): Bool => _struct.check_union(0x0, 14)
  
  fun enum(): U16 => get_enum()
  fun get_enum(): U16 => if _struct.check_union(0x0, 15) then _struct.u16(0x2) else 0 end
  fun as_enum(): U16? => _struct.assert_union(0x0, 15)?; _struct.u16(0x2)
  fun is_enum(): Bool => _struct.check_union(0x0, 15)
  
  // fun struct(): CapnEntityPtr? => get_struct()? // DISABLED: invalid Pony function name
  fun get_struct(): CapnEntityPtr? => try if _struct.check_union(0x0, 16) then _struct.ptr(0)? /* TODO: better type? */ else error end else error end
  fun as_struct(): CapnEntityPtr? => _struct.assert_union(0x0, 16)?; try _struct.ptr(0)? /* TODO: better type? */ else error end
  fun is_struct(): Bool => _struct.check_union(0x0, 16)
  
  // fun interface(): None => get_interface() // DISABLED: invalid Pony function name
  fun get_interface(): None => None
  fun as_interface(): None? => _struct.assert_union(0x0, 17)?; None
  fun is_interface(): Bool => _struct.check_union(0x0, 17)
  
  fun anyPointer(): CapnEntityPtr? => get_anyPointer()?
  fun get_anyPointer(): CapnEntityPtr? => try if _struct.check_union(0x0, 18) then _struct.ptr(0)? /* TODO: better type? */ else error end else error end
  fun as_anyPointer(): CapnEntityPtr? => _struct.assert_union(0x0, 18)?; try _struct.ptr(0)? /* TODO: better type? */ else error end
  fun is_anyPointer(): Bool => _struct.check_union(0x0, 18)

class val Annotation is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*2); _struct = s'
  
  fun id(): U64 => get_id()
  fun get_id(): U64 => _struct.u64(0x0)
  
  fun value(): Value => get_value()
  fun get_value(): Value => try _struct.ptr_struct[Value](0)? else _struct.ptr_emptystruct[Value]() end
  
  fun brand(): Brand => get_brand()
  fun get_brand(): Brand => try _struct.ptr_struct[Brand](1)? else _struct.ptr_emptystruct[Brand]() end

class val ElementSize is CapnEnum let _value: U16
  fun apply(): U16 => _value
  new val create(value': U16) => _value = value'
  
  new val empty() => _value = 0
  new val value_empty() => _value = 0
  
  new val bit() => _value = 1
  new val value_bit() => _value = 1
  
  new val byte() => _value = 2
  new val value_byte() => _value = 2
  
  new val twoBytes() => _value = 3
  new val value_twoBytes() => _value = 3
  
  new val fourBytes() => _value = 4
  new val value_fourBytes() => _value = 4
  
  new val eightBytes() => _value = 5
  new val value_eightBytes() => _value = 5
  
  new val pointer() => _value = 6
  new val value_pointer() => _value = 6
  
  new val inlineComposite() => _value = 7
  new val value_inlineComposite() => _value = 7

class val CodeGeneratorRequest is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x0, 8*2); _struct = s'
  
  fun nodes(): CapnList[Node] => get_nodes()
  fun get_nodes(): CapnList[Node] => try _struct.ptr_list[Node](0)? else _struct.ptr_emptylist[Node]() end
  
  fun requestedFiles(): CapnList[CodeGeneratorRequestRequestedFile] => get_requestedFiles()
  fun get_requestedFiles(): CapnList[CodeGeneratorRequestRequestedFile] => try _struct.ptr_list[CodeGeneratorRequestRequestedFile](1)? else _struct.ptr_emptylist[CodeGeneratorRequestRequestedFile]() end

class val CodeGeneratorRequestRequestedFile is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*2); _struct = s'
  
  fun id(): U64 => get_id()
  fun get_id(): U64 => _struct.u64(0x0)
  
  fun filename(): String => get_filename()
  fun get_filename(): String => try _struct.ptr_text(0)? else "" end
  
  fun imports(): CapnList[CodeGeneratorRequestRequestedFileImport] => get_imports()
  fun get_imports(): CapnList[CodeGeneratorRequestRequestedFileImport] => try _struct.ptr_list[CodeGeneratorRequestRequestedFileImport](1)? else _struct.ptr_emptylist[CodeGeneratorRequestRequestedFileImport]() end

class val CodeGeneratorRequestRequestedFileImport is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*1); _struct = s'
  
  fun id(): U64 => get_id()
  fun get_id(): U64 => _struct.u64(0x0)
  
  fun name(): String => get_name()
  fun get_name(): String => try _struct.ptr_text(0)? else "" end
