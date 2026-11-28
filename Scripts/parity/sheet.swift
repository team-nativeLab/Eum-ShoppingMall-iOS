import CoreGraphics
import CoreText
import Foundation
import ImageIO
import UniformTypeIdentifiers

// Usage: sheet <out.png> <figma dir> <sim dir> <code>...
// Each row: label | Figma (top 390x844) | app (scaled to 1x) | diff heatmap (red = differs). Rendered at 0.5x.
func load(_ path: String) -> CGImage? {
    guard let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil) else { return nil }
    return CGImageSourceCreateImageAtIndex(src, 0, nil)
}
func raster(_ image: CGImage, _ w: Int, _ h: Int, shiftUp: Double = 0) -> [UInt8] {
    var d = [UInt8](repeating: 255, count: w * h * 4)
    let ctx = CGContext(data: &d, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4,
                        space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    ctx.setFillColor(CGColor(gray: 1, alpha: 1)); ctx.fill(CGRect(x: 0, y: 0, width: w, height: h))
    let dh = Double(image.height) * Double(w) / Double(image.width)
    ctx.interpolationQuality = .high
    ctx.draw(image, in: CGRect(x: 0, y: Double(h) - dh + shiftUp, width: Double(w), height: dh))
    return d
}
let a = CommandLine.arguments
let codes = Array(a.dropFirst(4))
let w = 390, h = 844, gap = 8, label = 70
let rowW = label + (w + gap) * 3, sheetW = rowW, sheetH = codes.count * (h + gap)
let ctx = CGContext(data: nil, width: sheetW, height: sheetH, bitsPerComponent: 8, bytesPerRow: sheetW * 4,
                    space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
ctx.setFillColor(CGColor(gray: 0.85, alpha: 1)); ctx.fill(CGRect(x: 0, y: 0, width: sheetW, height: sheetH))
for (row, code) in codes.enumerated() {
    let top = sheetH - (row + 1) * (h + gap)
    guard let f = load("\(a[2])/\(code).png"), let s = load("\(a[3])/\(code).png") else { continue }
    let fp = raster(f, w, h), sp = raster(s, w, h, shiftUp: 3.67)
    var diff = [UInt8](repeating: 255, count: w * h * 4)
    for i in stride(from: 0, to: w * h * 4, by: 4) {
        let la = (Int(fp[i]) + Int(fp[i + 1]) + Int(fp[i + 2])) / 3
        let lb = (Int(sp[i]) + Int(sp[i + 1]) + Int(sp[i + 2])) / 3
        let g = UInt8(min(255, 200 + la / 5))
        if abs(la - lb) > 40 { diff[i] = 230; diff[i + 1] = 40; diff[i + 2] = 40 } else { diff[i] = g; diff[i + 1] = g; diff[i + 2] = g }
        diff[i + 3] = 255
    }
    for (col, px) in [fp, sp, diff].enumerated() {
        var copy = px
        let img = CGContext(data: &copy, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4,
                            space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!.makeImage()!
        ctx.draw(img, in: CGRect(x: label + col * (w + gap), y: top, width: w, height: h))
    }
    let font = CTFontCreateWithName("Helvetica-Bold" as CFString, 22, nil)
    let attr = NSAttributedString(string: code, attributes: [.init(kCTFontAttributeName as String): font])
    let line = CTLineCreateWithAttributedString(attr)
    ctx.textPosition = CGPoint(x: 6, y: top + h - 30)
    CTLineDraw(line, ctx)
}
// downscale to 0.5x
let outW = sheetW / 2, outH = sheetH / 2
let small = CGContext(data: nil, width: outW, height: outH, bitsPerComponent: 8, bytesPerRow: outW * 4,
                      space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
small.interpolationQuality = .high
small.draw(ctx.makeImage()!, in: CGRect(x: 0, y: 0, width: outW, height: outH))
let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: a[1]) as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, small.makeImage()!, nil)
CGImageDestinationFinalize(dest)
