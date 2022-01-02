//
// import Foundation
// import OrderedCollections
//
//// Query: Input -> (Modified storage, More queries)
//
// protocol Query {
//    func resolve(_ resolver: Resolver) throws -> Bool // completed?
// }
//
////final class AnyQuery {
////    let query: Any
////    let _resolve: () -> Bool
////
////    init<Q: Query>(query: Q) {
////        self.query = query
////        self._resolve = query.resolve
////    }
////
////    func resolve() -> Bool {
////        self._resolve()
////    }
////}
//
////enum QueryResult: ExpressibleByBooleanLiteral {
////    case success(String)
////    case failure(String)
////    case pending
////}
//
// final class Resolver {
//    private let initialKey = "_INITIAL_"
//    private let outputKey = "_OUTPUT_"
//    private var storage: [String: String] = [:]
//    private var queries: OrderedDictionary<String, Query> = [:]
//
//    func addQuery(_ query: Query, for key: String) {
//        queries[key] = query
//    }
//
//    subscript(_ key: String) -> String? {
//        return storage[key]
//    }
//
//    func save(_ value: String, for key: String) {
//        storage[key] = value
//    }
//
//    func setOutput(to result: String) {
//        save(result, for: outputKey)
//    }
//
//    func resolve(_ initialQuery: Query) throws -> String {
//        addQuery(initialQuery, for: initialKey)
//        var loop = 0
//        while !queries.isEmpty {
//            debug(loop)
//            defer { loop += 1}
//
//            let (key, query) = queries.elements.removeFirst()
//            let completed = try query.resolve(self)
//            if !completed {
//                queries[key] = query
//            }
//        }
//        if let output = storage[outputKey] {
//            return output
//        } else {
//            throw CouldntResolve()
//        }
//    }
//
//    func debug(_ loop: Int) {
//        print("--- \(loop) ---")
//        print("--- STORAGE ---")
//        dump(storage)
//        print("--- QUERIES ---")
//        dump(queries)
//        print("------")
//        print("")
//    }
//
//    struct CouldntResolve: Error {}
// }
