//
//  ViewController.swift
//  async_firebase_test
//
//  Created by 濱田 一 on 2017/10/30.
//  Copyright © 2017年 濱田 一. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import RealmSwift

class ViewController: UIViewController {

    var rootRef: DatabaseReference!
    var ActivityIndicator: UIActivityIndicatorView!
    var grayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 薄い灰色のViewをかぶせる
        grayView = UIView()
        grayView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        grayView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        grayView.center = self.view.center

        // ActivityIndicatorを作成＆中央に配置
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        ActivityIndicator.center = self.view.center
        
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        
        // 色・大きさを設定
        ActivityIndicator.activityIndicatorViewStyle = .whiteLarge
        
        //Viewに追加
        grayView.addSubview(ActivityIndicator)
        self.view.addSubview(grayView)

        DispatchQueue.global().async {
            self.readingDictionary()

            DispatchQueue.main.async {
                self.ActivityIndicator.startAnimating() // クルクルスタート
            }
        }
    }

    // RealmにFirebaseの辞書を読み込む
    func readingDictionary(){
        
        // 現在持っている辞書の削除
        let realm = try! Realm()
        let dicEntryArray = realm.objects(DicEntry.self)
        if !dicEntryArray.isEmpty {
            for entry in dicEntryArray {
                try! realm.write {
                    realm.delete(entry)
                }
            }
        }
        
        print("DEBUG_PRINT in readingDictionary()")

        rootRef = Database.database().reference()
        for idx in 0..<Const.DataLength {
            let path = Const.DataPath + "/" + String(idx)
            let defaultPlace = rootRef.child(path)
            
            defaultPlace.observeSingleEvent(of: .value, with: { snapshot in

                self.ActivityIndicator.stopAnimating() // クルクルストップ
                self.grayView.removeFromSuperview()

                if let postDict = snapshot.value as? NSDictionary {
                    
                    // 追加するデータを用意
                    let dicEntry = DicEntry()
                    dicEntry.id = postDict["id"] as! String? ?? ""
                    dicEntry.jname = postDict["jname"] as! String? ?? ""
                    dicEntry.tname = postDict["tname"] as! String? ?? ""
                    dicEntry.wylie = postDict["wylie"] as! String? ?? ""
                    dicEntry.tags = postDict["tags"] as! String? ?? ""
                    dicEntry.image = postDict["image"] as! String? ?? ""
                    dicEntry.eng = postDict["eng"] as! String? ?? ""
                    dicEntry.chn = postDict["chn"] as! String? ?? ""
                    dicEntry.kata = postDict["kata"] as! String? ?? ""
                    dicEntry.pron = postDict["pron"] as! String? ?? ""
                    dicEntry.verb = postDict["verb"] as! String? ?? ""
                    dicEntry.exp = postDict["exp"] as! String? ?? ""
                    dicEntry.bunrui1 = postDict["bunrui1"] as! String? ?? ""
                    dicEntry.bunrui2 = postDict["bunrui2"] as! String? ?? ""
                    dicEntry.bunrui3 = postDict["bunrui3"] as! String? ?? ""
                    
                    // データを追加
                    let realm = try! Realm()
                    try! realm.write() {
                        realm.add(dicEntry)
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

