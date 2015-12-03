
use "files"

actor FileWriter
  let _env: Env
  new create(env': Env) => _env = env'
  
  be apply(path: String, contents: String) =>
    try let file = CreateFile(FilePath(_env.root, path)) as File
      _write_file(file, contents)
    else _env.out.print("[ERROR] Couldn't access path: "+path)
    end
  
  fun _write_file(file: File, contents: String) =>
    if file.set_length(0) and file.write(contents)
    then _env.out.print("[WROTE] "+file.path.path)
    else _env.out.print("[ERROR] Couldn't write to path: "+file.path.path)
    end
