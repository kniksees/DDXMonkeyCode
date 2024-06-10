//
//  MessagesViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 06.06.2024.
//

import Foundation
import OSLog

class MessagesViewModel: ObservableObject {
    
    private init() {}
    static var shared = MessagesViewModel()
    
    @Published var chats: Dictionary<Int, Chat> = [:]
    @Published var images: Dictionary<Int, Data> = [:]
    private var hashedImages: Dictionary<String, Data> = [:]
    
    var usersSorted: [Chat] {
        get {
            [Chat](chats.values)
        }
    }
    
    func sendMessage(_ text: String, chatID: Int) async {
        
        let url = URL(string: "http://158.160.13.5:8080/send-message")!
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonString = """
        {"user_id": \(UserDefaults.standard.integer(forKey: "username")),
        "chat_id": \(chatID),
        "time": \(Date.now.timeIntervalSince1970),
        "text": "\(text)"}
        """
        let data = jsonString.data(using: .utf8)
        request.httpBody = data
        //URLSession.shared.dataTask(with: request)
        
        let response = try! await URLSession.shared.data(for: request)
    }
    
    private func receiveMessage(_ text: String, userID: Int) {

        let newMessage = Message(id: 0, image: "", sender: userID, text: text, time: Int(Date.now.timeIntervalSince1970), imageData: nil)
        chats[userID]?.messages.append(newMessage)
    }
    
    
    @Published var data: [String] = []
    private var timer: Timer?
    
        func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
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
        await getChat(userID: UserDefaults.standard.integer(forKey: "username"))
    }
    
    func getChat(userID: Int) async {
        let url = URL(string: "http://158.160.13.5:8080/users/\(userID)/chats")!
        //let response = try? await URLSession.shared.data(from: url)
        let response = try? await URLSession.shared.data(for: URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
        //let (data, _) = try? await URLSession.shared.data(from: url)
        if let data = response?.0 {
            if let welcome = try? JSONDecoder().decode(Welcome.self, from: data) {
                
                for i in welcome {
                    if i.user.image != nil {
                        if hashedImages[i.user.image!] == nil {
                            let imageURL = URL(string: i.user.image!)!
                            let (imageData, _) = try! await URLSession.shared.data(from: imageURL)
                            Logger().log(level: .info, "Downloading image")
                            await MainActor.run {
                                images[i.user.id] = imageData
                                hashedImages[i.user.image!] = imageData
                            }
                        } else {
                            await MainActor.run {
                                images[i.user.id] = hashedImages[i.user.image!]
                            }
                        }
                    }
                }
                Task {
                    await MainActor.run {
                        for i in welcome {
                            chats[i.chat] = i
                        }
                    }
                    for chat in chats.values {
                        for j in 0..<chat.messages.count {
                            if chat.messages[j].image != nil {
                                if hashedImages[chat.messages[j].image!] == nil {
                                    let imageURL = URL(string: chat.messages[j].image!)!
                                    let resquest = URLRequest(url: imageURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
                                    //let (imageData, _) = try! await URLSession.shared.data(from: imageURL)
                                    Logger().log(level: .info, "Downloading image")
                                    let (imageData, _) = try! await URLSession.shared.data(for: resquest)
                                    await MainActor.run {
                                        chats[chat.chat]?.messages[j].imageData = imageData
                                        hashedImages[chat.messages[j].image!] = imageData
                                    }
                                } else {
                                    await MainActor.run {
                                        chats[chat.chat]?.messages[j].imageData = hashedImages[chat.messages[j].image!]
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Logger().log(level: .info, "Fail json parsing")
            }
        } else {
            Logger().log(level: .info, "Data is nil")
        }
    }
}

typealias Welcome = [Chat]

struct Chat: Codable, Hashable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.user.id == rhs.user.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(user.id)
    }
    var chat: Int 
    var messages: [Message]
    let user: User
}

struct Message: Codable, Hashable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let image: String?
    let sender: Int
    let text: String
    let time: Int
    var imageData: Data?
}

struct User: Codable {
    let id: Int
    let image: String?
    let username: String
}



