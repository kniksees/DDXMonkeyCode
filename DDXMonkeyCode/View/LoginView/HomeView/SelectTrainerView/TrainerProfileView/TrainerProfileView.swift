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
    var trainer: Trainer {
        get {
            selectTrainerViewModel.trainerList[id]!
        }
    }
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: selectTrainerViewModel.images[trainer.image]!!)!)
                .resizable()
                .frame(width: 350, height: 350)
            HStack {
                Text(trainer.name)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color(.black))
                Spacer()
            }
            HStack {
                Text("Стаж \(trainer.experience) лет")
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
        }.frame(width: 350)
    }
}

#Preview {
    TrainerProfileView(id: 1)
}
