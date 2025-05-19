//
//  HTMLUtilities.swift
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

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

public enum HTMLUtilities {

	public static func convertToPlainTextWithLists(html: String) -> String {
		html.htmlToPlainText()
	}

	public static func convertToPlainText(html: String, addListLines: Bool = false) -> String {
		html.htmlToPlainText(addListLines: addListLines)
	}

	public static func convertToAttributeString(html: String) -> NSAttributedString? {
		guard let htmlData = html.data(using: .utf8) else { return nil }

		do {
			return try NSAttributedString(
				data: htmlData,
				options: [
					.documentType: NSAttributedString.DocumentType.html,
					.characterEncoding: String.Encoding.utf8.rawValue
				],
				documentAttributes: nil
			)
		} catch {
			print("[HTMLUtilities] Error converting HTML to NSAttributedString: \(error)")
			return nil
		}
	}

	public static func convertToRTF(html: String) -> Data? {
		guard let attributedString = convertToAttributeString(html: html) else { return nil }

		do {
			return try attributedString.data(
				from: NSRange(location: 0, length: attributedString.length),
				documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf]
			)
		} catch {
			print("[HTMLUtilities] Error converting HTML to RTF: \(error)")
			return nil
		}
	}

	public static func writeToFile(rtfData: Data, fileURL: URL) {
		let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("output_\(UUID().uuidString).rtf")
		try? rtfData.write(to: fileURL)
		print("[HTMLUtilities] RTF file saved at: \(fileURL)")
	}

	public static func convertPlainTextToHtml(text: String) -> String {
		var html = ""
		var inUnorderedList = false
		var inOrderedList = false

		let lines = text.components(separatedBy: .newlines)

		for line in lines {
			let trimmedLine = line.trimmingCharacters(in: .whitespaces)

			// Check if line starts with a dash for unordered list
			if trimmedLine.hasPrefix("- ") {
				let content = trimmedLine.dropFirst(2)

				if !inUnorderedList {
					// Start a new unordered list
					if inOrderedList {
						html += "</ol>\n"
						inOrderedList = false
					}
					html += "<ul>\n"
					inUnorderedList = true
				}

				html += "<li>\(escapeHtml(content.trimmingCharacters(in: .whitespacesAndNewlines)))</li>\n"
			}
			// Check if line starts with a number followed by a period for ordered list
			else if let _ = trimmedLine.range(of: #"^\d+\."#, options: .regularExpression) {
				if let dotIndex = trimmedLine.firstIndex(of: ".") {
					let content = trimmedLine[trimmedLine.index(after: dotIndex)...].trimmingCharacters(in: .whitespaces)

					if !inOrderedList {
						// Start a new ordered list
						if inUnorderedList {
							html += "</ul>\n"
							inUnorderedList = false
						}
						html += "<ol>\n"
						inOrderedList = true
					}

					html += "<li>\(escapeHtml(content))</li>\n"
				}
			}
			// Regular text
			else {
				// Close any open lists
				if inUnorderedList {
					html += "</ul>\n"
					inUnorderedList = false
				}
				if inOrderedList {
					html += "</ol>\n"
					inOrderedList = false
				}

				if !trimmedLine.isEmpty {
					html += "<p>\(escapeHtml(trimmedLine))</p>\n"
				} else {
					html += ""
				}
			}
		}

		// Close any remaining open lists
		if inUnorderedList {
			html += "</ul>\n"
		}
		if inOrderedList {
			html += "</ol>\n"
		}

		return html
	}

	public static func escapeHtml(_ str: String) -> String {
			return str.replacingOccurrences(of: "&", with: "&amp;")
								.replacingOccurrences(of: "<", with: "&lt;")
								.replacingOccurrences(of: ">", with: "&gt;")
	}
}

public extension String {

	func htmlToPlainText(addListLines: Bool = false) -> String {
		let stopCharacters = CharacterSet(charactersIn: "< \t\n\r\u{0085}\u{000C}\u{2028}\u{2029}")
		let newLineAndWhitespaceCharacters = CharacterSet(charactersIn: " \t\n\r\u{0085}\u{000C}\u{2028}\u{2029}")
		let tagNameCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

		let result = NSMutableString(capacity: self.count)
		let scanner = Scanner(string: self)
		scanner.charactersToBeSkipped = nil
		scanner.caseSensitive = true

		var dontReplaceTagWithSpace = false

		var inListItem = false
		var inOrderedList = false
		var listItemCounter = 0

		while !scanner.isAtEnd {
			// Scan text content between tags
			if let text = scanner.scanUpToCharacters(from: stopCharacters) {
				if inListItem {
					if inOrderedList {
							result.append("\(addListLines ? "\n" : "")\(listItemCounter). \(text)")
					} else {
						result.append("\(addListLines ? "\n" : "")- \(text)")
					}
					inListItem = false
				} else {
					result.append(text)
				}
			}

			// Handle tags or whitespace
			if scanner.scanString("<") != nil {
				// Found a tag
				if scanner.scanString("/") != nil {
					// Closing tag logic
					var tagName: String?
					dontReplaceTagWithSpace = false

					if let scannedTagName = scanner.scanCharacters(from: tagNameCharacters) {
						tagName = scannedTagName.lowercased()
						// Check if it's an inline tag
						dontReplaceTagWithSpace = [
							"a", "b", "i", "q", "span", "em",
							"strong", "cite", "abbr", "acronym", "label"
						].contains(tagName)
					}

					if !dontReplaceTagWithSpace && result.length > 0 && !scanner.isAtEnd {
						if let tagName {
							if tagName.hasPrefix("h") || tagName == "p" {
								result.append("\n")
							} else if tagName == "ol" {
								inOrderedList = false
								listItemCounter = 0
								result.append("")
							} else if tagName == "ul" {
								result.append("")
							} else if tagName == "li" {
								result.append("")
							} else {
								result.append(" ")
							}
						} else {
							result.append(" ")
						}
					}

					// Skip remaining tag content
					_ = scanner.scanUpToString(">")
					_ = scanner.scanString(">")
				} else {
					// Opening tag - skip content
					var tagName: String?
					if let scannedTagName = scanner.scanCharacters(from: tagNameCharacters) {
						tagName = scannedTagName.lowercased()
					}

					if tagName == "li" {
						inListItem = true
						if inOrderedList {
							listItemCounter += 1
						}
					} else if tagName == "ol" {
						inOrderedList = true
						listItemCounter = 0
					}

					_ = scanner.scanUpToString(">")
					_ = scanner.scanString(">")
				}
			} else {
				// Handle whitespace
				if scanner.scanCharacters(from: newLineAndWhitespaceCharacters) != nil {
					if result.length > 0 && !scanner.isAtEnd {
						result.append(" ")
					}
				}
			}
		}

		// Decode HTML entities
		let htmlEntities = [
			"&nbsp;": " ",
			"&amp;": "&",
			"&quot;": "\"",
			"&lt;": "<",
			"&gt;": ">"
		]

		var plainText = result as String

		for (entity, replacement) in htmlEntities {
			plainText = plainText.replacingOccurrences(of: entity, with: replacement)
		}

		return plainText.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.joined(separator: "\n")
	}
}
