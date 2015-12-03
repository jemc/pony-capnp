
use "debug"

type CapnEntityPtr is (CapnStructPtr | CapnListPtr | CapnCapabilityPtr)

primitive CapnEntityPtrUtil
  fun tag parse(segments: Array[CapnSegment] val, s_index: U64, s_offset: U64): CapnEntityPtr? =>
    let segment = segments(s_index)
    let lower = segment.u32(s_offset)
    
    match (lower and 0b11)
    | 0 => // Struct
      // TODO: review this calculation of data_offset for all edge cases.
      if 0 > ((lower or 0b11) >> 2).i32() then Debug("FIXME") end
      let data_offset    = s_offset + (((lower or 0b11) >> 2).i32().i64() * 8).u64() + 8
      let pointer_offset = data_offset
                         + (segment.u16(s_offset + 4).u64() * 8)
      let end_offset     = pointer_offset
                         + (segment.u16(s_offset + 6).u64() * 8)
      CapnStructPtr(segments, s_index, data_offset, pointer_offset, end_offset)
    | 1 => // List
      // TODO: review this calculation of data_offset for all edge cases.
      if 0 > (lower >> 2).i32() then Debug("FIXME") end
      let data_offset = s_offset + ((lower >> 2).i32().i64() * 8).u64() + 8
      let upper       = segment.u32(s_offset + 4)
      let width_code  = upper and 0b111
      let list_size   = upper >> 3
      CapnListPtrUtil.from(segments, s_index, data_offset, width_code, list_size)
    | 2 => // Far Pointer
      let double_far     = (lower and 0b100) isnt U32(0)
      let pointer_offset = (lower >> 3).u64() * 8
      let segment_index  = segment.u32(s_offset + 4).u64()
      if double_far then Debug("FIXME double_far"); error end
      parse(segments, segment_index, pointer_offset)
    | 3 => // Capability
      let table_index = segment.u32(s_offset + 4)
      CapnCapabilityPtr(table_index)
    else error
    end

class val CapnStructPtr
  let segments: Array[CapnSegment] val
  let segment_index: U64
  let segment: CapnSegment
  let data_offset: U64
  let pointer_offset: U64
  let end_offset: U64
  new val create(s: Array[CapnSegment] val, si: U64, d: U64, p: U64, e: U64)? =>
    segments = s; segment_index = si; segment = s(si)
    data_offset = d; pointer_offset = p; end_offset = e
  
  fun verify(ds: U64, ps: U64)? =>
    if (ds != (pointer_offset - data_offset))
    or (ps != (end_offset - pointer_offset))
    then error end
  
  fun u8(i: U64):  U8  => try segment(data_offset + i)     else 0 end
  fun u16(i: U64): U16 => try segment.u16(data_offset + i) else 0 end
  fun u32(i: U64): U32 => try segment.u32(data_offset + i) else 0 end
  fun u64(i: U64): U64 => try segment.u64(data_offset + i) else 0 end
  fun i8(i: U64):  I8  => u8(i).i8()
  fun i16(i: U64): I16 => u16(i).i16()
  fun i32(i: U64): I32 => u32(i).i32()
  fun i64(i: U64): I64 => u64(i).i64()
  fun f32(i: U64): F32 => u32(i).f32()
  fun f64(i: U64): F64 => u64(i).f64()
  fun bool(i: U64, bitmask: U8): Bool => (u8(i) and bitmask) != 0
  fun check_union(i: U64, value: U16): Bool => u16(i) == value
  fun assert_union(i: U64, value: U16)? => if u16(i) != value then error end
  
  fun pointer(i: U64): CapnEntityPtr? =>
    CapnEntityPtrUtil.parse(segments, segment_index, pointer_offset + (i * 8))
  
  fun pointers(): Iterator[CapnEntityPtr] =>
    object is Iterator[CapnEntityPtr]
      let capn_struct: CapnStructPtr box = this
      var index: U64 = 0
      fun ref has_next(): Bool =>
        (capn_struct.pointer_offset + (index * 8)) < capn_struct.end_offset
      fun ref next(): CapnEntityPtr? =>
        if has_next() then capn_struct.pointer(index = index + 1)
        else error
        end
    end
  
  fun ptr(i: U64): CapnEntityPtr? => pointer(i)
  fun ptr_text(i: U64): String? => (pointer(i) as CapnListPtrToBytes).as_text()
  fun ptr_data(i: U64): Array[U8] val? => error // TODO: implement
  
  fun ptr_list[A: CapnStruct val](i: U64): CapnList[A]? =>
    CapnList[A](pointer(i) as CapnListPtrToStructs)
  
  fun ptr_struct[A: CapnStruct val](i: U64): A^? =>
    A(pointer(i) as CapnStructPtr)

trait val CapnListPtr

class val CapnListPtrToVoids is CapnListPtr
  new val create()? => error // TODO: implement

class val CapnListPtrToBits is CapnListPtr
  new val create()? => error // TODO: implement

class val CapnListPtrToBytes is (CapnListPtr & ReadSeq[U8])
  let segments: Array[CapnSegment] val
  let segment_index: U64
  let data_offset: U64
  let end_offset: U64
  let list_size: U32
  
  new val create(s: Array[CapnSegment] val, si: U64, d: U64, c: U32) =>
    segments = s; segment_index = si
    data_offset = d; end_offset = d + c.u64()
    list_size = c
  
  fun as_text(): String => // TODO: zero-copy? cache?
    let s = recover trn String end
    for v in values() do
      if v == 0 then break end // stop at a null terminator
      s.push(v)
    end
    consume s
  
  fun size(): U64 => list_size.u64()
  
  fun apply(i: U64): U8? =>
    if i < list_size.u64()
    then segments(segment_index)(data_offset + i)
    else error
    end
  
  fun values(): Iterator[U8] =>
    object is Iterator[U8]
      let capn_list: CapnListPtrToBytes box = this
      var index: U64 = 0
      fun ref has_next(): Bool =>
        index < capn_list.list_size.u64()
      fun ref next(): U8? =>
        if has_next() then capn_list(index = index + 1)
        else error
        end
    end

class val CapnListPtrToWords is CapnListPtr
  new val create()? => error // TODO: implement

class val CapnListPtrToPointers is CapnListPtr
  new val create()? => error // TODO: implement

class val CapnListPtrToStructs is (CapnListPtr & ReadSeq[CapnStructPtr])
  let segments: Array[CapnSegment] val
  let segment_index: U64
  let data_offset: U64
  let end_offset: U64
  let list_size: U32
  let struct_data_size: U64
  let struct_pointer_size: U64
  new val create(s: Array[CapnSegment] val, si: U64, d: U64, c: U32)? =>
    segments = s; segment_index = si
    let segment = segments(segment_index)
    
    if c == 0 then
      list_size           = 0
      struct_data_size    = 0
      struct_pointer_size = 0
      data_offset         = d
      end_offset          = d
      return
    end
    
    list_size           = segment.u32(d) >> 2
    struct_data_size    = segment.u16(d + 4).u64() * 8
    struct_pointer_size = segment.u16(d + 6).u64() * 8
    data_offset         = d + 8
    end_offset          = data_offset + (list_size.u64() * (struct_data_size + struct_pointer_size)) // TODO: data_offset + (c.u64() * 8)
    
    // TODO: investigate and reinstate this check, which currently fails in some cases.
    // if (list_size.u64() * (struct_data_size + struct_pointer_size))
    // != (c.u64() * 8) then error end
  
  fun size(): U64 => list_size.u64()
  
  fun apply(i: U64): CapnStructPtr? =>
    if i >= list_size.u64() then error end
    let o0 = data_offset + (i * (struct_data_size + struct_pointer_size))
    let o1 = o0 + struct_data_size
    let o2 = o1 + struct_pointer_size
    CapnStructPtr(segments, segment_index, o0, o1, o2)
  
  fun values(): Iterator[CapnStructPtr] =>
    object is Iterator[CapnStructPtr]
      let capn_list: CapnListPtrToStructs box = this
      var index: U64 = 0
      fun ref has_next(): Bool =>
        index < capn_list.list_size.u64()
      fun ref next(): CapnStructPtr? =>
        if has_next() then capn_list(index = index + 1)
        else error
        end
    end

primitive CapnListPtrUtil
  fun tag from(s: Array[CapnSegment] val,
    si: U64, d: U64, w: U32, c: U32
  ): CapnListPtr? =>
    match w
    | 0 => CapnListPtrToVoids//(s, si, d, c)
    | 1 => CapnListPtrToBits//(s, si, d, c)
    | 2 => CapnListPtrToBytes(s, si, d, c)
    | 3 => CapnListPtrToWords//(s, si, d, c, 2)
    | 4 => CapnListPtrToWords//(s, si, d, c, 4)
    | 5 => CapnListPtrToWords//(s, si, d, c, 8)
    | 6 => CapnListPtrToPointers//(s, si, d, c)
    | 7 => CapnListPtrToStructs(s, si, d, c)
    else error
    end

class val CapnCapabilityPtr
  let table_index: U32
  new val create(i: U32) => table_index = i
