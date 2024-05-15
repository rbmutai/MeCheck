//
//  PurchaseItem.swift
//  MeCheck
//
//  Created by Robert Mutai on 14/05/2024.
//

import Foundation

struct PurchaseItem : Decodable, Identifiable, Hashable {
    var id: String
    var purchaseDate: Date
    var expirationDate: Date?
}
