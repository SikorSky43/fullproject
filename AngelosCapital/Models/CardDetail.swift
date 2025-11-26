//
//  CardDetailsModel.swift
//  Angelos
//
//  Created by BlackBird on 24/11/25.
//

import Foundation
struct CardDetail: Codable, Identifiable {
    let id: Int
    let user_id: Int
    let card_number: String
    let expiry_month: Int
    let expiry_year: Int
    let cvv: String
}
