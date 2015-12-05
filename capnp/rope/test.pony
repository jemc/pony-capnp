
use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None
  
  fun tag tests(test: PonyTest) =>
    test(_RopeTest)

class _RopeTest is UnitTest
  new iso create() => None
  fun name(): String => "Rope"
  
  fun apply(h: TestHelper): TestResult =>
    var rope = Rope
    h.expect_eq[USize](0, rope.size())
    h.expect_eq[String]("", rope.string())
    
    rope = rope + "abc" + "def" + "ghi"
    h.expect_eq[USize](9, rope.size())
    h.expect_eq[String]("abcdefghi", rope.string())
    
    rope = rope.slice(2, 8)
    h.expect_eq[USize](6, rope.size())
    h.expect_eq[String]("cdefgh", rope.string())
    
    rope = rope + "XYZ"
    h.expect_eq[USize](9, rope.size())
    h.expect_eq[String]("cdefghXYZ", rope.string())
    
    rope = rope.slice(5, 20)
    h.expect_eq[USize](4, rope.size())
    h.expect_eq[String]("hXYZ", rope.string())
    
    true
