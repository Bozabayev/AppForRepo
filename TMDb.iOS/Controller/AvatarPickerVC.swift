//
//  AvatarPickerVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/23/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 

    @IBOutlet weak var collectionView: UICollectionView!
    let nib = UINib(nibName: "AvatarPickerCell", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nib, forCellWithReuseIdentifier: "AvatarPickerCell")
        navigationItem.title = "Choose New Avatar"
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarPickerCell", for: indexPath) as? AvatarPickerCell {
            cell.configureCell(index: indexPath.item)
            return cell
        }
        return AvatarPickerCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 100  , height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        tabBarItem.image = UIImage(named: "\(UserDataService.instance.avatarName)")
        let image = UIImage(named: "\(UserDataService.instance.avatarName)")
        let size  = CGSize(width: 20, height: 20)
        keychain["avatarName"] = UserDataService.instance.avatarName
        let scaledImage =  image?.scaleImage(toSize: size)
        
        self.tabBarController?.tabBar.items![2].image = scaledImage
        self.tabBarController?.tabBar.items![2].selectedImage = scaledImage
        self.navigationController?.popViewController(animated: true)
    }

}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
