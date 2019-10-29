//
//  Primitive.swift
//  MetalTutoral
//
//  Created by developer on 10/22/19.
//  Copyright © 2019 developer. All rights reserved.
//

import MetalKit

class Primitive {
    static func makeCube(device: MTLDevice, size: Float) -> MDLMesh {
        let allocator = MTKMeshBufferAllocator(device: device)
        let mesh = MDLMesh(boxWithExtent: [size, size, size],
                           segments: [1,1,1],
                           inwardNormals: false,
                           geometryType: .triangles,
                           allocator: allocator)
        return mesh
    }
    
    static func makeLine(device: MTLDevice, size: Float) -> MDLMesh {
        let allocator = MTKMeshBufferAllocator(device: device)
        
        //create vertex buffer
        let vertices: [Vertex] = [Vertex(x: 0, y: 0), Vertex(x: 1, y: 0)]
        let vertexBuffer = allocator.newBuffer(MemoryLayout<Vertex>.stride * vertices.count, type: .vertex)
        let vertexMap = vertexBuffer.map()
        vertexMap.bytes.assumingMemoryBound(to: Vertex.self).assign(from: vertices, count: vertices.count)
        
        //create index buffer
        let indices: [UInt16] = [UInt16(0), UInt16(1)]
        let indexBuffer = allocator.newBuffer(MemoryLayout<UInt16>.stride * indices.count, type: .index)
        let indexMap = indexBuffer.map()
        indexMap.bytes.assumingMemoryBound(to: UInt16.self).assign(from: indices, count: indices.count)

        let submesh = MDLSubmesh(indexBuffer: indexBuffer,
                                    indexCount: indices.count,
                                    indexType: .uInt16,
                                    geometryType: .points,
                                    material: nil)
        
        
        let vertexDescriptor = MDLVertexDescriptor()
        vertexDescriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition,
                                                            format: .float2,
                                                            offset: 0,
                                                            bufferIndex: 0)
        let mesh = MDLMesh(vertexBuffer: vertexBuffer,
                              vertexCount: vertices.count,
                              descriptor: vertexDescriptor,
                              submeshes: [submesh])

        
        return mesh
    }
}
