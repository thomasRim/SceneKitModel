//
//  OGModelLoadView.swift
//  Alignment
//
//  Created by Vladimir Yevdokimov on 19.01.2020.
//  Copyright © 2020 Orthogenic. All rights reserved.
//

import UIKit
import SceneKit

class OGModelLoadView: Model3dView {
    var enableTouchMarks = false
    var didAddNodeOnTouch: ((SCNNode)->())?

    override func initScene(_ ready:(()->())? = nil ) {

        super.initScene(ready)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapModel(WithSender:)))
        self.addGestureRecognizer(gesture)
        
        sceneView?.debugOptions = [.showCreases, .showBoundingBoxes]
    }


    @IBAction func tapModel(WithSender sender: UITapGestureRecognizer) {
        guard enableTouchMarks else { return }
        let location = sender.location(in: sceneView)
        let hitResults = sceneView?.hitTest(location, options: nil)
        for res in hitResults ?? [] {
            
            let sphere = SCNSphere(radius: CGFloat(scene.rootNode.boundingSphere.radius/20.0))
            sphere.firstMaterial?.diffuse.contents = UIColor.red
            let point = SCNNode(geometry: sphere)
            point.position = SCNVector3(res.localCoordinates.x,
                                        res.localCoordinates.y,
                                        res.localCoordinates.z)
            self.present(node: point, in: sceneView?.scene?.rootNode.childNodes.first(where: {$0.camera == nil}), only: false)
            self.didAddNodeOnTouch?(point)
        }
    }

}
