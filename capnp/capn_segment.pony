
use "./rope"

type CapnSegment is Rope

primitive CapnSegmentUtil
  fun tag parse_table(data: Rope): Array[CapnSegment] val? =>
    let segment_count = data.u32(0).u64() + 1
    let segments = recover trn Array[CapnSegment](segment_count) end
    
    let pad_header: Bool = 0 == (segment_count % 2)
    let header_size: U64 =
      if pad_header
      then (segment_count + 2) * 4 // 4 bytes of padding
      else (segment_count + 1) * 4 // 0 bytes of padding
      end
    
    var content_size: U64 = 0
    var segment_index: U64 = 0
    while segment_index < segment_count do
      let segment_offset = header_size + content_size
      let segment_size = data.u32((segment_index + 1) * 4).u64() * 8
      
      segments.push(CapnSegment(
        data.slice(segment_offset, segment_offset + segment_size)
      ))
      
      content_size = content_size + segment_size
      segment_index = segment_index + 1
    end
    
    if data.size() < (header_size + content_size) then error end
    
    segments
