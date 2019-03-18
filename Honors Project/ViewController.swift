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
    /**** Variables ****/
    var menuImage : UIImage = UIImage(named: "art.scnassets/menu_icon.png")!
    var nodeModel: SCNNode!
    var nodeName: String = ""
    var selectedNode: SCNNode!
    var selectedScn: SCNScene! = nil

    /**** IBOutlets ****/
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet var menuOptions: [UIButton]!
    @IBOutlet weak var closeDetailsButton: UIButton!
    @IBOutlet weak var removeNodeButton: UIButton!
    @IBOutlet weak var placeNodeLabel: UILabel!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rotateRightButton: UIButton!
    @IBOutlet weak var rotateLeftButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // use menu icon for button
        menuButton.setImage(menuImage, for: UIControl.State.normal)

        // Set the view's delegate
        sceneView.delegate = self
        sceneView.antialiasingMode = .multisampling4X

        setupFocusSquare()
        
        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene
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
        // prevent anything else from happening if the details are open
        if(selectedNode != nil) { return }

        // get location of the touch
        let location = touches.first!.location(in: sceneView)

        // test if an object was touched
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        let hitResults: [SCNHitTestResult]  =
            sceneView.hitTest(location, options: hitTestOptions)

        // an object has been touched, show details
        if let hit = hitResults.first {
            // set nodeName to hit node name
            nodeName = hit.node.name!
            if let node = getParent(hit.node) {
                // set selectedNode to node
                selectedNode = node

                // showNodeDetails
                showNodeDetails()

                return
            }
        }

        // no object has been touched, try to add object to scene

        // check if a scene is selected
        if(selectedScn == nil) { return }

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
        // hide menu button while details are showing
        menuButton.isHidden = !menuButton.isHidden

        // toggle remove button visibility
        removeNodeButton.isHidden = !removeNodeButton.isHidden

        // toggle X button visibility to close out of show details
        closeDetailsButton.isHidden = !closeDetailsButton.isHidden

        // toggle down, up button visibility
        downButton.isHidden = !downButton.isHidden
        upButton.isHidden = !upButton.isHidden
        rightButton.isHidden = !rightButton.isHidden
        leftButton.isHidden = !leftButton.isHidden

        // toggle rotation buttons
        rotateLeftButton.isHidden = !rotateLeftButton.isHidden
        rotateRightButton.isHidden = !rotateRightButton.isHidden
    }

    /**** IBActions ****/
    @IBAction func menuAction(_ sender: UIButton) {
        menuControl()
    }

    @IBAction func handleCloseDetailsButton(_ sender: Any) {
        showNodeDetails()
        selectedNode = nil
        nodeName = ""
        placeNodeLabel.isHidden = true
    }

    // Remove node object from the scene
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
        menuControl()
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


    @IBAction func handleDownButton(_ sender: Any) {
        // move current node object down by y increment level
        selectedNode.position = SCNVector3(x: selectedNode.position.x, y: selectedNode.position.y - 0.01, z: selectedNode.position.z)
    }

    @IBAction func handleUpButton(_ sender: Any) {
        // move current node object up by y increment level
        selectedNode.position = SCNVector3(x: selectedNode.position.x, y: selectedNode.position.y + 0.01, z: selectedNode.position.z)
    }

    @IBAction func handleRightButton(_ sender: Any) {
        // move current node object right by x increment level
        selectedNode.position = SCNVector3(x: selectedNode.position.x + 0.01, y: selectedNode.position.y, z: selectedNode.position.z)
    }

    @IBAction func handleLeftButton(_ sender: Any) {
        // move current node object left by x increment level
        selectedNode.position = SCNVector3(x: selectedNode.position.x - 0.01, y: selectedNode.position.y, z: selectedNode.position.z)
    }

    // rotate current scnnode object by 10 degrees to the right
    @IBAction func handleRotateRightButton(_ sender: Any) {
        let rotateR = SCNAction.rotateBy(x: 0, y: CGFloat(10.0 * (Float.pi/180)), z: 0, duration: 0.1)
        selectedNode.runAction(rotateR)
    }

    // rotate current scnnode object by 10 degrees to the left
    @IBAction func handleRotateLeftButton(_ sender: Any) {
        let rotateR = SCNAction.rotateBy(x: 0, y: -CGFloat(10.0 * (Float.pi/180)), z: 0, duration: 0.1)
        selectedNode.runAction(rotateR)
    }

    /**** Helper functions ****/
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

    }
 */

    // render new furniture object node in the ARView
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // check if user has selected a scene has a value
        if(selectedScn == nil) { return }

        // assign nodeModel value of childNode
        nodeModel = selectedScn.rootNode.childNode(
            withName: nodeName, recursively: true)

        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async {
                let modelClone = self.nodeModel.clone()
                modelClone.position = SCNVector3Zero

                // Add model as a child of the node
                node.addChildNode(modelClone)

                // reset name, model and scn values
                self.nodeName = ""
                self.nodeModel = nil
                self.selectedScn = nil
                self.placeNodeLabel.isHidden = true
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

    // MARK: - Focus Square

    var focusSquare: FocusSquare?
    var screenCenter: CGPoint?
    let serialQueue = DispatchQueue(label: "com.apple.arkitexample.serialSceneKitQueue")
//    var virtualObjectManager: VirtualObjectManager!

    func setupFocusSquare() {
        serialQueue.async {
            self.focusSquare?.isHidden = true
            self.focusSquare?.removeFromParentNode()
            self.focusSquare = FocusSquare()
            self.sceneView.scene.rootNode.addChildNode(self.focusSquare!)
        }
    }

//    func updateFocusSquare() {
//        guard let screenCenter = screenCenter else { return }
//
//        DispatchQueue.main.async {
//            var objectVisible = false
//            for object in self.virtualObjectManager.virtualObjects {
//                if self.sceneView.isNode(object, insideFrustumOf: self.sceneView.pointOfView!) {
//                    objectVisible = true
//                    break
//                }
//            }
//
//            if objectVisible {
//                self.focusSquare?.hide()
//            } else {
//                self.focusSquare?.unhide()
//            }
//
//            let (worldPos, planeAnchor, _) = self.virtualObjectManager.worldPositionFromScreenPosition(screenCenter,
//                                                                                                       in: self.sceneView,
//                                                                                                       objectPos: self.focusSquare?.simdPosition)
//            if let worldPos = worldPos {
//                self.serialQueue.async {
//                    self.focusSquare?.update(for: worldPos, planeAnchor: planeAnchor, camera: self.session.currentFrame?.camera)
//                }
//                self.textManager.cancelScheduledMessage(forType: .focusSquare)
//            }
//        }
//    }
}
