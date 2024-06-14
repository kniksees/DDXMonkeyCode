//
//  MyProfileViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import Foundation
import OSLog
class MyProfileViewModel: ObservableObject {
    private init() {}
    static var shared = MyProfileViewModel()
    @Published var images: Dictionary<String, Data> = [:]
    
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
    
    func updateProfile(id: Int, name: String, gender: String, age: String, weight: String, height: String, goal: String, image: Data?) async {
        var imageUploadID: Int? = nil
        if image != nil {
            let imageJsonData = await uploadImage(image: image!)
            let imageResponse = try! JSONDecoder().decode(ImageResponse.self, from: imageJsonData!)
            imageUploadID = imageResponse.id
            images[imageResponse.url] = image
        } else {
            Logger().log(level: .info, "MyProfileViewModel: Image data id nil")
        }
        let url = URL(string: "http://158.160.13.5:8080/users/\(id)/profile")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var jsonString = ""
        if imageUploadID != nil {
//            jsonString = """
//                    {"name": "\(name)",
//                    "gender": "\(gender)",
//                    "age": \(age),
//                    "weight": \(weight),
//                    "height": \(height),
//                    "goal": "\(goal)",
//                    "image_id": \(imageUploadID!)}
//            """
            jsonString = """
                    {"gender": "\(gender)"}
            """
        } else {
//            jsonString = """
//                    {"name": "\(name)",
//                    "gender": "\(gender)",
//                    "age": \(age),
//                    "weight": \(weight),
//                    "height": \(height),
//                    "goal": "\(goal)"}
//            """
                        jsonString = """
                                                    {"gender": "\(gender)"}
                        """
        }
        
        
        
        let data = jsonString.data(using: .utf8)
        request.httpBody = data
        
        let response = try! await URLSession.shared.data(for: request)
        print("respnse \(response)")
    }
    
    func getSelfProfile() async -> SinglUser? {
        let id = UserDefaults.standard.integer(forKey: "userID")
        return await getProfile(id: id)
    }
    
    func updateMyProfile(name: String, gender: String, age: String, weight: String, height: String, goal: String, image: Data?) async {
        let id = UserDefaults.standard.integer(forKey: "userID")
        await updateProfile(id: id, name: name, gender: gender, age: age, weight: weight, height: height, goal: goal, image: image)
    }
    
    func getProfile(id: Int) async -> SinglUser? {
        Logger().log(level: .info, "MyProfileViewModel: Getting self profile")
        
        guard let profileURL = URL(string: "http://158.160.13.5:8080/users/\(id)/profile") else {
            Logger().log(level: .info, "MyProfileViewModel: Failed to parse url")
            return nil
        }
        let resquest = URLRequest(url: profileURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        guard let response = try? await URLSession.shared.data(for: resquest) else {
            Logger().log(level: .info, "MyProfileViewModel:  Failed to download profile")
            return nil
        }
        
        if let singlUser = try? JSONDecoder().decode(SinglUser.self, from: response.0 ) {
            Logger().log(level: .info, "MyProfileViewModel: Successfull to download profile")
            if let image = singlUser.user.image {
                images[image] = await getImageDataByURL(url: image)
            }
            return singlUser
        } else {
            Logger().log(level: .info, "MyProfileViewModel: \(response.0)")
            Logger().log(level: .info, "MyProfileViewModel: \(response.1)")
            Logger().log(level: .info, "MyProfileViewModel: Failed to parse json")
            return nil
        }
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
}

struct SinglUser: Codable {
    let profile: Profile?
    let user: User
}

struct Profile: Codable {
    let age: Int
    let gender, goal: String
    let height, id: Int
    let name: String
    let user_id, weight: Int
    let sports: [String]?
}
