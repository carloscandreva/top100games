//
//  ViewController.swift
//  top100games
//
//  Created by Carlos Alberto Mota Candreva on 20/07/2018.
//  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
//

import UIKit

class TopGameViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var networkProvider: Networkable!
    var topGames: [Top] = []
    var images: [UIImage] = []
    
    private var refreshControl = UIRefreshControl()
    
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
    
    func refreshStream() {
        self.getGamesImages {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        refreshControl.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        if let gameName = self.topGames[indexPath.row].game?.name {
            cell.diplayContent(image: self.images[indexPath.row], title: gameName)
        }
        return cell
    }
    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        
//        if offsetY > contentHeight - scrollView.frame.size.height {
//            numberOfItemsPerSection += 6
//            self.collectionView.reloadData()
//        }
//    }
    
    func getTopGames(completion: @escaping () -> Void) {
        networkProvider.getTopGames() {
            topGames in
            self.topGames = topGames
            completion()
        }
    }
    func getGamesImages(completion: @escaping () -> Void) {
        getTopGames {
            for game in self.topGames {
                let url = URL(string: (game.game?.logo?.large!)!)
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    self.images.append(image!)
                }
            }
            OperationQueue.main.addOperation {
                completion()
            }
        }
    }

}

