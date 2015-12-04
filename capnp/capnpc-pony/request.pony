
use schema = "schema"

class Request
  let root: schema.CodeGeneratorRequest
  new create(root': schema.CodeGeneratorRequest) =>
    root = root'
  
  fun file(id: U64): schema.CodeGeneratorRequestRequestedFile? =>
    for f in root.requestedFiles().values() do
      if id == f.id() then return f end
    end
    error
  
  fun node(id: U64): schema.Node? =>
    for n in root.nodes().values() do
      if id == n.id() then return n end
    end
    error
  
  fun node_scope_id(id: U64): U64? =>
    let scope_id = node(id).scopeId()
    if scope_id == 0 then error end
    scope_id
  
  fun _node_scoped_name_of_group(this_node: schema.Node): String =>
    let scope_node = try node(this_node.scopeId()) else return "" end
    try
      for field in scope_node.union_struct().fields().values() do
        try
          if this_node.id() == field.union_group().typeId() then
            return node_scoped_name(this_node.scopeId()) + "GROUP" + field.name()
          end
        end
      end
    end
    "UNKNOWN_GROUP"
  
  fun _node_scoped_name_of_typedecl(this_node: schema.Node): String =>
    let scope_node = try node(this_node.scopeId()) else return "" end
    for n in scope_node.nestedNodes().values() do
      if this_node.id() == n.id() then
        return node_scoped_name(this_node.scopeId()) + "" + n.name()
      end
    end
    "UNKNOWN_TYPE"
  
  fun node_scoped_name(id: U64): String =>
    let this_node = try node(id) else return "UNKNOWN_NAME" end
    if try this_node.union_struct().isGroup() else false end
    then _node_scoped_name_of_group(this_node)
    else _node_scoped_name_of_typedecl(this_node)
    end
