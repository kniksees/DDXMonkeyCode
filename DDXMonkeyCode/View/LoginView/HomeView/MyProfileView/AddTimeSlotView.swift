//
//  AddTimeSlotView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 15.06.2024.
//

import SwiftUI

struct AddTimeSlotView: View {

    @State var userID: String = ""
    
    @State var selectedDateStart: Date = Date.now
    @State var selectedDateFinish: Date = Date.now
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 10)
                Text("Начало тренировки")
                    .font(.system(size: 24, weight: .regular))
                DatePicker("Начло",
                           selection: $selectedDateStart,
                           displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                Text("Конец тренировки")
                    .font(.system(size: 24, weight: .regular))
                DatePicker("Конец",
                           selection: $selectedDateFinish,
                           displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                
                Button(action: {
                    Task {
                        await CalendarViewModel.shared.newWorkout(trainerID: UserDefaults.standard.integer(forKey: "userID"), timeStart: selectedDateStart, timeFinish: selectedDateFinish)
                    }
                }, label: {
                    Text("Создать таймслот")
                        .padding(15)
                        .background(.appBlack)
                        .foregroundColor(.appWhite)
                        .cornerRadius(20)
                })
                Spacer(minLength: 20)
            }
        }
    }
}

#Preview {
    AddTimeSlotView()
}
