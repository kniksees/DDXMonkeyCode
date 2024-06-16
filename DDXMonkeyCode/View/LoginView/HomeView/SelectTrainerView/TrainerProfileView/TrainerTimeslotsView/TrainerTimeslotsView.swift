//
//  TrainerTimeslotsView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 15.06.2024.
//

//import SwiftUI
//
//struct TrainerTimeslotsView: View {
//    var id: Int
//    @State var calendar: [CalendarElement] = []
//    @State var calendarDevided: [[CalendarElement]] = []
//    var body: some View {
//        ScrollView(showsIndicators: false) {
//            Spacer(minLength: 10)
//            VStack {
//                ForEach(calendarDevided, id: \.self) { calendarDay in
//                    Text("\(CalendarViewModel.shared.convertDateToStringddMMyyyy(date: calendarDay.first!.time_start))")
//                    ScrollView(.horizontal, showsIndicators: false) {
//
//                        HStack {
//                            Spacer(minLength: 10)
//                            ForEach(calendarDay, id: \.self) { slot in
//                                Button(action: {
//                                    Task {
//                                        await CalendarViewModel.shared.submitWorkout(userID: UserDefaults.standard.integer(forKey: "userID"), workoutID: slot.id, name: "123")
//                                    }
//                                }, label: {
//                                    Text("\(CalendarViewModel.shared.convertDateToStringHHmm(date: slot.time_start)) - \(CalendarViewModel.shared.convertDateToStringHHmm(date: slot.time_finish))")
//                                        .padding(10)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 20)
//                                                .stroke(.appDarkGray, lineWidth: 1)
//                                        )
//                                        .padding(3)
//                                        .font(.system(size: 10))
//                                        .foregroundStyle(.appBlack)
//                                })
//
//                            }
//
//
//                        }
//                    }
//                }
//            }
//        }
//        //.frame(width: UIScreen.main.bounds.size.width - 30)
//        .onAppear() {
//            Task {
//                await CalendarViewModel.shared.getCalendar(id: id)
//                if let calendarElement = CalendarViewModel.shared.calendars[id] {
//                    calendar = calendarElement
//                    calendarDevided =  CalendarViewModel.shared.getCalendarDevided(calendar: calendarElement)
//                }
//            }
//        }
//    }
//}
//

import SwiftUI

struct TrainerTimeslotsView: View {
    var id: Int
    @State var calendar: [CalendarElement] = []
    @State var calendarDevided: [[CalendarElement]] = []
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer(minLength: 10)
            VStack {
                ForEach(calendarDevided, id: \.self) { calendarDay in
                    Text("\(CalendarViewModel.shared.convertDateToStringddMMyyyy(date: calendarDay.first!.time_start))")
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], alignment: .leading, spacing: 5) {
                      
                        ForEach(calendarDay, id: \.self) { slot in
                            TimeslotBubbleView(calendarElement: slot)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.size.width - 20)
                }
            }
        }
        //.frame(width: UIScreen.main.bounds.size.width - 30)
        .onAppear() {
            Task {
                await CalendarViewModel.shared.getCalendar(id: id)
                if let calendarElement = CalendarViewModel.shared.calendars[id] {
                    calendar = calendarElement
                    calendarDevided =  CalendarViewModel.shared.getCalendarDevided(calendar: calendarElement)
                }
            }
        }
    }
}

