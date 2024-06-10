//
//  NetworkManager.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 09.06.2024.
//

import Foundation

class NetworkManager {
    func getMesssges() async -> Response {
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        let (data, _) = try! await URLSession.shared.data(from: url)
        return try! JSONDecoder().decode(Response.self, from: data)
    }
    
    struct Response: Decodable {
        var users: [String]
    }

}


