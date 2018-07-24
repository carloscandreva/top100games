//
//  TopOneHundredGamesAPI.swift
//  top100games
//
//  Created by Carlos Alberto Mota Candreva on 20/07/2018.
//  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
//

import Foundation
import Moya

enum GameApi {
    case getTopGames()
}
extension GameApi: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.twitch.tv/kraken/") else {fatalError("Base Url could not be configured.")}
        return url
    }
    
    var path: String {
        return "/games/top"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return stubbedReponse("GamesTop")
    }
    
    var task: Task {
        return .requestParameters(parameters: ["limit":100], encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        return ["Accept":"application/vnd.twitchtv.v5+json", "Client-ID":"dxgkf9i6vbh1fkaf20qaeisxt7pk2w"]
    }
    
}

func stubbedReponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}
