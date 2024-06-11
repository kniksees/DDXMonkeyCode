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
            MessageInputView(chatID: id)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                // Add your trailing toolbar items here
                Text(viewModel.chats[id]!.user.username)
                    .font(.system(size: 16, weight: .medium))
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                // Add your trailing toolbar items here
                Button(action: {
                    // Action for the trailing button
                }) {
                    HStack {

                        Image(uiImage: UIImage(data: viewModel.images[viewModel.chats[id]!.user.id] ?? Data()) ?? UIImage())
                            .resizable()
                            .frame(width: 36, height: 36)
                            .cornerRadius(18)
                    }
                }
            }
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
                    .foregroundColor(selectedImage == nil ? .blue : .green)
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
            
            TextField("Сообщение", text: $messageText)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)
            
            Button(action: {
                if !messageText.isEmpty || selectedImage != nil {
                    Task {
                        //MessagesViewModel.shared.chats[chatID]?.messages.append(Message(id: 0, image: "", sender: 2, text: messageText, time: Int(Date.now.timeIntervalSince1970)))
                        //var a = avatarImage as Data
                        await MessagesViewModel.shared.sendMessage(messageText, chatID: chatID, image: selectedImage)
                        messageText = ""
                        selectedImage = nil
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
