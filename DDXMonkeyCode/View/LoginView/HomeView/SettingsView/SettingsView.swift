//
//  SettingsView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 04.06.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        ScrollView {
            SettingsCellView(text: "Выйти") {
                isLoggedIn = false
            }
            SettingsCellView(text: "Купить премиум") {}

        }
        .navigationTitle("Настройки")
    }
}

#Preview {
    SettingsView()
}
