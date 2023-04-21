//
//  SettingViewController.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 03.08.2022.  
//

import UIKit

class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let test = TestData()
    let base = BaseCoreData()
    var myTime = Timer()
    var imageTest: UIImage? {
        didSet {
            saveObjectForTest() // save test object for load testing
        }
    }

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func bacupBase(_ sender: Any) {
        BaseCoreData.shared.backupBase(backupName: "backupBase")
    }
    
    @IBAction func restoreBase(_ sender: Any) {
        BaseCoreData.shared.restoreFromStore(backupName: "backupBase")
    }
    
    @IBAction func buttonSaveTestData(_ sender: Any) {
        test.saveTestRooms()
        test.saveTestBoxs()
        test.saveTestThings()
    }
    
    @IBAction func buttonClearBase(_ sender: Any) {
        base.deleteAllCoreBases()
    }
    
    @IBOutlet weak var textFieldCountObject: UITextField!
    var valueProgressBar: Float = 0
    
    @IBAction func buttonLoadTesting(_ sender: Any) {
        getPhotoInCamera()
    }
    
    func createTimer(){
        myTime = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector (updateProgressView), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgressView() {
        if progressView.progress != 1.0 {
            progressView.progress = valueProgressBar
        } else if progressView.progress == 1.0 {
            self.myTime.invalidate()
            showMessage(message: "Object is create")
            progressView.setProgress(0, animated: true)
        }
    }
    
    func saveObjectForTest() {
        let room = Object(name: "Test_room", image: #imageLiteral(resourceName: "noPhoto"))
        if let countObject = Int(textFieldCountObject.text ?? ""), countObject != 0 {
            let base = BaseCoreData()
            
            //Save in base "Test_room" and save in room count thing
            do {
                try base.saveObject(objectForSave: room, base: .rooms)
                if let roomsObject = base.findObjectByNameOrID(name: "Test_room", base: .rooms)?.first {
                    createTimer()
                    DispatchQueue.global(qos: .utility).async { [self] in
                        for n in 1...countObject {
                            try! base.saveObject(objectForSave: Object(name: "thing-\(n)", image: imageTest),
                                                 base: .things,
                                                 boxOrRoom: roomsObject)
                            self.valueProgressBar = Float(n) / Float(countObject)
                        }
                        
                    }
                }
                else {
                    showMessage(message: "Rooms is not empty! Exit test")
                }
            }
            catch{
                showMessage(message: error.localizedDescription)
            }
        }
        else {
            showMessage(message: "Only numbers!")
        }
    }
    
    
    func getPhotoInCamera(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        imageTest = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
