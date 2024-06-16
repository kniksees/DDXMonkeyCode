//
//  LoginVIewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 09.06.2024.
//

import Foundation

class LoginViewModel {
    private init() {}
    static var shared = LoginViewModel()
    var login: String = ""
    var password: String = ""
    //var selfID: Int = -1
    func login(username: String, password: String) async -> Int {
        let url = URL(string: "http://158.160.13.5:8080/login")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let  jsonString = """
                        {"username": "\(username)",
                        "password": "\(password)"}
                """
        let data = jsonString.data(using: .utf8)
        request.httpBody = data
        
        
        let response = try! await URLSession.shared.data(for: request)
        if let userID = try? JSONDecoder().decode(LoginUserResponse.self, from: response.0).id {
            UserDefaults.standard.setValue(userID, forKey: "userID")
            return userID
        } else {
            return -1
        }
    }
}

struct LoginUserResponse: Codable {
    let id: Int
}
