//
//  TimeslotBubbleView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 16.06.2024.
//

import SwiftUI

struct TimeslotBubbleView: View {
    @State var isSelected = false
    let calendarElement: CalendarElement
    var body: some View {

        Button(action: {
            isSelected = true
            Task {
                await CalendarViewModel.shared.submitWorkout(userID: UserDefaults.standard.integer(forKey: "userID"), workoutID: calendarElement.id)
            }
        }, label: {
            
            Text("\(CalendarViewModel.shared.convertDateToStringHHmm(date: calendarElement.time_start)) - \(CalendarViewModel.shared.convertDateToStringHHmm(date: calendarElement.time_finish))")
                .padding(8)
                //.background(.appBlack)
                .background(isSelected ? .appDarkGray : .appWhite)
                .cornerRadius(20)
                
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.appDarkGray, lineWidth: 1)
                )
                .padding(1)
                .font(.system(size: 10))
                .foregroundStyle(.appBlack)
        })
    }
}
