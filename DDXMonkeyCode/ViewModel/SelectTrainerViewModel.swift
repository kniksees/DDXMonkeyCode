//
//  SelectTrainerViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import Foundation
import SwiftUI
import OSLog

class SelectTrainerViewModel: NetworkManager, ObservableObject {
    private override init() {}
    static var shared = SelectTrainerViewModel()
//    @Published var trainerList = [1: Trainer(id: 1, age: 32, gender: "Дядя", name: "Кирюха", experience: 1, sport: "Дотер", image: "image"),
//                       2: Trainer(id: 2, age: 32, gender: "Дядя", name: "Кирюха", experience: 2, sport: "Дотер", image: "image"),
//                       3: Trainer(id: 3, age: 32, gender: "Дядя", name: "Кирюха", experience: 3, sport: "Дотер", image: "image"),
//                       4: Trainer(id: 4, age: 32, gender: "Дядя", name: "Кирюха", experience: 4, sport: "Дотер", image: "image"),
//                       5: Trainer(id: 5, age: 32, gender: "Дядя", name: "Кирюха", experience: 5, sport: "Дотер", image: "image"),
//                       8: Trainer(id: 8, age: 32, gender: "Дядя", name: "Кирюха", experience: 8, sport: "Дотер", image: "image"),
//                       9: Trainer(id: 9, age: 32, gender: "Дядя", name: "Кирюха", experience: 9, sport: "Дотер", image: "image")]
    @Published var trainerList: [Int: TrainerElement] = [:]
//    var getTrainerList: [Trainer] {
//        get {
//            [Trainer](trainerList.values)
//        }
//    }
    var getTrainerList: [TrainerElement] {
        get {
            [TrainerElement](trainerList.values)
        }
    }
    var images = ["image": UIImage(named: "SpongeBob")!.pngData()]
    
    func getTrainers() async {
        let url = URL(string: "http://158.160.13.5:8080/trainers")!
        let response = try? await URLSession.shared.data(for: URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
        if let data = response?.0 {
            if let trainerListWelcome = try? JSONDecoder().decode([TrainerElement].self, from: data) {
                for i in trainerListWelcome {

                   
                    if let imageURL = i.user.image {
                        if images[imageURL] == nil {
                            let imageData = await getImageDataByURL(url: imageURL)
                            Task {
                                await MainActor.run {
                                    
                                    images[imageURL] = imageData
                                }
                            }
                        }
                    }
                    Task {
                        await MainActor.run {
                            trainerList[i.user.id] = i
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
    
    func addChat(trainerID: Int) async {
        Task {
            print([trainerID, UserDefaults.standard.integer(forKey: "userID")])
            let url = URL(string: "http://158.160.13.5:8080/new-chat")!
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let jsonString = """
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


