//
//  TraineSlotSelectorViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import Foundation

struct TraineSlotMonth {
    let id: Int
    let countOfDay: Int
    let busyTime: TraineSlotDay
}

struct TraineSlotDay {
    let id: Int
    let busyTime: [Int]
}
