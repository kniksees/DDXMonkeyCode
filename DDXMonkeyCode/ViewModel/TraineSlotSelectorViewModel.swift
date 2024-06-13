//
//  TraineSlotSelectorViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import Foundation

struct Slots {
    let freeSlots: [TraineSlotDay]
}

struct TraineSlotDay {
    let dayNumber: Int
    let freeSlots: [String]
}

