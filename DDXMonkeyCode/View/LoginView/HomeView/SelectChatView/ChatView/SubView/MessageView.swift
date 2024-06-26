//
//  MessageView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 06.06.2024.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    var sender = UserDefaults.standard.integer(forKey: "userID")
    @StateObject var messagesViewModel = MessagesViewModel.shared
    
    var date: String {
        get {
            let date = Date(timeIntervalSince1970: TimeInterval(message.time))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let timeString = dateFormatter.string(from: date)
            return timeString
        }
    }
    var body: some View {
        VStack(spacing: 3) {
            HStack(alignment: .bottom, spacing: 12) {
                if message.sender == sender {
                    Spacer()
                }
                VStack {
                    if message.imageData != nil {

                        Image(uiImage: UIImage(data: message.imageData!) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 250)
                            .cornerRadius(12)
                        if let text = message.text, !text.isEmpty {
                            if message.sender == sender {
                                HStack {
                                    Spacer()
                                    Text(text.filter({$0 != "*"}))
                                }
                                .frame(maxWidth: 250)
                            } else {
                                HStack {
                                    
                                    Text(text.filter({$0 != "*"}))
                                    Spacer()
                                }
                                .frame(maxWidth: 250)
                            }
                        }
                        
                    } else {
                        Text(message.text?.filter({$0 != "*"}) ?? "")
                    }
                }
                .padding(10)
                .background(message.sender == sender ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.sender == sender ? .white : .black)
                .cornerRadius(16)
                .contextMenu {
                    if let imageData = message.imageData {
                        Button {
                            UIPasteboard.general.image = UIImage(data: imageData)
                        } label: {
                            Label("Копировать картинку", systemImage: "doc.on.doc.fill")
                        }
                    }
                    if let text = message.text, !text.isEmpty {
                        Button {
                            UIPasteboard.general.string = message.text
                        } label: {
                            Label("Копировать текст", systemImage: "doc.on.doc.fill")
                        }
                    }
                }
                if message.sender != sender {
                    Spacer()
                }
            }
            HStack {
                if message.sender == sender {
                    Spacer()
                }
                if let excercises = message.excercises {
                    NavigationLink {
                        ExcercisesView(excercises: excercises)
                    } label: {
                        Text("К упражнениям")
                            .padding(10)
                            .background(.appBlack)
                            .foregroundColor(.appWhite)
                            .cornerRadius(16)
                    }
                }
                if message.sender != sender {
                    Spacer()
                }
            }

            

            if (message.sender == sender) {
                HStack {
                    Spacer()
                    Text(date)
                        .font(.system(size: 10))
                        .foregroundStyle(Color(.appBlack))
                }
            } else {
                HStack {
                    Text(date)
                        .font(.system(size: 10))
                        .foregroundStyle(Color(.appBlack))
                    Spacer()
                }
            }
        }
    }
}
