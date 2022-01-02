import CollectionConcurrencyKit
import Foundation

// -------

struct ReadFile: Query {
    var key: String { fileName }

    let fileName: String

    func resolve(_ resolver: AsyncResolver) async throws -> Bool {
//        print("Running READ FILE for \(self.key)")
//        defer { print("END READ FILE for \(self.key)") }

        let contents = try fs.readFile(fileName)
        let textParts: [String] = await contents.content.concurrentMap { c in
            switch c {
            case let .text(string):
                return string
            case let .dependency(dependency):
                let content = await resolver.readFile(dependency)
                return content
            case let .dependencyUppercase(dependency):
                let content = await resolver.query(
                    ReadFile(fileName: dependency),
                    Uppercase(input: dependency)
                )
                return content
            case let .declaration(left, right):
                await resolver.save(right, for: left)
                return "\(left) declares \(right)"
            case let .usage(left):
                let right = await resolver.read(left)
                return "\(left) usage found \(right)"
            }
        }
        await resolver.save(textParts.joined(separator: " || "), for: key)
        return true
    }
}

struct Uppercase: Query {
    var key: String { input.uppercased() }

    let input: String

    func resolve(_ resolver: AsyncResolver) async throws -> Bool {
        let contents = await resolver.read(input)
        await resolver.save(contents.uppercased(), for: key)
        return true
    }
}

struct RunFile: Query {
    var key: String { "run \(fileName)" }

    let fileName: String

    func resolve(_ resolver: AsyncResolver) async -> Bool {
        await resolver.addQuery(ReadFile(fileName: fileName))
        let contents = await resolver.read(fileName)
        await resolver.setOutput(to: contents)
        return true
    }
}

extension AsyncResolver {
    // Prepareation of functions
    func readFile(_ fileName: String) async -> String {
        await query(ReadFile(fileName: fileName))
    }

    func uppercase(_ original: String) async -> String {
        await query(Uppercase(input: original))
    }

    func runFile(_ fileName: String) async -> String {
        addQuery(RunFile(fileName: fileName))
        return await read("_OUTPUT_")
    }
}

@main
enum MainWithFakeFunctions {
    static func main() async throws {
        let resolver = AsyncResolver()
//        resolver.debug()
        let result = await resolver.runFile("main")
        print(">>>", result)
    }
}

/// Run file main
/// Read file main
/// Dependency a found.
