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
    
    @State var name: String = ""
    @State var descripton: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 10)
                VStack {
                    TextField("name", text: $name)
                    TextField("descripton", text: $descripton)
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
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
                        await CalendarViewModel.shared.newWorkout(trainerID: UserDefaults.standard.integer(forKey: "userID"), timeStart: selectedDateStart, timeFinish: selectedDateFinish, description: descripton, name: name)
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
        .navigationTitle("Добавить таймслот")
    }
}

#Preview {
    AddTimeSlotView()
}
