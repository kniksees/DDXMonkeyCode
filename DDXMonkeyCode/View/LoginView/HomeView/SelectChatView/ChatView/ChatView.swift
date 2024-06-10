//
//  ChatView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 06.06.2024.
//

import SwiftUI
import PhotosUI
import UIKit

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
    
    @State private var imageItem: PhotosPickerItem?
    @State private var selectedImage: Data?

    var body: some View {
        HStack {
            PhotosPicker(selection: $imageItem, matching: .images) {
                Image(systemName: "photo.circle")
                    .font(.title)
                    .padding(10)
            }
            //PhotosPicker("photo", selection: $avatarItem, matching: .images)
            .onChange(of: imageItem) {
                Task {
                    if let loaded = try? await imageItem?.loadTransferable(type: Data.self) {
                        selectedImage = loaded
                    } else {
                        print("Failed")
                    }
                }
            }
            
            TextField("Type a message...", text: $messageText)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)

            Button(action: {
                if !messageText.isEmpty {
                    Task {
                        //MessagesViewModel.shared.chats[chatID]?.messages.append(Message(id: 0, image: "", sender: 2, text: messageText, time: Int(Date.now.timeIntervalSince1970)))
                        //var a = avatarImage as Data
                        await MessagesViewModel.shared.sendMessage(messageText, chatID: chatID, image: selectedImage)
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




//import SwiftUI
//import PhotosUI
//
//struct ChatView: View {
//    @State private var avatarItem: PhotosPickerItem?
//    @State private var avatarImage: Image?
//    
//    let id: Int
//
//    var body: some View {
//        VStack {
//            PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
//
//            avatarImage?
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300, height: 300)
//        }
//        .onChange(of: avatarItem) {
//            Task {
//                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
//                    avatarImage = loaded
//                } else {
//                    print("Failed")
//                }
//            }
//        }
//    }
//}
