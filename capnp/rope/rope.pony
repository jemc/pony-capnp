
interface val _RopeSegment is ReadSeq[U8]
  fun size(): USize
  fun apply(i: USize): U8?
  fun values(): Iterator[U8]

primitive RopeNone is _RopeSegment
  fun size(): USize            => 0
  fun apply(i: USize): U8?     => error
  fun values(): Iterator[U8] =>
    object ref is Iterator[U8]
      fun ref has_next(): Bool => false
      fun ref next(): U8?      => error
    end

class val _ArraySliceU8 is _RopeSegment
  let array: Array[U8] val
  let start: USize
  let finish: USize
  new val create(a: Array[U8] val, s: USize, f: USize) =>
    array = a; start = s; finish = f
  
  fun size(): USize                   => finish - start
  fun apply(i: USize): U8?            => array(start + i)
  fun slice(i: USize, j: USize): Rope => Rope(_ArraySliceU8(array, start + i, (start + j).min(finish)))
  fun values(): Iterator[U8] =>
    object is Iterator[U8]
      let slice: _ArraySliceU8 box = this
      var index: USize             = start
      fun ref has_next(): Bool => index < slice.finish
      fun ref next(): U8? =>
        if has_next() then slice.array(index = index + 1) else error end
    end

class val Rope is (_RopeSegment & Stringable)
  let _left:  _RopeSegment
  let _right: _RopeSegment
  let _weight: USize
  
  new val create(l: _RopeSegment = RopeNone, r: _RopeSegment = RopeNone) =>
    _left = l
    _right = r
    _weight = l.size()
  
  fun size(): USize =>
    _weight + _right.size()
  
  fun apply(i: USize): U8? =>
    if _weight <= i
    then _right(i - _weight)
    else _left(i)
    end
  
  fun slice(i: USize, j: USize): Rope =>
    if j <= i then return Rope(RopeNone) end
    
    match ((_weight <= i), (_weight < j))
    | (true,  true)  => _slice_segment(_right, i - _weight, j - _weight)
    | (false, false) => _slice_segment(_left, i, j)
    | (false, true)  => Rope(_slice_segment(_left, i, _weight),
                             _slice_segment(_right, 0, j - _weight))
    else Rope(RopeNone)
    end
  
  fun tag _slice_segment(seg': _RopeSegment, i: USize, j: USize): Rope =>
    match seg'
    | let seg: Array[U8] val => Rope(_ArraySliceU8(seg, i, j))
    | let seg: _ArraySliceU8 => seg.slice(i, j)
    | let seg: Rope          => seg.slice(i, j)
    | let seg: RopeNone      => Rope(RopeNone)
    else _copy_slice_segment(seg', i, j)
    end
  
  fun tag _copy_slice_segment(seg: _RopeSegment box, i: USize, j: USize): Rope =>
    let slice_seg = recover trn Array[U8] end
    try
      var index = i
      while index < j do
        slice_seg.push(seg.apply(index))
      index = index + 1 end
    end
    Rope(consume slice_seg)
  
  fun values(): Iterator[U8] =>
    object is Iterator[U8]
      let _left_values:  Iterator[U8] = _left.values()
      let _right_values: Iterator[U8] = _right.values()
      fun ref has_next(): Bool => _left_values.has_next()
                               or _right_values.has_next()
      fun ref next(): U8?      => try _left_values.next()
                                 else _right_values.next() end
    end
  
  fun val add(that: _RopeSegment): Rope =>
    // TODO: balance the tree here when helpful
    if _right is RopeNone then
      if _left is RopeNone then
        Rope(that)
      else
        Rope(_left, that)
      end
    else
      Rope(this, that)
    end
  
  fun u16(offset: USize): U16? => apply(offset).u16()
                               + (apply(offset + 1).u16() << 8)
  fun u32(offset: USize): U32? => apply(offset).u32()
                               + (apply(offset + 1).u32() << 8)
                               + (apply(offset + 2).u32() << 16)
                               + (apply(offset + 3).u32() << 24)
  fun u64(offset: USize): U64? => apply(offset).u64()
                               + (apply(offset + 1).u64() << 8)
                               + (apply(offset + 2).u64() << 16)
                               + (apply(offset + 3).u64() << 24)
                               + (apply(offset + 4).u64() << 32)
                               + (apply(offset + 5).u64() << 40)
                               + (apply(offset + 6).u64() << 48)
                               + (apply(offset + 7).u64() << 56)
  
  fun string(fmt: FormatDefault = FormatDefault,
    prefix: PrefixDefault = PrefixDefault, prec: USize = -1, width: USize = 0,
    align: Align = AlignLeft, fill: U32 = ' '
  ): String iso^ =>
    let len = size()
    let out = recover iso String(len) end
    for byte in values() do out.push(byte) end
    out
