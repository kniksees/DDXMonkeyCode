//
//  QRCodeView.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 06.06.2024.
//

import SwiftUI

struct QRCodeView: View {
    var body: some View {
        Image(uiImage: UIImage(named: "QRCode")!)
            .resizable()
            .frame(width: 300, height: 300)
    }
}

#Preview {
    QRCodeView()
}
