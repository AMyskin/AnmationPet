import Foundation

protocol QueueProtocol {
    associatedtype Element

    mutating func enqueue(_ element: Element)

    mutating func dequeue() -> Element?

    var isEmpty: Bool { get }

    var peek: Element? { get }

    var count: Int { get }
}

public struct Queue<T>: QueueProtocol {
    typealias Element = T

    private var array: [T] = []
    /// Добавляем в конец
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    /// Удаляем из начала
    public mutating func dequeue() -> T? {
        return isEmpty ? nil : array.removeFirst()
    }

    public var count: Int {
        array.count
    }

    public var isEmpty: Bool {
        array.isEmpty
    }
    /// Первый объект без удаления
    public var peek: T? {
        array.first
    }
}
