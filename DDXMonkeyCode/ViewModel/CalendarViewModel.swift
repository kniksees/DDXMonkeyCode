//
//  CalendarViewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 15.06.2024.
//

import Foundation
import OSLog

class CalendarViewModel {
    private init() {}
    static var shared = CalendarViewModel()
    var calendars: [Int: [CalendarElement]] = [:]
    
    func getCalendar(id: Int) async {
        let url = URL(string: "http://158.160.13.5:8080/users/\(id)/workouts")!
        let response = try? await URLSession.shared.data(for: URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
        if let data = response?.0 {
            if let calendarElements = try? JSONDecoder().decode([CalendarElement].self, from: data) {
                calendars[id] = calendarElements
            } else {
                Logger().log(level: .info, "CalendarViewModel: getCalendar: Fail json parsing")
            }
        } else {
            Logger().log(level: .info, "CalendarViewModel: getCalendar: Data is nil")
        }
    }
    
    func newWorkout(trainerID: Int, userID: Int? = nil, timeStart: Date, timeFinish: Date) async {
        let url = URL(string: "http://158.160.13.5:8080/new-workout")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var jsonString = ""
        if let userID {
            jsonString = """
                            {"trainer_id": \(trainerID)),
                            "user_id": \(userID),
                            "time_start": \(timeStart.timeIntervalSince1970),
                            "time_finish": \(timeFinish.timeIntervalSince1970)}
                    """
        } else {
            jsonString = """
                            {"trainer_id": \(trainerID)),
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
    
    func submitWorkout(userID: Int, workoutID: Int) async {
        let url = URL(string: "http://158.160.13.5:8080/submit-workout")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var jsonString = """
                        {"trainer_id": \(workoutID)),
                        "user_id": \(userID)}
                """
        let data = jsonString.data(using: .utf8)
        request.httpBody = data
        let response = try! await URLSession.shared.data(for: request)
        print("respnse \(response)")
    }
}
