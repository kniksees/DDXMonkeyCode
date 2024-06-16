//
//  NetworkManager.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 09.06.2024.
//

import Foundation
import OSLog

class NetworkManager {
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

    func getImageDataByURL(url: String?) async -> Data? {
        guard let url else {
            return nil
        }
        guard let imageURL = URL(string: url) else {
            Logger().log(level: .info, "Failed to parse url")
            return nil
        }
        let resquest = URLRequest(url: imageURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        
        guard let response = try? await URLSession.shared.data(for: resquest) else {
            Logger().log(level: .info, "Failed to get image data")
            return nil
        }
        Logger().log(level: .info, "NetworkManager: getImageDataByURL: sucsessful to downloal image")
        return response.0
        
    }
}


