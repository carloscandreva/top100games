//
//  ViewController.swift
//  top100games
//
//  Created by Carlos Alberto Mota Candreva on 20/07/2018.
//  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
//

import UIKit
import SystemConfiguration
import Foundation
import CoreData

class TopGameViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: Vars
    var networkProvider: Networkable!
    var topGames: [Top] = []
    var images: [UIImage] = []
    var topGamesCore: [TopCore] = []
    
    private var refreshControl = UIRefreshControl()
    
    //MARK: Init and Overloads
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.networkProvider = NetworkManager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.alwaysBounceVertical = true
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(TopGameViewController.refreshStream), for: .valueChanged)
        
        refreshControl = refresher
        refreshControl.attributedTitle = NSAttributedString(string: "Carregando top 100 games ...")
        collectionView!.addSubview(refreshControl)
        
        self.getGamesImages {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }

    //MARK: Public Functions
    func refreshStream() {
        self.getGamesImages {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        refreshControl.endRefreshing()
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func getTopGames(completion: @escaping () -> Void) {
        if isInternetAvailable() {
            networkProvider.getTopGames() {
                topGames in
                self.topGames = topGames
                completion()
            }
        } else {
            do {
                let alertView = UIAlertController(title: "", message: "Você está sem conexão, iremos tentar carregar as informações do cache.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: {
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let results = try context.fetch(TopCore.fetchRequest()) as! [TopCore]
                    self.topGamesCore = results
                    completion()
                    } as! () -> Void)
                
            } catch {
                let alertView = UIAlertController(title: "", message: "Nenhuma informação vinda do cache.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    func getGamesImages(completion: @escaping () -> Void) {
        getTopGames {
            if self.topGames.count > 0 {
                for game in self.topGames {
                    let url = URL(string: (game.game?.logo?.large!)!)
                    let data = try? Data(contentsOf: url!)
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.images.append(image!)
                    }
                }
            } else {
                for game in self.topGamesCore {
                    let url = URL(string: game.logo!)
                    let data = try? Data(contentsOf: url!)
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.images.append(image!)
                    }
                }
            }
            OperationQueue.main.addOperation {
                completion()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TopGameViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if topGames.count > 0 {
            return self.topGames.count
        } else {
            return self.topGamesCore.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        if topGames.count > 0 {
            if let gameName = self.topGames[indexPath.row].game?.name {
                cell.diplayContent(image: self.images[indexPath.row], title: gameName)
            }
        } else {
            if let gameName = self.topGamesCore[indexPath.row].name {
                cell.diplayContent(image: self.images[indexPath.row], title: gameName)
            }
        }
        
        return cell
    }
}
