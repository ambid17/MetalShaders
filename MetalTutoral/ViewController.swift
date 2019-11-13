//
//  ViewController.swift
//  MetalTutoral
//
//  Created by developer on 10/22/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import MetalKit
import SwiftUIKit


class MetalView: MTKView {
    private var renderer: Renderer
    
    init(renderer: Renderer) {
        self.renderer = renderer
        
        super.init(frame: .zero, device: renderer.device)
        
        self.renderer.load(metalView: self)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navigate.shared.configure(controller: navigationController)
        
        view.embed {
            ScrollView {
            VStack(withSpacing: 5, padding: 0, alignment: .fill, distribution: .fillProportionally) {
                     [
                        Button("Triangle", titleColor: .systemBlue, backgroundColor: .systemGray) {
                            Navigate.shared.go(UIViewController {
                                View {
                                    MetalView(renderer: TriangleRenderer())
                                }
                            }, style: .push)
                        },
                        Button("Cube", titleColor: .systemBlue, backgroundColor: .systemGray) {
                            Navigate.shared.go(UIViewController {
                                View {
                                    MetalView(renderer: MeshRenderer())
                                }
                            }, style: .push)
                        },
                        Button("Triangle3", titleColor: .systemBlue, backgroundColor: .systemGray) {
                            print("tri tapped3")
                        }
                    ]
            }
            .frame(height: 1000, width: Float(self.view.bounds.width))
            }
        }
        
                
        
                
    }
    
}
