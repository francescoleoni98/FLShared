//
//  BorderedText.swift
//  FLShared
//
//  Created by Francesco Leoni on 17/05/25.
//

import SwiftUI

public struct BorderedText<S: ShapeStyle>: View {

	var title: String?
	var icon: ImageType?
	var foreground: Color
	var background: S
	var size: CGFloat

	public init(title: String? = nil, icon: ImageType? = nil, foreground: Color = .primary, background: S = AnyShapeStyle(.thickMaterial), size: CGFloat = 40) {
		self.title = title
		self.icon = icon
		self.foreground = foreground
		self.background = background
		self.size = size
	}

	public var body: some View {
		HStack {
			if let title {
				Text(title)
					.font(.system(size: 16, weight: .medium))
			}

			if let icon {
				if icon.isSystem {
					icon.image
						.font(.system(size: 18, weight: .medium))
						.padding(.bottom, 2)
				} else {
					icon.image
						.resizable()
						.scaledToFit()
						.frame(width: 22, height: 22)
						.padding(.bottom, 2)
				}
			}
		}
		.padding(.horizontal, 16)
		.frame(width: title == nil ? size : nil, height: size)
		.foregroundColor(foreground)
		.background(background, in: .capsule)
		.overlay {
			Capsule()
				.stroke(foreground.opacity(0.1), lineWidth: 1)
		}
	}
}

#Preview {
	BorderedText(title: "Test", icon: .system("plus"))
}
