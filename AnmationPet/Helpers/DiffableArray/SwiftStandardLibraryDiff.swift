import Foundation

// swiftlint:disable identifier_name
// swiftlint:disable type_name
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
// swiftlint:disable legacy_multiple
// swiftlint:disable file_length

public struct StdCollectionDifference<ChangeElement> {
  /// A single change to a collection.
  @frozen
  public enum Change {
    /// An insertion.
    ///
    /// The `offset` value is the offset of the inserted element in the final
    /// state of the collection after the difference is fully applied.
    /// A non-`nil` `associatedWith` value is the offset of the complementary
    /// change.
    case insert(offset: Int, element: ChangeElement, associatedWith: Int?)

    /// A removal.
    ///
    /// The `offset` value is the offset of the element to be removed in the
    /// original state of the collection. A non-`nil` `associatedWith` value is
    /// the offset of the complementary change.
    case remove(offset: Int, element: ChangeElement, associatedWith: Int?)

    // Internal common field accessors
    internal var _offset: Int {
        switch self {
        case .insert(offset: let o, element: _, associatedWith: _):
          return o
        case .remove(offset: let o, element: _, associatedWith: _):
          return o
        }
    }
    internal var _element: ChangeElement {
        switch self {
        case .insert(offset: _, element: let e, associatedWith: _):
          return e
        case .remove(offset: _, element: let e, associatedWith: _):
          return e
        }
    }
    internal var _associatedOffset: Int? {
        switch self {
        case .insert(offset: _, element: _, associatedWith: let o):
          return o
        case .remove(offset: _, element: _, associatedWith: let o):
          return o
        }
    }
  }

  /// The insertions contained by this difference, from lowest offset to
  /// highest.
  public let insertions: [Change]

  /// The removals contained by this difference, from lowest offset to highest.
  public let removals: [Change]

  /// The public initializer calls this function to ensure that its parameter
  /// meets the conditions set in its documentation.
  ///
  /// - Parameter changes: a collection of `StdCollectionDifference.Change`
  ///   instances intended to represent a valid state transition for
  ///   `StdCollectionDifference`.
  ///
  /// - Returns: whether the parameter meets the following criteria:
  ///
  ///   1. All insertion offsets are unique
  ///   2. All removal offsets are unique
  ///   3. All associations between insertions and removals are symmetric
  ///
  /// Complexity: O(`changes.count`)
  private static func _validateChanges<Changes: Collection>(
    _ changes: Changes
  ) -> Bool where Changes.Element == Change {
    if changes.isEmpty { return true }

    var insertAssocToOffset = [Int: Int]()
    var removeOffsetToAssoc = [Int: Int]()
    var insertOffset = Set<Int>()
    var removeOffset = Set<Int>()

    for change in changes {
      let offset = change._offset
      if offset < 0 { return false }

      switch change {
      case .remove:
        if removeOffset.contains(offset) { return false }
        removeOffset.insert(offset)
      case .insert:
        if insertOffset.contains(offset) { return false }
        insertOffset.insert(offset)
      }

      if let assoc = change._associatedOffset {
        if assoc < 0 { return false }
        switch change {
        case .remove:
          if removeOffsetToAssoc[offset] != nil { return false }
          removeOffsetToAssoc[offset] = assoc
        case .insert:
          if insertAssocToOffset[assoc] != nil { return false }
          insertAssocToOffset[assoc] = offset
        }
      }
    }

    return removeOffsetToAssoc == insertAssocToOffset
  }

  /// Creates a new collection difference from a collection of changes.
  ///
  /// To find the difference between two collections, use the
  /// `difference(from:)` method declared on the `BidirectionalCollection`
  /// protocol.
  ///
  /// The collection of changes passed as `changes` must meet these
  /// requirements:
  ///
  /// - All insertion offsets are unique
  /// - All removal offsets are unique
  /// - All associations between insertions and removals are symmetric
  ///
  /// - Parameter changes: A collection of changes that represent a transition
  ///   between two states.
  ///
  /// - Complexity: O(*n* * log(*n*)), where *n* is the length of the
  ///   parameter.
  public init?<Changes: Collection>(
    _ changes: Changes
  ) where Changes.Element == Change {
    guard StdCollectionDifference<ChangeElement>._validateChanges(changes) else {
      return nil
    }

    self.init(_validatedChanges: changes)
  }

  /// Internal initializer for use by algorithms that cannot produce invalid
  /// collections of changes. These include the Myers' diff algorithm,
  /// self.inverse(), and the move inferencer.
  ///
  /// If parameter validity cannot be guaranteed by the caller then
  /// `StdCollectionDifference.init?(_:)` should be used instead.
  ///
  /// - Parameter c: A valid collection of changes that represent a transition
  ///   between two states.
  ///
  /// - Complexity: O(*n* * log(*n*)), where *n* is the length of the
  ///   parameter.
  internal init<Changes: Collection>(
    _validatedChanges changes: Changes
  ) where Changes.Element == Change {
    let sortedChanges = changes.sorted { (a, b) -> Bool in
      switch (a, b) {
      case (.remove, .insert):
        return true
      case (.insert, .remove):
        return false
      default:
        return a._offset < b._offset
      }
    }

    // Find first insertion via binary search
    let firstInsertIndex: Int
    if sortedChanges.isEmpty {
      firstInsertIndex = 0
    } else {
      var range = 0...sortedChanges.count
      while range.lowerBound != range.upperBound {
        let i = (range.lowerBound + range.upperBound) / 2
        switch sortedChanges[i] {
        case .insert:
          range = range.lowerBound...i
        case .remove:
          range = (i + 1)...range.upperBound
        }
      }
      firstInsertIndex = range.lowerBound
    }

    removals = Array(sortedChanges[0..<firstInsertIndex])
    insertions = Array(sortedChanges[firstInsertIndex..<sortedChanges.count])
  }

  public func inverse() -> Self {
    return StdCollectionDifference(_validatedChanges: self.map { c in
      switch c {
      case .remove(let o, let e, let a):
          return .insert(offset: o, element: e, associatedWith: a)
      case .insert(let o, let e, let a):
          return .remove(offset: o, element: e, associatedWith: a)
      }
    })
  }
}

/// A StdCollectionDifference is itself a Collection.
///
/// The enumeration order of `Change` elements is:
///
/// 1. `.remove`s, from highest `offset` to lowest
/// 2. `.insert`s, from lowest `offset` to highest
///
/// This guarantees that applicators on compatible base states are safe when
/// written in the form:
///
/// ```
/// for c in diff {
///   switch c {
///   case .remove(offset: let o, element: _, associatedWith: _):
///     arr.remove(at: o)
///   case .insert(offset: let o, element: let e, associatedWith: _):
///     arr.insert(e, at: o)
///   }
/// }
/// ```
extension StdCollectionDifference: Collection {
  public typealias Element = Change

  /// The position of a collection difference.
  @frozen
  public struct Index {
    // Opaque index type is isomorphic to Int
    @usableFromInline
    internal let _offset: Int

    internal init(_offset offset: Int) {
      _offset = offset
    }
  }

  public var startIndex: Index {
    return Index(_offset: 0)
  }

  public var endIndex: Index {
    return Index(_offset: removals.count + insertions.count)
  }

  public func index(after index: Index) -> Index {
    return Index(_offset: index._offset + 1)
  }

  public subscript(position: Index) -> Element {
    if position._offset < removals.count {
      return removals[removals.count - (position._offset + 1)]
    }
    return insertions[position._offset - removals.count]
  }

  public func index(before index: Index) -> Index {
    return Index(_offset: index._offset - 1)
  }

  public func formIndex(_ index: inout Index, offsetBy distance: Int) {
    index = Index(_offset: index._offset + distance)
  }

  public func distance(from start: Index, to end: Index) -> Int {
    return end._offset - start._offset
  }
}

extension StdCollectionDifference.Index: Equatable {
  @inlinable
  public static func == (
    lhs: StdCollectionDifference.Index,
    rhs: StdCollectionDifference.Index
  ) -> Bool {
    return lhs._offset == rhs._offset
  }
}

extension StdCollectionDifference.Index: Comparable {
  @inlinable
  public static func < (
    lhs: StdCollectionDifference.Index,
    rhs: StdCollectionDifference.Index
  ) -> Bool {
    return lhs._offset < rhs._offset
  }
}

extension StdCollectionDifference.Index: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(_offset)
  }
}

extension StdCollectionDifference.Change: Equatable where ChangeElement: Equatable {}

extension StdCollectionDifference: Equatable where ChangeElement: Equatable {}

extension StdCollectionDifference.Change: Hashable where ChangeElement: Hashable {}

extension StdCollectionDifference: Hashable where ChangeElement: Hashable {}

extension StdCollectionDifference where ChangeElement: Hashable {
  /// Returns a new collection difference with associations between individual
  /// elements that have been removed and inserted only once.
  ///
  /// - Returns: A collection difference with all possible moves inferred.
  ///
  /// - Complexity: O(*n*) where *n* is the number of collection differences.
  public func inferringMoves() -> StdCollectionDifference<ChangeElement> {
    let uniqueRemovals: [ChangeElement: Int?] = {
      var result = [ChangeElement: Int?](minimumCapacity: Swift.min(removals.count, insertions.count))
      for removal in removals {
        let element = removal._element
        if result[element] != .none {
          result[element] = .some(.none)
        } else {
          result[element] = .some(removal._offset)
        }
      }
      return result.filter { (_, v) -> Bool in v != .none }
    }()

    let uniqueInsertions: [ChangeElement: Int?] = {
      var result = [ChangeElement: Int?](minimumCapacity: Swift.min(removals.count, insertions.count))
      for insertion in insertions {
        let element = insertion._element
        if result[element] != .none {
          result[element] = .some(.none)
        } else {
          result[element] = .some(insertion._offset)
        }
      }
      return result.filter { (_, v) -> Bool in v != .none }
    }()

    return StdCollectionDifference(_validatedChanges: map({ (change: Change) -> Change in
      switch change {
      case .remove(offset: let offset, element: let element, associatedWith: _):
        if uniqueRemovals[element] == nil {
          return change
        }
        if let assoc = uniqueInsertions[element] {
          return .remove(offset: offset, element: element, associatedWith: assoc)
        }
      case .insert(offset: let offset, element: let element, associatedWith: _):
        if uniqueInsertions[element] == nil {
          return change
        }
        if let assoc = uniqueRemovals[element] {
          return .insert(offset: offset, element: element, associatedWith: assoc)
        }
      }
      return change
    }))
  }
}

extension StdCollectionDifference.Change: Codable where ChangeElement: Codable {
  private enum _CodingKeys: String, CodingKey {
    case offset
    case element
    case associatedOffset
    case isRemove
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: _CodingKeys.self)
    let offset = try values.decode(Int.self, forKey: .offset)
    let element = try values.decode(ChangeElement.self, forKey: .element)
    let associatedOffset = try values.decode(Int?.self, forKey: .associatedOffset)
    let isRemove = try values.decode(Bool.self, forKey: .isRemove)
    if isRemove {
      self = .remove(offset: offset, element: element, associatedWith: associatedOffset)
    } else {
      self = .insert(offset: offset, element: element, associatedWith: associatedOffset)
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: _CodingKeys.self)
    switch self {
    case .remove:
      try container.encode(true, forKey: .isRemove)
    case .insert:
      try container.encode(false, forKey: .isRemove)
    }

    try container.encode(_offset, forKey: .offset)
    try container.encode(_element, forKey: .element)
    try container.encode(_associatedOffset, forKey: .associatedOffset)
  }
}

extension StdCollectionDifference: Codable where ChangeElement: Codable {}

extension StdCollectionDifference {
  fileprivate func _fastEnumeratedApply(
    _ consume: (Change) throws -> Void
  ) rethrows {
    let totalRemoves = removals.count
    let totalInserts = insertions.count
    var enumeratedRemoves = 0
    var enumeratedInserts = 0

    while enumeratedRemoves < totalRemoves || enumeratedInserts < totalInserts {
      let change: Change
      if enumeratedRemoves < removals.count && enumeratedInserts < insertions.count {
        let removeOffset = removals[enumeratedRemoves]._offset
        let insertOffset = insertions[enumeratedInserts]._offset
        if removeOffset - enumeratedRemoves <= insertOffset - enumeratedInserts {
          change = removals[enumeratedRemoves]
        } else {
          change = insertions[enumeratedInserts]
        }
      } else if enumeratedRemoves < totalRemoves {
        change = removals[enumeratedRemoves]
      } else if enumeratedInserts < totalInserts {
        change = insertions[enumeratedInserts]
      } else {
        // Not reached, loop should have exited.
        preconditionFailure()
      }

      try consume(change)

      switch change {
      case .remove:
        enumeratedRemoves += 1
      case .insert:
        enumeratedInserts += 1
      }
    }
  }
}

// Error type allows the use of throw to unroll state on application failure
private enum _ApplicationError: Error { case failed }

extension RangeReplaceableCollection {
  /// Applies the given difference to this collection.
  ///
  /// - Parameter difference: The difference to be applied.
  ///
  /// - Returns: An instance representing the state of the receiver with the
  ///   difference applied, or `nil` if the difference is incompatible with
  ///   the receiver's state.
  ///
  /// - Complexity: O(*n* + *c*), where *n* is `self.count` and *c* is the
  ///   number of changes contained by the parameter.
  public func applying(_ difference: StdCollectionDifference<Element>) -> Self? {
    func append(
        into target: inout Self,
        contentsOf source: Self,
        from index: inout Self.Index,
        count: Int
    ) throws {
      let start = index
      if !source.formIndex(&index, offsetBy: count, limitedBy: source.endIndex) {
        throw _ApplicationError.failed
      }
      target.append(contentsOf: source[start..<index])
    }

    var result = Self()
    do {
      var enumeratedRemoves = 0
      var enumeratedInserts = 0
      var enumeratedOriginals = 0
      var currentIndex = self.startIndex
      try difference._fastEnumeratedApply { change in
        switch change {
        case .remove(offset: let offset, element: _, associatedWith: _):
          let origCount = offset - enumeratedOriginals
          try append(into: &result, contentsOf: self, from: &currentIndex, count: origCount)
          if currentIndex == self.endIndex {
            // Removing nonexistent element off the end of the collection
            throw _ApplicationError.failed
          }
          enumeratedOriginals += origCount + 1 // Removal consumes an original element
          currentIndex = self.index(after: currentIndex)
          enumeratedRemoves += 1
        case .insert(offset: let offset, element: let element, associatedWith: _):
          let origCount = (offset + enumeratedRemoves - enumeratedInserts) - enumeratedOriginals
          try append(into: &result, contentsOf: self, from: &currentIndex, count: origCount)
          result.append(element)
          enumeratedOriginals += origCount
          enumeratedInserts += 1
        }
      }
      if currentIndex < self.endIndex {
        result.append(contentsOf: self[currentIndex...])
      }
    } catch {
      return nil
    }

    return result
  }
}

// MARK: Definition of API
extension BidirectionalCollection {
  /// Returns the difference needed to produce this collection's ordered
  /// elements from the given collection, using the given predicate as an
  /// equivalence test.
  ///
  /// This function does not infer element moves. If you need to infer moves,
  /// call the `inferringMoves()` method on the resulting difference.
  ///
  /// - Parameters:
  ///   - other: The base state.
  ///   - areEquivalent: A closure that returns a Boolean value indicating
  ///     whether two elements are equivalent.
  ///
  /// - Returns: The difference needed to produce the reciever's state from
  ///   the parameter's state.
  ///
  /// - Complexity: Worst case performance is O(*n* * *m*), where *n* is the
  ///   count of this collection and *m* is `other.count`. You can expect
  ///   faster execution when the collections share many common elements.
  public func std_difference<C: BidirectionalCollection>(
    from other: C,
    by areEquivalent: (C.Element, Element) -> Bool
  ) -> StdCollectionDifference<Element>
  where C.Element == Self.Element {
    return _myers(from: other, to: self, using: areEquivalent)
  }
}

extension BidirectionalCollection where Element: Equatable {
  /// Returns the difference needed to produce this collection's ordered
  /// elements from the given collection.
  ///
  /// This function does not infer element moves. If you need to infer moves,
  /// call the `inferringMoves()` method on the resulting difference.
  ///
  /// - Parameters:
  ///   - other: The base state.
  ///
  /// - Returns: The difference needed to produce this collection's ordered
  ///   elements from the given collection.
  ///
  /// - Complexity: Worst case performance is O(*n* * *m*), where *n* is the
  ///   count of this collection and *m* is `other.count`. You can expect
  ///   faster execution when the collections share many common elements, or
  ///   if `Element` conforms to `Hashable`.
  public func std_difference<C: BidirectionalCollection>(
    from other: C
  ) -> StdCollectionDifference<Element> where C.Element == Self.Element {
    return std_difference(from: other, by: ==)
  }
}

// MARK: Internal implementation
// _V is a rudimentary type made to represent the rows of the triangular matrix
// type used by the Myer's algorithm.
//
// This type is basically an array that only supports indexes in the set
// `stride(from: -d, through: d, by: 2)` where `d` is the depth of this row in
// the matrix `d` is always known at allocation-time, and is used to preallocate
// the structure.
private struct _V {
  private var a: [Int]
#if INTERNAL_CHECKS_ENABLED
  private let isOdd: Bool
#endif

  // The way negative indexes are implemented is by
  // interleaving them in the empty slots between the valid positive indexes
  @inline(__always) private static func transform(_ index: Int) -> Int {
    // -3, -1, 1, 3 -> 3, 1, 0, 2 -> 0...3
    // -2, 0, 2 -> 2, 0, 1 -> 0...2
    return (index <= 0 ? -index : index &- 1)
  }

  init(maxIndex largest: Int) {
#if INTERNAL_CHECKS_ENABLED
    _internalInvariant(largest >= 0)
    isOdd = largest % 2 == 1
#endif
    a = [Int](repeating: 0, count: largest + 1)
  }

  subscript(index: Int) -> Int {
    get {
#if INTERNAL_CHECKS_ENABLED
      _internalInvariant(isOdd == (index % 2 != 0))
#endif
      return a[_V.transform(index)]
    }
    set(newValue) {
#if INTERNAL_CHECKS_ENABLED
      _internalInvariant(isOdd == (index % 2 != 0))
#endif
      a[_V.transform(index)] = newValue
    }
  }
}

private func _myers<C, D>(
    from old: C,
    to new: D,
    using cmp: (C.Element, D.Element) -> Bool
) -> StdCollectionDifference<C.Element>
where
    C: BidirectionalCollection,
    D: BidirectionalCollection,
    C.Element == D.Element
{
  // Core implementation of the algorithm described at http://www.xmailserver.org/diff2.pdf
  // Variable names match those used in the paper as closely as possible
  func _descent(from a: UnsafeBufferPointer<C.Element>, to b: UnsafeBufferPointer<D.Element>) -> [_V] {
    let n = a.count
    let m = b.count
    let max = n + m

    var result = [_V]()
    var v = _V(maxIndex: 1)
    v[1] = 0

    var x = 0
    var y = 0
    iterator: for d in 0...max {
      let prev_v = v
      result.append(v)
      v = _V(maxIndex: d)

      // The code in this loop is _very_ hot—the loop bounds increases in terms
      // of the iterator of the outer loop!
      for k in stride(from: -d, through: d, by: 2) {
        if k == -d {
          x = prev_v[k &+ 1]
        } else {
          let km = prev_v[k &- 1]

          if k != d {
            let kp = prev_v[k &+ 1]
            if km < kp {
              x = kp
            } else {
              x = km &+ 1
            }
          } else {
            x = km &+ 1
          }
        }
        y = x &- k

        while x < n && y < m {
          if !cmp(a[x], b[y]) {
            break
          }
          x &+= 1
          y &+= 1
        }

        v[k] = x

        if x >= n && y >= m {
          break iterator
        }
      }
      if x >= n && y >= m {
        break
      }
    }

    return result
  }

  // Backtrack through the trace generated by the Myers descent to produce the changes that make up the diff
  func _formChanges(
    from a: UnsafeBufferPointer<C.Element>,
    to b: UnsafeBufferPointer<C.Element>,
    using trace: [_V]
  ) -> [StdCollectionDifference<C.Element>.Change] {
    var changes = [StdCollectionDifference<C.Element>.Change]()
    changes.reserveCapacity(trace.count)

    var x = a.count
    var y = b.count
    for d in stride(from: trace.count &- 1, to: 0, by: -1) {
      let v = trace[d]
      let k = x &- y
      let prev_k = (k == -d || (k != d && v[k &- 1] < v[k &+ 1])) ? k &+ 1 : k &- 1
      let prev_x = v[prev_k]
      let prev_y = prev_x &- prev_k

      while x > prev_x && y > prev_y {
        // No change at this position.
        x &-= 1
        y &-= 1
      }

      if y != prev_y {
        changes.append(.insert(offset: prev_y, element: b[prev_y], associatedWith: nil))
      } else {
        changes.append(.remove(offset: prev_x, element: a[prev_x], associatedWith: nil))
      }

      x = prev_x
      y = prev_y
    }

    return changes
  }

  /* Splatting the collections into contiguous storage has two advantages:
   *
   *   1) Subscript access is much faster
   *   2) Subscript index becomes Int, matching the iterator types in the algorithm
   *
   * Combined, these effects dramatically improves performance when
   * collections differ significantly, without unduly degrading runtime when
   * the parameters are very similar.
   *
   * In terms of memory use, the linear cost of creating a ContiguousArray (when
   * necessary) is significantly less than the worst-case n² memory use of the
   * descent algorithm.
   */
  func _withContiguousStorage<C: Collection, R>(
    for values: C,
    _ body: (UnsafeBufferPointer<C.Element>) throws -> R
  ) rethrows -> R {
    if let result = try values.withContiguousStorageIfAvailable(body) { return result }
    let array = ContiguousArray(values)
    return try array.withUnsafeBufferPointer(body)
  }

  return _withContiguousStorage(for: old) { a in
    return _withContiguousStorage(for: new) { b in
      return StdCollectionDifference(_formChanges(from: a, to: b, using: _descent(from: a, to: b)))!
    }
  }
}
