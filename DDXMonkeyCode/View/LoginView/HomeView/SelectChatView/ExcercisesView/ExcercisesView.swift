//
//  ExcercisesView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 15.06.2024.
//

import SwiftUI

struct ExcercisesView: View {
    @StateObject var excercisesViewModel = ExcercisesViewModel.shared
    @State var images: [String: Data] = [:]
    var excercises: [Int]
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(excercises, id: \.self) { excerciseID in
                    if let excercise = excercisesViewModel.excercises[excerciseID] {
                        Text(excercise.name)
                        Text(excercise.difficulty)
                        Text(excercise.type)
                        Text(excercise.equipment.joined(separator: " "))
                        Text(excercise.muscles.joined(separator: " "))
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(excercise.images, id: \.self) { image in
                                    if let image = UIImage(data: images[image] ?? Data()) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: 250)
                                            .cornerRadius(12)

                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            for i in excercises {
                Task {
                    if let imagesList = excercisesViewModel.excercises[i]?.images {
                        for image in imagesList {
                            images[image] = await excercisesViewModel.getImageDataByURL(url: image)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ExcercisesView(excercises: [798, 799])
}
