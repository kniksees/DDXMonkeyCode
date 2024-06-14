//
//  MyProfileView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import SwiftUI

struct MyProfileView: View {
    @StateObject var myProfileViewModel = MyProfileViewModel.shared
    @State var singlUser: SinglUser? = SinglUser(profile: nil, user: User(id: -1, image: nil, type: "", username: "username"))
    @State var name: String = ""
    @State var gender: String = ""
    @State var age: String = ""
    @State var weight: String = ""
    @State var height: String = ""
    @State var goal: String = ""
    var body: some View {
        
            VStack {
                
                let image = singlUser?.user.image ?? ""
                Image(uiImage: UIImage(data: myProfileViewModel.images[image] ?? Data()) ?? UIImage(named: "SpongeBob")!)
                    .resizable()
                    .frame(width: 350, height: 350)
                
                HStack {
                    Text("Имя:")
                    TextField("заполнить", text: $name)
                    Spacer()
                }
                HStack {
                    Text("Цель:")
                    TextField("заполнить", text: $goal)
                    Spacer()
                }
                HStack {
                    Text("Пол:")
                    TextField("заполнить", text: $gender)
                    Spacer()
                }
                HStack {
                    Text("Вес:")
                    TextField("заполнить", text: $weight)
                    Spacer()
                }
                HStack {
                    Text("Рост:")
                    TextField("заполнить", text: $height)
                    Spacer()
                }
                HStack {
                    Text("Возраст:")
                    TextField("заполнить", text: $age)
                    Spacer()
                }
                Spacer()
                Button(action: {
                    Task {
                        await myProfileViewModel.updateMyProfile(name: name, gender: gender, age: age, weight: weight, height: height, goal: goal, image: nil)
                    }
                }, label: {
                    Text("Сохранить")
                        .padding(10)
                        .background(.appBlack)
                        .foregroundColor(.appWhite)
                        .cornerRadius(12)
                })
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        
        .frame(width: 350)
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
        .onAppear() {
            Task {
                singlUser = await myProfileViewModel.getSelfProfile()
                if let name = singlUser?.profile?.name {
                    self.name = name
                }
                if let gender = singlUser?.profile?.gender {
                    self.gender = gender
                }
                if let age = singlUser?.profile?.age {
                    self.age = String(age)
                }
                if let weight = singlUser?.profile?.weight {
                    self.weight = String(weight)
                }
                if let height = singlUser?.profile?.height {
                    self.height = String(height)
                }
                if let goal = singlUser?.profile?.goal {
                    self.goal = goal
                }
            }
        }
    }
}

#Preview {
    MyProfileView()
}
