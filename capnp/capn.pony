
trait val CapnStruct new val create(s': CapnStructPtr)
trait val CapnGroup is CapnStruct
trait val CapnEnum

class CapnList[A: CapnStruct val] is ReadSeq[A] let _list: CapnListPtrToStructs
  new create(list': CapnListPtrToStructs) => _list = list'
  fun size(): USize => _list.size()
  fun apply(i: USize): A^? => A(_list(i)?)
  fun values(): Iterator[A^]^ =>
    object is Iterator[A]
      let _inner: Iterator[CapnStructPtr] = this._list.values()
      fun ref has_next(): Bool => _inner.has_next()
      fun ref next(): A^? => A(_inner.next()?)
    end
