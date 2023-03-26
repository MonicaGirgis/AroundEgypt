//
//  Experience.swift
//  AroundEgypt
//
//  Created by Monica Girgis Kamel on 24/03/2023.
//

import Foundation

struct Experience : Codable {
    let id : String?
    let title : String?
    let coverPhoto : String?
    let description : String?
    let viewsNo : Int?
    let likesNo : Int?
    let recommended : Int?
    let isLiked : String?
    let detailedDescription: String?
    let address: String?

    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case coverPhoto = "cover_photo"
        case description = "description"
        case viewsNo = "views_no"
        case likesNo = "likes_no"
        case recommended = "recommended"
        case isLiked = "is_liked"
        case detailedDescription = "detailed_description"
        case address = "address"
    }
}
