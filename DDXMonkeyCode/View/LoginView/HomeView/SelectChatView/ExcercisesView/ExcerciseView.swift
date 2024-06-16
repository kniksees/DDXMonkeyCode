//
//  ExcerciseView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 16.06.2024.
//

import SwiftUI

struct ExcerciseView: View {
    var id: Int
    @StateObject var excercisesViewModel = ExcercisesViewModel.shared
    var body: some View {
        ZStack {
            Color(.appLigntGray)
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer(minLength: 10)
                    if let excercise = excercisesViewModel.excercises[id] {
                        HStack {
                            Text(excercise.name)
                                .font(.system(size: 20, weight: .regular))
                            Spacer()
                        }
                        
                        VStack {
                            HStack {
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
                                }
                                VStack {
                                    HStack {
                                        Image(systemName: "figure.stand")
                                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                        Text(excercise.muscles.joined(separator: " "))
                                        Spacer()
                                    }
                                    if !excercise.equipment.isEmpty {
                                        
                                        HStack {
                                            Image(systemName: "plus.circle")
                                            Text(excercise.equipment.joined(separator: " "))
                                            Spacer()
                                        }
                                    } else {
                                        Spacer()
                                    }
                                }
                            }
                            ForEach(excercise.images, id: \.self) { imageUrl in
                                if let imageURL = excercise.images.first, let imageData = excercisesViewModel.images[imageURL], let image = UIImage(data: imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(6)
                                }
                            }
                            Spacer()
                        }
                        .foregroundStyle(.appDarkDakGray)
                    }
                    
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
        }
        .navigationTitle("Упражнения")
    }
}


