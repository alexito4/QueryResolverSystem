import AsyncChannel
import Foundation

actor AsyncStorage<Key: Hashable, Value> {
    private var dictionary: [Key: Value] = [:]

    private var channels: [Key: AsyncChannel<Value>] = [:]

    func read(_ key: Key) async -> Value {
        let result = dictionary[key]
        if let result = result {
            return result
        }

        let channel: AsyncChannel<Value>
        if let c = channels[key] {
            channel = c
        } else {
            channel = .init()
            channels[key] = channel
        }
        defer { channels[key] = nil }
        return try! await channel.value
    }

    func write(_ value: Value, for key: Key) {
        dictionary[key] = value
        channels[key]?.send(dictionary[key]!)
    }
}
