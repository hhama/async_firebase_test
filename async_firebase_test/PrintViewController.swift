//
//  PrintViewController.swift
//  async_firebase_test
//
//  Created by 濱田 一 on 2017/11/05.
//  Copyright © 2017年 濱田 一. All rights reserved.
//

import UIKit
import RealmSwift


class PrintViewController: UIViewController {

    @IBOutlet weak var printValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realm内の辞書の確認
        let realm = try! Realm()
        let dicEntryArray = realm.objects(DicEntry.self)

        let printString = "dictionary-size: \(dicEntryArray.count)"
        printValueLabel.text = printString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
