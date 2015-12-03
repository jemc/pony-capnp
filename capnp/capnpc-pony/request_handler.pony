
use schema = "schema"

actor RequestHandler
  let _writer: FileWriter
  new create(writer: FileWriter) => _writer = writer
  
  be apply(req: schema.CodeGeneratorRequest) =>
    try _apply(Request(req)) end
  
  fun _apply(req: Request)? =>
    for file in req.root.nodes().values() do
      if file.union_is_file() then
        try
          let file_info = req.file(file.id())
          
          let filename = file_info.filename() + ".pony"
          _writer(filename, FileGenerator(req, file).string())
        end
      end
    end
