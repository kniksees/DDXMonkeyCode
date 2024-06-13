//
//  TabViewViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 06.06.2024.
//

import Foundation

class TabViewViewModel: ObservableObject {
    private init() {}
    static var shared = TabViewViewModel()
    @Published var selectedTab = 0
    func getTabViewLabel() -> String {
        return [0: "Вход", 1: "Чат", 2: "Тренировки", 3: "Профиль", 4: "Тренера"][selectedTab]!
    }
}
