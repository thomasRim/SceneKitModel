//
//  Model3dView.swift
//  Scanner
//
//  Created by Vladimir Evdokimov on 2019-03-13.
//  Copyright © 2019 Orthogenic Laboratories. All rights reserved.
//

import Foundation
import SceneKit

class Model3dView: UIView {
    var sceneView: SCNView?
    var scene: SCNScene = SCNScene()
    var camera: SCNNode?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initScene()
    }
    
    //MARK: - Public

    func present(node:SCNNode?, in rootNode:SCNNode? = nil, scale:Int = 1, only: Bool = true) {
        
        let produce = { [weak self] in
            if only {
                self?.scene.rootNode.childNodes.forEach({ if $0.camera == nil { $0.removeFromParentNode() } })
            }
            
            let rootNode = (rootNode != nil) ? rootNode : self?.scene.rootNode

            if let node = node {
                node.scale = SCNVector3(scale, scale, scale)
                rootNode?.addChildNode(node)
            }
            
            if self?.camera == nil {
                self?.addCamera()
            }
            
            let boxRadius: CGFloat = CGFloat(self?.scene.rootNode.boundingSphere.radius ?? 0)
            let ang: CGFloat = (self?.camera?.camera?.fieldOfView ?? 0)
            let dist = (boxRadius/2) * cos(ang) / sin(ang)
            
            self?.camera?.position = SCNVector3(0, 0, dist)
            self?.sceneView?.defaultCameraController.pointOfView?.rotation = SCNVector4(0, 0, 0, 1)
        }
        
        if self.scene.rootNode == nil {
            initScene {
                produce()
            }
            return
        }
        produce()
    }
    
    func clear() {
        scene.rootNode.childNodes.forEach({ $0.removeFromParentNode() })
        camera = nil
    }

    //MARK: - Private


    func initScene(_ ready:(()->())? = nil ) {
        self.clipsToBounds = true
        sceneView = SCNView(frame: self.frame)
        sceneView?.allowsCameraControl = true
        sceneView?.autoenablesDefaultLighting = true
        sceneView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let view = sceneView {
            view.backgroundColor = .clear
            self.addSubview(view)
        }
        sceneView?.showsStatistics = true
        
        sceneView?.gestureRecognizers?.forEach({
            if $0.isKind(of: UIPanGestureRecognizer.self) {
                sceneView?.gestureRecognizers = [$0]
                return
            }
        })
        
        sceneView?.prepare([scene as Any], completionHandler: {[weak self] (success) in
            guard success else {return}
            guard let weak = self else {return}
            
            weak.sceneView?.scene = weak.scene
        
            weak.scene.rootNode.childNodes.forEach({$0.removeFromParentNode()})
            
            ready?()
        })
    }
    
    private func addCamera() {
        camera = sceneView?.defaultCameraController.pointOfView
        
        camera = SCNNode()
        camera?.camera = SCNCamera()
        if let camera = camera {
            scene.rootNode.addChildNode(camera)
        }
        camera?.position = SCNVector3Make(0, 0, 0.1)
    }
}
