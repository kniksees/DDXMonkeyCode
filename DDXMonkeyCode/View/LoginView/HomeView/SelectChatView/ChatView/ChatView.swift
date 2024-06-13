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
        ZStack {
            Color(.appLigntGray)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollView {
                    Spacer(minLength: 10)
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.chats[id]!.messages, id: \.self) { message in
                            MessageView(message: message)
                                .padding(.horizontal)
                        }
                    }
                    Spacer(minLength: 10)
                }
                .defaultScrollAnchor(.bottom)
                MessageInputView(chatID: id)
                    //.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .ignoresSafeArea()
            }
        }
        
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                
                Text(viewModel.chats[id]!.user.username)
                    .font(.system(size: 16, weight: .medium))
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                
                Button(action: {
                   
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
        ZStack {
            Color(.appWhite)
                .ignoresSafeArea()
            HStack {
                
                PhotosPicker(selection: $imageItem, matching: .images) {
                    Image(systemName: "photo.circle")
                        .font(.title)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .foregroundColor(selectedImage == nil || selectedImage!.isEmpty ? .blue : .green)
                }
                
                .onChange(of: imageItem) {
                    Task {
                        if let loaded = try? await imageItem?.loadTransferable(type: Data.self) {
                            print(loaded)
                            
                            selectedImage = loaded
                        } else {
                            print("Failed")
                        }
                    }
                }
                if selectedImage != nil {
                    Button(action: {
                        selectedImage = nil
                        imageItem = nil
                    }, label: {
                        Image(systemName: "trash")
                            .font(.title2)
                        
                            .foregroundColor(.red)
                    })
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
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                }
            }
        }
        .frame(height: 60)
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
