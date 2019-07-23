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

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    var center : CGPoint!
//    var dice = SCNNode()
//    var audioSource = SCNAudioSource()
    var isFirstPoint = true
    var points = [SCNNode]()
    
    var selectedObject : AudioARItem?
    
    // Refactor this so you can add the second object and third object
    // idea: Pass in objects as an array with audio files as an object
    
    



    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        center = view.center

		sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showLightExtents]
		sceneView.showsStatistics = true

		sceneView.autoenablesDefaultLighting = true
    }
    
    enum WorldObjects: String {
        case dice = "dice"
        case speaker = "speaker"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)


//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//        if let diceNode = diceScene.rootNode.childNode(withName: WorldObjects.dice.rawValue, recursively: true) {
//            //            diceNode.position = SCNVector3(
//            //                x: hitResult.worldTransform.columns.3.x,
//            //                y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
//            //                z: hitResult.worldTransform.columns.3.z
//            //            )
//            diceNode.position = SCNVector3(
//                x: 10,
//                y: 0,
//                z: 0
//            )
//            sceneView.scene.rootNode.addChildNode(diceNode)
//            let audioSource = SCNAudioSource(fileNamed: "majorlazermono.mp3")!
//            audioSource.loops = true
//            audioSource.isPositional = true
//            diceNode.addAudioPlayer(SCNAudioPlayer(source: audioSource))
//        }
//
//        let spScene1 = SCNScene(named: "art.scnassets/cubeScene.scn")!
//        if let nd_speaker = spScene1.rootNode.childNode(withName: WorldObjects.speaker.rawValue, recursively: true) {
////        let spScene = SCNScene(named: "art.scnassets/Speaker.scn")!
////        if let nd_speaker = spScene.rootNode.childNode(withName: "SPEAKER", recursively: true) {
//            //            print("Z = ", hitResult, hitResult.worldTransform.columns.3.z)
//            //            nd_speaker.position = SCNVector3(
//            //                x: hitResult.worldTransform.columns.3.x,
//            //                y: hitResult.worldTransform.columns.3.y,
//            //                z: hitResult.worldTransform.columns.3.z - 5
//            //            )
//
//            nd_speaker.position = SCNVector3(
//                x: 0,
//                y: 0,
//                z: 0
//            )
//
//            sceneView.scene.rootNode.addChildNode(nd_speaker)
//            let audioSource = SCNAudioSource(fileNamed: "Sine Chirp mono.wav")!
//            audioSource.loops = true
//            audioSource.isPositional = true
//            nd_speaker.addAudioPlayer(SCNAudioPlayer(source: audioSource))
//        }

//        let spScene2 = SCNScene(named: "art.scnassets/cubeScene.scn")!
//        if let nd_speaker2 = spScene2.rootNode.childNode(withName: "speaker", recursively: true) {
//            nd_speaker2.position = SCNVector3(
//                x: 0,
//                y: 0,
//                z: 6
//            )
//
//            sceneView.scene.rootNode.addChildNode(nd_speaker2)
//            let audioSource = SCNAudioSource(fileNamed: "White Noise mono.wav")!
//            audioSource.loops = true
//            audioSource.isPositional = true
//            nd_speaker2.addAudioPlayer(SCNAudioPlayer(source: audioSource))
//        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        center = view.center // This will keep the center of the object where it needs to be
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = results.first {
                guard let node = selectedObject?.node else { return }
                node.position = SCNVector3(
                    x: hitResult.worldTransform.columns.3.x,
                    y: hitResult.worldTransform.columns.3.y + node.boundingSphere.radius,
                    z: hitResult.worldTransform.columns.3.z
                )
                if selectedObject?.audioSource != nil {
                    node.addAudioPlayer(SCNAudioPlayer(source: selectedObject!.audioSource))
                }
                sceneView.scene.rootNode.addChildNode(node)
                
//                let randomX = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
//                let randomZ = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
//                node.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5))
            }
        }
    }

    /* Create Outlet collection array of the item buttons */
    @IBOutlet var itemButtons: [ItemButton]!
    
    /* Transmit the info of the selected item to the selectedObject holder */
    @IBAction func itemSelected(_ sender: Any) {
        if let button = sender as? ItemButton {
            for itemButton in itemButtons {
                if itemButton == button {
                    itemButton.alpha = 1.0
                    selectedObject = itemButton.arItem
                } else {
                    itemButton.alpha = 0.4
                }
            }
        }
    }
    
}

struct AudioARItem {
    var name: String
    var audioSource: SCNAudioSource
    var node: SCNNode
}

class ItemButton: UIButton {
    var arItem: AudioARItem
    
    /* All the Inspectable variable can be edited directly from the Storyboard editor */
    @IBInspectable var audioFileName: String? {
        didSet {
            if let source = SCNAudioSource(fileNamed: audioFileName ?? "WhiteNoiseMono.wav") {
                arItem.audioSource = source
            }
        }
    }
    @IBInspectable var objectSceneName: String? {
        didSet { setupScene() }
    }
    @IBInspectable var objectNodeName: String? {
        didSet {
            setupScene()
            arItem.name = objectNodeName ?? ""
        }
    }
    
    @IBInspectable var audioLoops: Bool = false {
        didSet { arItem.audioSource.loops = audioLoops }
    }
    
    @IBInspectable var audioPositional: Bool = false {
        didSet { arItem.audioSource.isPositional = audioPositional }
    }
    
    private func setupScene() {
        if let nodeName = objectNodeName, let sceneName = objectSceneName {
            if let scene = SCNScene(named: "art.scnassets/" + sceneName + ".scn"),
                let node = scene.rootNode.childNode(withName: nodeName, recursively: true)
            {
                arItem.node = node
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        arItem = AudioARItem(name: "",audioSource: SCNAudioSource(), node: SCNNode())
        super.init(coder: aDecoder)
    }
}

extension ViewController: ARSCNViewDelegate {

	/**
	Implement this to provide a custom node for the given anchor.

	@discussion This node will automatically be added to the scene graph.
	If this method is not implemented, a node will be automatically created.
	If nil is returned the anchor will be ignored.
	@param renderer The renderer that will render the scene.
	@param anchor The added anchor.
	@return Node that will be mapped to the anchor or nil.
	*/
	/*func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

	}*/


	/**
	Called when a new node has been mapped to the given anchor.

	@param renderer The renderer that will render the scene.
	@param node The node that maps to the anchor.
	@param anchor The added anchor.
	*/
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		DispatchQueue.main.async {
			//self.infoLabel.text = "Surface Detected."
		}



	}


	/**
	Called when a node will be updated with data from the given anchor.

	@param renderer The renderer that will render the scene.
	@param node The node that will be updated.
	@param anchor The anchor that was updated.
	*/
	func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {

	}


	/**
	Called when a node has been updated with data from the given anchor.

	@param renderer The renderer that will render the scene.
	@param node The node that was updated.
	@param anchor The anchor that was updated.
	*/
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

	}


	/**
	Called when a mapped node has been removed from the scene graph for the given anchor.

	@param renderer The renderer that will render the scene.
	@param node The node that was removed.
	@param anchor The anchor that was removed.
	*/
	func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {

	}}
