//
//  TrainerProfileView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import SwiftUI

struct TrainerProfileView: View {
    let id: Int
    let selectTrainerViewModel = SelectTrainerViewModel.shared
    var trainer: TrainerElement {
        get {
            selectTrainerViewModel.trainerList[id]!
        }
    }
    var body: some View {
        VStack {
            var imageData = (selectTrainerViewModel.images[trainer.user.image ?? ""] ?? Data()) ?? Data()
            Image(uiImage: UIImage(data: imageData) ?? UIImage())
                .resizable()
                .frame(width: 350, height: 350)
                .cornerRadius(16)
            HStack {
                Text(trainer.profile.name ?? "")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color(.black))
                Spacer()
            }
            HStack {
                Text("Возраст \(trainer.profile.age)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color(.gray))
                Spacer()
            }
            Spacer()
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
        .frame(width: 350)
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    TrainerProfileView(id: 1)
}
