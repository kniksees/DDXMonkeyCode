//
//  Model.swift
//  DDXMonkeyCode
//
//  Created by Dmitry Erofeev on 14.06.2024.
//

import Foundation

struct SinglUser: Codable {
    let profile: Profile?
    let user: User
}

struct Profile: Codable {
    let experience: Int?
    let about: String?
    let age: Int
    let gender: String?
    let height: Int?
    let id: Int
    let name: String?
    let sports, tags: [String]?
    let user_id: Int
    let weight: Int?
    let goal: String?
    let expectations: String?
}

typealias Welcome = [Chat]

struct ImageResponse: Codable {
    let id: Int
    let url: String
}

struct Chat: Codable, Hashable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.user.id == rhs.user.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(user.id)
    }
    var chat: Int
    var messages: [Message]
    let user: User
    let profile: Profile?
}

struct Message: Codable, Hashable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let image: String?
    let sender: Int
    let text: String?
    let time: Int
    let excercises: [Int]?
    var imageData: Data?
}

struct User: Codable {
    let id: Int
    let image: String?
    let type: String
    let username: String
}

struct Trainer: Hashable {
    
    static func == (lhs: Trainer, rhs: Trainer) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let age: Int
    let gender: String
    let name: String
    let experience: Int
    let sport: String
    let image: String
}


struct TrainerElement: Codable, Hashable {
    static func == (lhs: TrainerElement, rhs: TrainerElement) -> Bool {
        lhs.user.id ==  rhs.user.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(user.id)
    }
    let profile: Profile?
    let user: User
    let is_recomended: Bool
}

struct Review: Codable, Hashable {
    static func == (lhs: Review, rhs: Review) -> Bool {
        lhs.id ==  rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    let author_user_id, id, mark: Int
    let text: String?
    let trainer_user_id: Int
}

struct Excercise: Codable {
    let difficulty: String
    let equipment: [String]
    let id: Int
    let images: [String]
    let muscles: [String]
    let name, type: String
}




struct TraineSlot: Codable {
    let is_free: Bool
    let time: Date
}

struct CalendarElement: Codable, Hashable {
    static func == (lhs: CalendarElement, rhs: CalendarElement) -> Bool {
        lhs.id ==  rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    let description: String?
    let id: Int
    let name: String?
    let time_finish: Int
    let time_start: Int
    let trainer_user_id: Int
    let user_id: Int?
    let zoom_link: Int?
}
