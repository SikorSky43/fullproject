import Foundation

struct Transaction: Identifiable, Codable {
    let id: Int
    let user_id: Int?
    let wallet_address: String
    let type: String
    let asset: String        // FIXED: matches DB
    let amount: String       // Laravel returns string
    let date: String         // timestamp (includes time)

    // No "time" field in DB

    let user: user?
}
