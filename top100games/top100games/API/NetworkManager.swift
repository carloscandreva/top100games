//
//  NetworkManager.swift
//  top100games
//
//  Created by Carlos Alberto Mota Candreva on 21/07/2018.
//  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
//

import Foundation
import Moya
import CoreData

protocol Networkable {
    var provider: MoyaProvider<GameApi> { get }
    func getTopGames(completion: @escaping ([Top])->())
}

struct NetworkManager: Networkable {

    var provider = MoyaProvider<GameApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    func getTopGames(completion: @escaping ([Top]) -> ()) {
        provider.request(.getTopGames()) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as! [String: Any]
                    
                    let jsonForSwift = JsonForSwift(dictionary: results as NSDictionary)
                    guard let topGames = jsonForSwift?.top else { fatalError() }
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    self.deleteAllData(entity: "TopCore")
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    for game in topGames {
                        let topCore = TopCore(context: context)
                        topCore.name = game.game?.name
                        topCore.logo = game.game?.logo?.large
                        
                        // Save the data to coredata
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }
                    completion(topGames)
                } catch let  err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

}
