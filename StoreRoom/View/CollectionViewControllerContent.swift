//
//  CollectionViewControllerContent.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 13.08.2022.
//

import UIKit

private let reuseIdentifier = "ItemCell"

class CollectionViewControllerContent: UICollectionViewController {

    @IBOutlet var collectionViewThings: UICollectionView!
    var idBoxOrRoom: UUID? = nil
    private var selectThing: Int = 0
    private var boxs = [ItemCollection]()
    private var things = [ItemCollection]()
    private let base = BaseCoreData()
    private var calculateSizeCell: CalculateSizeCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if idBoxOrRoom == nil {
                showMessage(message: ValidationError.notFoundIdRoom.localizedDescription)
                fatalError()}
        if let entityBoxs = base.boxInRoom(idRoom: idBoxOrRoom!) {
            boxs = entityBoxs.map({ EntityBoxs in EntityBoxs.convertToItemCollection()})
        }
        if let entityThings = base.contentBoxRoom(idBoxOrRoom: idBoxOrRoom!) {
            things = entityThings.map({ EntityThings in EntityThings.convertToItemCollection()})
        }

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        calculateSizeCell = CalculateSizeCell(itemsPerRow: 2, widthView: collectionViewThings.bounds.width)
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return boxs.count
        case 1:
            return things.count
        default:
            return 0
        }
    }
    
    
//    override func indexTitles(for collectionView: UICollectionView) -> [String]? {
//        return ["вещи", "коробки"]
//    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        switch indexPath.section{
        case 0:
            cell.labelName.text = boxs[indexPath.row].name
            cell.image.image = boxs[indexPath.row].image.preparingThumbnail(of: calculateSizeCell!.sizeCell ?? calculateSizeCell!.calculateSizeCell())
        case 1:
            cell.labelName.text = things[indexPath.row].name
            cell.image.image = things[indexPath.row].image.preparingThumbnail(of: calculateSizeCell!.sizeCell ?? calculateSizeCell!.calculateSizeCell())
        default:
            break
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            print ("show box")
        case 1:
            selectThing = indexPath.row
            performSegue(withIdentifier: "gotoShowThing", sender: nil)
        default:
            break
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK: переход содержимое коробки/кладовки
        if let destination = segue.destination as? ViewControllerShowThing {
            destination.label = things[selectThing].name
            destination.image = things[selectThing].image
            }
    }
}
