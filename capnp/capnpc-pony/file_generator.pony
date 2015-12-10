
use schema = "schema"

class FileGenerator
  let gen: CodeGen = CodeGen
  let req: Request
  
  fun string(): String => gen.string()
  
  new ref create(req': Request, node: schema.Node)? => req = req'; _file(node)
  
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
  
  fun _field_type_name(field: schema.Field): String =>
    if field.is_group()
    then req.node_scoped_name(field.group().typeId())
    else _type_name(field.slot().get_type())
    end
  
  fun _type_is_partial(t: schema.Type): Bool =>
    t.is_interface()
    or t.is_anyPointer()
  
  fun _field_type_is_partial(field: schema.Field): Bool =>
    if field.is_group()
    then false
    else _type_is_partial(field.slot().get_type())
    end
  
  fun _field_get_is_partial(field: schema.Field): Bool =>
    if field.is_group() then false else
      let t = field.slot().get_type()
      t.is_text()
      or t.is_data()
      or t.is_list()
      or t.is_struct()
      or t.is_anyPointer()
    end
  
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
      _field_fun(node, field)
      _field_get_fun(node, field)
      _field_is_fun(node, field)
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
  
  fun ref _field_expr_check_union(node: schema.Node, field: schema.Field)? =>
    if node.get_struct().discriminantCount() <= 1 then error end
    
    gen.add(" _struct.check_union(")
    gen.add((node.get_struct().discriminantOffset() * 2).string(FormatHex))
    gen.add(", ")
    gen.add(field.discriminantValue().string())
    gen.add(")")
  
  fun ref _field_expr_if_check_union(node: schema.Node, field: schema.Field)? =>
    if node.get_struct().discriminantCount() <= 1 then error end
    
    gen.add(" if")
    _field_expr_check_union(node, field)
    gen.add(" then")
  
  fun ref _field_expr_get_value(node: schema.Node, field: schema.Field) =>
    let type_name     = _field_type_name(field)
    let slot          = field.slot()
    let offset        = slot.offset()
    let default_value = slot.defaultValue()
    let t             = slot.get_type()
    
    gen.add(" ")
    if field.is_group() then gen.add(type_name+"(_struct)")
    elseif t.is_void()  then gen.add("None")
    elseif t.is_bool()  then
      let dv = default_value.bool()
      if dv then gen.add("not ") end
      gen.add("_struct.bool(")
      gen.add((offset / 8).string(FormatHex))
      gen.add(", 0b")
      gen.add(U32(1 << (offset % 8)).string(FormatBinaryBare, PrefixDefault, 8))
      gen.add(")")
    elseif t.is_int8() then
      let dv = default_value.int8()
      if dv != 0 then gen.add(dv.string()+" xor ") end
      gen.add("_struct.i8("+(offset * 1).string(FormatHex)+")")
    elseif t.is_int16() then
      let dv = default_value.int16()
      if dv != 0 then gen.add(dv.string()+" xor ") end
      gen.add("_struct.i16("+(offset * 2).string(FormatHex)+")")
    elseif t.is_int32() then
      let dv = default_value.int32()
      if dv != 0 then gen.add(dv.string()+" xor ") end
      gen.add("_struct.i32("+(offset * 4).string(FormatHex)+")")
    elseif t.is_int64() then
      let dv = default_value.int64()
      if dv != 0 then gen.add(dv.string()+" xor ") end
      gen.add("_struct.i64("+(offset * 8).string(FormatHex)+")")
    elseif t.is_uint8() then
      let dv = default_value.uint8()
      if dv != 0 then gen.add(dv.string()+" xor ") end
      gen.add("_struct.u8("+(offset * 1).string(FormatHex)+")")
    elseif t.is_uint16() then
      let dv = default_value.uint16()
      if dv != 0 then gen.add(dv.string()+" xor ") end
      gen.add("_struct.u16("+(offset * 2).string(FormatHex)+")")
    elseif t.is_uint32() then
      let dv = default_value.uint32()
      if dv != 0 then gen.add(dv.string()+" xor ") end
      gen.add("_struct.u32("+(offset * 4).string(FormatHex)+")")
    elseif t.is_uint64() then
      let dv = default_value.uint64()
      if dv != 0 then gen.add(dv.string()+" xor ") end
      gen.add("_struct.u64("+(offset * 8).string(FormatHex)+")")
    elseif t.is_float32() then
      let dv = default_value.float32()
      if dv != 0 then gen.add("// UNHANDLED: default_value") end
      gen.add("_struct.f32("+(offset * 4).string(FormatHex)+")")
    elseif t.is_float64() then
      let dv = default_value.float64()
      if dv != 0 then gen.add("// UNHANDLED: default_value") end
      gen.add("_struct.f64("+(offset * 8).string(FormatHex)+")")
    elseif t.is_text() then
      gen.add("_struct.ptr_text("+offset.string()+")")
    elseif t.is_data() then
      gen.add("_struct.ptr_data("+offset.string()+")")
    elseif t.is_list() then
      let etype_name = _type_name(t.list().elementType())
      gen.add("_struct.ptr_list["+etype_name+"]("+offset.string()+")")
    elseif t.is_enum() then
      gen.add(req.node_scoped_name(t.enum().typeId()))
      gen.add("(")
      let dv = default_value.uint16()
      if dv != 0 then gen.add(dv.string()+" xor ") end
      gen.add("_struct.u16("+(offset * 2).string(FormatHex)+"))")
    elseif t.is_struct() then
      let etype_name = req.node_scoped_name(t.get_struct().typeId())
      gen.add("_struct.ptr_struct["+etype_name+"]("+offset.string()+")")
    elseif t.is_interface() then
      // TODO: handle
      gen.add("// UNKNOWN_INTERFACE")
    elseif t.is_anyPointer() then
      // TODO: handle default_value
      gen.add("_struct.ptr("+offset.string()+") /* TODO: better type? */")
    else gen.add("// UNKNOWN")
    end
  
  fun ref _field_expr_default_value(node: schema.Node, field: schema.Field) =>
    let type_name = _field_type_name(field)
    let slot      = field.slot()
    let dv        = slot.defaultValue()
    let t         = slot.get_type()
    
    gen.add(" ")
    if field.is_group()      then gen.add("_struct.ptr_emptystruct["+type_name+"]()") // TODO: handle default_value
    elseif t.is_void()       then gen.add("None")
    elseif t.is_bool()       then gen.add(dv.bool().string())
    elseif t.is_int8()       then gen.add(dv.int8().string())
    elseif t.is_int16()      then gen.add(dv.int16().string())
    elseif t.is_int32()      then gen.add(dv.int32().string())
    elseif t.is_int64()      then gen.add(dv.int64().string())
    elseif t.is_uint8()      then gen.add(dv.uint8().string())
    elseif t.is_uint16()     then gen.add(dv.uint16().string())
    elseif t.is_uint32()     then gen.add(dv.uint32().string())
    elseif t.is_uint64()     then gen.add(dv.uint64().string())
    elseif t.is_float32()    then gen.add(dv.float32().string())
    elseif t.is_float64()    then gen.add(dv.float64().string())
    elseif t.is_text()       then gen.add(gen.string_literal(dv.text()))
    elseif t.is_data()       then gen.add(gen.bytes_literal(dv.data()))
    elseif t.is_list()       then let etype_name = _type_name(t.list().elementType())
                                  gen.add("_struct.ptr_emptylist["+etype_name+"]()") // TODO: handle default_value
    elseif t.is_enum()       then gen.add(req.node_scoped_name(t.enum().typeId()))
                                  gen.add("("+dv.uint16().string()+")")
    elseif t.is_struct()     then let etype_name = req.node_scoped_name(t.get_struct().typeId())
                                  gen.add("_struct.ptr_emptystruct["+etype_name+"]()") // TODO: handle default_value
    elseif t.is_interface()  then None // TODO
    elseif t.is_anyPointer() then gen.add("error") // TODO
    end
  
  fun ref _field_fun(node: schema.Node, field: schema.Field) =>
    let name      = field.name()
    let type_name = _field_type_name(field)
    
    if gen.is_safe_ident(name) then
      gen.line("fun "+name+"(): "+type_name)
      if _field_type_is_partial(field) then gen.add("?") end
      gen.add(" => get_"+name+"()")
    else
      gen.line("// fun "+name+"(): "+type_name)
      if _field_type_is_partial(field) then gen.add("?") end
      gen.add(" => get_"+name+"()")
      gen.add(" // DISABLED: invalid Pony function name")
    end
  
  fun ref _field_get_fun(node: schema.Node, field: schema.Field)? =>
    let name      = field.name()
    let type_name = _field_type_name(field)
    let is_union  = field.discriminantValue() != 0xffff
    let slot      = field.slot()
    let type_info = slot.get_type()
    
    gen.line("fun get_"+name+"(): "+type_name)
    if _field_type_is_partial(field) then gen.add("?") end
    gen.add(" =>")
    
    if not field.is_group() and type_info.is_void() then
      gen.add(" None")
      return
    end
    
    if _field_get_is_partial(field) then gen.add(" try") end
    if is_union then _field_expr_if_check_union(node, field) end
    
    _field_expr_get_value(node, field)
    
    if is_union then
      gen.add(" else")
      if _field_get_is_partial(field)
      then gen.add(" error")
      else _field_expr_default_value(node, field)
      end
      gen.add(" end")
    end
    
    if _field_get_is_partial(field) then // TODO: refactor, merge with earlier if
      gen.add(" else")
      _field_expr_default_value(node, field)
      gen.add(" end")
    end
  
  fun ref _field_is_fun(node: schema.Node, field: schema.Field)? =>
    if field.discriminantValue() == 0xffff then return end
    
    let name = field.name()
    
    gen.line("fun is_"+name+"(): Bool =>")
    _field_expr_check_union(node, field)
