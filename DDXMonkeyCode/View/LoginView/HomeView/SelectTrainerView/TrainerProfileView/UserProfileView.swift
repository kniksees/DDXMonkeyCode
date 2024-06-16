//
//  UserProfileView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import SwiftUI

struct UserProfileView: View {
    let id: Int
    let selectTrainerViewModel = SelectTrainerViewModel.shared
    var trainer: TrainerElement? {
        get {
            selectTrainerViewModel.trainerList[id]
        }
    }
    @StateObject var userProfileViewModel = MyProfileViewModel.shared
    @State var customer: SinglUser? = nil
    var body: some View {
        if let trainer {
            ScrollView(showsIndicators: false) {
                
                
                VStack(spacing: 0) {
                    let imageData = (selectTrainerViewModel.images[trainer.user.image ?? ""] ?? Data()) ?? Data()
                    Image(uiImage: UIImage(data: imageData) ?? UIImage())
                        .resizable()
                        .frame(width: UIScreen.main.bounds.size.width - 30, height: UIScreen.main.bounds.size.width - 30)
                        .cornerRadius(16)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 7, trailing: 0))
                        .frame(width: UIScreen.main.bounds.size.width - 30)
                    HStack {
                        Text(trainer.profile?.name ?? "")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(Color(.black))
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.size.width - 30)
                    HStack {
                        Text("Опыт \(trainer.profile?.experience ?? 0), возраст \(trainer.profile?.age ?? 0)")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color(.gray))
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.size.width - 30)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    HStack {
                        Text("Навыки")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(.appBlack))
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.size.width - 30)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                    if let sports = trainer.profile?.sports {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 3) {
                                Spacer(minLength: 10)
                                ForEach(sports, id: \.self) { sport in
                                    Text(sport)
                                        .padding(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.appDarkGray, lineWidth: 1)
                                        )
                                        .padding(3)
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    }
                    HStack {
                        Text("Увлечения")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(.appBlack))
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.size.width - 30)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                    if let tags = trainer.profile?.tags {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 3) {
                                Spacer(minLength: 10)
                                ForEach(tags, id: \.self) { tag in
                                    Text(tag)
                                        .padding(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.appDarkGray, lineWidth: 1)
                                        )
                                        .padding(3)
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    }
                    HStack {
                        Text("O себе")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(.appBlack))
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.size.width - 30)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                    if let about = trainer.profile?.about {
                        HStack {
                            Text(about)
                                .font(.system(size: 14, weight: .regular))
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        .frame(width: UIScreen.main.bounds.size.width - 30)
                        .frame(width: UIScreen.main.bounds.size.width - 30)
                    }
                    HStack {
                        Text("Отзывы")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(.appBlack))
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.size.width - 30)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                    if let reviews = selectTrainerViewModel.reviewList[trainer.user.id] {
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 3) {
                                Spacer(minLength: 10)
                                ForEach(reviews, id: \.self) { review in
                                    if let text = review.text  {
                                        ReviewView(text: text, mark: review.mark)
                                    }
                                }
                                SendReviewView(id: trainer.user.id)
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink {
                            TrainerTimeslotsView(id: trainer.user.id)
                        } label: {
                            Image(systemName: "calendar")
                                .padding(10)
                                .background(.appBlack)
                                .foregroundColor(.appWhite)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            Task {
                                await selectTrainerViewModel.addChat(trainerID: id)
                            }
                        }, label: {
                            Text("Написать тренеру")
                                .padding(10)
                                .background(.appBlack)
                                .foregroundColor(.appWhite)
                                .cornerRadius(12)
                        })
                    }
                    .frame(width: UIScreen.main.bounds.size.width - 30)
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            }
            //.frame(width: UIScreen.main.bounds.size.width - 30)
            .navigationTitle("Тренер")
        } else {
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                    if let customer {
                        if let imageURL = customer.user.image, let imageData = userProfileViewModel.images[imageURL], let image = UIImage(data: imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.size.width - 30, height: UIScreen.main.bounds.size.width - 30)
                                .cornerRadius(16)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 7, trailing: 0))
                                .frame(width: UIScreen.main.bounds.size.width - 30)
                        }
                    }
                    HStack {
                        Text("Имя:")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.appDarkGray)
                        Spacer()
                    }
                    HStack {
                        Text("\(customer?.profile?.name ?? "")")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                    }
                    HStack {
                        Text("Цель:")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.appDarkGray)
                        Spacer()
                    }
                    HStack {
                        Text("\(customer?.profile?.goal ?? "")")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                    }
                    HStack {
                        Text("Пол:")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.appDarkGray)
                        Spacer()
                    }
                    HStack {
                        Text("\(customer?.profile?.gender ?? "")")
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
                        Text("\(customer?.profile?.weight ?? 0)")
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
                        Text("\(customer?.profile?.height ?? 0)")
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
                        Text("\(customer?.profile?.age ?? 0)")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                    }

                }
            }
            .navigationTitle(customer?.profile?.name ?? "")
            .frame(width: UIScreen.main.bounds.size.width - 30)
            .onAppear() {
                Task {
                    customer = await userProfileViewModel.getProfile(id: id)
                }
            }
        }
    }
}

//#Preview {
//    TrainerProfileView(id: 1)
//}
