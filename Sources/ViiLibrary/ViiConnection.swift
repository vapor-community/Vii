public protocol ViiConnection: class {
    associatedtype ViiConnectionType
    var connection: ViiConnectionType { get set }
}
