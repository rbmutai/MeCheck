//
//  MenuItem.swift
//  MeCheck
//
//  Created by Robert Mutai on 05/04/2024.
//

import Foundation

struct MenuItem: Decodable, Identifiable, Hashable {
    var id: Int
    var title: String
    var icon: String
}
