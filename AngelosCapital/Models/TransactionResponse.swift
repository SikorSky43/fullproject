import Foundation

struct TransactionResponse: Codable {
    let status: Bool
    let data: [Transaction]
}
