//
//  GameItems.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 03/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//

import Foundation

struct GameItems:Codable {
    let id: Int?
    let slug: String?
    let name: String?
    let released: String?
    let tba: Bool?
    let background_image: String?
    let rating: Double?
    let rating_top: Int?
    let ratings_count: Int?
}
