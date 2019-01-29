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

    @IBOutlet var sceneView: ARSCNView!

    @IBOutlet weak var menuButton: UIButton!

    @IBOutlet var menuOptions: [UIButton]!

    @IBAction func menuAction(_ sender: UIButton) {
        menuOptions.forEach{(option) in
            UIView.animate(withDuration: 0.3, animations: ({
                option.isHidden = !option.isHidden
                self.view.layoutIfNeeded()
            }))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // use menu icon for button
        menuButton.setImage(menuImage, for: UIControl.State.normal)

        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!

        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let result = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])

        guard let hitResult = result.last else {return}
        let hitTransform = (hitResult.worldTransform)
        let hitVector = SCNVector3Make(hitTransform.columns.3.x, hitTransform.columns.3.y, hitTransform.columns.3.z)

        createShip(position: hitVector)
    }

    func createShip(position: SCNVector3) {
        let sphereShape = SCNSphere(radius: 0.05)

        // set the color of the box...can use UIImage(named: "") for texture from an image
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green

        sphereShape.materials = [material]

        // create the scene node from the shape
        let sphere = SCNNode(geometry: sphereShape)
        sphere.position = position

        // var shipNode = SCNNode(mdlObject: "art.scnassets/ship.scn")
        sceneView.scene.rootNode.addChildNode(sphere)
    }

    // remove single object from the view
    @IBAction func removeObject(node: SCNNode) {
        node.removeFromParentNode()
    }

    // clear all objects from the scene; connected to Clear View from menu
    @IBAction func clearView() {
        // prompt user to confirm they want to clear view
        let alertPrompt = UIAlertController(title: "Clear View", message: "Are you sure you want to remove all objects from current view?", preferredStyle: .alert)

        // add yes and no options
        alertPrompt.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            return
        }))
        alertPrompt.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default Action"), style: .default, handler: { _ in
                let newScene = SCNScene(named: "art.scnassets/newscene.scn")!
                self.sceneView.scene = newScene
        }))

        // display prompt
        self.present(alertPrompt, animated: true, completion: nil)
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
