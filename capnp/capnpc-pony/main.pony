
actor Main
  new create(env: Env) =>
    let receiver = Receiver(RequestHandler(FileWriter(env)))
    env.input(receiver.stdin_notify())
