//
//  ChatCardItem.swift
//  EchoChat
//
//  Created by Mind on 18/06/25.
//

import Foundation

struct ChatCardItems:Codable {
    let users : [CardUsers]?
    
    enum CodingKeys: String, CodingKey {

        case users = "users"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        users = try values.decodeIfPresent([CardUsers].self, forKey: .users)
    }
}

struct CardUsers : Codable {
    let id : Int?
    let name : String?
    let profilePic : String?
    let age : Int?
    let question : String?
    var isLocked: Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case profilePic = "profilePic"
        case age = "age"
        case question = "question"
        case isLocked = "isLocked"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        question = try values.decodeIfPresent(String.self, forKey: .question)
        isLocked = try values.decodeIfPresent(Bool.self, forKey: .isLocked)
    }
}
