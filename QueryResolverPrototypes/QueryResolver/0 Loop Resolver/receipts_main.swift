// import Foundation
//
// print("Hello, World!")
//
/// *
// Health Potion
// - boil 5
// - add unicorn horn
// - add stuffed dragon heart
// - add plethore juice
// - stir 2
// - add fae tears
// - cool down 10
//
// boil number = "Boil in water for number minutes"
// */
//
// struct RawReceipt {
//    let name: String
//    let actions: [Action]
//
//    struct Action {
//        let action: String
//        let param: String
//    }
// }
//
// let receipt = RawReceipt(
//    name: "Health Potion",
//    actions: [
//        .init(action: "boil", param: "5"),
//        .init(action: "add", param: "unicorn horn"),
//        .init(action: "add", param: "stuffed dragon heart"),
//        .init(action: "add", param: "plethora juice"),
//        .init(action: "stir", param: "2"),
//        .init(action: "add", param: "fae tears"),
//        .init(action: "cool down", param: "10")
//    ]
// )
//// boil number = "Boil in water for number minutes"
// let boil = Receipt.Step.init(action: "boil", param: .number(5))
//
// struct Receipt {
//    let name: String
//    let steps: [Step]
//
//    struct Step {
//        let action: String
//        let param: Param
//
//        enum Param {
//            case number(Int)
//            case ingredient(Ingredient)
//        }
//    }
// }
//
// enum Ingredient {
//    case raw(String)
//    case prepared(Receipt)
// }
//
//// -----
//
// struct ReceiptQuery: Query {
//    let receipt: RawReceipt
//
//    func resolve(_ resolver: Resolver) -> Bool {
//        for action in receipt.actions {
////            if let resolver[action.action]
//        }
//        return true
//    }
// }
//
// struct StepInput: Query {
//    let
// }
//
//// -----
//
// let resolver = Resolver()
// let result = try resolver.resolve(ReceiptQuery(receipt: receipt))
// dump(result)
//
//
//
//
//
//
