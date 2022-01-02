//
// import Foundation
//
// struct AST {}
//
// protocol Parser {
//    func parse(_ input: String) -> AST
// }
//
// class DBProxy<T> {
//    let impl: T
//    let storage = [String:String]()
// }
//
// struct ParserImpl: Parser {
//    func parse(_ input: String) -> AST {
//        print("real parser")
//        return AST()
//    }
// }
//
// class MyDB: DBProxy, Parser {
//    let p = ParserImpl()
//
//    func parse(_ input: String) -> AST {
//
//    }
// }
//
// @main
// struct SwiftProxyTest {
//    static func main() async throws {
//        let db = MyDB()
//        db.parse("a")
//    }
// }
//
//
