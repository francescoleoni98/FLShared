//
//  ImageUtilities.swift
//  BrainDump
//
//  Created by Francesco Leoni on 17/04/25.
//

import SwiftUI

public enum ImageUtilities {

#if os(macOS)
	public static func createIconImageData(icon: NSImage, backgroundColor: NSColor, size: CGSize = CGSize(width: 256, height: 256)) -> Data? {
		let image = NSImage(size: size)
		image.lockFocus()

		backgroundColor.setFill()
		NSBezierPath(rect: CGRect(origin: .zero, size: size)).fill()

		// Tint and draw the icon
		if let tintedIcon = icon.copy() as? NSImage {
			tintedIcon.lockFocus()
			NSColor.white.set()
			let iconBounds = CGRect(origin: .zero, size: tintedIcon.size)
			iconBounds.fill(using: .sourceAtop)
			tintedIcon.unlockFocus()

			let iconAspectRatio = icon.size.width / icon.size.height

			let maxIconWidth = size.width * 0.6
			let maxIconHeight = size.height * 0.6

			var finalIconSize: CGSize

			if iconAspectRatio > 1 {
				finalIconSize = CGSize(width: maxIconWidth, height: maxIconWidth / iconAspectRatio)
			} else {
				finalIconSize = CGSize(width: maxIconHeight * iconAspectRatio, height: maxIconHeight)
			}

			let iconOrigin = CGPoint(
				x: (size.width - finalIconSize.width) / 2,
				y: (size.height - finalIconSize.height) / 2
			)

			tintedIcon.draw(in: CGRect(origin: iconOrigin, size: finalIconSize),
											from: .zero,
											operation: .sourceOver,
											fraction: 1.0)
		}

		image.unlockFocus()

		guard let tiffData = image.tiffRepresentation,
					let bitmap = NSBitmapImageRep(data: tiffData),
					let jpegData = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.9]) else {
			return nil
		}

		return jpegData
	}
#else
	public static func createIconJPEG(icon: UIImage?, backgroundColor: UIColor, imageSize: CGSize = CGSize(width: 256, height: 256)) -> Data? {
		guard let icon else { return nil }

		UIGraphicsBeginImageContextWithOptions(imageSize, true, 0)

		backgroundColor.setFill()
		UIRectFill(CGRect(origin: .zero, size: imageSize))

		let templateIcon = icon.withRenderingMode(.alwaysTemplate)
		let iconView = UIImageView(image: templateIcon)
		iconView.tintColor = .white

		let maxIconWidth = imageSize.width * 0.6
		let maxIconHeight = imageSize.height * 0.6
		let iconAspect = icon.size.width / icon.size.height

		var iconSize: CGSize
		if iconAspect > 1 {
			iconSize = CGSize(width: maxIconWidth, height: maxIconWidth / iconAspect)
		} else {
			iconSize = CGSize(width: maxIconHeight * iconAspect, height: maxIconHeight)
		}

		let iconOrigin = CGPoint(
			x: (imageSize.width - iconSize.width) / 2,
			y: (imageSize.height - iconSize.height) / 2
		)

		let iconRect = CGRect(origin: iconOrigin, size: iconSize)

		// Draw icon manually with white tint
		if let context = UIGraphicsGetCurrentContext() {
			context.saveGState()

			context.translateBy(x: 0, y: imageSize.height)
			context.scaleBy(x: 1.0, y: -1.0) // Flip coordinates

			if let cgImage = icon.withRenderingMode(.alwaysTemplate).cgImage {
				context.clip(to: iconRect, mask: cgImage)
				context.setFillColor(UIColor.white.cgColor)
				context.fill(iconRect)
			}

			context.restoreGState()
		}

		let finalImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return finalImage?.jpegData(compressionQuality: 0.9)
	}
#endif
}
