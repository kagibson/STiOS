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
let scene = SCNScene(named:"art.scnassets/FullBodyV2.dae")!

class GameViewController: UIViewController, SkeletonDelegate{

    override func viewDidLoad()
    {
        if let tbs = self.tabBarController as? SessionTabBarController
        {
            print("setting delegate here")
            tbs.userSkeleton.skeletonDelegate = self
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
        
        // retrieve arm node
//        let foreArm = scene.rootNode.childNode(withName: "foreArm_Right", recursively: true)!
//        
//        // animate the 3d object
//        foreArm.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
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
//        let leftForeArm: BodyJoint = sensorData["leftForearm"]!
//        var leftBicep: BodyJoint = sensorData["leftBicep"]!
        
        // Uncomment these:
//        let rightForeArm: BodyJoint = sensorData["rightForearm"]!
//        let rightBicep: BodyJoint = sensorData["rightBicep"]!
        
//        print("LeftForeArm:")
//        print(rightForeArm.orientation.w_)
//        print(rightForeArm.orientation.x_)
//        print(rightForeArm.orientation.y_)
//        print(rightForeArm.orientation.z_)
        
//        let RightForeArm = scene.rootNode.childNode(withName: "foreArm_Right", recursively: true)!
//        RightForeArm.orientation = SCNVector4(x:rightForeArm.orientation.x_, y:rightForeArm.orientation.y_, z:rightForeArm.orientation.z_, w:rightForeArm.orientation.w_)
//        
//        let RightBicep = scene.rootNode.childNode(withName:"upperArm_Right", recursively: true)!
//        RightBicep.orientation = SCNVector4(x:rightBicep.orientation.x_, y:rightBicep.orientation.y_, z:rightBicep.orientation.z_, w:rightBicep.orientation.w_)
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
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
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
