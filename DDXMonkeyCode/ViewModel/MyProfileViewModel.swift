//
//  MyProfileViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import Foundation
import OSLog
class MyProfileViewModel: NetworkManager, ObservableObject {
    private override init() {}
    static var shared = MyProfileViewModel()
    @Published var images: Dictionary<String, Data> = [:]
    
    func updateProfile(id: Int, name: String, gender: String, age: String, weight: String, height: String, goal: String, image: Data?) async {
        var imageUploadID: Int? = nil
        if image != nil {
            let imageJsonData = await uploadImage(image: image!)
            let imageResponse = try! JSONDecoder().decode(ImageResponse.self, from: imageJsonData!)
            imageUploadID = imageResponse.id
            await MainActor.run {
                images[imageResponse.url] = image
            }

        } else {
            Logger().log(level: .info, "MyProfileViewModel: Image data id nil")
        }
        let url = URL(string: "http://158.160.13.5:8080/users/\(id)/profile")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var jsonString = ""
        if imageUploadID != nil {
                        jsonString = """
                                {"name": "\(name)",
                                "gender": "\(gender)",
                                "age": \(age),
                                "weight": \(weight),
                                "height": \(height),
                                "goal": "\(goal)",
                                "image_id": \(imageUploadID!)}
                        """
//            jsonString = """
//                    {"gender": "\(gender)"}
//            """
        } else {
                        jsonString = """
                                {"name": "\(name)",
                                "gender": "\(gender)",
                                "age": \(age),
                                "weight": \(weight),
                                "height": \(height),
                                "goal": "\(goal)"}
                        """
//            jsonString = """
//                        {"gender": "\(gender)"}
//                        """
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
                Task {
                    let imageData = await self.getImageDataByURL(url: image)
                    await MainActor.run {
                        images[image] = imageData
                    }
                }
            }
            return singlUser
        } else {
            Logger().log(level: .info, "MyProfileViewModel: \(response.0)")
            Logger().log(level: .info, "MyProfileViewModel: \(response.1)")
            Logger().log(level: .info, "MyProfileViewModel: Failed to parse json")
            return nil
        }
    }
    

}

struct SinglUser: Codable {
    let profile: Profile?
    let user: User
}

struct Profile: Codable {
    let about: String?
    let age: Int
    let gender: String?
    let height: Int?
    let id: Int
    let name: String?
    let sports, tags: [String]?
    let user_id: Int
    let weight: Int?
    let goal: String?
}
