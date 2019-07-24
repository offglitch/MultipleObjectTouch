//
//  ViewController.swift
//  MultipleObjectTouch
//
//  Created by Majid Alturki on 7/12/19.
//  Copyright © 2019 Majid Alturki. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var center : CGPoint!
    //    var dice = SCNNode()
    //    var audioSource = SCNAudioSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        center = view.center
        //        let scene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        // load dice
        //        dice = scene.rootNode.childNode(withName: "ardrone", recursively: true)!
        
        // Load audioSource
        //        audioSource = SCNAudioSource(fileNamed: "art.scnassets/diceSound.m4a")!
        //        audioSource.loops = true
        //        audioSource.isPositional = true
        //        audioSource.shouldStream = false
        //        audioSource.load()
        //        sceneView.scene = scene
        //        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        //        configuration.planeDetection = [.horizontal, .vertical]
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        dice.removeAllAudioPlayers()
    //        dice.addAudioPlayer(SCNAudioPlayer(source: audioSource))
    //    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        center = view.center // This will keep the center of the object where it needs to be
    }
    
    
    var isFirstPoint = true
    var points = [SCNNode]()
    
    
    // Refactor this so you can add the second object and third object
    // idea: Pass in objects as an array with audio files as an object
    enum WorldObjects : String {
        case dice = "dice"
        case speaker = "speaker"
    }
    
    var selectObject : WorldObjects = .dice
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = results.first {
                switch selectObject {
                case .dice:
                    // Create a new scene
                    let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                    if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                        diceNode.position = SCNVector3(
                            x: hitResult.worldTransform.columns.3.x,
                            y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                            z: hitResult.worldTransform.columns.3.z
                        )
                        
                        sceneView.scene.rootNode.addChildNode(diceNode)
                        
                        let audioSource = SCNAudioSource(fileNamed: "songdemo.mp3")!
                        audioSource.loops = true
                        audioSource.isPositional = true
                        audioSource.shouldStream = false
                        audioSource.load()
                        diceNode.addAudioPlayer(SCNAudioPlayer(source: audioSource))
                    }
                    break
                case .speaker:
                    //let spScene = SCNScene(named: "art.scnassets/cubeScene.scn")!
                    let spScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                    if let nd_speaker = spScene.rootNode.childNode(withName: "cloud", recursively: true) {
                        nd_speaker.position = SCNVector3(
                            x: hitResult.worldTransform.columns.3.x,
                            y: hitResult.worldTransform.columns.3.y + nd_speaker.boundingSphere.radius,
                            z: hitResult.worldTransform.columns.3.z
                        )
                        //nd_speaker.scale = SCNVector3(0.3, 0.3, 0.3)
                        
                        sceneView.scene.rootNode.addChildNode(nd_speaker)
                        
                        let audioSource = SCNAudioSource(fileNamed: "weatheraudiohit.mp3")!
                        audioSource.loops = true
                        audioSource.isPositional = true
                        audioSource.shouldStream = false
                        audioSource.load()
                        nd_speaker.addAudioPlayer(SCNAudioPlayer(source: audioSource))
                    }
                    break
                }
            }
        }
    }
    
    
    
    @IBAction func diceTouched(_ sender: Any) {
        selectObject = .dice
    }
    
    
    @IBAction func speakerTouched(_ sender: Any) {
        selectObject = .speaker
    }
}
