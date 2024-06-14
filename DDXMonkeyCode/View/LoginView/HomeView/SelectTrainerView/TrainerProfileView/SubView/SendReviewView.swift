//
//  SendReviewView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 14.06.2024.
//

import SwiftUI

struct SendReviewView: View {
    @State var text = ""
    @State var mark = ""
    var id: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(.appLigntGray)
            VStack() {
                HStack {
                    TextField("Ваша оцентка", text: $mark)
                    Spacer()
                }
                HStack {
                    TextField("Ваш отзыв", text: $text)
                    Spacer()
                }
                Spacer()
                Button {
                    Task {
                        await SelectTrainerViewModel.shared.sendReview(text: text, userID: UserDefaults.standard.integer(forKey: "userID"), trainerID: id, mark: Int(mark) ?? 5)
                    }
                } label: {
                    Text("Отправить")
                        .padding(10)
                        .background(.appBlack)
                        .foregroundColor(.appWhite)
                        .cornerRadius(12)
                }

            }
            .padding(15)
        }
        .frame(width: 250, height: 250)
    }
}

#Preview {
    SendReviewView(id: -1)
}
