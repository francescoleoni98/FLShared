//
//  ImageType.swift
//  FLShared
//
//  Created by Francesco Leoni on 10/05/25.
//

import SwiftUI

public enum ImageType {

	case system(String, Color? = nil)
	case customSymbol(String, Color? = nil)
	case named(String, Color? = nil)

	public var image: Image {
		switch self {
		case .system(let name, _):
			return Image(systemName: name)
		case .named(let name, _), .customSymbol(let name, _):
			return Image(name)
		}
	}

	public var tint: Color? {
		switch self {
		case .system(_, let color),
				.customSymbol(_, let color),
				.named(_, let color):
			return color
		}
	}

	public var isSystem: Bool {
		switch self {
		case .system, .customSymbol:
			return true
		case .named:
			return false
		}
	}
}
