// import Foundation
//
// actor AsyncStorage<Key: Hashable, Value> {
//    private var dictionary: [Key: Value] = [:]
//
//    private var waiters: [Key: [UUID: AsyncFuture<Value>]] = [:]
//
//    private func waitForResult(_ key: Key) async -> Value {
//        let id = UUID()
//        let future = AsyncFuture<Value>()
//        waiters[key, default: [:]][id] = future
//
//        let result = await future.getValue()
//
//        waiters[key, default: [:]][id] = nil
//        return result
//    }
//
//    func read(_ key: Key) async -> Value {
//        let result = dictionary[key]
//        if let result = result {
//            return result
//        }
//        return await waitForResult(key)
//    }
//
//    func write(_ value: Value, for key: Key) {
//        dictionary[key] = value
//        waiters[key]?.values.forEach { $0.send(dictionary[key]!) }
//    }
// }
