//
//  Renderer.swift
//  MetalTutoral
//
//  Created by developer on 10/22/19.
//  Copyright © 2019 developer. All rights reserved.
//

import MetalKit
class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    var mesh: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    
    var timer: Float = 0
    var alpha: Float = 1
    
    init(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        metalView.device = device
        
        let mdlMesh = Primitive.makeLine(device: device, size: 1)
        do{
            mesh = try MTKMesh(mesh: mdlMesh, device: device)
        } catch let error {
            print(error.localizedDescription)
        }
        
        vertexBuffer = mesh.vertexBuffers[0].buffer
        
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
        super.init()

        metalView.clearColor = MTLClearColor(red: 1, green: 1, blue: 0.8, alpha: 1)
        metalView.delegate = self
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let descriptor = view.currentRenderPassDescriptor,
            let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
        
        //drawing code goes here
//        timer += 0.05
//        var currentTime = sin(timer)
//        var al = abs(currentTime)
//        renderEncoder.setVertexBytes(&currentTime,
//                                     length: MemoryLayout<Float>.stride,
//                                     index: 1)
//        renderEncoder.setFragmentBytes(&al, length: MemoryLayout<Float>.stride, index: 0)
        
        
        
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        for submesh in mesh.submeshes {
            renderEncoder.drawIndexedPrimitives(type: .point,
                                                indexCount: submesh.indexCount,
                                                indexType: submesh.indexType,
                                                indexBuffer: submesh.indexBuffer.buffer,
                                                indexBufferOffset: submesh.indexBuffer.offset)
            
        }
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        
        //Present and commit the drawable texture to the GPU
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
