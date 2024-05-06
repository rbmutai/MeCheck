//
//  ReminderItem.swift
//  MeCheck
//
//  Created by Robert Mutai on 06/05/2024.
//

import Foundation
struct ReminderItem: Decodable, Identifiable, Hashable {
    var id: Int
    var title: String
    var time: Date
}

