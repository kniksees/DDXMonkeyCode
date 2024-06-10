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
        
        var response = try! await URLSession.shared.upload(for: request, from: data)
//        let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
//            DispatchQueue.main.async {
//                
//                
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                    return
//                }
//                
//                if let httpResponse = response as? HTTPURLResponse {
//                    print("Response status code: \(httpResponse.statusCode)")
//                }
//                
//                if let data = data {
//                    let responseString = String(data: data, encoding: .utf8)
//                    print("Response: \(responseString ?? "")")
//                }
//            }
//        }
//        task.resume()
        //print(String(data: response.0, encoding: .utf8), response.1.url)
        return response.0
    }
    
    func sendMessage(_ text: String, chatID: Int, image: Data?) async {
        //print(image)
//        chats[chatID]?.messages.append(Message(id: -1, image: "", sender: UserDefaults.standard.integer(forKey: "userID"), text: text, time: Int(Date.now.timeIntervalSince1970), imageData: image))
        Task {
            var imageUploadID: Int? = nil
            if image != nil {
                let imageJsonData = await uploadImage(image: image!)
                let imageResponse = try! JSONDecoder().decode(ImageResponse.self, from: imageJsonData!)
                imageUploadID = imageResponse.id
                
                hashedImages[imageResponse.url] = image
               
  
                

            }
            //print("imageUploadID \(imageUploadID)")
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
    
    private func receiveMessage(_ text: String, userID: Int) {
        
        //let newMessage = Message(id: 0, image: "", sender: userID, text: text, time: Int(Date.now.timeIntervalSince1970), imageData: nil)
        //chats[userID]?.messages.append(newMessage)
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
    
    func getChat(userID: Int) async {
//        print("getChat")
//        print(userID)
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
        //lhs.id == rhs.id && ((lhs.imageData == nil) == (rhs.imageData == nil))
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        //hasher.combine(imageData == nil)
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



