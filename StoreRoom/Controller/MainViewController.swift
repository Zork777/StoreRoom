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
    private var rooms: [EntityRooms]?
    
    var dataManager = GetRooms()
    var calculateSizeCell: CalculateSizeCell?
    var selectRoom: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewStoreRoom.delegate = self
        collectionViewStoreRoom.dataSource = self
        collectionViewStoreRoom.register(UINib(nibName: "CollectionViewCell", bundle: nil ), forCellWithReuseIdentifier: idCell)
        
        //MARK: рассчет размера ячейки
        calculateSizeCell = CalculateSizeCell(itemsPerRow: 1, widthView: collectionViewStoreRoom.bounds.width)
        rooms = dataManager.getRooms()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewStoreRoom.dequeueReusableCell(withReuseIdentifier: idCell, for: indexPath) as! CollectionViewCell
        guard let room = rooms?[indexPath.row] else {return cell}
        cell.labelName.text = room.name
        cell.image.image = room.image?.convertToUIImage().preparingThumbnail(of: calculateSizeCell!.sizeCell ?? calculateSizeCell!.calculateSizeCell())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectRoom = indexPath.row
        performSegue(withIdentifier: "gotoContentView", sender: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateSizeCell!.sizeCell ?? calculateSizeCell!.calculateSizeCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return calculateSizeCell!.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 16
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK: переход содержимое коробки/кладовки
        if let destination = segue.destination as? CollectionViewControllerContent { //ViewControllerContent
            destination.dataManager = GetDataInRoom(objectRoom: rooms![selectRoom])
            destination.title = rooms?[selectRoom].name
        }
    }
}



