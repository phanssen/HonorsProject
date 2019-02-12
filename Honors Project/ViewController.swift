//
//  ViewController.swift
//  Honors Project
//
//  Created by Paige Hanssen on 1/8/19.
//  Copyright © 2019 Paige Hanssen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    var menuImage : UIImage = UIImage(named: "art.scnassets/menu_icon.png")!
    var nodeModel: SCNNode!
    let nodeName = "cherub"
    var selectedNode: SCNNode!

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet var menuOptions: [UIButton]!
    @IBOutlet weak var closeDetailsButton: UIButton!
    @IBOutlet weak var removeNodeButton: UIButton!


    @IBAction func menuAction(_ sender: UIButton) {
        menuControl()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // use menu icon for button
        menuButton.setImage(menuImage, for: UIControl.State.normal)

        // Set the view's delegate
        sceneView.delegate = self
        sceneView.antialiasingMode = .multisampling4X
        
        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene

        let modelScene = SCNScene(named:
            "art.scnassets/cherub/cherub.dae")!

        nodeModel =  modelScene.rootNode.childNode(
            withName: nodeName, recursively: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    // track screen touches on ARView and either add or remove object accordingly
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // prevent anything else from happening if the details are open...may need to change this when selecting things from library
        if selectedNode != nil { return }

        // get location of the touch
        let location = touches.first!.location(in: sceneView)

        // test if an object was touched
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        let hitResults: [SCNHitTestResult]  =
            sceneView.hitTest(location, options: hitTestOptions)

        // an object has been touched and gets removed(?) -> turn this into "showDetails"
        if let hit = hitResults.first {
            if let node = getParent(hit.node) {
                // set selectedNode to node
                selectedNode = node

                // showNodeDetails
                showNodeDetails()

                return
            }
        }

        // find a feature point and add an ARAnchor
        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(location, types: .featurePoint)
        if let hit = hitResultsFeaturePoints.first {
            sceneView.session.add(anchor: ARAnchor(transform: hit.worldTransform))
        }
    }

    // recursively search for parent node
    func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == nodeName {
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }

    func showNodeDetails() {
        // make remove button visible
        removeNodeButton.isHidden = !removeNodeButton.isHidden

        // make X button visible to close out of show details
        closeDetailsButton.isHidden = !closeDetailsButton.isHidden
    }

    @IBAction func handleCloseDetailsButton(_ sender: Any) {
        showNodeDetails()
        selectedNode = nil
    }

    @IBAction func handleRemoveNodeButton(_ sender: Any) {
        // prompt user to confirm they want to clear object
        let alertPrompt = UIAlertController(title: "Remove Object", message: "Are you sure you want to remove this object?", preferredStyle: .alert)

        // add yes and no options
        alertPrompt.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            return
        }))
        alertPrompt.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default Action"), style: .default, handler: { _ in
            self.selectedNode.removeFromParentNode()
            self.handleCloseDetailsButton(sender)
        }))

        // display prompt
        self.present(alertPrompt, animated: true, completion: nil)
    }

    @IBAction func handleLibraryButton(_ sender: Any) {
        performSegue(withIdentifier: "toLibrary", sender: self)
    }

    // clear all objects from the scene; connected to Clear View from menu
    @IBAction func clearView() {
        if selectedNode != nil { return }

        // prompt user to confirm they want to clear view
        let alertPrompt = UIAlertController(title: "Clear View", message: "Are you sure you want to remove all objects from current view?", preferredStyle: .alert)

        // add yes and no options
        alertPrompt.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            return
        }))
        alertPrompt.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default Action"), style: .default, handler: { _ in
                self.sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in node.removeFromParentNode()}
        }))

        // display prompt
        self.present(alertPrompt, animated: true, completion: nil)
    }

    // open and close the menu
    func menuControl() {
        menuOptions.forEach{(option) in
            UIView.animate(withDuration: 0.3, animations: ({
                option.isHidden = !option.isHidden
                self.view.layoutIfNeeded()
            }))
        }
    }

    // MARK: - ARSCNViewDelegate

/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async {
                let modelClone = self.nodeModel.clone()
                modelClone.position = SCNVector3Zero

                // Add model as a child of the node
                node.addChildNode(modelClone)
            }
        }

        return node
    }
 */

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async {
                let modelClone = self.nodeModel.clone()
                modelClone.position = SCNVector3Zero

                // Add model as a child of the node
                node.addChildNode(modelClone)
            }
        }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}



//func createShip(position: SCNVector3) {
//    let sphereShape = SCNSphere(radius: 0.05)
//
//    // set the color of the box...can use UIImage(named: "") for texture from an image
//    let material = SCNMaterial()
//    material.diffuse.contents = UIColor.green
//
//    sphereShape.materials = [material]
//
//    // create the scene node from the shape
//    let sphere = SCNNode(geometry: sphereShape)
//    sphere.position = position
//
//    // var shipNode = SCNNode(mdlObject: "art.scnassets/ship.scn")
//    sceneView.scene.rootNode.addChildNode(sphere)
//}
