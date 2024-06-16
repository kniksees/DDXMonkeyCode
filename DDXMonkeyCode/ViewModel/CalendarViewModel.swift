//
//  CalendarViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 15.06.2024.
//

import Foundation
import OSLog

class CalendarViewModel: NetworkManager, ObservableObject {
    private override init() {}
    static var shared = CalendarViewModel()
    
    @Published var calendars: [Int: [CalendarElement]] = [:]
    @Published var images: [String: Data] = [:]
    @Published var profiles: [Int: SinglUser] = [:]
    
    func getCalendar(id: Int) async {
        let url = URL(string: "http://158.160.13.5:8080/users/\(id)/workouts")!
        let response = try? await URLSession.shared.data(for: URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
        if let data = response?.0 {
            if let calendarElements = try? JSONDecoder().decode([CalendarElement].self, from: data) {
                for i in calendarElements {
                    let userID = i.trainer_user_id
                    Task {
                        if profiles[userID] == nil {
                            let profile = await getProfile(id: userID)
                            await MainActor.run {
                                profiles[userID] = profile
                            }
                            if let imageURL =  profile?.user.image {
                                if images[imageURL] == nil {
                                    let imageData = await getImageDataByURL(url: imageURL)
                                    await MainActor.run {
                                        images[imageURL] = imageData
                                    }
                                }
                            }
                        }
                    }
                    if let trainerID = i.user_id {
                        Task {
                            if profiles[trainerID] == nil {
                                let profile = await getProfile(id: trainerID)
                                await MainActor.run {
                                    profiles[trainerID] = profile
                                }
                                if let imageURL =  profile?.user.image {
                                    if images[imageURL] == nil {
                                        let imageData = await getImageDataByURL(url: imageURL)
                                        await MainActor.run {
                                            images[imageURL] = imageData
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                await MainActor.run {
                    calendars[id] = calendarElements
                }
            } else {
                Logger().log(level: .info, "CalendarViewModel: getCalendar: Fail json parsing")
            }
        } else {
            Logger().log(level: .info, "CalendarViewModel: getCalendar: Data is nil")
        }
    }
    
    func newWorkout(trainerID: Int, userID: Int? = nil, timeStart: Date, timeFinish: Date, description: String, name: String) async {
        let url = URL(string: "http://158.160.13.5:8080/new-workout")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var jsonString = ""
        if let userID {
            jsonString = """
                            {"trainer_user_id": \(trainerID),
                            "user_id": \(userID),
                            "description": "\(description)",
                            "name": "\(name)",
                            "time_start": \(timeStart.timeIntervalSince1970),
                            "time_finish": \(timeFinish.timeIntervalSince1970)}
                    """
        } else {
            jsonString = """
                            {"trainer_user_id": \(trainerID),
                            "description": "\(description)",
                            "name": "\(name)",
                            "time_start": \(timeStart.timeIntervalSince1970),
                            "time_finish": \(timeFinish.timeIntervalSince1970)}
                    """
        }
        
        
        let data = jsonString.data(using: .utf8)
        request.httpBody = data
        let response = try! await URLSession.shared.data(for: request)
        print("respnse \(response)")
    }
    
    func newWorkouts(trainerID: Int, userID: Int, timeStart: Date, timeFinish: Date, timeTraine: Data, timeBreak: Data) {
        
    }
    
    func submitWorkout(userID: Int, workoutID: Int, name: String = "") async {
        let url = URL(string: "http://158.160.13.5:8080/submit-workout")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonString = """
                        {"workout_id": \(workoutID),
                        "user_id": \(userID),
                        "name": "\(name)"}
                """
        let data = jsonString.data(using: .utf8)
        request.httpBody = data
        let response = try! await URLSession.shared.data(for: request)
        print("respnse \(response)")
    }
    
    func convertDateToStringHHmm(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
    func convertDateToStringddMMyyyy(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
    func getCalendarDevided(calendar: [CalendarElement]) -> [[CalendarElement]] {
        let calendar = calendar.filter({$0.time_start > Int(Date.now.timeIntervalSince1970)}).sorted(by: {$0.time_start < $1.time_start})
        if !calendar.isEmpty {
            print(calendar)
            //var temp: [[CalendarElement]] = [[calendar[0]]]
            var temp: [[CalendarElement]] = []
            var j = 0
            while j < calendar.count {
                if calendar[j].user_id == nil {
                    temp = [[calendar[j]]]
                    break
                }
                j += 1
            }
            
            if j > calendar.count - 1{
                return temp
            }
            for i in j + 1..<calendar.count {
                if calendar[i].user_id == nil {
                    let daysSinceEpoch = Calendar.current.dateComponents([.day], from: Date(timeIntervalSince1970: 0), to: Date(timeIntervalSince1970: TimeInterval(calendar[i].time_start))).day ?? 0
                    let prevDaysSinceEpoch = Calendar.current.dateComponents([.day], from: Date(timeIntervalSince1970: 0), to: Date(timeIntervalSince1970: TimeInterval(calendar[i - 1].time_start))).day ?? 0
                    if daysSinceEpoch == prevDaysSinceEpoch {
                        temp[temp.count - 1].append(calendar[i])
                    } else {
                        temp.append([calendar[i]])
                    }
                }
            }
            print(temp)
            return temp
        }
        return []
    }
    
    func getCalendarDevidedForUser(calendar: [CalendarElement]) -> [[CalendarElement]] {
        let calendar = calendar.filter({$0.time_start > Int(Date.now.timeIntervalSince1970)}).sorted(by: {$0.time_start < $1.time_start})
        if !calendar.isEmpty {
            print(calendar)
            //var temp: [[CalendarElement]] = [[calendar[0]]]
            var temp: [[CalendarElement]] = []
            var j = 0
            while j < calendar.count {
                if calendar[j].user_id != nil {
                    temp = [[calendar[j]]]
                    break
                }
                j += 1
            }
            
            if j > calendar.count - 1{
                return temp
            }
            for i in j + 1..<calendar.count {
                if calendar[i].user_id != nil {
                    let daysSinceEpoch = Calendar.current.dateComponents([.day], from: Date(timeIntervalSince1970: 0), to: Date(timeIntervalSince1970: TimeInterval(calendar[i].time_start))).day ?? 0
                    let prevDaysSinceEpoch = Calendar.current.dateComponents([.day], from: Date(timeIntervalSince1970: 0), to: Date(timeIntervalSince1970: TimeInterval(calendar[i - 1].time_start))).day ?? 0
                    if daysSinceEpoch == prevDaysSinceEpoch {
                        temp[temp.count - 1].append(calendar[i])
                    } else {
                        temp.append([calendar[i]])
                    }
                }
            }
            print(temp)
            return temp
        }
        return []
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
