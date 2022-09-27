//
//  CollectionViewControllerContent.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 13.08.2022.
//

import UIKit
import CoreData

private let reuseIdentifier = "ItemCell"

class CollectionViewControllerContent: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionViewThings: UICollectionView!
    var dataManager: DataManager? = nil
    
    private var selectThing: Int = 0
    private var boxs = [EntityBoxs]()
    private var things = [CellData]()
    private var calculateSizeCell: CalculateSizeCell?
    
    var dialogGetNameThing: (()->()) = {return}
    
    var typeObjectForSave: BaseCoreData.Bases = .things
    var objectForSave:Object = Object(name: nil, image: nil) {
        
        didSet {
            if objectForSave.name != nil && objectForSave.image != nil {
                if saveObjectInBase() {
                    objectForSave = Object(name: nil, image: nil)
                }
                else {
                    showMessage(message: "Не получилось сохранить в базу новую вещь")
                }
            }
        }
    }
    
    @IBAction func buttonAddThing(_ sender: Any) {
//        dialogGetNameThing = viewGetName
//        getPhotoInCamera()
//        alertGetName()
        objectForSave.image = #imageLiteral(resourceName: "sokrovisha-1")
        viewGetName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxs = dataManager?.getBoxs() ?? []
        if let thingsEntity = dataManager?.getThings() {
            things = thingsEntity.map{$0.convertToItemCollection()}
        }
        self.collectionView!.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        calculateSizeCell = CalculateSizeCell(itemsPerRow: 2, widthView: collectionViewThings.bounds.width)
        
        view.backgroundColor = .white
        collectionViewThings.translatesAutoresizingMaskIntoConstraints = false
        collectionViewThings.sizeToFit()
        collectionViewThings.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        collectionViewThings.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        collectionViewThings.topAnchor.constraint(equalTo: view.topAnchor , constant: 16).isActive = true
        collectionViewThings.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        view.backgroundColor = .systemBackground

    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
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
            cell.image.image = boxs[indexPath.row].image?.convertToUIImage().preparingThumbnail(of: calculateSizeCell!.sizeCell ?? calculateSizeCell!.calculateSizeCell())
        case 1:
            cell.labelName.text = things[indexPath.row].name
            cell.image.image = things[indexPath.row].image.preparingThumbnail(of: calculateSizeCell!.sizeCell ?? calculateSizeCell!.calculateSizeCell())
        default:
            break
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectThing = indexPath.row
        switch indexPath.section{
            
            //выбор коробки
        case 0:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let destination = storyBoard.instantiateViewController(withIdentifier: "CollectionViewControllerContent") as! CollectionViewControllerContent
            destination.title = boxs[selectThing].name
            destination.dataManager = GetDataInBox(boxEntity: boxs[selectThing])
            show (destination, sender: true)
            
            // выбор вещи
        case 1:
            performSegue(withIdentifier: "gotoShowThing", sender: nil)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: CGFloat(8), left: .zero, bottom: .zero, right: .zero)
    }
    
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(1)
//    }
    
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

///сохранение вещи или коробки
    func saveObjectInBase() -> Bool {
        guard let boxOrRoom = dataManager?.getObjectBoxOrRoom() else {
            showMessage(message: "error save object")
            return false
        }
        
        switch typeObjectForSave {
        case .things:
            do {
                try BaseCoreData.shared.saveObject(objectForSave: objectForSave,
                                                   base: .things,
                                                   boxOrRoom: boxOrRoom)
            }
            catch {
                showMessage(message: "error save object thing")
                return false
            }
            things.append(CellData(name: objectForSave.name ?? "_",
                                   image: objectForSave.image ?? #imageLiteral(resourceName: "noPhoto")))
            collectionViewThings.reloadSections(IndexSet(integer: 1))
            print ("saved thing")
        case .boxs:
            do {
                try BaseCoreData.shared.saveObject(objectForSave: objectForSave,
                                                   base: .boxs,
                                                   boxOrRoom: boxOrRoom)
            }
            catch {
                showMessage(message: "error save object thing")
                return false
            }
            boxs = dataManager?.getBoxs() ?? []
            collectionViewThings.reloadSections(IndexSet(integer: 0))
            print ("saved box")
        case .rooms, .main:
            print ("type not found")
            return false
        }
        
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK: переход содержимое коробки/кладовки
        if let destination = segue.destination as? ViewControllerShowThing {
            destination.label = things[selectThing].name
            destination.image = things[selectThing].image
            }
    }
}


