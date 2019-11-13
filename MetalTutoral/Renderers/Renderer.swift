//
//  Renderer.swift
//  MetalTutoral
//
//  Created by developer on 10/22/19.
//  Copyright © 2019 developer. All rights reserved.
//

import MetalKit

class MetalDevice {
    static var shared: MetalDevice = MetalDevice()
    
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    
    init() {
        guard let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        self.device = device
        self.commandQueue = commandQueue
    }
}

protocol Renderer {
    var device: MTLDevice { get }
    var commandQueue: MTLCommandQueue { get }
    var mesh: MTKMesh? { get set }
    var vertexBuffer: MTLBuffer? { get set }
    var pipelineState: MTLRenderPipelineState? { get set }
    
    var vertexShaderName: String { get }
    var fragmentShaderName: String { get }
    
    func getMesh() -> MDLMesh
    func load(metalView: MTKView)
}

extension Renderer {
    var device: MTLDevice {
        return MetalDevice.shared.device
    }
    
    var commandQueue: MTLCommandQueue {
        return MetalDevice.shared.commandQueue
    }
}
