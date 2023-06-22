//
//  PostsModels.swift
//  EncoraChallenge
//
//  Created by MAC1DIGITAL20 on 22/06/23.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}

struct ResponseData: Codable {
    let data: [Post]
}
