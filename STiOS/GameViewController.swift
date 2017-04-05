//
//  GameViewController.swift
//  STiOS
//
//  Created by Kristian Torres on 2016-12-08.
//  Copyright © 2016 ECE 4600 G09. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import ExerciseMotionTracker

// create a new scene
//let scene = SCNScene(named: "art.scnassets/RightArm.dae")!
let scene = SCNScene(named:"art.scnassets/fullHumanV2.dae")!

// Arms
let RightBicep = scene.rootNode.childNode(withName:"upperArm.R", recursively: true)!
let RightForeArm = scene.rootNode.childNode(withName: "foreArm.R", recursively: true)!
let LeftBicep = scene.rootNode.childNode(withName:"upperArm.L", recursively: true)!
let LeftForeArm = scene.rootNode.childNode(withName:"foreArm.L", recursively: true)!

// Legs
//let RightUpperLeg = scene.rootNode.childNode(withName:"upperLeg.R", recursively: true)!
//let RightLowerLeg = scene.rootNode.childNode(withName:"lowerLeg.R", recursively: true)!
//let LeftUpperLeg = scene.rootNode.childNode(withName:"upperLeg.L", recursively: true)!
//let LeftLowerLeg = scene.rootNode.childNode(withName:"lowerLeg.L", recursively: true)!
//
//// Spine
////let root = scene.rootNode.childNode(withName: "root", recursively: true)!
//let lowerSpine = scene.rootNode.childNode(withName:"lowerSpine", recursively: true)!
//let upperSpine = scene.rootNode.childNode(withName: "upperSpine", recursively: true)!
//let neck = scene.rootNode.childNode(withName:"neck", recursively: true)!
//let head = scene.rootNode.childNode(withName: "head", recursively: true)!

let init_x = LeftBicep.position.x
let init_y = LeftBicep.position.y
let init_z = LeftBicep.position.z

let init_x_1 = LeftForeArm.position.x
let init_y_1 = LeftForeArm.position.y
let init_z_1 = LeftForeArm.position.z


class GameViewController: UIViewController, SkeletonDelegate{

    override func viewDidLoad()
    {
        if let tbs = self.tabBarController as? SessionTabBarController
        {
            print("setting delegate here")
            tbs.userSkeleton.skeletonDelegate = self
            
            // "Initial Position" of the model is set up here:
            
//            RightBicep.orientation = SCNVector4(x:0, y:0, z:0, w:1)
//            RightForeArm.orientation = SCNVector4(x:0, y:0, z:0, w:1)
//            LeftBicep.orientation = SCNVector4(x:0, y:0, z:0, w:1)
//            LeftForeArm.orientation = SCNVector4(x:0, y:0, z:0, w:1)
            
//            RightUpperLeg.orientation = SCNVector4(x:1, y:1, z:1, w:0)
//            RightLowerLeg.orientation = SCNVector4(x:1, y:1, z:1, w:0)
//            LeftUpperLeg.orientation = SCNVector4(x:1, y:1, z:1, w:0)
//            LeftLowerLeg.orientation = SCNVector4(x:1, y:1, z:1, w:0)
            
//            head.orientation = SCNVector4(x:0, y:0, z:0, w:1)
//            neck.orientation = SCNVector4(x:0, y:0, z:0, w:1)
//            upperSpine.orientation = SCNVector4(x:0, y:0, z:0, w:1)
//            lowerSpine.orientation = SCNVector4(x:0, y:0, z:0, w:1)
            //root.orientation = SCNVector4(x:0, y:0, z:0, w:0)
        }
        
        super.viewDidLoad()
        
        // create a new scene
        //let scene = SCNScene(named: "art.scnassets/RightArm.dae")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    public func updateBodyJoints(sensorData: [String : BodyJoint])
    {
        let rightForearm: BodyJoint = sensorData["rightForearm"]!
        let rightBicep: BodyJoint = sensorData["rightBicep"]!
        let leftForearm: BodyJoint = sensorData["leftForearm"]!
        let leftBicep: BodyJoint = sensorData["leftBicep"]!
        
        // Working!!!!!!!!!!!!!!!
        
        RightBicep.orientation = SCNVector4(x:-rightBicep.orientation.x_, y:rightBicep.orientation.y_, z:rightBicep.orientation.z_, w:rightBicep.orientation.w_)
        
        LeftBicep.orientation = SCNVector4(x:-leftBicep.orientation.x_, y:leftBicep.orientation.y_, z:leftBicep.orientation.z_, w:leftBicep.orientation.w_)
        
        RightForeArm.orientation = SCNVector4(x:-rightForearm.orientation.x_, y:rightForearm.orientation.y_, z:rightForearm.orientation.z_, w:rightForearm.orientation.w_)
        
        LeftForeArm.orientation = SCNVector4(x:-leftForearm.orientation.x_, y:leftForearm.orientation.y_, z:leftForearm.orientation.z_, w:leftForearm.orientation.w_)
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        RightBicep.orientation = SCNVector4(x:0, y:0, z:0, w:1)
        RightForeArm.orientation = SCNVector4(x:0, y:0, z:0, w:1)
        LeftBicep.orientation = SCNVector4(x:0, y:0, z:0, w:0.1)
        LeftForeArm.orientation = SCNVector4(x:0, y:0, z:0, w:1)
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
