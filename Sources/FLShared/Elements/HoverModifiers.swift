//
//  HoverModifiers.swift
//  BrainDump
//
//  Created by Francesco Leoni on 28/04/25.
//

import SwiftUI

public struct HoverBackground<S: InsettableShape>: ViewModifier {

	@State private var hovering: Bool = false

	let foreground: Color
	let background: Color
	let shape: S

	public init(foreground: Color, background: Color, shape: S) {
		self.foreground = foreground
		self.background = background
		self.shape = shape
	}

	public func body(content: Content) -> some View {
		content
			.foregroundStyle(hovering ? background : foreground)
			.background(hovering ? foreground : background, in: shape)
			.onHover { hovering in
				withAnimation {
					self.hovering = hovering
				}
			}
	}
}

public struct HoverOpacity: ViewModifier {

	@State private var hovering: Bool = false

	let opacity: CGFloat

	public init(opacity: CGFloat) {
		self.opacity = opacity
	}

	public func body(content: Content) -> some View {
		content
			.opacity(hovering ? opacity : 1)
			.onHover { hovering in
				withAnimation {
					self.hovering = hovering
				}
			}
	}
}

public extension View {
	
	func hoverBackground<S: InsettableShape>(foreground: Color, background: Color, in clipShape: S) -> some View {
#if os(visionOS)
		self
#else
		modifier(HoverBackground(foreground: foreground, background: background, shape: clipShape))
#endif
	}
	
	func hoverOpacity(_ opacity: CGFloat = 0.7) -> some View {
#if os(visionOS)
		self
#else
		modifier(HoverOpacity(opacity: opacity))
#endif
	}
}
