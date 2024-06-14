//
//  ReviewView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 14.06.2024.
//

import SwiftUI

struct ReviewView: View {
    var text: String
    var mark: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(.appLigntGray)
            VStack() {
                HStack {
                    Text(String(mark))
                        .font(.system(size: 20, weight: .regular))
                    Image(systemName: "star.fill")
                        .font(.system(size: 14, weight: .regular))
                    Spacer()
                }
                HStack {
                    Text(text)
                        .font(.system(size: 14, weight: .regular))
                    Spacer()
                }
                Spacer()
            }
            .padding(15)
        }
        .frame(width: 250, height: 250)
    }
}

#Preview {
    ReviewView(text: "Отзыв Отзыв Отзыв Отзыв Отзыв Отзыв Отзыв Отзыв Отзыв Отзыв Отзыв Отзыв Отзыв ", mark: 5)
}
