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
        ZStack {
            Color(.appLigntGray)
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {

                VStack {
                    Spacer(minLength: 10)
                    ForEach(excercises, id: \.self) { excerciseID in
                        ExcerciseCellView(id: excerciseID)
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
        .navigationTitle("Упражнения")
    }
}

#Preview {
    ExcercisesView(excercises: [798, 799])
}
