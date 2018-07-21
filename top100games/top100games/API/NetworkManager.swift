//
//  NetworkManager.swift
//  top100games
//
//  Created by Carlos Alberto Mota Candreva on 21/07/2018.
//  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
//

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<GameApi> { get }
    func getTopGames(completion: @escaping ([Top])->())
}

struct NetworkManager: Networkable {

    var provider = MoyaProvider<GameApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    func getTopGames(completion: @escaping ([Top]) -> ()) {
        provider.request(.getTopGames) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as! [String: Any]
                    let jsonForSwift = JsonForSwift(dictionary: results as NSDictionary)
                    guard let topGames = jsonForSwift?.top else { fatalError() }
                    completion(topGames)
                } catch let  err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }
    }

}
