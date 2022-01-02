import Foundation

class FileSystem {
    struct FileNotFound: Error {
        let fileName: String
    }

//    private let files = [
//        "main": File(content: [
//            .dependency("a"),
//            .dependency("b"),
//            .text("start main"),
//            .usage("type"),
//            .dependencyUppercase("c"),
//        ]),
//        "a": File(content: [
//            .text("contents of file a"),
//            .usage("type")
//        ]),
//        "b": File(content: [
//            .text("contents of file b"),
//        ]),
//        "c": File(content: [
//            .text("contents of file c"),
//            .dependency("d")
//        ]),
//        "d": File(content: [
//            .text("contents of file d"),
//            .dependency("declarations")
//        ]),
//        "declarations": File(content: [
//            .declaration("type", "String"),
//            .usage("type")
//        ]),
//    ]

    private let files = [
        "main": File(content: [
            .dependency("a"),
            .text("start main"),
            .usage("type"),
            .dependency("b"),
        ]),
        "a": File(content: [
            .text("contents of file a"),
        ]),
        "b": File(content: [
            .text("contents of file b"),
            .declaration("type", "String"),
            .dependency("a"),
        ]),
    ]

    func readFile(_ name: String) throws -> File {
        if let file = files[name] {
            return file
        } else {
            throw FileNotFound(fileName: name)
        }
    }

    struct File {
        let content: [FileContent]
    }

    enum FileContent {
        case text(String)
        case dependency(String)
        case dependencyUppercase(String)
        case declaration(String, String)
        case usage(String)
    }
}

let fs = FileSystem()
