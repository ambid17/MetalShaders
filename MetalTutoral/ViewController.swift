//
//  ViewController.swift
//  MetalTutoral
//
//  Created by developer on 10/22/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let metalView = view as? MTKView else {
            fatalError("metal view not set up in story board")
        }
        
        renderer = Renderer(metalView: metalView)
    }

}
