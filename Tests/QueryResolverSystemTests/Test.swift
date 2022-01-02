import CollectionConcurrencyKit
@testable import QueryResolverSystem
import XCTest

final class QueryResolverSystemTests: XCTestCase {
    var resolver: AsyncResolver!

    override func setUp() {
        super.setUp()
        resolver = AsyncResolver()
    }

    override func tearDown() {
        resolver = nil
        super.tearDown()
    }

    func testSimple() async throws {
        files = [
            "main": File(contents: [
                .text("Start of Main"),
            ]),
        ]
        let result = try await resolver.resolve(MainRun())
        XCTAssertEqual(result, "Start of Main")
    }

    func testSimpleDependency() async throws {
        files = [
            "main": File(contents: [
                .import("other"),
                .text("Start of Main"),
            ]),
            "other": .init(contents: [
                .text("Other file."),
            ]),
        ]
        let result = try await resolver.resolve(MainRun())
        XCTAssertEqual(result, """
        Other file.
        Start of Main
        """)
    }

    func testNestedDependencyDeclaration() async throws {
        files = [
            "main": File(contents: [
                .import("other"),
                .text("Start of Main"),
                .usage("A"),
                .usage("B"),
            ]),
            "other": .init(contents: [
                .import("types"),
                .text("Other file."),
            ]),
            "types": .init(contents: [
                .text("Declaring types:"),
                .declaration("A", "Amazing"),
                .declaration("B", "Burr!"),
            ]),
        ]
        let result = try await resolver.resolve(MainRun())
        XCTAssertEqual(result, """
        Declaring types:
        A declares Amazing
        B declares Burr!
        Other file.
        Start of Main
        A usage found Amazing
        B usage found Burr!
        """)
    }

    func testNestedDependencyDeclarationOutOfOrder() async throws {
        files = [
            "main": File(contents: [
                .text("Start of Main"),
                .usage("A"),
                .usage("B"),
                .import("other"),
            ]),
            "other": .init(contents: [
                .text("Other file."),
                .import("types"),
            ]),
            "types": .init(contents: [
                .text("Declaring types:"),
                .declaration("A", "Amazing"),
                .declaration("B", "Burr!"),
            ]),
        ]
        let result = try await resolver.resolve(MainRun())
        XCTAssertEqual(result, """
        Start of Main
        A usage found Amazing
        B usage found Burr!
        Other file.
        Declaring types:
        A declares Amazing
        B declares Burr!
        """)
    }
}

extension AsyncResolver {
    struct ProcessFile: Query {
        var key: String { "process_\(fileName)" }
        let fileName: String

        func resolve(_ resolver: AsyncResolver) async throws -> Bool {
            guard let file = files[fileName] else {
                return false
            }

            let textParts: [String] = await file.contents.concurrentMap { c in
                switch c {
                case let .text(string):
                    return string
                case let .import(dependency):
                    let content = await resolver.processFile(name: dependency)
                    return content
                case let .declaration(left, right):
                    await resolver.save(right, for: left)
                    return "\(left) declares \(right)"
                case let .usage(left):
                    let right = await resolver.read(left)
                    return "\(left) usage found \(right)"
                }
            }
            await resolver.save(textParts.joined(separator: "\n"), for: key)

            return true
        }
    }

    func processFile(name: String) async -> String {
        await query(ProcessFile(fileName: name))
    }
}

var files: [String: File] = [:]

struct MainRun: Query {
    var key: String { "MAIN_RUN" }

    func resolve(_ resolver: AsyncResolver) async throws -> Bool {
        let result = await resolver.processFile(name: "main")
        await resolver.setOutput(to: result)
        return true
    }
}

struct File {
    let contents: [Content]

    enum Content {
        case text(String)
        case `import`(String)
        case declaration(String, String)
        case usage(String)
    }
}
