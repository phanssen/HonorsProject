//
//  LibraryCollectionViewController.swift
//  Honors Project
//
//  Created by Paige Hanssen on 1/30/19.
//  Copyright © 2019 Paige Hanssen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FurnitureCell"

class LibraryCollectionViewController: UICollectionViewController {

    let furniture = ["Plant"]
    let furnitureImages: [UIImage] = [UIImage(named: "plant")!]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    // return the number of sections
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return furniture.count
    }

    // return the number of items in the collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return furniture.count
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FurnitureCell", for: indexPath) as! FurnitureCellController // have to cast to cell controller type, otherwise it doesn't recognize that there is a furniture label

        cell.furnitureLabel.text = furniture[indexPath.item]
        cell.furnitureImageView.image = furnitureImages[indexPath.item]
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)

        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
        
        // show options for placing cell or deleting cell here
    }

    @IBAction func onCloseLibrary(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
