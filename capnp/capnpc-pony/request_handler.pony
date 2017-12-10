
use schema = "schema"

actor RequestHandler
  let _writer: FileWriter
  new create(writer: FileWriter) => _writer = writer
  
  be apply(req': schema.CodeGeneratorRequest) =>
    let req = Request(req')
    for file in req.root.nodes().values() do
      if file.is_file() then
        try
          let file_info = req.file(file.id())?
          
          let filename = file_info.filename() + ".pony"
          _writer(filename, FileGenerator(req, file)?.string())
        end
      end
    end
