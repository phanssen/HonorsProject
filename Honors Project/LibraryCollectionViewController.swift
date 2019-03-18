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

    /**** Collection cell items ****/
    let furniture = ["Elephant", "Cherub", "Wood-Chair"]
    let furnitureImages: [SCNScene] = [SCNScene(named: "art.scnassets/elephant/elephant.dae")!, SCNScene(named: "art.scnassets/cherub/cherub.dae")!, SCNScene(named: "art.scnassets/wood-chair/wood-chair.dae")!]

    override func viewDidLoad() {
        super.viewDidLoad()

        // display button options: delete and place in view
        let placeButton = UIButton()
        placeButton.setTitle("Place in view", for: UIControl.State.normal)
        placeButton.isHidden = true
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
        return 1
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
        if let mainVC = presentingViewController as? ViewController {
            mainVC.nodeName = furniture[indexPath.item].lowercased()
            mainVC.selectedScn = furnitureImages[indexPath.item]
            mainVC.placeNodeLabel.isHidden = false
        }

        // show item options here

//        placeItemButton.isHidden = !placeItemButton.isHidden
//        deleteItemButton.isHidden = !deleteItemButton.isHidden
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onCloseLibrary(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    // display option buttons for a cell item
    func showOptions() {

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
