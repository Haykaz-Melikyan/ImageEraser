//
//  EraseImageView.swift
//
//
//  Created by Haykaz Melikyan
//  Copyright © Haykaz. All rights reserved.
//

import Foundation
import UIKit

class EraseImageView: UIView {
    public var backgroundImage: UIImage?
    private var context: CGContext!
    private var contextBounds = CGRect.zero
    private var foregroundImage: UIImage?
    private var touchWidth: CGFloat = 0.0
    private var touchRevealsImage = false
    
    private func createBitmapContext() {
        let grayscale = CGColorSpaceCreateDeviceGray()
        contextBounds = bounds
        context = CGContext(data: nil, width: size_t(contextBounds.size.width), height: size_t(contextBounds.size.height), bitsPerComponent: 8, bytesPerRow: size_t(contextBounds.size.width), space: grayscale, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        let white = UIColor.white.cgColor
        context?.setFillColor(white)
        
        context?.fill(contextBounds)
        context.setLineCap(CGLineCap.round)
        context.setLineJoin(CGLineJoin.round)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let points = [touch?.previousLocation(in: self), touch?.location(in: self)].compactMap { $0 }
        context.setLineWidth(touchWidth)
        
        let color = touchRevealsImage ? UIColor.white.cgColor : UIColor.black.cgColor
        context.setStrokeColor(color)
        context.strokeLineSegments(between: points)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if foregroundImage == nil || backgroundImage == nil {
            return
        }
        drawImageScaled(backgroundImage)
        let mask = context.makeImage()
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        ctx?.clip(to: contextBounds, mask: mask!)
        drawImageScaled(foregroundImage)
        ctx?.restoreGState()
    }
    
    func resetDrawing() {
        let color = touchRevealsImage ? UIColor.white.cgColor : UIColor.black.cgColor
        context.setFillColor(color)
        context.fill(contextBounds)
        setNeedsDisplay()
    }
    
    func drawImageScaled(_ image: UIImage?) {
        let selfRatio: CGFloat = frame.size.width / frame.size.height
        let imgRatio = (image?.size.width ?? 0.0) / (image?.size.height ?? 0.0)
        var rect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        if selfRatio > imgRatio {
            rect.size.height = frame.size.height
            rect.size.width = imgRatio * (rect.size.height )
        } else {
            rect.size.width = frame.size.width
            rect.size.height = (rect.size.width ) / imgRatio
        }
        rect.origin.x = 0.5 * (frame.size.width - (rect.size.width ))
        rect.origin.y = 0.5 * (frame.size.height - (rect.size.height ))
        
        image?.draw(in: rect )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createBitmapContext()
        touchWidth = 20.0
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createBitmapContext()
        touchWidth = 20.0
    }
    

    var _backgroundImage: UIImage? {
        get {
            return backgroundImage
        }
        set(value) {
            if value != backgroundImage {
                backgroundImage = value
                setNeedsDisplay()
            }
        }
    }
    
    public func setForegroundImage(_ value: UIImage?) {
        if value != foregroundImage {
            foregroundImage = value
            setNeedsDisplay()
        }
    }
    
    public func setTouchRevealsImage(_ value: Bool) {
        if value != touchRevealsImage {
            touchRevealsImage = value
            setNeedsDisplay()
        }
    }
}

