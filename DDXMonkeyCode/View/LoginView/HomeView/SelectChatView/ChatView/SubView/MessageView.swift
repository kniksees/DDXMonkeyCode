//
//  MessageView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 06.06.2024.
//

import SwiftUI

struct MessageView: View {
    //@State var message: Message
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
                        if message.sender == sender {
                            HStack {
                                Spacer()
                                Text(message.text ?? "")
                            }
                            .frame(maxWidth: 250)
                        } else {
                            HStack {
                                
                                Text(message.text ?? "")
                                Spacer()
                            }
                            .frame(maxWidth: 250)
                        }
                        Image(uiImage: UIImage(data: message.imageData!) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 250)
                            .cornerRadius(12)
                        
                    } else {
                        Text(message.text ?? "")
                    }
                }
                .padding(10)
                .background(message.sender == sender ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.sender == sender ? .white : .black)
                .cornerRadius(12)
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


//            if let image = message.imageData {
//                VStack {
//                    if message.text != nil {
//                        HStack {
//                            if message.sender == sender {
//                                Spacer()
//                            }
//                            Text(message.text!)
//                                .padding(10)
//                                .background(message.sender == sender ? Color.blue : Color.gray.opacity(0.2))
//                                .foregroundColor(message.sender == sender ? .white : .black)
//                                .cornerRadius(12)
//                            if message.sender != sender {
//                                Spacer()
//                            }
//                        }
//                    }
//                    Image(uiImage: UIImage(data: image) ?? UIImage())
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//
//                        .cornerRadius(12)
//                }
//                .frame(maxWidth: 250)
//            } else {
//                if message.text != nil {
//                    Text(message.text!)
//                        .padding(10)
//                        .background(message.sender == sender ? Color.blue : Color.gray.opacity(0.2))
//                        .foregroundColor(message.sender == sender ? .white : .black)
//                        .cornerRadius(12)
//                }
//            }
//
//            if !(message.sender == sender) {
//                Spacer()
//            }
