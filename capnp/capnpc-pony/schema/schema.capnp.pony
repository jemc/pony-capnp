
use "../.."

class val Node is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x28, 8*6); _struct = s'
  fun id(): U64 => _struct.u64(0x0)
  fun displayName(): String? => _struct.ptr_text(0)
  fun displayNamePrefixLength(): U32 => _struct.u32(0x8)
  fun scopeId(): U64 => _struct.u64(0x10)
  fun nestedNodes(): CapnList[NodeNestedNode] => _struct.ptr_list[NodeNestedNode](1)
  fun annotations(): CapnList[Annotation] => _struct.ptr_list[Annotation](2)
  fun parameters(): CapnList[NodeParameter] => _struct.ptr_list[NodeParameter](5)
  fun isGeneric(): Bool => _struct.bool(0x24, 0b00000001)
  fun union_file(): None? => _struct.assert_union(0xC, 0); None
  fun union_struct(): NodeGROUPstruct? => _struct.assert_union(0xC, 1); NodeGROUPstruct(_struct)
  fun union_enum(): NodeGROUPenum? => _struct.assert_union(0xC, 2); NodeGROUPenum(_struct)
  fun union_interface(): NodeGROUPinterface? => _struct.assert_union(0xC, 3); NodeGROUPinterface(_struct)
  fun union_const(): NodeGROUPconst? => _struct.assert_union(0xC, 4); NodeGROUPconst(_struct)
  fun union_annotation(): NodeGROUPannotation? => _struct.assert_union(0xC, 5); NodeGROUPannotation(_struct)
  fun union_is_file(): Bool => _struct.check_union(0xC, 0)
  fun union_is_struct(): Bool => _struct.check_union(0xC, 1)
  fun union_is_enum(): Bool => _struct.check_union(0xC, 2)
  fun union_is_interface(): Bool => _struct.check_union(0xC, 3)
  fun union_is_const(): Bool => _struct.check_union(0xC, 4)
  fun union_is_annotation(): Bool => _struct.check_union(0xC, 5)

class val NodeGROUPstruct is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun dataWordCount(): U16 => _struct.u16(0xE)
  fun pointerCount(): U16 => _struct.u16(0x18)
  fun preferredListEncoding(): ElementSize => ElementSize(_struct.u16(0x1A))
  fun isGroup(): Bool => _struct.bool(0x1C, 0b00000001)
  fun discriminantCount(): U16 => _struct.u16(0x1E)
  fun discriminantOffset(): U32 => _struct.u32(0x20)
  fun fields(): CapnList[Field] => _struct.ptr_list[Field](3)

class val NodeGROUPenum is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun enumerants(): CapnList[Enumerant] => _struct.ptr_list[Enumerant](3)

class val NodeGROUPinterface is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun methods(): CapnList[Method] => _struct.ptr_list[Method](3)
  fun superclasses(): CapnList[Superclass] => _struct.ptr_list[Superclass](4)

class val NodeGROUPconst is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun get_type(): Type? => _struct.ptr_struct[Type](3)
  fun value(): Value? => _struct.ptr_struct[Value](4)

class val NodeGROUPannotation is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun get_type(): Type? => _struct.ptr_struct[Type](3)
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
  new val create(s': CapnStructPtr)? => s'.verify(0x0, 8*1); _struct = s'
  fun name(): String? => _struct.ptr_text(0)

class val NodeNestedNode is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x8, 8*1); _struct = s'
  fun name(): String? => _struct.ptr_text(0)
  fun id(): U64 => _struct.u64(0x0)

class val Field is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x18, 8*4); _struct = s'
  fun name(): String? => _struct.ptr_text(0)
  fun codeOrder(): U16 => _struct.u16(0x0)
  fun annotations(): CapnList[Annotation] => _struct.ptr_list[Annotation](1)
  fun discriminantValue(): U16 => 65535 xor _struct.u16(0x2)
  fun ordinal(): FieldGROUPordinal => FieldGROUPordinal(_struct)
  fun union_slot(): FieldGROUPslot? => _struct.assert_union(0x8, 0); FieldGROUPslot(_struct)
  fun union_group(): FieldGROUPgroup? => _struct.assert_union(0x8, 1); FieldGROUPgroup(_struct)
  fun union_is_slot(): Bool => _struct.check_union(0x8, 0)
  fun union_is_group(): Bool => _struct.check_union(0x8, 1)

class val FieldGROUPslot is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun offset(): U32 => _struct.u32(0x4)
  fun get_type(): Type? => _struct.ptr_struct[Type](2)
  fun defaultValue(): Value? => _struct.ptr_struct[Value](3)
  fun hadExplicitDefault(): Bool => _struct.bool(0x10, 0b00000001)

class val FieldGROUPgroup is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun typeId(): U64 => _struct.u64(0x10)

class val FieldGROUPordinal is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun union_implicit(): None? => _struct.assert_union(0xA, 0); None
  fun union_explicit(): U16? => _struct.assert_union(0xA, 1); _struct.u16(0xC)
  fun union_is_implicit(): Bool => _struct.check_union(0xA, 0)
  fun union_is_explicit(): Bool => _struct.check_union(0xA, 1)
// UNHANDLED: schema/schema.capnp:Field.noDiscriminant

class val Enumerant is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x8, 8*2); _struct = s'
  fun name(): String? => _struct.ptr_text(0)
  fun codeOrder(): U16 => _struct.u16(0x0)
  fun annotations(): CapnList[Annotation] => _struct.ptr_list[Annotation](1)

class val Superclass is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x8, 8*1); _struct = s'
  fun id(): U64 => _struct.u64(0x0)
  fun brand(): Brand? => _struct.ptr_struct[Brand](0)

class val Method is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x18, 8*5); _struct = s'
  fun name(): String? => _struct.ptr_text(0)
  fun codeOrder(): U16 => _struct.u16(0x0)
  fun paramStructType(): U64 => _struct.u64(0x8)
  fun resultStructType(): U64 => _struct.u64(0x10)
  fun annotations(): CapnList[Annotation] => _struct.ptr_list[Annotation](1)
  fun paramBrand(): Brand? => _struct.ptr_struct[Brand](2)
  fun resultBrand(): Brand? => _struct.ptr_struct[Brand](3)
  fun implicitParameters(): CapnList[NodeParameter] => _struct.ptr_list[NodeParameter](4)

class val Type is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x18, 8*1); _struct = s'
  fun union_void(): None? => _struct.assert_union(0x0, 0); None
  fun union_bool(): None? => _struct.assert_union(0x0, 1); None
  fun union_int8(): None? => _struct.assert_union(0x0, 2); None
  fun union_int16(): None? => _struct.assert_union(0x0, 3); None
  fun union_int32(): None? => _struct.assert_union(0x0, 4); None
  fun union_int64(): None? => _struct.assert_union(0x0, 5); None
  fun union_uint8(): None? => _struct.assert_union(0x0, 6); None
  fun union_uint16(): None? => _struct.assert_union(0x0, 7); None
  fun union_uint32(): None? => _struct.assert_union(0x0, 8); None
  fun union_uint64(): None? => _struct.assert_union(0x0, 9); None
  fun union_float32(): None? => _struct.assert_union(0x0, 10); None
  fun union_float64(): None? => _struct.assert_union(0x0, 11); None
  fun union_text(): None? => _struct.assert_union(0x0, 12); None
  fun union_data(): None? => _struct.assert_union(0x0, 13); None
  fun union_list(): TypeGROUPlist? => _struct.assert_union(0x0, 14); TypeGROUPlist(_struct)
  fun union_enum(): TypeGROUPenum? => _struct.assert_union(0x0, 15); TypeGROUPenum(_struct)
  fun union_struct(): TypeGROUPstruct? => _struct.assert_union(0x0, 16); TypeGROUPstruct(_struct)
  fun union_interface(): TypeGROUPinterface? => _struct.assert_union(0x0, 17); TypeGROUPinterface(_struct)
  fun union_anyPointer(): TypeGROUPanyPointer? => _struct.assert_union(0x0, 18); TypeGROUPanyPointer(_struct)
  fun union_is_void(): Bool => _struct.check_union(0x0, 0)
  fun union_is_bool(): Bool => _struct.check_union(0x0, 1)
  fun union_is_int8(): Bool => _struct.check_union(0x0, 2)
  fun union_is_int16(): Bool => _struct.check_union(0x0, 3)
  fun union_is_int32(): Bool => _struct.check_union(0x0, 4)
  fun union_is_int64(): Bool => _struct.check_union(0x0, 5)
  fun union_is_uint8(): Bool => _struct.check_union(0x0, 6)
  fun union_is_uint16(): Bool => _struct.check_union(0x0, 7)
  fun union_is_uint32(): Bool => _struct.check_union(0x0, 8)
  fun union_is_uint64(): Bool => _struct.check_union(0x0, 9)
  fun union_is_float32(): Bool => _struct.check_union(0x0, 10)
  fun union_is_float64(): Bool => _struct.check_union(0x0, 11)
  fun union_is_text(): Bool => _struct.check_union(0x0, 12)
  fun union_is_data(): Bool => _struct.check_union(0x0, 13)
  fun union_is_list(): Bool => _struct.check_union(0x0, 14)
  fun union_is_enum(): Bool => _struct.check_union(0x0, 15)
  fun union_is_struct(): Bool => _struct.check_union(0x0, 16)
  fun union_is_interface(): Bool => _struct.check_union(0x0, 17)
  fun union_is_anyPointer(): Bool => _struct.check_union(0x0, 18)

class val TypeGROUPlist is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun elementType(): Type? => _struct.ptr_struct[Type](0)

class val TypeGROUPenum is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun typeId(): U64 => _struct.u64(0x8)
  fun brand(): Brand? => _struct.ptr_struct[Brand](0)

class val TypeGROUPstruct is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun typeId(): U64 => _struct.u64(0x8)
  fun brand(): Brand? => _struct.ptr_struct[Brand](0)

class val TypeGROUPinterface is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun typeId(): U64 => _struct.u64(0x8)
  fun brand(): Brand? => _struct.ptr_struct[Brand](0)

class val TypeGROUPanyPointer is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun union_unconstrained(): TypeGROUPanyPointerGROUPunconstrained? => _struct.assert_union(0x8, 0); TypeGROUPanyPointerGROUPunconstrained(_struct)
  fun union_parameter(): TypeGROUPanyPointerGROUPparameter? => _struct.assert_union(0x8, 1); TypeGROUPanyPointerGROUPparameter(_struct)
  fun union_implicitMethodParameter(): TypeGROUPanyPointerGROUPimplicitMethodParameter? => _struct.assert_union(0x8, 2); TypeGROUPanyPointerGROUPimplicitMethodParameter(_struct)
  fun union_is_unconstrained(): Bool => _struct.check_union(0x8, 0)
  fun union_is_parameter(): Bool => _struct.check_union(0x8, 1)
  fun union_is_implicitMethodParameter(): Bool => _struct.check_union(0x8, 2)

class val TypeGROUPanyPointerGROUPunconstrained is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun union_anyKind(): None? => _struct.assert_union(0xA, 0); None
  fun union_struct(): None? => _struct.assert_union(0xA, 1); None
  fun union_list(): None? => _struct.assert_union(0xA, 2); None
  fun union_capability(): None? => _struct.assert_union(0xA, 3); None
  fun union_is_anyKind(): Bool => _struct.check_union(0xA, 0)
  fun union_is_struct(): Bool => _struct.check_union(0xA, 1)
  fun union_is_list(): Bool => _struct.check_union(0xA, 2)
  fun union_is_capability(): Bool => _struct.check_union(0xA, 3)

class val TypeGROUPanyPointerGROUPparameter is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun scopeId(): U64 => _struct.u64(0x10)
  fun parameterIndex(): U16 => _struct.u16(0xA)

class val TypeGROUPanyPointerGROUPimplicitMethodParameter is CapnGroup let _struct: CapnStructPtr
  new val create(s': CapnStructPtr) => _struct = s'
  fun parameterIndex(): U16 => _struct.u16(0xA)

class val Brand is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x0, 8*1); _struct = s'
  fun scopes(): CapnList[BrandScope] => _struct.ptr_list[BrandScope](0)

class val BrandScope is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x10, 8*1); _struct = s'
  fun scopeId(): U64 => _struct.u64(0x0)
  fun union_bind(): CapnList[BrandBinding]? => _struct.assert_union(0x8, 0); _struct.ptr_list[BrandBinding](0)
  fun union_inherit(): None? => _struct.assert_union(0x8, 1); None
  fun union_is_bind(): Bool => _struct.check_union(0x8, 0)
  fun union_is_inherit(): Bool => _struct.check_union(0x8, 1)

class val BrandBinding is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x8, 8*1); _struct = s'
  fun union_unbound(): None? => _struct.assert_union(0x0, 0); None
  fun union_type(): Type? => _struct.assert_union(0x0, 1); _struct.ptr_struct[Type](0)
  fun union_is_unbound(): Bool => _struct.check_union(0x0, 0)
  fun union_is_type(): Bool => _struct.check_union(0x0, 1)

class val Value is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x10, 8*1); _struct = s'
  fun union_void(): None? => _struct.assert_union(0x0, 0); None
  fun union_bool(): Bool? => _struct.assert_union(0x0, 1); _struct.bool(0x2, 0b00000001)
  fun union_int8(): I8? => _struct.assert_union(0x0, 2); _struct.i8(0x2)
  fun union_int16(): I16? => _struct.assert_union(0x0, 3); _struct.i16(0x2)
  fun union_int32(): I32? => _struct.assert_union(0x0, 4); _struct.i32(0x4)
  fun union_int64(): I64? => _struct.assert_union(0x0, 5); _struct.i64(0x8)
  fun union_uint8(): U8? => _struct.assert_union(0x0, 6); _struct.u8(0x2)
  fun union_uint16(): U16? => _struct.assert_union(0x0, 7); _struct.u16(0x2)
  fun union_uint32(): U32? => _struct.assert_union(0x0, 8); _struct.u32(0x4)
  fun union_uint64(): U64? => _struct.assert_union(0x0, 9); _struct.u64(0x8)
  fun union_float32(): F32? => _struct.assert_union(0x0, 10); _struct.f32(0x4)
  fun union_float64(): F64? => _struct.assert_union(0x0, 11); _struct.f64(0x8)
  fun union_text(): String? => _struct.assert_union(0x0, 12); _struct.ptr_text(0)
  fun union_data(): Array[U8] val? => _struct.assert_union(0x0, 13); _struct.ptr_data(0)
  fun union_list(): CapnEntityPtr? => _struct.assert_union(0x0, 14); _struct.ptr(0) // TODO: better return type?
  fun union_enum(): U16? => _struct.assert_union(0x0, 15); _struct.u16(0x2)
  fun union_struct(): CapnEntityPtr? => _struct.assert_union(0x0, 16); _struct.ptr(0) // TODO: better return type?
  fun union_interface(): None? => _struct.assert_union(0x0, 17); None
  fun union_anyPointer(): CapnEntityPtr? => _struct.assert_union(0x0, 18); _struct.ptr(0) // TODO: better return type?
  fun union_is_void(): Bool => _struct.check_union(0x0, 0)
  fun union_is_bool(): Bool => _struct.check_union(0x0, 1)
  fun union_is_int8(): Bool => _struct.check_union(0x0, 2)
  fun union_is_int16(): Bool => _struct.check_union(0x0, 3)
  fun union_is_int32(): Bool => _struct.check_union(0x0, 4)
  fun union_is_int64(): Bool => _struct.check_union(0x0, 5)
  fun union_is_uint8(): Bool => _struct.check_union(0x0, 6)
  fun union_is_uint16(): Bool => _struct.check_union(0x0, 7)
  fun union_is_uint32(): Bool => _struct.check_union(0x0, 8)
  fun union_is_uint64(): Bool => _struct.check_union(0x0, 9)
  fun union_is_float32(): Bool => _struct.check_union(0x0, 10)
  fun union_is_float64(): Bool => _struct.check_union(0x0, 11)
  fun union_is_text(): Bool => _struct.check_union(0x0, 12)
  fun union_is_data(): Bool => _struct.check_union(0x0, 13)
  fun union_is_list(): Bool => _struct.check_union(0x0, 14)
  fun union_is_enum(): Bool => _struct.check_union(0x0, 15)
  fun union_is_struct(): Bool => _struct.check_union(0x0, 16)
  fun union_is_interface(): Bool => _struct.check_union(0x0, 17)
  fun union_is_anyPointer(): Bool => _struct.check_union(0x0, 18)

class val Annotation is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x8, 8*2); _struct = s'
  fun id(): U64 => _struct.u64(0x0)
  fun value(): Value? => _struct.ptr_struct[Value](0)
  fun brand(): Brand? => _struct.ptr_struct[Brand](1)

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
  new val create(s': CapnStructPtr)? => s'.verify(0x0, 8*2); _struct = s'
  fun nodes(): CapnList[Node] => _struct.ptr_list[Node](0)
  fun requestedFiles(): CapnList[CodeGeneratorRequestRequestedFile] => _struct.ptr_list[CodeGeneratorRequestRequestedFile](1)

class val CodeGeneratorRequestRequestedFile is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x8, 8*2); _struct = s'
  fun id(): U64 => _struct.u64(0x0)
  fun filename(): String? => _struct.ptr_text(0)
  fun imports(): CapnList[CodeGeneratorRequestRequestedFileImport] => _struct.ptr_list[CodeGeneratorRequestRequestedFileImport](1)

class val CodeGeneratorRequestRequestedFileImport is CapnStruct let _struct: CapnStructPtr
  new val create(s': CapnStructPtr)? => s'.verify(0x8, 8*1); _struct = s'
  fun id(): U64 => _struct.u64(0x0)
  fun name(): String? => _struct.ptr_text(0)
