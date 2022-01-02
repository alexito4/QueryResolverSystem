import Foundation
import OrderedCollections

public protocol Query {
    var key: String { get }
    func resolve(_ resolver: AsyncResolver) async throws -> Bool // completed?
}

public actor AsyncResolver {
    private let outputKey = "_OUTPUT_"

    private var storage = AsyncStorage<String, String>()
    private var ranQueries: OrderedDictionary<String, Query> = [:]

    public func addQuery(_ query: Query) {
        guard ranQueries[query.key] == nil else {
            // Skip since the query already ran
            return
        }
        ranQueries[query.key] = query
        Task {
            try await query.resolve(self)
            // don't remove the query from ranQueries cause if it comes again we don't want to re run it
        }
    }

    public func read(_ key: String) async -> String {
        print("||| Reading \(key)")
        defer { print("||| Read \(key)") }
        return await storage.read(key)
    }

    // having to add queries and then read seems too disconected.
    // wait if we run query and get result...
    public func query(_ queries: Query...) async -> String {
        for query in queries {
            addQuery(query)
        }
        return await read(queries.last!.key)
    }

    public func save(_ value: String, for key: String) async {
        print("||| save \(key)")
        await storage.write(value, for: key)
    }

    public func setOutput(to result: String) async {
        await save(result, for: outputKey)
    }

    public func resolve(_ initialQuery: Query) async throws -> String {
        addQuery(initialQuery)

        let output = await storage.read(outputKey)
        return output
//        } else {
//            throw CouldntResolve()
//        }
    }

    struct CouldntResolve: Error {}

    nonisolated func debug() {
        Task.detached {
            while true {
                dump(self)
                await Task.sleep(1 * NSEC_PER_SEC)
            }
        }
    }
}
