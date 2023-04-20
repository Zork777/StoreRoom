//
//  SettingViewController.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 03.08.2022.
//

import UIKit

class SettingViewController: UIViewController {
    let test = TestData()
    let base = BaseCoreData()
    var myTime = Timer()
    
//    private let progressView: UIProgressView = {
//        let progressView = UIProgressView(progressViewStyle: .default)
//        progressView.trackTintColor = .gray
//        progressView.progressTintColor = .systemBlue
//        return progressView
//    }()
    @IBOutlet weak var progressView: UIProgressView!
    
//    private let progressBar: UIView = {
//       let progressBar = UIView()
//        progressBar.backgroundColor = .green
//        return progressBar
//    }()
    
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
        let room = Object(name: "room1", image: #imageLiteral(resourceName: "noPhoto"))
        if let countObject = Int(textFieldCountObject.text ?? ""), countObject != 0 {
            let base = BaseCoreData()
    
            //Save in base "room1" and save in room count thing
            do {
                try base.saveObject(objectForSave: room, base: .rooms)
                if let roomsObject = try base.fetchContext(base: .rooms, predicate: nil).first {
                    createTimer()
                    DispatchQueue.global(qos: .utility).async { [self] in
                        for n in 1...countObject {
                            try! base.saveObject(objectForSave: Object(name: "thing-\(n)", image: #imageLiteral(resourceName: "noPhoto")),
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        view.addSubview(progressBar)
//        progressBar.addSubview(progressView)
//        progressBar.translatesAutoresizingMaskIntoConstraints = false
//        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        progressBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        progressBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//        progressView.translatesAutoresizingMaskIntoConstraints = false
//        progressView.centerXAnchor.constraint(equalTo: progressBar.centerXAnchor).isActive = true
//        progressView.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor).isActive = true
//        progressView.widthAnchor.constraint(equalTo: progressBar.widthAnchor).isActive = true
//        progressView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        progressView.setProgress(0.0, animated: false)

    }
    

}
