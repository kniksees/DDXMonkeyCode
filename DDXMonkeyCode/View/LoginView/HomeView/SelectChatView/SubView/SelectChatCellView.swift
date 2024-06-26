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
    var timeOfLastMessage: Int?
    var timeOfLastMessageLabel: String {
        get {
            if let timeOfLastMessage {
                let date = Date(timeIntervalSince1970: TimeInterval(timeOfLastMessage))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let timeString = dateFormatter.string(from: date)
                return timeString
            } else {
                return ""
            }
        }
    }
    var body: some View {
        ZStack {
            Color(.appWhite)
                .ignoresSafeArea()
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
                        HStack {
                            Text(textName)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(Color(.appBlack))
                            Spacer()
                            Text(timeOfLastMessageLabel)
                                .font(.system(size: 10))
                                .foregroundStyle(Color(.appDarkGray))
                        }
                        Text(textPreview)
                            .font(.subheadline)
                            .lineLimit(1)
                            .foregroundStyle(Color(.ddxBlack))
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.size.width, height: 80)
            }
        }
    }
}

#Preview {
    SelectChatCellView(textName: "AI Тренер", textPreview: "Спишь?", targer: AnyView(SettingsView()), image: Image(uiImage: UIImage(named: "SpongeBob")!), timeOfLastMessage: 1718287078)
}
