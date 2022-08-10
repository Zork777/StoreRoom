//
//  ViewController.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 03.08.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionViewStoreRoom: UICollectionView!
    
    private let idCell = "ItemCell"
    private var rooms: [ItemCollection]?
    let base = BaseCoreData()
    var sizeCell: CGSize?
    
    private let itemsPerRow: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(
                                              top: 16.0,
                                              left: 16.0,
                                              bottom: 16.0,
                                              right: 16.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewStoreRoom.delegate = self
        self.collectionViewStoreRoom.dataSource = self
        self.collectionViewStoreRoom.register(UINib(nibName: "CollectionViewCell", bundle: nil ), forCellWithReuseIdentifier: idCell)
        
        //MARK: рассчет размера ячейки
        sizeCell = calculateSizeCell()
        
        rooms = try! base.fetchContext(base: .rooms, predicate: nil).map{$0 as! EntityRooms}.map{$0.convertToItemCollection()}
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewStoreRoom.dequeueReusableCell(withReuseIdentifier: idCell, for: indexPath) as! CollectionViewCell
        guard let room = rooms?[indexPath.row] else {return cell}
        cell.labelName.text = room.name
        cell.image.image = room.image.preparingThumbnail(of: sizeCell ?? calculateSizeCell())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("select")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return sizeCell ?? calculateSizeCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 16
    }
    
///MARK: рассчет размера ячейки
    func calculateSizeCell() -> CGSize{
        let paddingSpace = sectionInsets.left * (itemsPerRow) + sectionInsets.right
        let availableWidth = collectionViewStoreRoom.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

