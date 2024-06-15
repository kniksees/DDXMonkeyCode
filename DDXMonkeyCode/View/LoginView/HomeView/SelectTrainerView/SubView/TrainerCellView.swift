//
//  TrainerCellView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import SwiftUI

//struct TrainerCellView: View {
//    var id: Int
//    var selectTrainerViewModel = SelectTrainerViewModel.shared
//    var trainer: Trainer {
//        get {
//            selectTrainerViewModel.trainerList[id]!
//        }
//    }
//    var body: some View {
//        NavigationLink {
//            TrainerProfileView(id: id)
//        } label: {
//            ZStack {
//                RoundedRectangle(cornerRadius: 16)
//                    .foregroundColor(.appWhite)
//                VStack {
//                    Image(uiImage: UIImage(data: selectTrainerViewModel.images[trainer.image]!!)!)
//                        .resizable()
//                        .frame(width: 150, height: 150)
//                    HStack {
//                        Text(trainer.name)
//                            .font(.system(size: 18, weight: .medium))
//                            .foregroundStyle(Color(.black))
//                        Spacer()
//                    }
//                    HStack {
//                        Text("Стаж \(trainer.experience) лет")
//                            .font(.system(size: 14, weight: .regular))
//                            .foregroundStyle(Color(.gray))
//                        Spacer()
//                    }
//                }.frame(width: 150, height: 150)
//            }
//            .frame(width: 178, height: 219)
//        }
//    }
//}

struct TrainerCellView: View {
    var id: Int
    var selectTrainerViewModel = SelectTrainerViewModel.shared
    var trainer: TrainerElement {
        get {
            selectTrainerViewModel.trainerList[id]!
        }
    }
    var body: some View {
        NavigationLink {
            TrainerProfileView(id: id)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.appWhite)
                VStack {
                    var imageData = (selectTrainerViewModel.images[trainer.user.image ?? ""] ?? Data()) ?? Data()
                    Image(uiImage: UIImage(data: imageData) ?? UIImage())
                        .resizable()
                        .frame(width: 150, height: 150)
                        .cornerRadius(8)
                    HStack {
                        Text(trainer.profile?.name ?? "None")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color(.black))
                        Spacer()
                    }
                    HStack {
                        Text("Опыт \(trainer.profile?.experience ?? 0)")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color(.gray))
                        Spacer()
                    }
                }.frame(width: 150, height: 150)
            }
            .frame(width: 178, height: 219)
        }
    }
}


#Preview {
    TrainerCellView(id: 1)
}
