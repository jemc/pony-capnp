
primitive _Mem
  fun u16(data: String, offset: USize): U16? =>
    // TODO: Use direct pointer access; avoid extra bounds checks
    data(offset)?.u16()
    + (data(offset + 1)?.u16() << 8)
  
  fun u32(data: String, offset: USize): U32? =>
    // TODO: Use direct pointer access; avoid extra bounds checks
    data(offset)?.u32()
    + (data(offset + 1)?.u32() << 8)
    + (data(offset + 2)?.u32() << 16)
    + (data(offset + 3)?.u32() << 24)
  
  fun u64(data: String, offset: USize): U64? =>
    // TODO: Use direct pointer access; avoid extra bounds checks
    data(offset)?.u64()
    + (data(offset + 1)?.u64() << 8)
    + (data(offset + 2)?.u64() << 16)
    + (data(offset + 3)?.u64() << 24)
    + (data(offset + 4)?.u64() << 32)
    + (data(offset + 5)?.u64() << 40)
    + (data(offset + 6)?.u64() << 48)
    + (data(offset + 7)?.u64() << 56)
