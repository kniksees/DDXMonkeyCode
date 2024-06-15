//
//  MyWorkoutsView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 05.06.2024.
//

import SwiftUI


struct MyWorkoutsView: View {
    
    @State var calendarDevided: [[CalendarElement]] = []
    
    var id = UserDefaults.standard.integer(forKey: "userID")
    
    var body: some View {
        ZStack {
            Color(.appLigntGray)
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer(minLength: 10)
                    ForEach(calendarDevided, id: \.self) { calendarDay in
                        VStack(spacing: 0) {
                            HStack {
                                Text("\(CalendarViewModel.shared.convertDateToStringddMMyyyy(date: calendarDay.first!.time_start))")
                                    .font(.system(size: 16, weight: .regular))
                                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 7, trailing: 0))
                                Spacer()
                            }
                            ForEach(calendarDay, id: \.self) { slot in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 17)
                                        .foregroundStyle(.appWhite)
                                    VStack {
                                        HStack {
                                            Text("\(CalendarViewModel.shared.convertDateToStringHHmm(date: slot.time_start)) - \(CalendarViewModel.shared.convertDateToStringHHmm(date: slot.time_finish))")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundStyle(.appDarkDakGray)
                                                .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                                            Spacer()
                                        }
                                        HStack {
                                            Text(slot.name ?? "Название")
                                                .font(.system(size: 20, weight: .medium))
                                                .foregroundStyle(.appBlack)
                                            Spacer()
                                        }
                                        HStack {
                                            Text(slot.description ?? "Описание")
                                                .font(.system(size: 16, weight: .regular))
                                                .foregroundStyle(.appDarkDakGray)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.size.width - 60)
                                   
                                }
                                .frame(height: 170)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                
                            }
                        }
                        .frame(width: UIScreen.main.bounds.size.width - 30)
                        
                    }
                }
            }
        }
        .onAppear() {
            Task {
                await CalendarViewModel.shared.getCalendar(id: id)
                if let calendarElement = CalendarViewModel.shared.calendars[id] {
                    //print("\(calendarElement.count) ---------")
                    calendarDevided =  CalendarViewModel.shared.getCalendarDevidedForUser(calendar: calendarElement)
                    //print(calendarElement)
                }
            }
        }
    }
}

