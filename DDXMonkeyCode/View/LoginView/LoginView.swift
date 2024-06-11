//
//  LoginView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 04.06.2024.
//

import SwiftUI

struct LoginView: View {
//    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var login = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color(.appWhite)
                .ignoresSafeArea()
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(.appLigntGray))
                    TextField(text: $login) {
                        Text("Логин")
                            .foregroundStyle(Color(.appDarkGray))
                            .font(.system(size: 12, weight: .regular))
                    }
                    .autocapitalization(.none)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 20))
                }
                .frame(width: 350, height: 31)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(.appLigntGray))
                    SecureField(text: $password) {
                        Text("Пароль")
                            .foregroundStyle(Color(.appDarkGray))
                            .font(.system(size: 12, weight: .regular))
                    }
                    .autocapitalization(.none)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 20))
                }
                .frame(width: 350, height: 31)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                LoginButtonView {
                    LoginViewModel.shared.login = login
                    LoginViewModel.shared.password = password
                    Task {
                        var userID = await LoginViewModel.shared.login(username: login, password: password)
                        print(userID)
                        UserDefaults.standard.set(userID, forKey: "userID")
                    }

//                    UserDefaults.standard.set(Int(login), forKey: "username")
                }
            }
            
        }

    }
    
}

#Preview {
    LoginView()
}

