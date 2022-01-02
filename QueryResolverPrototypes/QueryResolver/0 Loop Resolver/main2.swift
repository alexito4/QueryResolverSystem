// import Foundation
//
// print("Hello, World!")
/// *
// a
// b
// c
// main: a b c
// */
//
// class FileSystem {
//    struct FileNotFound: Error {
//        let fileName: String
//    }
//
//    private let files = [
//        "main": File(content: [
//            .dependency("a"),
//            .dependency("b"),
//            .text("start main"),
//            .dependencyUppercase("c")
//        ]),
//        "a": File(content: [
//            .text("contents of file a")
//        ]),
//        "b": File(content: [
//            .text("contents of file b")
//        ]),
//        "c": File(content: [
//            .text("contents of file c")
//        ])
//    ]
//
//
//    func readFile(_ name: String) throws -> File {
//        if let file = files[name] {
//            return file
//        } else {
//            throw FileNotFound(fileName: name)
//        }
//    }
//
//    struct File {
//        let content: [FileContent]
//    }
//    enum FileContent {
//        case text(String)
//        case dependency(String)
//        case dependencyUppercase(String)
//    }
// }
// let fs = FileSystem()
//
//// -------
//
// struct ReadFile: Query {
//    let fileName: String
//
//    func resolve(_ resolver: Resolver) throws -> Bool {
//        let contents = try fs.readFile(fileName)
//
//        var textParts: [String] = []
//        var queries: [(Query, String)] = []
//        for c in contents.content {
//            switch c {
//            case .text(let string):
//                textParts.append(string)
//            case .dependency(let dependency):
//                if let content = resolver[dependency] {
//                    textParts.append(content)
//                } else {
//                    queries.append((ReadFile(fileName: dependency), dependency))
//                }
//            case .dependencyUppercase(let dependency):
//                if let content = resolver[dependency.uppercased()] {
//                    textParts.append(content)
//                } else {
//                    queries.append((Uppercase(fileName: dependency), dependency.uppercased()))
//                }
//            }
//        }
//
//        if queries.isEmpty {
//            resolver.save(textParts.joined(separator: " || "), for: fileName)
//            return true
//        } else {
//            queries.forEach({ resolver.addQuery($0.0, for: $0.1) })
//            return false
//        }
//    }
// }
//
// struct Uppercase: Query {
//    let fileName: String
//
//    func resolve(_ resolver: Resolver) throws -> Bool {
//        if let contents = resolver[fileName] {
//            resolver.save(contents.uppercased(), for: fileName.uppercased())
//            return true
//        } else {
//            resolver.addQuery(ReadFile(fileName: fileName), for: fileName)
//            return false
//        }
//    }
// }
//
// struct RunFile: Query {
//    let fileName: String
//
//    func resolve(_ resolver: Resolver) -> Bool {
//        if let contents = resolver[fileName] {
//            resolver.setOutput(to: contents)
//            return true
//        } else {
//            resolver.addQuery(ReadFile(fileName: fileName), for: fileName)
//            return false
//        }
//    }
// }
//
// let resolver = Resolver()
// let result = try resolver.resolve(RunFile(fileName: "main"))
// dump(result)
//
//
//
//
//
//
