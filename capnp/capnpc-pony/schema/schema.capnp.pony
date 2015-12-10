
use "../.."

class val Node is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x28, 8*6); _struct = s'
  fun id(): U64 => _struct.u64(0x0)
  fun displayName(): String => try _struct.ptr_text(0) else "" end
  fun displayNamePrefixLength(): U32 => _struct.u32(0x8)
  fun scopeId(): U64 => _struct.u64(0x10)
  fun nestedNodes(): CapnList[NodeNestedNode] => try _struct.ptr_list[NodeNestedNode](1) else _struct.ptr_emptylist[NodeNestedNode]() end
  fun annotations(): CapnList[Annotation] => try _struct.ptr_list[Annotation](2) else _struct.ptr_emptylist[Annotation]() end
  fun parameters(): CapnList[NodeParameter] => try _struct.ptr_list[NodeParameter](5) else _struct.ptr_emptylist[NodeParameter]() end
  fun isGeneric(): Bool => _struct.bool(0x24, 0b00000001)
  fun file(): None => None
  fun get_struct(): NodeGROUPstruct => if _struct.check_union(0xC, 1) then NodeGROUPstruct(_struct) else _struct.ptr_emptystruct[NodeGROUPstruct]() end
  fun enum(): NodeGROUPenum => if _struct.check_union(0xC, 2) then NodeGROUPenum(_struct) else _struct.ptr_emptystruct[NodeGROUPenum]() end
  fun get_interface(): NodeGROUPinterface => if _struct.check_union(0xC, 3) then NodeGROUPinterface(_struct) else _struct.ptr_emptystruct[NodeGROUPinterface]() end
  fun const(): NodeGROUPconst => if _struct.check_union(0xC, 4) then NodeGROUPconst(_struct) else _struct.ptr_emptystruct[NodeGROUPconst]() end
  fun annotation(): NodeGROUPannotation => if _struct.check_union(0xC, 5) then NodeGROUPannotation(_struct) else _struct.ptr_emptystruct[NodeGROUPannotation]() end
  fun is_file(): Bool => _struct.check_union(0xC, 0)
  fun is_struct(): Bool => _struct.check_union(0xC, 1)
  fun is_enum(): Bool => _struct.check_union(0xC, 2)
  fun is_interface(): Bool => _struct.check_union(0xC, 3)
  fun is_const(): Bool => _struct.check_union(0xC, 4)
  fun is_annotation(): Bool => _struct.check_union(0xC, 5)

class val NodeGROUPstruct is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun dataWordCount(): U16 => _struct.u16(0xE)
  fun pointerCount(): U16 => _struct.u16(0x18)
  fun preferredListEncoding(): ElementSize => ElementSize(_struct.u16(0x1A))
  fun isGroup(): Bool => _struct.bool(0x1C, 0b00000001)
  fun discriminantCount(): U16 => _struct.u16(0x1E)
  fun discriminantOffset(): U32 => _struct.u32(0x20)
  fun fields(): CapnList[Field] => try _struct.ptr_list[Field](3) else _struct.ptr_emptylist[Field]() end

class val NodeGROUPenum is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun enumerants(): CapnList[Enumerant] => try _struct.ptr_list[Enumerant](3) else _struct.ptr_emptylist[Enumerant]() end

class val NodeGROUPinterface is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun methods(): CapnList[Method] => try _struct.ptr_list[Method](3) else _struct.ptr_emptylist[Method]() end
  fun superclasses(): CapnList[Superclass] => try _struct.ptr_list[Superclass](4) else _struct.ptr_emptylist[Superclass]() end

class val NodeGROUPconst is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun get_type(): Type => try _struct.ptr_struct[Type](3) else _struct.ptr_emptystruct[Type]() end
  fun value(): Value => try _struct.ptr_struct[Value](4) else _struct.ptr_emptystruct[Value]() end

class val NodeGROUPannotation is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun get_type(): Type => try _struct.ptr_struct[Type](3) else _struct.ptr_emptystruct[Type]() end
  fun targetsFile(): Bool => _struct.bool(0xE, 0b00000001)
  fun targetsConst(): Bool => _struct.bool(0xE, 0b00000010)
  fun targetsEnum(): Bool => _struct.bool(0xE, 0b00000100)
  fun targetsEnumerant(): Bool => _struct.bool(0xE, 0b00001000)
  fun targetsStruct(): Bool => _struct.bool(0xE, 0b00010000)
  fun targetsField(): Bool => _struct.bool(0xE, 0b00100000)
  fun targetsUnion(): Bool => _struct.bool(0xE, 0b01000000)
  fun targetsGroup(): Bool => _struct.bool(0xE, 0b10000000)
  fun targetsInterface(): Bool => _struct.bool(0xF, 0b00000001)
  fun targetsMethod(): Bool => _struct.bool(0xF, 0b00000010)
  fun targetsParam(): Bool => _struct.bool(0xF, 0b00000100)
  fun targetsAnnotation(): Bool => _struct.bool(0xF, 0b00001000)

class val NodeParameter is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x0, 8*1); _struct = s'
  fun name(): String => try _struct.ptr_text(0) else "" end

class val NodeNestedNode is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*1); _struct = s'
  fun name(): String => try _struct.ptr_text(0) else "" end
  fun id(): U64 => _struct.u64(0x0)

class val Field is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x18, 8*4); _struct = s'
  fun name(): String => try _struct.ptr_text(0) else "" end
  fun codeOrder(): U16 => _struct.u16(0x0)
  fun annotations(): CapnList[Annotation] => try _struct.ptr_list[Annotation](1) else _struct.ptr_emptylist[Annotation]() end
  fun discriminantValue(): U16 => 65535 xor _struct.u16(0x2)
  fun ordinal(): FieldGROUPordinal => FieldGROUPordinal(_struct)
  fun slot(): FieldGROUPslot => if _struct.check_union(0x8, 0) then FieldGROUPslot(_struct) else _struct.ptr_emptystruct[FieldGROUPslot]() end
  fun group(): FieldGROUPgroup => if _struct.check_union(0x8, 1) then FieldGROUPgroup(_struct) else _struct.ptr_emptystruct[FieldGROUPgroup]() end
  fun is_slot(): Bool => _struct.check_union(0x8, 0)
  fun is_group(): Bool => _struct.check_union(0x8, 1)

class val FieldGROUPslot is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun offset(): U32 => _struct.u32(0x4)
  fun get_type(): Type => try _struct.ptr_struct[Type](2) else _struct.ptr_emptystruct[Type]() end
  fun defaultValue(): Value => try _struct.ptr_struct[Value](3) else _struct.ptr_emptystruct[Value]() end
  fun hadExplicitDefault(): Bool => _struct.bool(0x10, 0b00000001)

class val FieldGROUPgroup is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun typeId(): U64 => _struct.u64(0x10)

class val FieldGROUPordinal is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun implicit(): None => None
  fun explicit(): U16 => if _struct.check_union(0xA, 1) then _struct.u16(0xC) else 0 end
  fun is_implicit(): Bool => _struct.check_union(0xA, 0)
  fun is_explicit(): Bool => _struct.check_union(0xA, 1)
// UNHANDLED: schema/schema.capnp:Field.noDiscriminant

class val Enumerant is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*2); _struct = s'
  fun name(): String => try _struct.ptr_text(0) else "" end
  fun codeOrder(): U16 => _struct.u16(0x0)
  fun annotations(): CapnList[Annotation] => try _struct.ptr_list[Annotation](1) else _struct.ptr_emptylist[Annotation]() end

class val Superclass is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*1); _struct = s'
  fun id(): U64 => _struct.u64(0x0)
  fun brand(): Brand => try _struct.ptr_struct[Brand](0) else _struct.ptr_emptystruct[Brand]() end

class val Method is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x18, 8*5); _struct = s'
  fun name(): String => try _struct.ptr_text(0) else "" end
  fun codeOrder(): U16 => _struct.u16(0x0)
  fun paramStructType(): U64 => _struct.u64(0x8)
  fun resultStructType(): U64 => _struct.u64(0x10)
  fun annotations(): CapnList[Annotation] => try _struct.ptr_list[Annotation](1) else _struct.ptr_emptylist[Annotation]() end
  fun paramBrand(): Brand => try _struct.ptr_struct[Brand](2) else _struct.ptr_emptystruct[Brand]() end
  fun resultBrand(): Brand => try _struct.ptr_struct[Brand](3) else _struct.ptr_emptystruct[Brand]() end
  fun implicitParameters(): CapnList[NodeParameter] => try _struct.ptr_list[NodeParameter](4) else _struct.ptr_emptylist[NodeParameter]() end

class val Type is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x18, 8*1); _struct = s'
  fun void(): None => None
  fun bool(): None => None
  fun int8(): None => None
  fun int16(): None => None
  fun int32(): None => None
  fun int64(): None => None
  fun uint8(): None => None
  fun uint16(): None => None
  fun uint32(): None => None
  fun uint64(): None => None
  fun float32(): None => None
  fun float64(): None => None
  fun text(): None => None
  fun data(): None => None
  fun list(): TypeGROUPlist => if _struct.check_union(0x0, 14) then TypeGROUPlist(_struct) else _struct.ptr_emptystruct[TypeGROUPlist]() end
  fun enum(): TypeGROUPenum => if _struct.check_union(0x0, 15) then TypeGROUPenum(_struct) else _struct.ptr_emptystruct[TypeGROUPenum]() end
  fun get_struct(): TypeGROUPstruct => if _struct.check_union(0x0, 16) then TypeGROUPstruct(_struct) else _struct.ptr_emptystruct[TypeGROUPstruct]() end
  fun get_interface(): TypeGROUPinterface => if _struct.check_union(0x0, 17) then TypeGROUPinterface(_struct) else _struct.ptr_emptystruct[TypeGROUPinterface]() end
  fun anyPointer(): TypeGROUPanyPointer => if _struct.check_union(0x0, 18) then TypeGROUPanyPointer(_struct) else _struct.ptr_emptystruct[TypeGROUPanyPointer]() end
  fun is_void(): Bool => _struct.check_union(0x0, 0)
  fun is_bool(): Bool => _struct.check_union(0x0, 1)
  fun is_int8(): Bool => _struct.check_union(0x0, 2)
  fun is_int16(): Bool => _struct.check_union(0x0, 3)
  fun is_int32(): Bool => _struct.check_union(0x0, 4)
  fun is_int64(): Bool => _struct.check_union(0x0, 5)
  fun is_uint8(): Bool => _struct.check_union(0x0, 6)
  fun is_uint16(): Bool => _struct.check_union(0x0, 7)
  fun is_uint32(): Bool => _struct.check_union(0x0, 8)
  fun is_uint64(): Bool => _struct.check_union(0x0, 9)
  fun is_float32(): Bool => _struct.check_union(0x0, 10)
  fun is_float64(): Bool => _struct.check_union(0x0, 11)
  fun is_text(): Bool => _struct.check_union(0x0, 12)
  fun is_data(): Bool => _struct.check_union(0x0, 13)
  fun is_list(): Bool => _struct.check_union(0x0, 14)
  fun is_enum(): Bool => _struct.check_union(0x0, 15)
  fun is_struct(): Bool => _struct.check_union(0x0, 16)
  fun is_interface(): Bool => _struct.check_union(0x0, 17)
  fun is_anyPointer(): Bool => _struct.check_union(0x0, 18)

class val TypeGROUPlist is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun elementType(): Type => try _struct.ptr_struct[Type](0) else _struct.ptr_emptystruct[Type]() end

class val TypeGROUPenum is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun typeId(): U64 => _struct.u64(0x8)
  fun brand(): Brand => try _struct.ptr_struct[Brand](0) else _struct.ptr_emptystruct[Brand]() end

class val TypeGROUPstruct is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun typeId(): U64 => _struct.u64(0x8)
  fun brand(): Brand => try _struct.ptr_struct[Brand](0) else _struct.ptr_emptystruct[Brand]() end

class val TypeGROUPinterface is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun typeId(): U64 => _struct.u64(0x8)
  fun brand(): Brand => try _struct.ptr_struct[Brand](0) else _struct.ptr_emptystruct[Brand]() end

class val TypeGROUPanyPointer is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun unconstrained(): TypeGROUPanyPointerGROUPunconstrained => if _struct.check_union(0x8, 0) then TypeGROUPanyPointerGROUPunconstrained(_struct) else _struct.ptr_emptystruct[TypeGROUPanyPointerGROUPunconstrained]() end
  fun parameter(): TypeGROUPanyPointerGROUPparameter => if _struct.check_union(0x8, 1) then TypeGROUPanyPointerGROUPparameter(_struct) else _struct.ptr_emptystruct[TypeGROUPanyPointerGROUPparameter]() end
  fun implicitMethodParameter(): TypeGROUPanyPointerGROUPimplicitMethodParameter => if _struct.check_union(0x8, 2) then TypeGROUPanyPointerGROUPimplicitMethodParameter(_struct) else _struct.ptr_emptystruct[TypeGROUPanyPointerGROUPimplicitMethodParameter]() end
  fun is_unconstrained(): Bool => _struct.check_union(0x8, 0)
  fun is_parameter(): Bool => _struct.check_union(0x8, 1)
  fun is_implicitMethodParameter(): Bool => _struct.check_union(0x8, 2)

class val TypeGROUPanyPointerGROUPunconstrained is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun anyKind(): None => None
  fun get_struct(): None => None
  fun list(): None => None
  fun capability(): None => None
  fun is_anyKind(): Bool => _struct.check_union(0xA, 0)
  fun is_struct(): Bool => _struct.check_union(0xA, 1)
  fun is_list(): Bool => _struct.check_union(0xA, 2)
  fun is_capability(): Bool => _struct.check_union(0xA, 3)

class val TypeGROUPanyPointerGROUPparameter is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun scopeId(): U64 => _struct.u64(0x10)
  fun parameterIndex(): U16 => _struct.u16(0xA)

class val TypeGROUPanyPointerGROUPimplicitMethodParameter is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun parameterIndex(): U16 => _struct.u16(0xA)

class val Brand is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x0, 8*1); _struct = s'
  fun scopes(): CapnList[BrandScope] => try _struct.ptr_list[BrandScope](0) else _struct.ptr_emptylist[BrandScope]() end

class val BrandScope is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x10, 8*1); _struct = s'
  fun scopeId(): U64 => _struct.u64(0x0)
  fun bind(): CapnList[BrandBinding] => try if _struct.check_union(0x8, 0) then _struct.ptr_list[BrandBinding](0) else error end else _struct.ptr_emptylist[BrandBinding]() end
  fun inherit(): None => None
  fun is_bind(): Bool => _struct.check_union(0x8, 0)
  fun is_inherit(): Bool => _struct.check_union(0x8, 1)

class val BrandBinding is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*1); _struct = s'
  fun unbound(): None => None
  fun get_type(): Type => try if _struct.check_union(0x0, 1) then _struct.ptr_struct[Type](0) else error end else _struct.ptr_emptystruct[Type]() end
  fun is_unbound(): Bool => _struct.check_union(0x0, 0)
  fun is_type(): Bool => _struct.check_union(0x0, 1)

class val Value is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x10, 8*1); _struct = s'
  fun void(): None => None
  fun bool(): Bool => if _struct.check_union(0x0, 1) then _struct.bool(0x2, 0b00000001) else false end
  fun int8(): I8 => if _struct.check_union(0x0, 2) then _struct.i8(0x2) else 0 end
  fun int16(): I16 => if _struct.check_union(0x0, 3) then _struct.i16(0x2) else 0 end
  fun int32(): I32 => if _struct.check_union(0x0, 4) then _struct.i32(0x4) else 0 end
  fun int64(): I64 => if _struct.check_union(0x0, 5) then _struct.i64(0x8) else 0 end
  fun uint8(): U8 => if _struct.check_union(0x0, 6) then _struct.u8(0x2) else 0 end
  fun uint16(): U16 => if _struct.check_union(0x0, 7) then _struct.u16(0x2) else 0 end
  fun uint32(): U32 => if _struct.check_union(0x0, 8) then _struct.u32(0x4) else 0 end
  fun uint64(): U64 => if _struct.check_union(0x0, 9) then _struct.u64(0x8) else 0 end
  fun float32(): F32 => if _struct.check_union(0x0, 10) then _struct.f32(0x4) else 0 end
  fun float64(): F64 => if _struct.check_union(0x0, 11) then _struct.f64(0x8) else 0 end
  fun text(): String => try if _struct.check_union(0x0, 12) then _struct.ptr_text(0) else error end else "" end
  fun data(): Array[U8] val => try if _struct.check_union(0x0, 13) then _struct.ptr_data(0) else error end else recover val Array[U8] end end
  fun list(): CapnEntityPtr? => if _struct.check_union(0x0, 14) then _struct.ptr(0) else error end // TODO: better return type?
  fun enum(): U16 => if _struct.check_union(0x0, 15) then _struct.u16(0x2) else 0 end
  fun get_struct(): CapnEntityPtr? => if _struct.check_union(0x0, 16) then _struct.ptr(0) else error end // TODO: better return type?
  fun get_interface(): None => None
  fun anyPointer(): CapnEntityPtr? => if _struct.check_union(0x0, 18) then _struct.ptr(0) else error end // TODO: better return type?
  fun is_void(): Bool => _struct.check_union(0x0, 0)
  fun is_bool(): Bool => _struct.check_union(0x0, 1)
  fun is_int8(): Bool => _struct.check_union(0x0, 2)
  fun is_int16(): Bool => _struct.check_union(0x0, 3)
  fun is_int32(): Bool => _struct.check_union(0x0, 4)
  fun is_int64(): Bool => _struct.check_union(0x0, 5)
  fun is_uint8(): Bool => _struct.check_union(0x0, 6)
  fun is_uint16(): Bool => _struct.check_union(0x0, 7)
  fun is_uint32(): Bool => _struct.check_union(0x0, 8)
  fun is_uint64(): Bool => _struct.check_union(0x0, 9)
  fun is_float32(): Bool => _struct.check_union(0x0, 10)
  fun is_float64(): Bool => _struct.check_union(0x0, 11)
  fun is_text(): Bool => _struct.check_union(0x0, 12)
  fun is_data(): Bool => _struct.check_union(0x0, 13)
  fun is_list(): Bool => _struct.check_union(0x0, 14)
  fun is_enum(): Bool => _struct.check_union(0x0, 15)
  fun is_struct(): Bool => _struct.check_union(0x0, 16)
  fun is_interface(): Bool => _struct.check_union(0x0, 17)
  fun is_anyPointer(): Bool => _struct.check_union(0x0, 18)

class val Annotation is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*2); _struct = s'
  fun id(): U64 => _struct.u64(0x0)
  fun value(): Value => try _struct.ptr_struct[Value](0) else _struct.ptr_emptystruct[Value]() end
  fun brand(): Brand => try _struct.ptr_struct[Brand](1) else _struct.ptr_emptystruct[Brand]() end

class val ElementSize is CapnEnum let _value: U16
  fun apply(): U16 => _value
  new val create(value': U16) => _value = value'
  new val empty() => _value = 0
  new val bit() => _value = 1
  new val byte() => _value = 2
  new val twoBytes() => _value = 3
  new val fourBytes() => _value = 4
  new val eightBytes() => _value = 5
  new val pointer() => _value = 6
  new val inlineComposite() => _value = 7

class val CodeGeneratorRequest is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x0, 8*2); _struct = s'
  fun nodes(): CapnList[Node] => try _struct.ptr_list[Node](0) else _struct.ptr_emptylist[Node]() end
  fun requestedFiles(): CapnList[CodeGeneratorRequestRequestedFile] => try _struct.ptr_list[CodeGeneratorRequestRequestedFile](1) else _struct.ptr_emptylist[CodeGeneratorRequestRequestedFile]() end

class val CodeGeneratorRequestRequestedFile is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*2); _struct = s'
  fun id(): U64 => _struct.u64(0x0)
  fun filename(): String => try _struct.ptr_text(0) else "" end
  fun imports(): CapnList[CodeGeneratorRequestRequestedFileImport] => try _struct.ptr_list[CodeGeneratorRequestRequestedFileImport](1) else _struct.ptr_emptylist[CodeGeneratorRequestRequestedFileImport]() end

class val CodeGeneratorRequestRequestedFileImport is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => s'.verify(0x8, 8*1); _struct = s'
  fun id(): U64 => _struct.u64(0x0)
  fun name(): String => try _struct.ptr_text(0) else "" end
