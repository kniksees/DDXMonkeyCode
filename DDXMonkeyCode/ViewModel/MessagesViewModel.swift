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
//        get {
//            [Chat](chats.values)
//            }
        
    }
    
    func uploadImage(image: Data) async -> Data? {
        guard let url = URL(string: "http://158.160.13.5:8080/upload") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"result_arabic.jpeg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(image)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let response = try! await URLSession.shared.upload(for: request, from: data)
        return response.0
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
            print("respnse \(response)")
        }
    }
    
    
    @Published var data: [String] = []
    private var timer: Timer?
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
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
    
    func getImageDataByURL(url: String?) async -> Data? {
        guard let url else {
            return nil
        }
        guard let imageURL = URL(string: url) else {
            Logger().log(level: .info, "Failed to parse url")
            return nil
        }
        let resquest = URLRequest(url: imageURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        Logger().log(level: .info, "Downloading image")
        guard let response = try? await URLSession.shared.data(for: resquest) else {
            Logger().log(level: .info, "Failed to get image data")
            return nil
        }
        return response.0
    }
    
    func getAvatarsFromChatList(chatList: Welcome) async {
        for i in chatList {
            guard let imageURL = i.user.image else {return}
            if hashedImages[imageURL] == nil {
                let imageData = await getImageDataByURL(url: imageURL)
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
                Logger().log(level: .info, "Fail json parsing")
            }
        } else {
            Logger().log(level: .info, "Data is nil")
        }
    }
}

typealias Welcome = [Chat]

struct ImageResponse: Codable {
    let id: Int
    let url: String
}

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
    let text: String?
    let time: Int
    var imageData: Data?
}

struct User: Codable {
    let id: Int
    let image: String?
    let username: String
}



