//
//  HomeView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 04.06.2024.
//


import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = TabViewViewModel.shared
    
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            QRCodeView()
                .tabItem {
                    Label("Вход", systemImage: "qrcode")
                }
                .tag(0)
            SelectChatView()
                .tabItem {
                    Label("Чат", systemImage: "message")
                }
                .tag(1)
            MyWorkoutsView()
                .tabItem {
                    Label("Тренировки", systemImage: "dumbbell")
                }
                .tag(2)
            MyWorkoutsView()
                .tabItem {
                    Label("Профиль", systemImage: "person")
                }
                .tag(3)
        }.onChange(of: selection) { newValue in
            viewModel.selectedTab = selection
        }
    }
}


#Preview {
    HomeView()
}
