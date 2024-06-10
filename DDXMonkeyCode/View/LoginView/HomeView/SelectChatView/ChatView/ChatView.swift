//
//  ChatView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 06.06.2024.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = MessagesViewModel.shared
    let id: Int
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.chats[id]!.messages, id: \.self) { message in
                        MessageView(message: message)
                            .padding(.horizontal)
                    }
                }
            }.defaultScrollAnchor(.bottom)
            
//            MessageInputView(onSend: viewModel.sendMessage, id: id)
//                .padding()
            MessageInputView(chatID: id)
                .padding()
        }
    }
}

struct MessageInputView: View {
    @State private var messageText = ""
    let chatID: Int

    var body: some View {
        HStack {
            TextField("Type a message...", text: $messageText)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)

            Button(action: {
                if !messageText.isEmpty {
                    Task {
                        //MessagesViewModel.shared.chats[chatID]?.messages.append(Message(id: 0, image: "", sender: 2, text: messageText, time: Int(Date.now.timeIntervalSince1970)))
                        await MessagesViewModel.shared.sendMessage(messageText, chatID: chatID)
                        messageText = ""
                    }
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .padding(10)
            }
        }
    }
}


