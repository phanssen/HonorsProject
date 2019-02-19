//
//  LibraryCollectionViewController.swift
//  Honors Project
//
//  Created by Paige Hanssen on 1/30/19.
//  Copyright © 2019 Paige Hanssen. All rights reserved.
//

import UIKit
import SceneKit

private let reuseIdentifier = "FurnitureCell"

class LibraryCollectionViewController: UICollectionViewController {

    let furniture = ["Elephant", "Cherub"]
    let furnitureImages: [SCNScene] = [SCNScene(named: "art.scnassets/elephant/elephant.dae")!, SCNScene(named: "art.scnassets/cherub/cherub.dae")!]

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
        cell.furnitureObject.scene = furnitureImages[indexPath.item]
//        let tempNode = furnitureImages[indexPath.item].rootNode.childNode(withName: "elephant", recursively: true)!
//        tempNode.scale = SCNVector3(x: 2.0, y: 2.0, z: 2.0)

//        cell.furnitureObject.scene = tempSCN

        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)

        if let mainVC = presentingViewController as? ViewController {
            mainVC.nodeName = furniture[indexPath.item].lowercased()
            mainVC.selectedScn = furnitureImages[indexPath.item]
        }
        // show item options
        dismiss(animated: true, completion: nil)
//        onCloseLibrary(self)
//        mainVC.performSegue(withIdentifier: "toLibrary", sender: self)

//        if(cell?.layer.borderColor == UIColor.gray.cgColor) {
//            cell?.layer.borderColor = UIColor.lightGray.cgColor
//            cell?.layer.borderWidth = 0.5
//        } else {
//            cell?.layer.borderColor = UIColor.gray.cgColor
//            cell?.layer.borderWidth = 2
//        }
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
