//
//  SCNode+load.swift
//  Alignment
//
//  Created by Vladimir Yevdokimov on 16.01.2020.
//  Copyright © 2020 Orthogenic. All rights reserved.
//

import SceneKit
import ModelIO
import SceneKit.ModelIO

extension SCNNode {

    static func loadModel(url: URL?) -> SCNNode? {
        if let url = url,
            let object: MDLMesh = MDLAsset(url: url).object(at: 0) as? MDLMesh {
            let node = SCNNode(mdlObject: object)
            return node
        }
        return nil
    }

    static func loadModel(named: String?) -> SCNNode? {
        if let url = Bundle.main.url(forResource: named, withExtension: ""),
            let object: MDLMesh = MDLAsset(url: url).object(at: 0) as? MDLMesh {
            let node = SCNNode(mdlObject: object)
            node.name = named
            return node
        }
        return nil
    }

    static func loadTexture(named: String?, to node:SCNNode?, roughness: String? = nil, bump:String? = nil) {
        node?.childNodes.forEach({$0.removeFromParentNode()})

        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: named ?? "")
        if let r = roughness, r.count > 0 { material.roughness.contents = UIImage(named: r)}
        if let b = bump, b.count > 0 { material.roughness.contents = UIImage(named: b)}
        let geo = node?.geometry
        geo?.materials = [material]
        let g_node = SCNNode(geometry: geo)
        node?.addChildNode(g_node)
    }
}
