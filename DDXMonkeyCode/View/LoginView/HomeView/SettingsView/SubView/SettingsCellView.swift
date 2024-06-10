//
//  SettingsCellView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 05.06.2024.
//

import SwiftUI

struct SettingsCellView: View {
    var text: String
    var action: () -> ()
    var body: some View {
        ZStack {
            Button {
                action()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color(.appBlack))
                        .frame(width: 300, height: 40)
                    Text("\(text)")
                        .foregroundStyle(Color(.ddxWhite))
                }
            }
        }
    }
}

#Preview {
    SettingsCellView(text: "Выйти") {
        
    }
}
