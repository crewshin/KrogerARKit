//
//  SolarSystemController.swift
//  KrogerAR
//
//  Created by Saint-Juste, Henry on 9/26/17.

import UIKit
import ARKit

class SolarSystemController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UIPopoverPresentationControllerDelegate, PlanetSelectionControllerDelegate {
    //------------------------
    // MARK: - View Properties
    //------------------------
    @IBOutlet private weak var sceneView: ARSCNView!
    @IBOutlet private weak var descriptionContainer: UIVisualEffectView!
    @IBOutlet private weak var earthImageViewContainer: UIVisualEffectView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    //------------------------
    // MARK: - Properties
    //------------------------
    private var solarScene: SCNScene!
    
    //------------------------
    // MARK: - Initilization
    //------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         // Prevent the screen from being dimmed after a while as users will likely have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // TODO: - Explain DebugOptions
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.showsStatistics = true
        
        /// Start the view's ARSession with a configuration that uses the rear-facing camera, tracks a device's orientation and position, and detects real-world flat surfaces.
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [ARSession.RunOptions.resetTracking, ARSession.RunOptions.removeExistingAnchors])
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        solarScene = SCNScene(named: "SolarSystem.scnassets/SolarSystem.scn")
        sceneView.scene = solarScene
    }
    
    //------------------------
    // MARK: - UIControl
    //------------------------
    @IBAction func planetAction(_ sender: UITapGestureRecognizer) {
        if descriptionLabel.text!.isEmpty {
            if let sourceView = sender.view {
                let planetSelectionController = PlanetSelectionController(size: CGSize(width: 280, height: 320))
                planetSelectionController.delegate = self
                planetSelectionController.modalPresentationStyle = .popover
                planetSelectionController.popoverPresentationController?.sourceView = sourceView
                planetSelectionController.popoverPresentationController?.sourceRect = sourceView.bounds
                planetSelectionController.popoverPresentationController?.delegate = self
                present(planetSelectionController, animated: true, completion: { /* can do something in here */ })
            }
        } else {
            print("Notify user that they the AR session is being initiliaze.")
        }
    }
    
    //------------------------
    // MARK: - Helpers
    //------------------------
    /// Called to setup the view objects.
    private func setupContainers() {
        descriptionContainer.layer.masksToBounds = true
        descriptionContainer.layer.cornerRadius = 5.5
        
        earthImageViewContainer.layer.masksToBounds = true
        earthImageViewContainer.layer.cornerRadius = 5.5
    }
    
    /// Called to reset the view's ARSession with a configuration object. (ARWorldTrackingConfiguration)
    private func resetTracking() {
        /// Reset the view's ARSession with a configuration that uses the rear-facing camera, tracks a device's orientation and position, and detects real-world flat surfaces.
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [ARSession.RunOptions.resetTracking, ARSession.RunOptions.removeExistingAnchors])
    }
    
    private func updateDescriptionLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        switch trackingState {
        case .notAvailable:
            message = "Unable to track AR session state."
        case .limited(.initializing):
            message = "Initializing AR session."
        default:
            message = ""
        }
        
        descriptionLabel.text = message
        descriptionContainer.isHidden = message.isEmpty
    }
    
    //------------------------
    // MARK: - ARSCNViewDelegate
    //------------------------
    
    //------------------------
    // MARK: - ARSessionDelegate
    //------------------------
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        // get the most recently captured video frame image
        guard let frame = session.currentFrame else { return }
        updateDescriptionLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        // get the most recently captured video frame image
        guard let frame = session.currentFrame else { return }
        updateDescriptionLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateDescriptionLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    //------------------------
    // MARK: - UIPopoverPresentationControllerDelegate
    //------------------------
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    //------------------------
    // MARK: - PlanetSelectionControllerDelegate
    //------------------------
    func PlanetSelectionControllerDidSelect(solarObject: SolarObject) {
        if let node = solarObject.scene() {
            // get point of view
            guard let pointOfView = self.sceneView.pointOfView else { return }
            // get phone orientation
            let orientation = SCNVector3(-pointOfView.transform.m31, -pointOfView.transform.m32, -pointOfView.transform.m33)
            // get location relative to 3D space / real world
            //let location = SCNVector3(pointOfView.transform.m41, pointOfView.transform.m42, pointOfView.transform.m43)
            let location = SCNVector3(pointOfView.transform.m41, pointOfView.transform.m42, -2.5)
            // combine both orientation and location to get the currentLocation of the camera
            let currentPositionOfCamera = orientation + location
            //node.position = currentPositionOfCamera
            // add the node to the scene
            //self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
}

public func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}
