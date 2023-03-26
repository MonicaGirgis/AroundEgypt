//
//  Models.swift
//  Baquala
//
//  Created by Monica Girgis Kamel on 23/05/2022.
//

import Foundation

struct EmptyResponse:Decodable{}

struct GeneralStatus : Decodable {
    var code : Int
    var errors : [GeneralErrors]?
}

struct GeneralErrors: Decodable {
    var type: String?
    var message: String?
}

struct Response<T : Decodable> : Decodable {
    var meta : GeneralStatus
    var data: T
}

