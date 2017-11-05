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

        let defaultPlace = Database.database().reference().child(Const.DataPath)
            
        defaultPlace.observeSingleEvent(of: .value, with: { snapshot in

            self.ActivityIndicator.stopAnimating() // クルクルストップ
            self.grayView.removeFromSuperview()

            if let postDict = snapshot.value as? [NSDictionary] {
                    
                for idx in 0..<postDict.count {
                    // 追加するデータを用意
                    let dicEntry = DicEntry()
                    dicEntry.id = postDict[idx]["id"] as! String? ?? ""
                    dicEntry.jname = postDict[idx]["jname"] as! String? ?? ""
                    dicEntry.tname = postDict[idx]["tname"] as! String? ?? ""
                    dicEntry.wylie = postDict[idx]["wylie"] as! String? ?? ""
                    dicEntry.tags = postDict[idx]["tags"] as! String? ?? ""
                    dicEntry.image = postDict[idx]["image"] as! String? ?? ""
                    dicEntry.eng = postDict[idx]["eng"] as! String? ?? ""
                    dicEntry.chn = postDict[idx]["chn"] as! String? ?? ""
                    dicEntry.kata = postDict[idx]["kata"] as! String? ?? ""
                    dicEntry.pron = postDict[idx]["pron"] as! String? ?? ""
                    dicEntry.verb = postDict[idx]["verb"] as! String? ?? ""
                    dicEntry.exp = postDict[idx]["exp"] as! String? ?? ""
                    dicEntry.bunrui1 = postDict[idx]["bunrui1"] as! String? ?? ""
                    dicEntry.bunrui2 = postDict[idx]["bunrui2"] as! String? ?? ""
                    dicEntry.bunrui3 = postDict[idx]["bunrui3"] as! String? ?? ""
                    
                    // データを追加
                    let realm = try! Realm()
                    try! realm.write() {
                        realm.add(dicEntry)
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

