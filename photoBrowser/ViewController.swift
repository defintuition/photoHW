//
//  ViewController.swift
//  photoBrowser
//
//  Created by Amber Spadafora on 1/21/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var photoTable: UITableView!
    
    
    var momentsList: PHFetchResult<PHCollectionList>?
    var collectionFetchResult: PHFetchResult<PHCollection>?
    var collectionFetchResult2: PHFetchResult<PHCollection>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoTable.delegate = self
        photoTable.dataSource = self
        photoTable.rowHeight = 100
        photoTable.estimatedRowHeight = 100
        
        photoTable.sectionHeaderHeight = CGFloat(integerLiteral: 30)
        
        
        DispatchQueue.main.async {
            let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
            self.momentsList = momentsLists
            self.photoTable.reloadData()
        }
        
        
    }
    
    
    // MARK: TableView Delegates
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return momentsList?[section].localizedTitle ?? "no title"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard momentsList != nil else { return 0 }
        return momentsList!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let collectionList = momentsList?[section]
        let assets = PHCollection.fetchCollections(in: collectionList!, options: nil)
        
        return assets.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photo", for: indexPath)
        
        let collectionList = momentsList?[indexPath.section]
        let assets = PHCollection.fetchCollections(in: collectionList!, options: nil)
        let manager = PHImageManager.default()
        
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        
        if let collection = assets[indexPath.row] as? PHAssetCollection {
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            print(assets.count)
            let cellTag = Int(manager.requestImage(for: assets[indexPath.row],
                                 targetSize: CGSize(width: 100.0, height: 100.0),
                                 contentMode: .aspectFill,
                                 options: nil) { (result, _) in
                                    cell.imageView?.image = result
                                    cell.setNeedsLayout()
            })
            cell.tag = cellTag
        }
        
        
        return cell
    }
    
}

