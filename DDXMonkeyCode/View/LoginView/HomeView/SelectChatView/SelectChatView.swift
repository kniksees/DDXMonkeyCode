//
//  SelectChatView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 04.06.2024.
//

import SwiftUI

struct SelectChatView: View {
    @StateObject private var viewModel = MessagesViewModel.shared
    
    @State private var data: [String] = []
    @State private var timer: Timer?
    
    var body: some View {
        ScrollView {
            
            ForEach(viewModel.usersSorted, id: \.self) { chat in
                Divider()
                SelectChatCellView(textName: chat.user.username,
                                   textPreview: chat.messages.last?.text ?? "",
                                   targer: AnyView(ChatView(id: chat.chat).navigationTitle(chat.user.username)),
                                   image: Image(uiImage: UIImage(data: viewModel.images[chat.user.id] ?? Data()) ?? UIImage()))
            }
            Divider()
            
        }
        .navigationTitle("Чаты")
        
        .onAppear {
            viewModel.startTimer()
        }
    }
    
//    var body: some View {
//        NavigationView(content: {
//            ScrollView {
//                
//                ForEach(viewModel.usersSorted, id: \.self) { chat in
//                    Divider()
//                    SelectChatCellView(textName: chat.user.username,
//                                       textPreview: chat.messages.last?.text ?? "",
//                                       targer: AnyView(ChatView(id: chat.chat).navigationTitle(chat.user.username)),
//                                       image: Image(uiImage: UIImage(data: viewModel.images[chat.user.id] ?? Data()) ?? UIImage()))
//                }
//                Divider()
//                
//            }
//            .navigationTitle("Чаты")
//        })
//
//        
//        .onAppear {
//            viewModel.startTimer()
//        }
//    }
}



#Preview {
    SelectChatView()
}
