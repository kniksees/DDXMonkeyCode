//
//  ExcerciseCellView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 16.06.2024.
//

import SwiftUI

struct ExcerciseCellView: View {
    var id: Int
    @StateObject var excercisesViewModel = ExcercisesViewModel.shared
    var body: some View {
        NavigationLink {
            ExcerciseView(id: id)
        } label: {
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.appWhite)
                VStack(spacing: 0) {
                    if let excercise = excercisesViewModel.excercises[id] {
                        HStack {
                            Text(excercise.name)
                                .font(.system(size: 20, weight: .regular))
                                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0))
                                .foregroundStyle(.appBlack)
                            Spacer()
                        }
                        HStack {
                            if let imageURL = excercise.images.first, let imageData = excercisesViewModel.images[imageURL], let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .clipped()
                                    .cornerRadius(6)
                                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 0))
                            }
                            VStack {
                                HStack {
                                    Image(systemName: "star.leadinghalf.filled")
                                    Text(excercise.difficulty)
                                    Spacer()
                                }
                                
                                HStack {
                                    Image(systemName: "eyes")
                                    Text(excercise.type)
                                    Spacer()
                                }
                                HStack {
                                    Image(systemName: "figure.stand")
                                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                    Text(excercise.muscles.joined(separator: " "))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                if !excercise.equipment.isEmpty {

                                    HStack {
                                        Image(systemName: "plus.circle")
                                        Text(excercise.equipment.joined(separator: " "))
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                            .foregroundStyle(.appDarkDakGray)
                            Spacer()

                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.size.width - 30, height: 190)
        }
        

    }
}

//#Preview {
//    ExcerciseCellView(id)
//}
