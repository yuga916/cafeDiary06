//
//  imageViewController.swift
//  FoodTracker
//
//  Created by 一戸悠河 on 2017/02/17.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit
import CoreData
import Photos

class imageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var cafeArray: [NSDictionary] = []
    var cafeDic: NSDictionary! = [:]
    var myCafe = NSArray() as! [String]
    var count = 0
    let oneFlowLayout = oneItemsFlowLayout()
    let cellMargin:CGFloat = 2.0
    
    @IBOutlet weak var imageCollection: UICollectionView!
    
//    let oneFlowLayout = oneItemsFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollection.delegate = self
        imageCollection.dataSource = self

//        ページングするかどうか
//        imageCollection.isPagingEnabled = true
        
    }

    //既に存在するデータの読み込み処理
    func read() {
        //AppDelegateを使う用意をする
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //どのエンティティからdataを取得してくるか設定
        let query:NSFetchRequest<Diary> = Diary.fetchRequest()
        
        do{
            //データを一括取得
            var fetchResults = try viewContext.fetch(query)
            print(fetchResults.count)
            //            print(fetchResults)
            //データの取得
            //一旦配列を空っぽにする（初期化する）→そうしないとどんどん、TableViewに表示されてしまう。
            myCafe = NSArray() as! [String]
            cafeArray = NSArray() as! [NSDictionary]
            //nilが入るかもしれないのでasに?をつける。
            for result: AnyObject in fetchResults {
                
                let coffeeName:String? = result.value(forKey: "coffeeName") as? String
                let date: Date? = result.value(forKey: "date") as? Date
                let studyTime: NSNumber = (result.value(forKey: "studyTime") as? NSNumber)!
                let img: String? = result.value(forKey: "img") as? String
                let rating: NSNumber? = result.value(forKey: "rating") as? NSNumber
                print("name:\(coffeeName) saveDate:\(date) studyTime:\(studyTime) image:\(img) rating:\(rating)")
                cafeDic = ["coffeeName":coffeeName, "date":date, "studyTime":studyTime, "img":img, "rating":rating]
                cafeArray.append(cafeDic)
                print(cafeArray)
                
                //                myCafe = NSArray() as! [String]
                //                myCafe.append(coffeeName!)
                //                print(myCafe)
            }
            print(cafeArray.count)
        } catch {
        }
        //TableViewの再描画
        imageCollection.reloadData()
    }
    
    // Screenサイズに応じたセルサイズを返す
//    // UICollectionViewDelegateFlowLayoutの設定が必要
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: NSIndexPath) -> CGSize {
////        let cellSize:CGFloat = collectionView.frame.size.width / 2
//        let cellSize:CGFloat = UIScreen.main.bounds.size.width
//        // 正方形で返すためにwidth,heightを同じにする
//        return CGSize(width: cellSize, height: cellSize)
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let width: CGFloat = UIScreen.main.bounds.size.width
//        //        let height: CGFloat = view.frame.height
//        return CGSize(width: width, height: width)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let cellSize:CGFloat = collectionView.frame.size.width / 2
        let cellSize:CGFloat
        if UIScreen.main.bounds.size.width > 500 {
          cellSize = UIScreen.main.bounds.size.width / 4 - 2
        } else {
          cellSize = UIScreen.main.bounds.size.width / 2 - 2
        }
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)

    }

    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return cellMargin
//    }
    
    // MARK: - UICollectionViewDelegate Protocol
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! imageCollectionViewCell
        //画像
        var imgDic = cafeArray[indexPath.row] as! NSDictionary
        var AImage: UIImage!
        if imgDic["img"] as? String == "" {
            cell.image.image = UIImage(named: "defaultPhoto")
        } else {
            let url = URL(string: (imgDic["img"] as! NSString) as String)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,targetSize: CGSize(width: 5, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
                //                        self.cell.tableMyImg.image = image
                AImage = image
                self.count += 1
            }
            cell.image.image = AImage
        }
        
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//                for data in 1 ... cafeArray.count {
//                  var imgDic = data as! NSDictionary
//                    if imgDic["img"] as! String == nil {
//                        var count = imgDic["img"] as! String
//                    }
//                }
//        
//        
//                return count
        return cafeArray.count
//        return count
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
//    {
//        let width = (self.imageCollection.frame.size.width-20)/2
//        
//        return CGSize(width: width, height: 150)
//    }
    
    //こっちは表示されるたびに出力される
    override func viewWillAppear(_ animated: Bool) {
        read()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Viewを切り替える
    private func changeView(flowLayout: UICollectionViewFlowLayout) {
        
        UIView.animate(withDuration: 0.5) { [weak self] () -> Void in
            
            self?.imageCollection.collectionViewLayout.invalidateLayout()
            self?.imageCollection.setCollectionViewLayout(flowLayout, animated: true)
            self?.imageCollection.layoutIfNeeded()
        }
        
    }
    
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("タップされたよ")
//        changeView(flowLayout: oneFlowLayout)
//        self.changeView(flowLayout: oneFlowLayout)
        // [indexPath.row] から画像名を探し、UImage を設定
//        selectedImage = UIImage(named: photos[(indexPath as NSIndexPath).row])
//        if selectedImage != nil {
//            // SubViewController へ遷移するために Segue を呼び出す
//            performSegue(withIdentifier: "toSubViewController",sender: nil)
//        }
        
    }
    
//    // Segue 準備
//    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
//        if (segue.identifier == "toSubViewController") {
//            let subVC: SubViewController = (segue.destination as? SubViewController)!
//            // SubViewController のselectedImgに選択された画像を設定する
//            subVC.selectedImg = selectedImage
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //githubの確認
    
}
