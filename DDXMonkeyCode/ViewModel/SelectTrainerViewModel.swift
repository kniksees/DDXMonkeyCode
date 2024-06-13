//
//  SelectTrainerViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import Foundation
import SwiftUI
class SelectTrainerViewModel: ObservableObject {
    private init() {}
    static var shared = SelectTrainerViewModel()
    var trainerList = [1: Trainer(id: 1, age: 32, gender: "Дядя", name: "Кирюха", experience: 1, sport: "Дотер", image: "image"),
                       2: Trainer(id: 2, age: 32, gender: "Дядя", name: "Кирюха", experience: 2, sport: "Дотер", image: "image"),
                       3: Trainer(id: 3, age: 32, gender: "Дядя", name: "Кирюха", experience: 3, sport: "Дотер", image: "image"),
                       4: Trainer(id: 4, age: 32, gender: "Дядя", name: "Кирюха", experience: 4, sport: "Дотер", image: "image"),
                       5: Trainer(id: 5, age: 32, gender: "Дядя", name: "Кирюха", experience: 5, sport: "Дотер", image: "image"),
                       8: Trainer(id: 8, age: 32, gender: "Дядя", name: "Кирюха", experience: 8, sport: "Дотер", image: "image"),
                       9: Trainer(id: 9, age: 32, gender: "Дядя", name: "Кирюха", experience: 9, sport: "Дотер", image: "image")]
    var getTrainerList: [Trainer] {
        get {
            [Trainer](trainerList.values)
        }
    }
    var images = ["image": UIImage(named: "SpongeBob")!.pngData()]
    
    func addChat(trainerID: Int) async {
        Task {
            print([trainerID, UserDefaults.standard.integer(forKey: "userID")])
            let url = URL(string: "http://158.160.13.5:8080/new-chat")!
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            var jsonString = """
                        {"users": \([trainerID, UserDefaults.standard.integer(forKey: "userID")])}
                """
            print(jsonString)
            let data = jsonString.data(using: .utf8)
            request.httpBody = data
            
            let response = try! await URLSession.shared.data(for: request)
            print("respnse \(response)")
        }
    }
}

struct Trainer: Hashable {
    
    static func == (lhs: Trainer, rhs: Trainer) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let age: Int
    let gender: String
    let name: String
    let experience: Int
    let sport: String
    let image: String
}
