//
//  PhotoGalleryViewController.swift
//  SwiftPhotoGallery
//
//  Created by Prashant on 12/09/15.
//  Copyright (c) 2015 PrashantKumar Mangukiya. All rights reserved.
//

import UIKit


class PhotoGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var testBarButton: UIBarButtonItem!
    // collection view cell default width, height
    var cellWidth: Int = 100
    var cellHeight: Int = 100
    var faceHelper = FaceHelper.defaultHelper
    var takePhotoType = 0
    // outlet - collection view for photo listing
    @IBOutlet var photoCollectionView: UICollectionView!
    

    
    // MARK: - view function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        let label = UILabel()
        label.text = "单击右上角添加按钮添加一张照片"
        label.textAlignment = .Center
        label.frame.origin.x = self.photoCollectionView.center.x
        label.frame.origin.y = self.photoCollectionView.center.y
        self.photoCollectionView.backgroundView = label
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Calculate cell width, height based on screen width
        self.calculateCellWidthHeight()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
   
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
       func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.faceHelper.faceImages.count == 0{
            self.photoCollectionView.backgroundView?.hidden = false
            self.testBarButton.enabled = false
        }
        else{
            self.photoCollectionView.backgroundView?.hidden = true
            self.testBarButton.enabled = true
        }

        return self.faceHelper.faceImages.count
    }
    
    // return width and height of cell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
    
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

      
        let newCell = collectionView.dequeueReusableCellWithReuseIdentifier("CellPhoto", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        let faceId = self.faceHelper.faceIds[indexPath.row]
        let photo = self.faceHelper.faceImages[faceId]!
        newCell.galleryImage.image = photo.image
        
        return  newCell
    }
    
    
    func choosePhoto(from: UIImagePickerControllerSourceType) {
        self.takePhotoType = 0
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = from
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
   
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        var img = info[UIImagePickerControllerOriginalImage] as! UIImage
        img = img.fixOrientation()
        self.showHudWithText("正在上传")
        if self.takePhotoType == 0{
            self.faceHelper.addFace(img){
                [unowned self]
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.showHudWithText("上传成功", mode: .Text, hideAfter: 1.0)
                    self.photoCollectionView.reloadData()
                }
                
            }
        }
        else{
            self.faceHelper.testFace(img){
                [unowned self]
                error, isSamePerson in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.hideHud()
                    var message: String
                    if isSamePerson!{
                        message = "识别成功！现在起可以通过拍照签到了。"
                    }
                    else{
                        message = "识别失败！请尝试再添加照片提高识别准确率。"
                    }
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let faceId = self.faceHelper.faceIds[indexPath.row]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "删除", style: .Destructive){
            [unowned self]
            _ in
            self.showHudWithText("正在删除")
            self.faceHelper.deleteFace(faceId){
                [unowned self]
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.photoCollectionView.reloadData()
                    self.hideHud()
                }
                
            }
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // calculate collection view cell width and height based on screen width
    private func calculateCellWidthHeight() {
        
        // how many photos display in one row
        let numberOfPhotoInRow : CGFloat = 3
        
        // find current screen width
        let screenWidth = self.photoCollectionView.frame.width
        
        // deduct spacing from screen width
        // Formula: screeWidth - leftSpace - ( spaceBetweenThumb * (numberOfPhotoInRow - 1) ) - rightSpace
        let netWidth = screenWidth - 5 - ( 5 * (numberOfPhotoInRow - 1) ) - 5
        
        // calcualte single thumb width
        let thumbWidth = Int( netWidth / numberOfPhotoInRow)
        
        // assign width to class variable
        self.cellWidth = thumbWidth
        self.cellHeight = thumbWidth
    }
    @IBAction func addFace(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "从相册选择照片", style: .Default){
            [unowned self]
            _ in
                self.choosePhoto(.PhotoLibrary)
        
            })
        
        alert.addAction(UIAlertAction(title: "使用摄像头拍照", style: .Default){
            [unowned self]
            _ in
                self.choosePhoto(.Camera)
            
            })
        alert.addAction(UIAlertAction(title: "取消", style: .Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func test_face(sender: AnyObject) {
        self.takePhotoType = 1
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
   
}
