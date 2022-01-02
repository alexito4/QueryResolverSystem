//
// import Foundation
//
// actor DataStorage {
//    var dictionary: Dictionary<Int, String> = [:]
//
//    func save(_ n: Int) {
//        dictionary[n] = "\(n)"
//    }
// }
//
// func pausableGetValue(_ data: DataStorage, i: Int) async -> String {
//    var result: String?
//    var count = 1
//    repeat {
//        print(i, "try", count)
//        count += 1
//        result = await data.dictionary[i]
//        await Task.yield()
//        await Task.sleep(1)
//    } while result == nil
//    return result!
// }
//
// @main
// struct YeldTest {
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
