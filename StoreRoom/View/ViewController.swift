//
//  ViewController.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 02.11.2022.
//

import UIKit
import CoreData

private let reuseIdentifier = "ItemCell"

class ViewController: UIViewController {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: объявляем переменные
    var dialogViews = [UIView]()
    var dataManager: DataManager!
    private var selectCell: Int = 0
    private var boxsOrRooms = [NSManagedObject]()
    private var things = [NSManagedObject]()
    var calculateSizeCell: CalculateSizeCell!
    var dialogGetNameThing: (()->()) = {return}
    var typeObjectForSave: BaseCoreData.Bases = .things
    var buttonAdd = UIBarButtonItem()
    var buttonDelete = UIBarButtonItem()
    var buttonEdit = UIBarButtonItem()
    var buttonLeftBarItem = UIBarButtonItem()
    
    //MARK: переменная для хранения объекта для записи + проверка готовности объекта для записи
    var objectForSave:Object = Object(name: nil, image: nil) {
        
        didSet {
            if objectForSave.name != nil && objectForSave.image != nil {
                if dataManager.saveObjectInBase(typeObjectForSave: typeObjectForSave, objectForSave: objectForSave){
                    addObjectInArray()
                    objectForSave = Object(name: nil, image: nil)
                }
                else {
                    let messageError = NSLocalizedString("errorSaveObject",
                                                         value: "Couldn't save a new item to the database",
                                                         comment: "message error aboute error save in core base in var objectForSave")
                    showMessage(message: messageError)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK:загружаем данные в массивы
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.boxsOrRooms = strongSelf.dataManager.getBoxOrRomm() ?? []

            strongSelf.things = strongSelf.dataManager.getThings() ?? []
            strongSelf.collectionView.reloadData()
        }
        
        //MARK: настраиваем collection
        configCollection()
        
        if dataManager.getObjectBoxOrRoom() == nil {
            let nameTitle = NSLocalizedString("RootTitleName", value: "Root", comment: "title name main window")
            title = nameTitle }
        
        
        collectionView!.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        //MARK: добавляем кнопки в bar
        buttonEdit = editButtonItem
        buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonAddThing))
        buttonDelete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItem))
        navigationItem.rightBarButtonItems = [buttonAdd, buttonEdit]
    }
    
    func configCollection() {
        collectionView.backgroundColor = .systemBackground
        collectionView.sizeToFit()
        
        //MARK: create tool bar
        let oneColumn = UIImage(systemName: "rectangle.grid.1x2.fill")
        let twoColumn = UIImage(systemName: "rectangle.grid.2x2.fill")
        let threeColumn = UIImage(systemName: "rectangle.grid.3x2.fill")
        let fourColumn = UIImage(systemName: "square.grid.4x3.fill")
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
        
        //MARK: настройка входа в системное меню
        let tap = UITapGestureRecognizer(target: self, action: #selector(funcAdminButton))
        tap.numberOfTapsRequired = 5
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }

}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
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
        
        if editing {
            buttonLeftBarItem = navigationItem.backBarButtonItem ?? UIBarButtonItem()
            navigationItem.leftBarButtonItem = buttonDelete
            navigationItem.rightBarButtonItems = [buttonEdit]
        }
        else {
            navigationItem.backBarButtonItem = buttonLeftBarItem
            navigationItem.leftBarButtonItems = []
            navigationItem.rightBarButtonItems = [buttonAdd, buttonEdit]
        }
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return boxsOrRooms.count
        case 1:
            return things.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        switch indexPath.section{
        case 0:
            let name = boxsOrRooms[indexPath.row].value(forKey: "name") as? String ?? ""
            var image = (boxsOrRooms[indexPath.row].value(forKey: "image") as? Data)?.convertToUIImage()
            if image == nil { image = #imageLiteral(resourceName: "noPhoto") }
            cell.config(cell: Cell(labelName: name, image: image!, sizeCell: calculateSizeCell.sizeCell))


        case 1:
            let name = things[indexPath.row].value(forKey: "name") as? String ?? ""
            var image = (things[indexPath.row].value(forKey: "image") as? Data)?.convertToUIImage()
            if image == nil { image = #imageLiteral(resourceName: "noPhoto") }
            cell.config(cell: Cell(labelName: name, image: image!, sizeCell: calculateSizeCell.sizeCell))
            

        default:
            break
        }

        cell.isInEditingMode = isEditing
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isEditing { return }
        
        selectCell = indexPath.row
        switch indexPath.section{
            
            //MARK: Действие при нажатии на коробку или кладовку
        case 0:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let destination = storyBoard.instantiateViewController(withIdentifier: "mainScene1") as! ViewController
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewControllerShowThing {
            let name = things[selectCell].value(forKey: "name") as? String ?? ""
            let image = (things[selectCell].value(forKey: "image") as? Data)?.convertToUIImage()
            destination.label = name
            destination.image = image
            }
    }
    
    //MARK: переход в настройки
    @objc func funcAdminButton() {
        performSegue(withIdentifier: "gotoSetting", sender: nil)
    }
    
    //MARK: функция изменения кол-ва row
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
    final class NumberOfRow: UIBarButtonItem {
        var numberOfRow: CGFloat?
    }
    
    //MARK: функция добавляет новую кладовку, коробку, вещь
    @objc func buttonAddThing(){
        dialogGetNameThing = viewGetName
        getPhotoInCamera()
        
//        objectForSave.image = #imageLiteral(resourceName: "sokrovisha-1") //for test
//        viewGetName() //for test
    }
    
    //MARK: функция Записывает новый объект в массив и обновляет ячейки
    func addObjectInArray() {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else {return}
            switch strongSelf.typeObjectForSave {
            case .things:
                strongSelf.things = strongSelf.dataManager.getThings() ?? []
                strongSelf.collectionView.reloadSections(IndexSet(integer: 1))
                
            case .boxs, .rooms:
                strongSelf.boxsOrRooms = strongSelf.dataManager?.getBoxOrRomm() ?? []
                strongSelf.collectionView.reloadSections(IndexSet(integer: 0))
                
            case .main:
                showMessage(message: "global error (addObjectInArray)")
                print ("type not found")
            }
        }
    }
    
    //MARK: функция удаляет выбранные ячейки
    @objc func deleteItem() {
        if let selectedCells = collectionView.indexPathsForSelectedItems{
            let items = selectedCells.sorted().reversed().map { ($0.section, $0.row) }
            let messageError = NSLocalizedString("errorDeleteObject",
                                                 value: "Error delete - ",
                                                 comment: "message error when deleting an box/root/thing")
            for item in items {
                let objectIndex = item.1
                
                switch item.0 {
                    //MARK: удаление коробок
                case 0:
                    let getCountOld = boxsOrRooms.count
                    let objectName = boxsOrRooms[objectIndex].value(forKey: "name") as? String ?? ""
                    let blankFullScreen = UIView(frame: view.frame)
                    let dialogConfirmDelete = DialogConfirmDelete.fromNib()
                    
                    dialogConfirmDelete.objectName.text = objectName
                    dialogConfirmDelete.functionDelete = {
                        [weak self] in
                        guard let strongSelf = self else {return}
                        let getCountNew = strongSelf.boxsOrRooms.count
                        let correctIndex = objectIndex-(getCountOld - getCountNew)
                        if !strongSelf.dataManager.deleteObjectInBase(typeObjectForDelete: .boxs, objectForDelete: strongSelf.boxsOrRooms[correctIndex]) {
                            showMessage(message: "\(messageError)\"\(objectName)\"")}
                        else {
                            strongSelf.boxsOrRooms.remove(at: correctIndex)
                            strongSelf.collectionView.deleteItems(at: [IndexPath(row: correctIndex, section: item.0)])}
                        }
                    dialogConfirmDelete.functionCloseVC = {
                        self.dismiss(animated: true)
                        blankFullScreen.removeFromSuperview()
                    }
                    

                    blankFullScreen.backgroundColor = .white
                    blankFullScreen.alpha = 0.5
                    view.addSubview(blankFullScreen)
                    
                    view.addSubview(dialogConfirmDelete)
                    dialogConfirmDelete.setupInit(view: view)
                    
                    //MARK: Удаление вещей
                case 1:
                    let objectName = things[objectIndex].value(forKey: "name") as? String ?? ""
                    if !dataManager.deleteObjectInBase(typeObjectForDelete: .things, objectForDelete: things[objectIndex]) {
                        showMessage(message: "\(messageError)\"\(objectName)\"")
                    }
                    else {
                        things.remove(at: objectIndex)
                        collectionView.deleteItems(at: [IndexPath(row: item.1, section: item.0)])
                    }
                default:
                    break
                }
            }
            isEditing = false
        }
    }
    
}
