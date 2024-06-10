//
//  LoginVIewModel.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 09.06.2024.
//

import Foundation

class LoginViewModel {
    private init() {}
    static var shared = LoginViewModel()
    var login: String = ""
    var password: String = ""
}
