//
//  BorderedButton.swift
//  BrainDump
//
//  Copyright (c) 2025 Francesco Leoni
//
//  This file is part of the Brain Dump project.
//  Unauthorized copying of this file, via any medium, is strictly prohibited.
//  Proprietary and confidential.
//
//  Written by Francesco Leoni <leoni.francesco98@gmail.com>, April 2025.
//

import SwiftUI

public struct BorderedButton<S: ShapeStyle>: View {

	var title: String?
	var icon: ImageType?
	var foreground: Color
	var background: S
	var size: CGFloat
	var action: () -> Void

	public init(title: String? = nil, icon: ImageType? = nil, foreground: Color = .primary, background: S = AnyShapeStyle(.thickMaterial), size: CGFloat = 40, action: @escaping () -> Void) {
		self.title = title
		self.icon = icon
		self.foreground = foreground
		self.background = background
		self.size = size
		self.action = action
	}

	public var body: some View {
		Button(action: action) {
			BorderedText(title: title, icon: icon, foreground: foreground, background: background, size: size)
		}
	}
}

#Preview {
	BorderedButton(title: "Test", icon: .system("plus")) {

	}
}
