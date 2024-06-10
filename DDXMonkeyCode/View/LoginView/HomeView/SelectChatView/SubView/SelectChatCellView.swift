//
//  SelectChatCellView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 05.06.2024.
//

import SwiftUI

struct SelectChatCellView: View {
    var textName: String
    var textPreview: String
    var targer: AnyView
    var image: Image
    var body: some View {
        NavigationLink {
            targer
        } label: {
            
            HStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(textName)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color(.ddxBlack))
                    
                    Text(textPreview)
                        .font(.subheadline)
                        .lineLimit(1)
                        .foregroundStyle(Color(.ddxBlack))
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 70)
        }
    }
}

#Preview {
    SelectChatCellView(textName: "AI Тренер", textPreview: "Спишь?", targer: AnyView(SettingsView()), image: Image(uiImage: UIImage(named: "SpongeBob")!))
}
