//
//  GratitudeItem.swift
//  MeCheck
//
//  Created by Robert Mutai on 04/04/2024.
//

import Foundation

struct GratitudeItem: Decodable, Identifiable, Hashable {
    var id: Int
    var detail: String
    var responsible: String
    var icon: String
    var date: Date
}
