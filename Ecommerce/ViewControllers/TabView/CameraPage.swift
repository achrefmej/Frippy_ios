//
//  CameraPage.swift
//  Autos
//
//  Created by iMac on 7/5/2023.
//

import SwiftUI
import AVKit

struct CameraPage: UIViewRepresentable {
 
    
    var frameSize: CGSize
    @Binding var session : AVCaptureSession
    func makeUIView(context: Context) -> UIView {
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = .init(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.masksToBounds=true
        view.layer.addSublayer(cameraLayer)
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
   
}

