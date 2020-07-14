//
//  InitServices.swift
//  Game Catalogue
//
//  Created by PT Lintas Media Danawa on 13/07/20.
//  Copyright © 2020 JFS Studio. All rights reserved.
//

import Foundation
import Moya
import UIKit

let initProviderServices = MoyaProvider<InitService>()

enum InitService{
    
    case getDataGames
    case getSearchDataGames(String)
    case getDetailGames(Int)
}


extension InitService :TargetType{
    
    
    var baseURL: URL {
        return URL(string: BaseUrl.BaseUrl)!
    }
    
    var path: String {
        switch self {
 
        case .getDataGames:
            return "games"
            
        case .getSearchDataGames:
            return "games"
                        
        case .getDetailGames(let id):
            return "games/\(id)"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getDataGames:
            return .get
            
        case .getSearchDataGames:
            return .get
            
        case .getDetailGames:
            return .get
            
        default:
            return .post
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            
        case .getDataGames:
            let parameters: [String: Any] = [
                :
            ]
            
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default
            )
            
        case .getSearchDataGames(let game):
            let parameters: [String: Any] = [
                "search":game
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default
            )
            
        case .getDetailGames:
            let parameters : [String: Any] = [
                :
            ]
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.default
            )
        }
        
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
