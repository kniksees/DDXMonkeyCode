//
//  LoginButtonView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 05.06.2024.
//

import SwiftUI

struct LoginButtonView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    var action: () -> ()
    var body: some View {
        Button {
            isLoggedIn = true
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color(.appBlack))
                Text("Вход")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color(.appWhite))
            }
            .frame(width: 77, height: 31)
            
        }

    }
}

#Preview {
    LoginButtonView {
        
    }
}
