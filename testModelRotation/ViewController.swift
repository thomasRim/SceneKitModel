//
//  ViewController.swift
//  testModelRotation
//
//  Created by V.Yevdokymov on 2020-01-21.
//  Copyright © 2020 V.Yevdokymov. All rights reserved.
//

import UIKit
import SceneKit
class ViewController: UIViewController {

    @IBOutlet weak private var modelView: OGModelLoadView?

    var modelNode: SCNNode?
    var pointNode: SCNNode?

    let step: Float = (Float.pi/180)*2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadModel()
    }

    @IBAction fileprivate func reloadModel(WithSender sender: AnyObject?) {
        print("\(self) - \(#function)")
        modelView?.clear()
        
        loadModel()
    }
    
    @IBAction fileprivate func rotateLeft(WithSender sender: AnyObject?) {
        print("\(self) - \(#function)")
        if let node = modelNode {
            let axis = simd_float3(0,1,0)
            let rotation = simd_quaternion(-step, axis)
            node.simdOrientation = rotation * node.simdOrientation
        }
        wLog()
    }
    
    @IBAction fileprivate func rotateRight(WithSender sender: AnyObject?) {
        print("\(self) - \(#function)")
        if let node = modelNode {
            let axis = simd_float3(0,1,0)
            let rotation = simd_quaternion(step, axis)
            node.simdOrientation = rotation * node.simdOrientation
        }
        wLog()
    }
    
    @IBAction fileprivate func rF(WithSender sender: AnyObject?) {
        print("\(self) - \(#function)")
        if let node = modelNode {
            let axis = simd_float3(0,0,1)
            let rotation = simd_quaternion(step, axis)
            node.simdOrientation = rotation * node.simdOrientation
        }
        wLog()
    }
    
    @IBAction fileprivate func fF(WithSender sender: AnyObject?) {
        print("\(self) - \(#function)")
        if let node = modelNode {
            let axis = simd_float3(0,0,1)
            let rotation = simd_quaternion(-step, axis)
            node.simdOrientation = rotation * node.simdOrientation
        }
        wLog()
    }

    
    private func loadModel() {
        modelView?.enableTouchMarks = true
        
        if let node = SCNNode.loadModel(named: "Model.obj") {
            modelNode = node
            node.geometry?.materials.first?.isDoubleSided = true
            modelView?.present(node: node)
            wLog()
            
            modelView?.didAddNodeOnTouch = { [weak self] node in
                self?.modelView?.enableTouchMarks = false
                self?.pointNode = node
                let pos = node.position
                self?.modelNode?.pivot = SCNMatrix4MakeTranslation(pos.x, pos.y, pos.z)
                self?.wLog()
            }
        }
    }
    
    private func wLog() {
        print("model wTr: \(modelNode!.worldTransform)")
        print("model wOr: \(modelNode!.worldOrientation)")
        print("model wPo: \(modelNode!.worldPosition)")
    }
}

