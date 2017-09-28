//
//  SpaceObjects.swift
//  KrogerAR
//
//  Created by Saint-Juste, Henry on 9/26/17.
//

import Foundation
import UIKit
import ARKit

protocol SolarObject {
    var name: String {get set}
    var description: String {get set}
    var imageName: String {get set}
}

struct SpaceObject: SolarObject {
    var name: String
    var description: String
    var imageName: String
}

struct Planet: SolarObject {
    var name: String
    var description: String
    var imageName: String
}

extension SolarObject {
    func image() -> UIImage? {
        return UIImage(named: "SolarSystem.scnassets/\(imageName)")
    }
    
    func node() -> SCNNode? {
        return SCNScene(named: "SolarSystem.scnassets/SolarSystem.scn")?.rootNode.childNode(withName: name, recursively: true)
    }
    
    func scene() -> SCNScene? {
        return SCNScene(named: "SolarSystem.scnassets/SolarSystem.scn")
    }
}
