//
//  ContentView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 04.06.2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @StateObject private var viewModel = TabViewViewModel.shared
    var body: some View {
        NavigationView {
            if isLoggedIn {
                HomeView()
                    .navigationBarItems(trailing: settingsButton)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("\(viewModel.getTabViewLabel())")
                
            } else {
                LoginView()
                    //.navigationBarTitle("Login")
                    //.navigationTitle("Вход")
            }
        }
    }

    private var settingsButton: some View {
        NavigationLink {
            SettingsView()
        } label: {
            Image(systemName: "gearshape")
        }
    }
}

#Preview {
    ContentView()
}


