//
//  CollectionViewControllerContent.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 13.08.2022.
//

import UIKit
import CoreData

private let reuseIdentifier = "ItemCell"


class CollectionViewControllerContent: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIToolbarDelegate {

    //MARK: переход в настройки
    @objc func funcAdminButton() {
        performSegue(withIdentifier: "gotoSetting", sender: nil)
    }
    
    //MARK: изменение кол-ва row
    @objc func buttonNumberOfRow(sender: NumberOfRow) {
        guard let numberOfRow = sender.numberOfRow else {return}
        calculateSizeCell = CalculateSizeCell(itemsPerRow: numberOfRow)
        
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.collectionView.reloadSections(IndexSet(integer: 0))
            strongSelf.collectionView.reloadSections(IndexSet(integer: 1))

        }

    }
    
    @objc func buttonEditMode() {
        print ("edit mode")
    }
    
    //MARK: variables
    var dataManager: DataManager!
    private var selectCell: Int = 0
    private var boxsOrRooms = [NSManagedObject]()
    private var things = [CellData]()
    var calculateSizeCell: CalculateSizeCell!
    var dialogGetNameThing: (()->()) = {return}
    var typeObjectForSave: BaseCoreData.Bases = .things
    
    
    //MARK: хранение объекта для записи + проверка готовности объекта для записи
    var objectForSave:Object = Object(name: nil, image: nil) {
        
        didSet {
            if objectForSave.name != nil && objectForSave.image != nil {
                if dataManager.saveObjectInBase(typeObjectForSave: typeObjectForSave, objectForSave: objectForSave){
                    addObjectInArray()
                    objectForSave = Object(name: nil, image: nil)
                }
                else {
                    showMessage(message: "Не получилось сохранить в базу новую вещь")
                }
            }
        }
    }
    
    //MARK: Добавляем новую кладовку, коробку, вещь
        @objc func buttonAddThing(){
//        dialogGetNameThing = viewGetName
//        getPhotoInCamera()
        
//        objectForSave.image = #imageLiteral(resourceName: "sokrovisha-1") //for test
//        viewGetName() //for test
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:загружаем данные в массивы
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.boxsOrRooms = strongSelf.dataManager.getBoxOrRomm() ?? []

            if let thingsEntity = strongSelf.dataManager.getThings() {
                strongSelf.things = thingsEntity.map{$0.convertToItemCollection()}
            }
            strongSelf.collectionView.reloadData()
        }
        
        if dataManager.getObjectBoxOrRoom() == nil { title = "Кладовки" }
        
        collectionView!.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        
        //MARK: добавляем кнопки на barItemright выбор(select) +
        let buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonAddThing))
//        let buttonEdit = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(buttonEditMode))
        let buttonEdit = editButtonItem
        navigationItem.rightBarButtonItems = [buttonAdd, buttonEdit]
        
        
        //MARK: create tool bar
        let oneColumn = UIImage(systemName: "rectangle.grid.1x2.fill")
        let twoColumn = UIImage(systemName: "rectangle.grid.2x2.fill")
        let threeColumn = UIImage(systemName: "rectangle.grid.3x2.fill")
        let fourColumn = UIImage(systemName: "square.grid.4x3.fill")
//        let edit = UIImage(systemName: "square.and.pencil")
        self.navigationController?.isToolbarHidden = false
        let barButtonOneRow = NumberOfRow(image: oneColumn, style: .plain, target: self,
                                          action: #selector(buttonNumberOfRow(sender:)))
                                          barButtonOneRow.numberOfRow = 1
        let barButtonTwoRow = NumberOfRow(image: twoColumn, style: .plain, target: self,
                                          action: #selector(buttonNumberOfRow(sender:)))
                                          barButtonTwoRow.numberOfRow = 2
        let barButtonThreeRow = NumberOfRow(image: threeColumn, style: .plain, target: self,
                                            action: #selector(buttonNumberOfRow(sender:)))
                                            barButtonThreeRow.numberOfRow = 3
        let barButtonFourRow = NumberOfRow(image: fourColumn, style: .plain, target: self,
                                            action: #selector(buttonNumberOfRow(sender:)))
                                            barButtonFourRow.numberOfRow = 4
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        self.toolbarItems = [barButtonOneRow, flexibleSpace, barButtonTwoRow, flexibleSpace, barButtonThreeRow, flexibleSpace, barButtonFourRow]

        
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.sizeToFit()
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor , constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        view.backgroundColor = .systemBackground
        
        
        //MARK: настройка входа в системное меню
        let tap = UITapGestureRecognizer(target: self, action: #selector(funcAdminButton))
        tap.numberOfTapsRequired = 5
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }

   
    //MARK: отмена выбора ячейки
//    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        if let selectedItems = collectionView.indexPathsForSelectedItems {
//            if selectedItems.contains(indexPath) {
//                collectionView.deselectItem(at: indexPath, animated: true)
//                return false
//            }
//        }
//        return true
//    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return boxsOrRooms.count
        case 1:
            return things.count
        default:
            return 0
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView.allowsMultipleSelection = editing
        
        collectionView.indexPathsForSelectedItems?.forEach({ (IndexPath) in
            collectionView.deselectItem(at: IndexPath, animated: true)
        })
        
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            cell.isInEditingMode = editing
        }
    }
    
    
    
//    override func indexTitles(for collectionView: UICollectionView) -> [String]? {
//        return ["вещи", "коробки"]
//    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        switch indexPath.section{
        case 0:
            let name = boxsOrRooms[indexPath.row].value(forKey: "name") as? String ?? ""
            var image = (boxsOrRooms[indexPath.row].value(forKey: "image") as? Data)?.convertToUIImage()
            if image == nil { image = #imageLiteral(resourceName: "noPhoto") }
            cell.config(cell: Cell(labelName: name, image: image!, sizeCell: calculateSizeCell.sizeCell))


        case 1:
            let name = things[indexPath.row].name
            let image = things[indexPath.row].image
            cell.config(cell: Cell(labelName: name, image: image, sizeCell: calculateSizeCell.sizeCell))

        default:
            break
        }

        cell.isInEditingMode = isEditing
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("select-", collectionView.indexPathsForSelectedItems)
        
        if isEditing {
            print ("view delete button")
            deleteItem()
            return
        } else {
            print ("hide delete button1")
        }
        
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            print ("hide delete button2")
        }
        
        selectCell = indexPath.row
        switch indexPath.section{
            
            //MARK: Действие при нажатии на коробку или кладовку
        case 0:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let destination = storyBoard.instantiateViewController(withIdentifier: "mainScene") as! CollectionViewControllerContent
            destination.title = boxsOrRooms[selectCell].value(forKey: "name") as? String
            destination.calculateSizeCell = CalculateSizeCell(itemsPerRow: 2)
            destination.dataManager = GetData(object: boxsOrRooms[selectCell])
            show (destination, sender: true)
            
            //MARK: Действие при нажатии на вещь
        case 1:
            performSegue(withIdentifier: "gotoShowThing", sender: nil)
        default:
            break
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: CGFloat(8), left: .zero, bottom: .zero, right: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateSizeCell.sizeCell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
//        return true
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
    
    
    //MARK: удаляем выбранные ячейки
    func deleteItem() {
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            print (selectedCells)
          // 1
          let items = selectedCells.map { $0.item }.sorted().reversed()
          // 2
          for item in items {
//              print(item)
//              modelData.remove(at: item)
          }
          // 3
//          collectionViewThings.deleteItems(at: selectedCells)
//          deleteButton.isEnabled = false
        }
    }
    
    /// Записываем новый объект в массив и обновляем ячейки
    func addObjectInArray() {

        switch typeObjectForSave {
        case .things:
            things.append(CellData(name: objectForSave.name ?? "_",
                                   image: objectForSave.image ?? #imageLiteral(resourceName: "noPhoto")))
            collectionView.reloadSections(IndexSet(integer: 1))
            
        case .boxs, .rooms:
            boxsOrRooms = dataManager?.getBoxOrRomm() ?? []
            collectionView.reloadSections(IndexSet(integer: 0))
            
        case .main:
            print ("type not found")
        }
    }
    
    //MARK: show picter thing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewControllerShowThing {
            destination.label = things[selectCell].name
            destination.image = things[selectCell].image
            }
    }
}

final class NumberOfRow: UIBarButtonItem {
    var numberOfRow: CGFloat?
}


