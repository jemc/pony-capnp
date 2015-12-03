
use schema = "schema"

class FileGenerator
  let gen: CodeGen = CodeGen
  let req: Request
  
  fun string(): String => gen.string()
  
  new ref create(req': Request, node: schema.Node)? => req = req'; _file(node)
  
  fun tag _verify_ident(name: String): String? =>
    match name
    | "use"
    | "type" | "interface" | "trait" | "primitive" | "class" | "actor"
    | "var" | "let" | "embed"
    | "fun" | "be" | "new"
    | "return" | "break" | "continue" | "error"
    | "compile_intrinsic" | "compile_error"
    | "and" | "or" | "xor" | "is" | "isnt"
    | "not" | "addressof" | "identityof"
    | "if" | "else" | "elseif" | "ifdef" | "try" | "then" | "with"
    | "match" | "while" | "do" | "for" | "in" | "repeat" | "until"
    | "recover" | "consume"
    | "this" | "true" | "false"
    | "iso" | "trn" | "ref" | "val" | "box" | "tag"
    | "apply" | "create"
    | "end" => error
    else name
    end
  
  fun _type_name(t: schema.Type): String =>
    if     t.union_is_void()    then "None"
    elseif t.union_is_bool()    then "Bool"
    elseif t.union_is_int8()    then "I8"
    elseif t.union_is_int16()   then "I16"
    elseif t.union_is_int32()   then "I32"
    elseif t.union_is_int64()   then "I64"
    elseif t.union_is_uint8()   then "U8"
    elseif t.union_is_uint16()  then "U16"
    elseif t.union_is_uint32()  then "U32"
    elseif t.union_is_uint64()  then "U64"
    elseif t.union_is_float32() then "F32"
    elseif t.union_is_float64() then "F64"
    elseif t.union_is_text()    then "String"
    elseif t.union_is_data()    then "Array[U8] val"
    elseif t.union_is_list() then
      try "CapnList["+_type_name(t.union_list().elementType())+"]" else "???" end
    elseif t.union_is_enum() then
      try req.node_scoped_name(t.union_enum().typeId()) else "???" end
    elseif t.union_is_struct() then
      try req.node_scoped_name(t.union_struct().typeId()) else "???" end
    elseif t.union_is_interface() then "UNKNOWN_INTERFACE"
    elseif t.union_is_anyPointer() then "CapnEntityPtr"
    else "UNKNOWN_TYPE"
    end
  
  fun _type_is_partial(t: schema.Type): Bool =>
    t.union_is_text()
    or t.union_is_data()
    or t.union_is_list()
    or t.union_is_struct()
    or t.union_is_interface()
    or t.union_is_anyPointer()
  
  fun ref _file(node: schema.Node)? =>
    gen.line()
    gen.line("use \"../..\"")
    
    for nest_info in node.nestedNodes().values() do
      let child = req.node(nest_info.id())
      if     child.union_is_struct() then _struct(child)
      elseif child.union_is_enum()   then _enum(child)
      else gen.line("// UNHANDLED: " + child.displayName())
      end
    end
  
  fun ref _enum(node: schema.Node)? =>
    let name = req.node_scoped_name(node.id())
    let enum_info = node.union_enum()
    
    gen.line()
    gen.line("class val "+name+" is CapnEnum let _value: U16")
    gen.push_indent()
    gen.line("fun apply(): U16 => _value")
    gen.line("new val create(value': U16) => _value = value'")
    
    var value: U16 = 0
    for enumerant in enum_info.enumerants().values() do
      var val_name = enumerant.name()
      val_name = try _verify_ident(val_name) else "value_"+val_name end
      gen.line("new val "+val_name+"() => _value = "+value.string())
    value = value + 1 end
    
    gen.pop_indent()
  
  fun ref _struct(node: schema.Node)? =>
    let name = req.node_scoped_name(node.id())
    let struct_info = node.union_struct()
    let ds: String = (struct_info.dataWordCount() * 8).string(FormatHex)
    let ps: String = (struct_info.pointerCount()).string()
    let cls = if struct_info.isGroup() then "CapnGroup" else "CapnStruct" end
    
    gen.line()
    gen.line("class val "+name+" is "+cls+" let _struct: CapnStructPtr")
    gen.push_indent()
    gen.line("new val create(s': CapnStructPtr)")
    
    if struct_info.isGroup() then
      gen.add(" =>")
    else
      gen.add("? => s'.verify("+ds+", 8*"+ps+");")
    end
    
    gen.add(" _struct = s'")
    
    // Non-union field getters
    for field in struct_info.fields().values() do
      if field.discriminantValue() == 0xffff
      then _field_getter(node, field)
      end
    end
    
    // Union field getters
    for field in struct_info.fields().values() do
      if field.discriminantValue() != 0xffff
      then _field_getter(node, field)
      end
    end
    
    // Union field checkers
    for field in struct_info.fields().values() do
      if field.discriminantValue() != 0xffff
      then _field_union_checker(node, field)
      end
    end
    
    gen.pop_indent()
    
    // Group class definitions
    for field in struct_info.fields().values() do
      try let group = field.union_group()
        _struct(req.node(group.typeId()))
      end
    end
    
    // Nested type declarations
    for nest_info in node.nestedNodes().values() do
      let child = req.node(nest_info.id())
      if child.union_is_struct() then _struct(child)
      else gen.line("// UNHANDLED: " + child.displayName())
      end
    end
  
  fun ref _field_union_checker(node: schema.Node, field: schema.Field)? =>
    var name = field.name()
    
    name = "union_is_"+name
    name = try _verify_ident(name) else "get_"+name end
    
    gen.line("fun "+name+"(): Bool =>")
    
    gen.add(" _struct.check_union(")
    gen.add((node.union_struct().discriminantOffset() * 2).string(FormatHex))
    gen.add(", ")
    gen.add(field.discriminantValue().string())
    gen.add(")")
  
  fun ref _field_group_getter(node: schema.Node, field: schema.Field)? =>
    var name = field.name()
    var type_name = req.node_scoped_name(field.union_group().typeId())
    
    let is_union = field.discriminantValue() != 0xffff
    
    if is_union then name = "union_"+name end
    name = try _verify_ident(name) else "get_"+name end
    
    if is_union then type_name = type_name+"" end
    
    gen.line("fun "+name+"(): "+type_name)
    if is_union then gen.add("?") end
    gen.add(" =>")
    
    if is_union then _field_union_assert_statement(node, field) end
    
    gen.add(" "+type_name+"(_struct)")
  
  fun ref _field_union_assert_statement(node: schema.Node, field: schema.Field)? =>
    if node.union_struct().discriminantCount() <= 1 then error end
    
    gen.add(" _struct.assert_union(")
    gen.add((node.union_struct().discriminantOffset() * 2).string(FormatHex))
    gen.add(", ")
    gen.add(field.discriminantValue().string())
    gen.add(");")
  
  fun ref _field_getter(node: schema.Node, field: schema.Field)? =>
    if field.union_is_group() then return _field_group_getter(node, field) end
    
    let slot = field.union_slot()
    var name = field.name()
    let type_info = slot.get_type()
    let type_name = _type_name(type_info)
    let is_union = field.discriminantValue() != 0xffff
    
    if is_union then name = "union_"+name end
    name = try _verify_ident(name) else "get_"+name end
    
    gen.line("fun "+name+"(): "+type_name)
    if is_union or _type_is_partial(type_info) then gen.add("?") end
    gen.add(" =>")
    
    if is_union then _field_union_assert_statement(node, field) end
    
    gen.add(" ")
    if type_info.union_is_void() then
      gen.add("None")
    elseif type_info.union_is_bool() then
      try let dv = slot.defaultValue().union_bool()
        if dv then gen.add("not ") end
      end
      gen.add("_struct.bool(")
      gen.add((slot.offset() / 8).string(FormatHex))
      gen.add(", 0b")
      gen.add(U32(1 << (slot.offset() % 8)).string(FormatBinaryBare, PrefixDefault, 8))
      gen.add(")")
    elseif type_info.union_is_int8() then
      try let dv = slot.defaultValue().union_int8()
        if dv != 0 then gen.add(dv.string()+" xor ") end
      end
      gen.add("_struct.i8(")
      gen.add((slot.offset() * 1).string(FormatHex))
      gen.add(")")
    elseif type_info.union_is_int16() then
      try let dv = slot.defaultValue().union_int16()
        if dv != 0 then gen.add(dv.string()+" xor ") end
      end
      gen.add("_struct.i16(")
      gen.add((slot.offset() * 2).string(FormatHex))
      gen.add(")")
    elseif type_info.union_is_int32() then
      try let dv = slot.defaultValue().union_int32()
        if dv != 0 then gen.add(dv.string()+" xor ") end
      end
      gen.add("_struct.i32(")
      gen.add((slot.offset() * 4).string(FormatHex))
      gen.add(")")
    elseif type_info.union_is_int64() then
      try let dv = slot.defaultValue().union_int64()
        if dv != 0 then gen.add(dv.string()+" xor ") end
      end
      gen.add("_struct.i64(")
      gen.add((slot.offset() * 8).string(FormatHex))
      gen.add(")")
    elseif type_info.union_is_uint8() then
      try let dv = slot.defaultValue().union_uint8()
        if dv != 0 then gen.add(dv.string()+" xor ") end
      end
      gen.add("_struct.u8(")
      gen.add((slot.offset() * 1).string(FormatHex))
      gen.add(")")
    elseif type_info.union_is_uint16() then
      try let dv = slot.defaultValue().union_uint16()
        if dv != 0 then gen.add(dv.string()+" xor ") end
      end
      gen.add("_struct.u16(")
      gen.add((slot.offset() * 2).string(FormatHex))
      gen.add(")")
    elseif type_info.union_is_uint32() then
      try let dv = slot.defaultValue().union_uint32()
        if dv != 0 then gen.add(dv.string()+" xor ") end
      end
      gen.add("_struct.u32(")
      gen.add((slot.offset() * 4).string(FormatHex))
      gen.add(")")
    elseif type_info.union_is_uint64() then
      try let dv = slot.defaultValue().union_uint64()
        if dv != 0 then gen.add(dv.string()+" xor ") end
      end
      gen.add("_struct.u64(")
      gen.add((slot.offset() * 8).string(FormatHex))
      gen.add(")")
    elseif type_info.union_is_float32() then
      try let dv = slot.defaultValue().union_float32()
        if dv != 0 then gen.add(" // UNHANDLED: defaultValue") end
      end
      gen.add("_struct.f32(")
      gen.add((slot.offset() * 4).string(FormatHex))
      gen.add(")")
    elseif type_info.union_is_float64() then
      try let dv = slot.defaultValue().union_float64()
        if dv != 0 then gen.add(" // UNHANDLED: defaultValue") end
      end
      gen.add("_struct.f64(")
      gen.add((slot.offset() * 8).string(FormatHex))
      gen.add(")")
    elseif type_info.union_is_text() then
      try let dv = slot.defaultValue().union_text()
        gen.add(" // UNHANDLED: defaultValue")
      end
      gen.add("_struct.ptr_text(")
      gen.add(slot.offset().string())
      gen.add(")")
    elseif type_info.union_is_data() then
      try let dv = slot.defaultValue().union_data()
        gen.add(" // UNHANDLED: defaultValue")
      end
      gen.add("_struct.ptr_data(")
      gen.add(slot.offset().string())
      gen.add(")")
    elseif type_info.union_is_list() then
      // TODO: handle defaultValue
      gen.add("_struct.ptr_list[")
      gen.add(try _type_name(type_info.union_list().elementType()) else "???" end)
      gen.add("](")
      gen.add(slot.offset().string())
      gen.add(")")
    elseif type_info.union_is_enum() then
      // TODO: handle defaultValue
      gen.add(try req.node_scoped_name(type_info.union_enum().typeId()) else "???" end)
      gen.add("(")
      try let dv = slot.defaultValue().union_uint16()
        if dv != 0 then gen.add(dv.string()+" xor ") end
      end
      gen.add("_struct.u16(")
      gen.add((slot.offset() * 2).string(FormatHex))
      gen.add("))")
    elseif type_info.union_is_struct() then
      // TODO: handle defaultValue
      gen.add("_struct.ptr_struct[")
      gen.add(try req.node_scoped_name(type_info.union_struct().typeId()) else "???" end)
      gen.add("](")
      gen.add(slot.offset().string())
      gen.add(")")
    elseif type_info.union_is_interface() then
      // TODO: handle
      // TODO: handle defaultValue
      gen.add("// UNKNOWN_INTERFACE")
    elseif type_info.union_is_anyPointer() then
      // TODO: handle defaultValue
      gen.add("_struct.ptr(")
      gen.add(slot.offset().string())
      gen.add(") // TODO: better return type?")
    else gen.add("// UNKNOWN")
    end
