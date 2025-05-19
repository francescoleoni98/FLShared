//
//  SwiftUIView.swift
//  FLShared
//
//  Created by Francesco Leoni on 18/05/25.
//

import SwiftUI

public enum HighlightShape {

	case circle
	case roundedRectangle(radius: CGFloat)
}

public extension View {

	@ViewBuilder
	func navbarTitleMode(large: Bool) -> some View {
		#if os(iOS)
		navigationBarTitleDisplayMode(large ? .large : .inline)
		#else
		self
		#endif
	}

	@ViewBuilder
	func conditionalSheetOrFullScreenCover<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
#if os(iOS)
		if UIDevice.current.userInterfaceIdiom == .phone {
			fullScreenCover(isPresented: isPresented, content: content)
		} else {
			sheet(isPresented: isPresented, content: content)
		}
#else
		sheet(isPresented: isPresented, content: content)
#endif
	}

	@ViewBuilder
	func conditionalSheetOrFullScreenCover<Content: View, Item: Identifiable>(item: Binding<Item?>, @ViewBuilder content: @escaping (Item) -> Content) -> some View {
#if os(iOS)
		if UIDevice.current.userInterfaceIdiom == .phone {
			fullScreenCover(item: item, content: content)
		} else {
			sheet(item: item, content: content)
		}
#else
		sheet(item: item, content: content)
#endif
	}

	@ViewBuilder
	func highlightShape(_ shape: HighlightShape) -> some View {
#if os(visionOS)
		switch shape {
		case .circle:
			buttonBorderShape(.circle)

		case .roundedRectangle(let radius):
			buttonBorderShape(.roundedRectangle(radius: radius))
		}
#else
		self
#endif
	}

	@ViewBuilder
	func contextAwareTint(style: Color, isProminent: Bool) -> some View {
		if isProminent {
			tint(style)
		} else {
			foregroundStyle(Color("black"))
		}
	}
}
