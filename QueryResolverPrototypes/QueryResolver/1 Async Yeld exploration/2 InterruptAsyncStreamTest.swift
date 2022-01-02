//
// import Foundation
// import Combine
//
// struct US<T>: @unchecked Sendable {
//    var value: T?
// }
//
// actor DataStorage {
//    private var dictionary: Dictionary<Int, String> = [:]
//
//    private var waiters: Dictionary<Int, [UUID: PassthroughSubject<String, Never>]> = [:]
//
//    private func waitForResult(_ i: Int) async -> String {
//        let id = UUID()
//        let subject = PassthroughSubject<String, Never>()
//        waiters[i, default: [:]][id] = subject
//
//        var cancellable: AnyCancellable?
//        let result: String = await withCheckedContinuation { continuation in
//            cancellable = subject.sink { result in
//                continuation.resume(returning: result)
//            }
//        }
//        let _ = cancellable
//        waiters[i, default: [:]][id] = nil
//        return result
//    }
//
//    func read(_ i: Int) async -> String {
//        let result = dictionary[i]
//        if let result = result {
//            return result
//        }
//        return await waitForResult(i)
//    }
//
//    func save(_ n: Int) {
//        dictionary[n] = "\(n)"
//        waiters[n]?.values.forEach({ $0.send(dictionary[n]!) })
//    }
// }
//
// func pausableGetValue(_ data: DataStorage, i: Int) async -> String {
//    return await data.read(i)
// }
//
// @main
// struct YeldInterruptionTest {
//    static func main() async throws {
//        print("main")
//        let data = DataStorage()
//        let result = await withTaskGroup(of: String.self, returning: String.self) { group in
//            group.addTask(priority: .low) {
//                async let v100 = await pausableGetValue(data, i: 100)
//                async let v50 = await pausableGetValue(data, i: 50)
//                Task {
//                    await Task.sleep(2 * NSEC_PER_SEC)
//                    await data.save(2000)
//                }
//                async let v2000 = await pausableGetValue(data, i: 2000)
//                return await "--> \(v100) - \(v50) - \(v2000)"
//            }
//            group.addTask {
//                for i in 0...1000 {
//                    await data.save(i)
//                    await Task.sleep(10)
//                }
//                return ""
//            }
//            return await group
//                .filter({ !$0.isEmpty })
//                .reduce("", +)
//        }
//        print(result)
//    }
// }
