//
//  SettingViewController.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 03.08.2022.
//

import UIKit

class SettingViewController: UIViewController {
    let test = TestData()
    
    @IBAction func buttonSaveTestData(_ sender: Any) {
        test.saveTestRooms()
        test.saveTestBoxs()
        test.saveTestThings()
    }
    
    @IBAction func buttonClearBase(_ sender: Any) {
        test.clearBase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
