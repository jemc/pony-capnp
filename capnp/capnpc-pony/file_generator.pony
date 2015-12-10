
use schema = "schema"

class FileGenerator
  let gen: CodeGen = CodeGen
  let req: Request
  
  fun string(): String => gen.string()
  
  new ref create(req': Request, node: schema.Node)? => req = req'; _file(node)
  
  fun tag _string_literal(s: String box): String =>
    let out = recover trn String end
    out.push('"')
    for b' in s.values() do
      match b'
      | '"'  => out.push('\\'); out.push('"')
      | '\\' => out.push('\\'); out.push('\\')
      | let b: U8 if b < 0x10 => out.append("\\x0" + b.string(FormatHexBare))
      | let b: U8 if b < 0x20 => out.append("\\x"  + b.string(FormatHexBare))
      | let b: U8 if b < 0x7F => out.push(b)
      else let b = b';           out.append("\\x"  + b.string(FormatHexBare))
      end
    end
    out.push('"')
    consume out
  
  fun tag _bytes_literal(a: Array[U8] box): String =>
    if a.size() == 0 then return "recover val Array[U8] end" end
    let out = recover trn String end
    out.append("[as U8: ")
    
    let iter = a.values()
    for b in iter do
      out.append("0x" + b.string(FormatHexBare, PrefixDefault, 2))
      if iter.has_next() then out.append(", ") end
    end
    
    out.push(']')
    consume out
  
  fun _type_name(t: schema.Type): String =>
    if     t.is_void()       then "None"
    elseif t.is_bool()       then "Bool"
    elseif t.is_int8()       then "I8"
    elseif t.is_int16()      then "I16"
    elseif t.is_int32()      then "I32"
    elseif t.is_int64()      then "I64"
    elseif t.is_uint8()      then "U8"
    elseif t.is_uint16()     then "U16"
    elseif t.is_uint32()     then "U32"
    elseif t.is_uint64()     then "U64"
    elseif t.is_float32()    then "F32"
    elseif t.is_float64()    then "F64"
    elseif t.is_text()       then "String"
    elseif t.is_data()       then "Array[U8] val"
    elseif t.is_list()       then "CapnList["+_type_name(t.list().elementType())+"]"
    elseif t.is_enum()       then req.node_scoped_name(t.enum().typeId())
    elseif t.is_struct()     then req.node_scoped_name(t.get_struct().typeId())
    elseif t.is_interface()  then "UNKNOWN_INTERFACE"
    elseif t.is_anyPointer() then "CapnEntityPtr"
    else "UNKNOWN_TYPE"
    end
  
  fun _type_is_partial(t: schema.Type): Bool =>
    t.is_interface()
    or t.is_anyPointer()
  
  fun ref _file(node: schema.Node)? =>
    gen.line()
    gen.line("use \"../..\"")
    
    for nest_info in node.nestedNodes().values() do
      let child = req.node(nest_info.id())
      if     child.is_struct() then _struct(child)
      elseif child.is_enum()   then _enum(child)
      else gen.line("// UNHANDLED: " + child.displayName())
      end
    end
  
  fun ref _enum(node: schema.Node) =>
    let name = req.node_scoped_name(node.id())
    let enum_info = node.enum()
    
    gen.line()
    gen.line("class val "+name+" is CapnEnum let _value: U16")
    gen.push_indent()
    gen.line("fun apply(): U16 => _value")
    gen.line("new val create(value': U16) => _value = value'")
    
    var value: U16 = 0
    for enumerant in enum_info.enumerants().values() do
      let val_name = enumerant.name()
      if gen.is_safe_ident(val_name) then
        gen.line("new val "+val_name+"() => _value = "+value.string())
      else
        gen.line("// new val "+val_name+"() => _value = "+value.string())
        gen.add(" // DISABLED: invalid Pony function name")
      end
      gen.line("new val value_"+val_name+"() => _value = "+value.string())
    value = value + 1 end
    
    gen.pop_indent()
  
  fun ref _struct(node: schema.Node)? =>
    let name = req.node_scoped_name(node.id())
    let struct_info = node.get_struct()
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
      gen.add(" => s'.verify("+ds+", 8*"+ps+");")
    end
    
    gen.add(" _struct = s'")
    
    // Class fields
    for field in struct_info.fields().values() do
      _field_getter(node, field)
      _field_union_checker(node, field)
    end
    
    gen.pop_indent()
    
    // Group class definitions
    for field in struct_info.fields().values() do
      try let group = field.group()
        _struct(req.node(group.typeId()))
      end
    end
    
    // Nested type declarations
    for nest_info in node.nestedNodes().values() do
      let child = req.node(nest_info.id())
      if child.is_struct() then _struct(child)
      else gen.line("// UNHANDLED: " + child.displayName())
      end
    end
  
  fun ref _field_union_checker(node: schema.Node, field: schema.Field)? =>
    if field.discriminantValue() == 0xffff then return end
    
    let name = field.name()
    
    gen.line("fun is_"+name+"(): Bool =>")
    
    _field_union_check_statement(node, field)
  
  fun ref _field_group_getter(node: schema.Node, field: schema.Field)? =>
    let name      = field.name()
    let type_name = req.node_scoped_name(field.group().typeId())
    let is_union  = field.discriminantValue() != 0xffff
    
    if gen.is_safe_ident(name) then
      gen.line("fun "+name+"(): "+type_name+" => get_"+name+"()")
    else
      gen.line("// fun "+name+"(): "+type_name+" => get_"+name+"()")
      gen.add(" // DISABLED: invalid Pony function name")
    end
    
    gen.line("fun get_"+name+"(): "+type_name+" =>")
    
    if is_union then _field_union_check_condition(node, field) end
    
    gen.add(" "+type_name+"(_struct)")
    
    if is_union then gen.add(" else _struct.ptr_emptystruct["+type_name+"]() end") end
  
  fun ref _field_union_check_statement(node: schema.Node, field: schema.Field)? =>
    if node.get_struct().discriminantCount() <= 1 then error end
    
    gen.add(" _struct.check_union(")
    gen.add((node.get_struct().discriminantOffset() * 2).string(FormatHex))
    gen.add(", ")
    gen.add(field.discriminantValue().string())
    gen.add(")")
  
  fun ref _field_union_check_condition(node: schema.Node, field: schema.Field)? =>
    if node.get_struct().discriminantCount() <= 1 then error end
    
    gen.add(" if")
    _field_union_check_statement(node, field)
    gen.add(" then")
  
  fun ref _field_getter(node: schema.Node, field: schema.Field)? =>
    if field.is_group() then return _field_group_getter(node, field) end
    
    let slot      = field.slot()
    let name      = field.name()
    let type_info = slot.get_type()
    let type_name = _type_name(type_info)
    let is_union  = field.discriminantValue() != 0xffff
    
    if gen.is_safe_ident(name) then
      gen.line("fun "+name+"(): "+type_name)
      if _type_is_partial(type_info) then gen.add("?") end
      gen.add(" => get_"+name+"()")
    else
      gen.line("// fun "+name+"(): "+type_name)
      if _type_is_partial(type_info) then gen.add("?") end
      gen.add(" => get_"+name+"()")
      gen.add(" // DISABLED: invalid Pony function name")
    end
    
    gen.line("fun get_"+name+"(): "+type_name)
    if _type_is_partial(type_info) then gen.add("?") end
    gen.add(" =>")
    
    if type_info.is_void() then
      gen.add(" None")
    elseif type_info.is_bool() then
      if is_union then _field_union_check_condition(node, field) end
      let dv = slot.defaultValue().bool()
      if dv then gen.add("not ") end
      gen.add(" _struct.bool(")
      gen.add((slot.offset() / 8).string(FormatHex))
      gen.add(", 0b")
      gen.add(U32(1 << (slot.offset() % 8)).string(FormatBinaryBare, PrefixDefault, 8))
      gen.add(")")
      if is_union then gen.add(" else "+dv.string()+" end") end
    elseif type_info.is_int8() then
      if is_union then _field_union_check_condition(node, field) end
      let dv = slot.defaultValue().int8()
      if dv != 0 then gen.add(" "+dv.string()+" xor") end
      gen.add(" _struct.i8(")
      gen.add((slot.offset() * 1).string(FormatHex))
      gen.add(")")
      if is_union then gen.add(" else "+dv.string()+" end") end
    elseif type_info.is_int16() then
      if is_union then _field_union_check_condition(node, field) end
      let dv = slot.defaultValue().int16()
      if dv != 0 then gen.add(" "+dv.string()+" xor") end
      gen.add(" _struct.i16(")
      gen.add((slot.offset() * 2).string(FormatHex))
      gen.add(")")
      if is_union then gen.add(" else "+dv.string()+" end") end
    elseif type_info.is_int32() then
      if is_union then _field_union_check_condition(node, field) end
      let dv = slot.defaultValue().int32()
      if dv != 0 then gen.add(" "+dv.string()+" xor") end
      gen.add(" _struct.i32(")
      gen.add((slot.offset() * 4).string(FormatHex))
      gen.add(")")
      if is_union then gen.add(" else "+dv.string()+" end") end
    elseif type_info.is_int64() then
      if is_union then _field_union_check_condition(node, field) end
      let dv = slot.defaultValue().int64()
      if dv != 0 then gen.add(" "+dv.string()+" xor") end
      gen.add(" _struct.i64(")
      gen.add((slot.offset() * 8).string(FormatHex))
      gen.add(")")
      if is_union then gen.add(" else "+dv.string()+" end") end
    elseif type_info.is_uint8() then
      if is_union then _field_union_check_condition(node, field) end
      let dv = slot.defaultValue().uint8()
      if dv != 0 then gen.add(" "+dv.string()+" xor") end
      gen.add(" _struct.u8(")
      gen.add((slot.offset() * 1).string(FormatHex))
      gen.add(")")
      if is_union then gen.add(" else "+dv.string()+" end") end
    elseif type_info.is_uint16() then
      if is_union then _field_union_check_condition(node, field) end
      let dv = slot.defaultValue().uint16()
      if dv != 0 then gen.add(" "+dv.string()+" xor") end
      gen.add(" _struct.u16(")
      gen.add((slot.offset() * 2).string(FormatHex))
      gen.add(")")
      if is_union then gen.add(" else "+dv.string()+" end") end
    elseif type_info.is_uint32() then
      if is_union then _field_union_check_condition(node, field) end
      let dv = slot.defaultValue().uint32()
      if dv != 0 then gen.add(" "+dv.string()+" xor") end
      gen.add(" _struct.u32(")
      gen.add((slot.offset() * 4).string(FormatHex))
      gen.add(")")
      if is_union then gen.add(" else "+dv.string()+" end") end
    elseif type_info.is_uint64() then
      if is_union then _field_union_check_condition(node, field) end
      let dv = slot.defaultValue().uint64()
      if dv != 0 then gen.add(" "+dv.string()+" xor") end
      gen.add(" _struct.u64(")
      gen.add((slot.offset() * 8).string(FormatHex))
      gen.add(")")
      if is_union then gen.add(" else "+dv.string()+" end") end
    elseif type_info.is_float32() then
      if is_union then _field_union_check_condition(node, field) end
      let dv = slot.defaultValue().float32()
      if dv != 0 then gen.add(" // UNHANDLED: defaultValue") end
      gen.add(" _struct.f32(")
      gen.add((slot.offset() * 4).string(FormatHex))
      gen.add(")")
      if is_union then gen.add(" else "+dv.string()+" end") end
    elseif type_info.is_float64() then
      if is_union then _field_union_check_condition(node, field) end
      let dv = slot.defaultValue().float64()
      if dv != 0 then gen.add(" // UNHANDLED: defaultValue") end
      gen.add(" _struct.f64(")
      gen.add((slot.offset() * 8).string(FormatHex))
      gen.add(")")
      if is_union then gen.add(" else "+dv.string()+" end") end
    elseif type_info.is_text() then
      let dv = slot.defaultValue().text()
      gen.add(" try")
      if is_union then _field_union_check_condition(node, field) end
      gen.add(" _struct.ptr_text(")
      gen.add(slot.offset().string())
      gen.add(")")
      if is_union then gen.add(" else error end") end
      gen.add(" else "+_string_literal(dv)+" end")
    elseif type_info.is_data() then
      let dv = slot.defaultValue().data()
      gen.add(" try")
      if is_union then _field_union_check_condition(node, field) end
      gen.add(" _struct.ptr_data(")
      gen.add(slot.offset().string())
      gen.add(")")
      if is_union then gen.add(" else error end") end
      gen.add(" else "+_bytes_literal(dv)+" end")
    elseif type_info.is_list() then
      // TODO: handle defaultValue
      let etype_name = _type_name(type_info.list().elementType())
      gen.add(" try")
      if is_union then _field_union_check_condition(node, field) end
      gen.add(" _struct.ptr_list["+etype_name+"]("+slot.offset().string()+")")
      if is_union then gen.add(" else error end") end
      gen.add(" else _struct.ptr_emptylist["+etype_name+"]() end")
    elseif type_info.is_enum() then
      if is_union then _field_union_check_condition(node, field) end
      // TODO: handle defaultValue
      gen.add(" ")
      gen.add(req.node_scoped_name(type_info.enum().typeId()))
      gen.add("(")
      let dv = slot.defaultValue().uint16()
      if dv != 0 then gen.add(dv.string()+" xor ") end
      gen.add("_struct.u16(")
      gen.add((slot.offset() * 2).string(FormatHex))
      gen.add("))")
      if is_union then gen.add(" else error end") end
    elseif type_info.is_struct() then
      // TODO: handle defaultValue
      let etype_name = req.node_scoped_name(type_info.get_struct().typeId())
      gen.add(" try")
      if is_union then _field_union_check_condition(node, field) end
      gen.add(" _struct.ptr_struct["+etype_name+"]("+slot.offset().string()+")")
      if is_union then gen.add(" else error end") end
      gen.add(" else _struct.ptr_emptystruct["+etype_name+"]() end")
    elseif type_info.is_interface() then
      // TODO: handle
      // TODO: handle defaultValue
      gen.add("// UNKNOWN_INTERFACE")
    elseif type_info.is_anyPointer() then
      if is_union then _field_union_check_condition(node, field) end
      // TODO: handle defaultValue
      gen.add(" _struct.ptr(")
      gen.add(slot.offset().string())
      gen.add(")")
      if is_union then gen.add(" else error end") end
      gen.add(" // TODO: better return type?")
    else gen.add("// UNKNOWN")
    end
