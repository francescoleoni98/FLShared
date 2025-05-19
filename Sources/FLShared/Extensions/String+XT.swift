//
//  String+XT.swift
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

import Foundation

public extension String {

	var trimmed: String {
		trimmingCharacters(in: .whitespacesAndNewlines)
	}

	var titleFromString: String {
		components(separatedBy: "\n").first?.trimmed ?? ""
	}

	func firstWords(_ num: Int) -> String {
		guard let words = self.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").first?.components(separatedBy: " ") else { return self }

		if words.count > num {
			return words.prefix(num).joined(separator: " ") + "..."
		} else {
			return words.prefix(num).joined(separator: " ")
		}
	}
}
