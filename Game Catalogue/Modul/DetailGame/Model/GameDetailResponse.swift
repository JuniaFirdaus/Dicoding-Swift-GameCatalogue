//
//  GameDetailResponse.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 13/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//

import Foundation

struct GameDetailResponse : Codable {

    let background_image : String?
    let background_image_additional : String?
    let clip : Clip?
    let description : String?
    let description_raw : String?
    let platforms : [Platforms]?
    let id : Int?
    let metacritic_url : String?
    let name : String?
    let name_original : String?
    let publishers : [Publisher]?
    let rating : Float?
    let released : String?
    let slug : String?
    let stores : [Stores]?
    let updated : String?
    let website : String?
}
