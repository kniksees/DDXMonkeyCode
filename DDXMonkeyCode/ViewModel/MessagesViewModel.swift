//
//  MessagesViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 06.06.2024.
//

import Foundation
import OSLog

class MessagesViewModel: NetworkManager, ObservableObject {
    
    override private init() {
        Logger().log(level: .info, "User id: \(UserDefaults.standard.integer(forKey: "userID"))")
        
    }
    static var shared = MessagesViewModel()
    
    @Published var chats: Dictionary<Int, Chat> = [:]
    @Published var images: Dictionary<Int, Data> = [:]
    private var hashedImages: Dictionary<String, Data> = [:]
    
    var usersSorted: [Chat] {
        get {
            [Chat](chats.values).sorted { chat1, chat2 in
                if chat1.user.id == 1 {
                    return true
                } else if chat2.user.id == 1 {
                    return false
                } else {
                    if chat1.messages.isEmpty {
                        return false
                    } else if chat2.messages.isEmpty {
                        return true
                    } else {
                        return chat1.messages.last!.time > chat2.messages.last!.time
                    }
                }
            }
        }
    }
    

    
    func sendMessage(_ text: String, chatID: Int, image: Data?) async {
        let text = text.trimmingCharacters(in: .whitespaces)
        Task {
            var imageUploadID: Int? = nil
            if image != nil {
                let imageJsonData = await uploadImage(image: image!)
                let imageResponse = try! JSONDecoder().decode(ImageResponse.self, from: imageJsonData!)
                imageUploadID = imageResponse.id
                hashedImages[imageResponse.url] = image
            }
            let url = URL(string: "http://158.160.13.5:8080/send-message")!
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            var jsonString = ""
            if imageUploadID != nil {
                jsonString = """
                        {"user_id": \(UserDefaults.standard.integer(forKey: "userID")),
                        "chat_id": \(chatID),
                        "time": \(Date.now.timeIntervalSince1970),
                        "text": "\(text)",
                        "image_id": \(imageUploadID!)}
                """
            } else {
                jsonString = """
                        {"user_id": \(UserDefaults.standard.integer(forKey: "userID")),
                        "chat_id": \(chatID),
                        "time": \(Date.now.timeIntervalSince1970),
                        "text": "\(text)"}
                """
            }
            
            
            
            let data = jsonString.data(using: .utf8)
            request.httpBody = data
            
            let response = try! await URLSession.shared.data(for: request)
        }
    }
    
    
    @Published var data: [String] = []
    private var timer: Timer?
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                Task {
                    await self?.fetchData()
                }
            }
            
        }
    }
    //
    //    func stopTimer() {
    //        timer?.invalidate()
    //        timer = nil
    //    }
    
    func fetchData() async {
        await getChat(userID: UserDefaults.standard.integer(forKey: "userID"))
    }
    

    
    func getAvatarsFromChatList(chatList: Welcome) async {
        for i in chatList {
            guard let imageURL = i.user.image else {continue}
            if hashedImages[imageURL] == nil {
                let imageData = await getImageDataByURL(url: imageURL)
                Logger().log(level: .info, "MessagesViewModel: download")
                Logger().log(level: .info, "MessagesViewModel: imageData \(imageData?.count ?? 0)")
                await MainActor.run {
                    images[i.user.id] = imageData
                    hashedImages[i.user.image!] = imageData
                }
            } else {
                await MainActor.run {
                    images[i.user.id] = hashedImages[imageURL]
                }
            }
        }
    }
    
    func getImagesFromChatList(chatList: Welcome) async {
        if chatList.flatMap({$0.messages}).count == chats.values.flatMap({$0.messages}).count && chatList.count == chats.count {
            Logger().log(level: .info, "No new messages")
            return
        }
        Logger().log(level: .info, "Processing new messages")
        var tempWelcome = chatList
        for i in 0..<chatList.count {
            for j in 0..<chatList[i].messages.count {
                let message = chatList[i].messages[j]
                if let image = message.image {
                    if hashedImages[image] == nil {
                        let imageData = await getImageDataByURL(url: image)
                        tempWelcome[i].messages[j].imageData = imageData
                        await MainActor.run {

                            hashedImages[image] = imageData
                        }
                        
                    } else {
                        tempWelcome[i].messages[j].imageData = hashedImages[image]
                    }
                }
            }
            let chatWithImages = tempWelcome[i]
            await MainActor.run {
                chats[chatList[i].chat] = chatWithImages
            }
        }
    }
    
    func getChat(userID: Int) async {
        let url = URL(string: "http://158.160.13.5:8080/users/\(userID)/chats")!
        let response = try? await URLSession.shared.data(for: URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
        if let data = response?.0 {
            if let welcome = try? JSONDecoder().decode(Welcome.self, from: data) {
                await getAvatarsFromChatList(chatList: welcome)
                await getImagesFromChatList(chatList: welcome)
            } else {
                Logger().log(level: .info, "MessagesViewModel: getChat: Fail json parsing")
            }
        } else {
            Logger().log(level: .info, "MessagesViewModel: getChat: Data is nil")
        }
    }
}





