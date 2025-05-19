//
//  BorderedRoundedButtonStyle.swift
//  FLShared
//
//  Created by Francesco Leoni on 17/05/25.
//

import SwiftUI

public struct BorderedRoundedButtonStyle<S: ShapeStyle>: ButtonStyle {

	var foreground: Color
	var background: S
	var size: CGFloat?

	public init(foreground: Color = .primary, background: S = AnyShapeStyle(.thickMaterial), size: CGFloat? = nil) {
		self.foreground = foreground
		self.background = background
		self.size = size
	}

	public func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding(.horizontal, 14)
			.padding(.vertical, 10)
			.foregroundColor(foreground)
			.frame(width: size, height: size)
			.background(background, in: .capsule)
			.overlay {
				Capsule()
					.stroke(foreground.opacity(0.1), lineWidth: 1)
			}
	}
}

#Preview {
	Button("Test", systemImage: "plus") {

	}
	.buttonStyle(BorderedRoundedButtonStyle())
}
