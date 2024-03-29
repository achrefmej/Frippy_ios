//
//  QRScannerDelegate.swift
//  Frippy_finall
//
//  Created by Mac Mini 6 on 9/5/2023.
//

import SwiftUI
import AVKit
class QRScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate{
    @Published var ScannedCode: String?
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return}
            guard let Code = readableObject.stringValue else { return }
            print(Code)
            ScannedCode = Code
        }
    }
}

