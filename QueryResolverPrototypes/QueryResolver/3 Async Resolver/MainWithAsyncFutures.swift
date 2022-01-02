////import Foundation
//// -------
//
// struct ReadFile: Query {
//    var key: String { fileName }
//
//    let fileName: String
//
//    func resolve(_ resolver: AsyncResolver) async throws -> Bool {
//        print("Running READ FILE for \(self.key)")
//        let contents = try fs.readFile(fileName)
//
//        var textParts: [String] = []
//        for c in contents.content {
//            switch c {
//            case let .text(string):
//                textParts.append(string)
//            case let .dependency(dependency):
//                let content = await resolver.query(ReadFile(fileName: dependency))
//                textParts.append(content)
//            case let .dependencyUppercase(dependency):
//                let content = await resolver.query(
//                    ReadFile(fileName: dependency),
//                    Uppercase(input: dependency)
//                )
//                textParts.append(content)
//            }
//        }
//
//        await resolver.save(textParts.joined(separator: " || "), for: key)
//        return true
//    }
// }
//
// struct Uppercase: Query {
//    var key: String { input.uppercased() }
//
//    let input: String
//
//    func resolve(_ resolver: AsyncResolver) async throws -> Bool {
//        let contents = await resolver.read(input)
//        await resolver.save(contents.uppercased(), for: key)
//        return true
//    }
// }
//
// struct RunFile: Query {
//    var key: String { "run \(fileName)" }
//
//    let fileName: String
//
//    func resolve(_ resolver: AsyncResolver) async -> Bool {
//        await resolver.addQuery(ReadFile(fileName: fileName))
//        print("aa")
////        resolver.debug()
//        let contents = await resolver.read(fileName)
//        await resolver.setOutput(to: contents)
//        return true
//    }
// }
//
// @main
// enum MainWithAsyncFutures {
//    static func main() async throws {
//        let resolver = AsyncResolver()
//        let result = try await resolver.resolve(RunFile(fileName: "main"))
//        dump(result)
//        dump(resolver)
//    }
// }
//
//
