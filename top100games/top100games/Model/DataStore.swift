////
////  DataStore.swift
////  top100games
////
////  Created by Carlos Alberto Mota Candreva on 23/07/2018.
////  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//final class DataStore {
//    
//    static let sharedInstance = DataStore()
//    fileprivate init() {}
//    
//    var topGames: [Top] = []
//    var images: [UIImage] = []
//    
//    func getTopGames(completion: @escaping () -> Void) {
//        
//        networkProvider.getTopGames() {
//            topGames in
//            self.topGames = topGames
//            completion()
//        }
//    }
//    
//    func getBookImages(completion: @escaping () -> Void) {
//        getBooks {
//            for book in self.audiobooks {
//                let url = URL(string: book.coverImage)
//                let data = try? Data(contentsOf: url!)
//                if let imageData = data {
//                    let image = UIImage(data: imageData)
//                    self.images.append(image!)
//                }
//            }
//            OperationQueue.main.addOperation {
//                completion()
//            }
//        }
//    }
//}
