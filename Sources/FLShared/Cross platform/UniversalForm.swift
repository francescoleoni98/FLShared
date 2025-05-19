//
//  UniversalForm.swift
//  FLShared
//
//  Copyright (c) 2025 Francesco Leoni
//  Written by Francesco Leoni <leoni.francesco98@gmail.com>, April 2025.
//

import SwiftUI

public struct UniversalForm<Content: View>: View {

	var width: CGFloat?
	var height: CGFloat?
	@ViewBuilder var content: () -> Content

	public init(width: CGFloat? = 500, height: CGFloat? = nil, content: @escaping () -> Content) {
		self.width = width
		self.height = height
		self.content = content
	}

	public var body: some View {
#if os(iOS) || os(visionOS)
		content()
#else
		content()
			.padding()
			.frame(width: width, height: height)
#endif
	}
}
