//
//  ExcercisesViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 15.06.2024.
//

import Foundation
import OSLog
class ExcercisesViewModel: NetworkManager, ObservableObject {
    private override init() {}
    static var shared = ExcercisesViewModel()
    var excercises: [Int: Excercise] = [:]
    var images: [String: Data] = [:]
    
    func getExcercises() async {
        let url = URL(string: "http://158.160.13.5:8080/excercises")!
        let response = try? await URLSession.shared.data(for: URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
        if let data = response?.0 {
            if let welcome = try? JSONDecoder().decode([Excercise].self, from: data) {
                for excercise in welcome {
                    excercises[excercise.id] = excercise
                    Logger().log(level: .info, "ExcercisesViewModel: getExcercises: Sucsessful to get excercise")
                }
            } else {
                Logger().log(level: .info, "ExcercisesViewModel: getExcercises: Fail json parsing")
            }
        } else {
            Logger().log(level: .info, "ExcercisesViewModel: getExcercises: Data is nil")
        }
    }
    
    override func getImageDataByURL(url: String?) async -> Data? {
        if let image = await super.getImageDataByURL(url: url) {
            await MainActor.run {
                images[url!] = image
            }
            return image
        }
        return nil
    }
}
