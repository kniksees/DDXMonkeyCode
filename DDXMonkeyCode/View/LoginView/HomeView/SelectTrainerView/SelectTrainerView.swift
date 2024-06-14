//
//  SelectTrainerView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 13.06.2024.
//

import SwiftUI

struct SelectTrainerView: View {
    @StateObject var selectTrainerViewModel = SelectTrainerViewModel.shared
    var body: some View {
        ZStack {
            Color(.appLigntGray)
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                Spacer(minLength: 10)
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]) {
                    ForEach(selectTrainerViewModel.getTrainerList, id: \.self) { trainer in
                        TrainerCellView(id: trainer.user.id)
                    }
                    
                }
                Spacer(minLength: 15)
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        .onAppear() {
            Task {
                await selectTrainerViewModel.getTrainers()
            }
        }
    }
}

#Preview {
    SelectTrainerView()
}
