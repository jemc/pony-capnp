
use "collections"

class CodeGen
  let _lines:   List[String] = List[String]
  let _indents: List[String] = List[String]
  
  new iso create() =>
    _indents.push("")
  
  fun string(): String =>
    let out = recover trn String end
    for l in _lines.values() do out.append(l + "\n") end
    out
  
  fun ref add(s: String = "") =>
    _lines.push(try _lines.pop() else "" end + s)
  
  fun ref line(s: String = "") =>
    _lines.push(current_indent() + s)
  
  fun ref push_indent(s: String = "  ") =>
    _indents.push(current_indent() + s)
  
  fun ref pop_indent() =>
    try _indents.pop() end
  
  fun ref current_indent(): String =>
    try _indents.tail()() else "" end
  
  fun tag is_safe_ident(ident: String): Bool =>
    match ident
    | "use"
    | "type" | "interface" | "trait"
    | "primitive" | "class" | "actor" | "struct"
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
    | "end" => false
    else true
    end
  
  fun tag string_literal(s: String box): String =>
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
  
  fun tag bytes_literal(a: Array[U8] box): String =>
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
