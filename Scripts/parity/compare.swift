import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

// Usage: compare <figma 1x png> <simulator 3x png> <out composite png>
// Prints mean absolute luminance difference over the 390x844 viewport (0-255), excluding the status bar.
func load(_ path: String) -> CGImage {
    CGImageSourceCreateImageAtIndex(CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil)!, 0, nil)!
}
func pixels(_ image: CGImage, width: Int, height: Int, cropTopTo: Int? = nil, shiftUp: Double = 0) -> [UInt8] {
    var data = [UInt8](repeating: 0, count: width * height * 4)
    let ctx = CGContext(data: &data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4,
                        space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    ctx.setFillColor(CGColor(gray: 1, alpha: 1)); ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))
    let scale = Double(width) / Double(image.width)
    let drawHeight = Double(image.height) * scale
    ctx.interpolationQuality = .high
    ctx.draw(image, in: CGRect(x: 0, y: Double(height) - drawHeight + shiftUp, width: Double(width), height: drawHeight))
    return data
}
let args = CommandLine.arguments
let w = 390, h = 844
let figma = pixels(load(args[1]), width: w, height: h)
let sim = pixels(load(args[2]), width: w, height: h, shiftUp: 3.67)
var total = 0.0, count = 0.0
for y in 50..<h { for x in 0..<w {
    let i = (y * w + x) * 4
    let a = (Int(figma[i]) + Int(figma[i + 1]) + Int(figma[i + 2])) / 3
    let b = (Int(sim[i]) + Int(sim[i + 1]) + Int(sim[i + 2])) / 3
    total += Double(abs(a - b)); count += 1
} }
print(String(format: "%.2f", total / count))
// composite: figma | sim
let cw = w * 2 + 10
var comp = [UInt8](repeating: 255, count: cw * h * 4)
for y in 0..<h { for x in 0..<w { for c in 0..<4 {
    comp[(y * cw + x) * 4 + c] = figma[(y * w + x) * 4 + c]
    comp[(y * cw + x + w + 10) * 4 + c] = sim[(y * w + x) * 4 + c]
} } }
let ctx = CGContext(data: &comp, width: cw, height: h, bitsPerComponent: 8, bytesPerRow: cw * 4,
                    space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: args[3]) as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, ctx.makeImage()!, nil)
CGImageDestinationFinalize(dest)
