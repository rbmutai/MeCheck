//
//  IntroItem.swift
//  MeCheck
//
//  Created by Robert Mutai on 29/04/2024.
//

import Foundation

struct IntroItem: Decodable, Identifiable, Hashable {
    var id: Int
    var title: String
    var detail: String
    var icon: String
}
