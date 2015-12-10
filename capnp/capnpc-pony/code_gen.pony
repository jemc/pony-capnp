
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
