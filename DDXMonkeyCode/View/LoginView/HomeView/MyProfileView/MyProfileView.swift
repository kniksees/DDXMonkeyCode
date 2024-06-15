//
//  MyProfileView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import SwiftUI
import PhotosUI
import UIKit

struct MyProfileView: View {
    @StateObject var myProfileViewModel = MyProfileViewModel.shared
    @State var singlUser: SinglUser? = SinglUser(profile: nil, user: User(id: -1, image: nil, type: "", username: "username"))
    @State var name: String = ""
    @State var gender: String = ""
    @State var age: String = ""
    @State var weight: String = ""
    @State var height: String = ""
    @State var goal: String = ""
    @State var sports: String = ""
    @State var tags: String = ""
    @State var about: String = ""
    
    @State private var imageItem: PhotosPickerItem?
    @State private var selectedImage: Data?
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 2) {
                
                PhotosPicker(selection: $imageItem, matching: .images) {
                    let image = singlUser?.user.image ?? ""
                    Image(uiImage: UIImage(data: (selectedImage ?? myProfileViewModel.images[image]) ?? Data()) ?? UIImage(systemName: "person")!)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.size.width - 30, height: UIScreen.main.bounds.size.width - 30)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .scaledToFit()
                    
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                
                .onChange(of: imageItem) {
                    Task {
                        if let loaded = try? await imageItem?.loadTransferable(type: Data.self) {
                            print(loaded)
                            
                            selectedImage = loaded
                        } else {
                            print("Failed")
                        }
                    }
                }
                //            let image = singlUser?.user.image ?? ""
                //            Image(uiImage: UIImage(data: myProfileViewModel.images[image] ?? Data()) ?? UIImage(named: "SpongeBob")!)
                //                .resizable()
                //                .frame(width: UIScreen.main.bounds.size.width - 30, height: UIScreen.main.bounds.size.width - 30)
                //                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                HStack {
                    Text("Имя:")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.appDarkGray)
                    Spacer()
                }
                HStack {
                    TextField("заполнить", text: $name)
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                }
                if let type = singlUser?.user.type {
                    if type == "user"  {
                        HStack {
                            Text("Цель:")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.appDarkGray)
                            Spacer()
                        }
                        HStack {
                            TextField("заполнить", text: $goal)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }
                    }
                    if type == "trainer" {
                        HStack {
                            Text("Виды спорта:")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.appDarkGray)
                            Spacer()
                        }
                        HStack {
                            TextField("заполнить", text: $sports)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }
                        HStack {
                            Text("Хобби:")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.appDarkGray)
                            Spacer()
                        }
                        HStack {
                            TextField("заполнить", text: $tags)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }
                        HStack {
                            Text("О себе:")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.appDarkGray)
                            Spacer()
                        }
                        HStack {
                            TextField("заполнить", text: $about)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }
                    }
                }

                HStack {
                    Text("Пол:")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.appDarkGray)
                    Spacer()
                }
                HStack {
                    
                    TextField("заполнить", text: $gender)
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                }
                HStack {
                    Text("Вес:")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.appDarkGray)
                    Spacer()
                }
                HStack {
                    
                    TextField("заполнить", text: $weight)
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                }
                HStack {
                    Text("Рост:")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.appDarkGray)
                    Spacer()
                }
                HStack {
                    
                    TextField("заполнить", text: $height)
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                }
                HStack {
                    Text("Возраст:")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.appDarkGray)
                    Spacer()
                }
                HStack {
                    
                    TextField("заполнить", text: $age)
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    if let type = singlUser?.user.type {
                        if type == "trainer" {
                            NavigationLink {
                                AddTimeSlotView()
                            } label: {
                                Text("Добавить таймслот")
                                    .padding(15)
                                    .background(.appBlack)
                                    .foregroundColor(.appWhite)
                                    .cornerRadius(20)
                            }

                        }
                    }
                    Button(action: {
                        if let type = singlUser?.user.type {
                            if type == "user" {
                                Task {
                                    await myProfileViewModel.updateMyProfile(type: type, name: name, gender: gender, age: age, weight: weight, height: height, goal: goal, image: selectedImage)
                                }
                            }
                            if type == "trainer" {
                                Task {
                                    await myProfileViewModel.updateMyProfile(type: type, name: name, gender: gender, age: age, weight: weight, height: height, image: selectedImage, sports: sports, tags: tags, about: about)
                                }
                            }
                        }
                    }, label: {
                        Image(systemName: "square.and.arrow.down")
                            .padding(15)
                            .background(.appBlack)
                            .foregroundColor(.appWhite)
                            .cornerRadius(20)
                        
                    })
                    
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        }
        .frame(width: UIScreen.main.bounds.size.width - 30)
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
        .onAppear() {
            Task {
                singlUser = await myProfileViewModel.getSelfProfile()
                if let imageURL = singlUser?.user.image {
                    if let image = myProfileViewModel.images[imageURL] {
                        selectedImage = image
                    }
                }
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
                if let sports = singlUser?.profile?.sports?.joined(separator: ", ") {
                    self.sports = sports
                }
                if let tags = singlUser?.profile?.tags?.joined(separator: ", ") {
                    self.tags = tags
                }
                if let about = singlUser?.profile?.about {
                    self.about = about
                }
            }
        }
    }
}

#Preview {
    MyProfileView()
}
