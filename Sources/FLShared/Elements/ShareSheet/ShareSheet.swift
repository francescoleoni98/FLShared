//
//  ShareSheet.swift
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

#if os(macOS)
import AppKit

public struct SharingsPicker: NSViewRepresentable {

	@Binding var isPresented: Bool
	var sharingItems: [Any] = []

	public func makeNSView(context: Context) -> NSView {
		let view = NSView()
		return view
	}

	public func updateNSView(_ nsView: NSView, context: Context) {
		if isPresented {
			let picker = NSSharingServicePicker(items: sharingItems)
			picker.delegate = context.coordinator

			// !! MUST BE CALLED IN ASYNC, otherwise blocks update
			DispatchQueue.main.async {
				picker.show(relativeTo: .zero, of: nsView, preferredEdge: .minY)
			}
		}
	}

	public func makeCoordinator() -> Coordinator {
		Coordinator(owner: self)
	}

	public class Coordinator: NSObject, NSSharingServicePickerDelegate {

		let owner: SharingsPicker

		init(owner: SharingsPicker) {
			self.owner = owner
		}

		public func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, didChoose service: NSSharingService?) {

			// do here whatever more needed here with selected service

			sharingServicePicker.delegate = nil
			self.owner.isPresented = false
		}
	}
}
#else
public struct ShareObject: Identifiable {

	public var id: UUID
	public var title: String?
	public var object: Any
	public var filename: String?

	public init(id: UUID = UUID(), title: String? = nil, object: Any, filename: String? = nil) {
		self.id = id
		self.title = title
		self.object = object
		self.filename = filename
	}
}

public struct ShareObjects: Identifiable {

	public var id: UUID
	public var objects: [ShareObject]

	public init(id: UUID = UUID(), objects: [ShareObject]) {
		self.id = id
		self.objects = objects
	}
}

public struct ShareSheet: UIViewControllerRepresentable {

	var objects: [ShareObject]

	public init(object: ShareObject) {
		self.objects = [object]
	}

	public init(objects: ShareObjects) {
		self.objects = objects.objects
	}

	public func makeUIViewController(context: Context) -> UIActivityViewController {
		let activityItems = objects.map { ShareableObject(object: $0.object, title: $0.title) }
		let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

		for object in objects {
			if let url = object.object as? URL {
				activityViewController.completionWithItemsHandler = { _, success, items, _ in
					do {
						try FileManager.default.removeItem(at: url)
						print("File deleted at:", url)
					} catch {
						print("Cannot delete file at:", url)
					}
				}
			}
		}

//		if let filename = object.filename {
//			activityViewController.completionWithItemsHandler = { activity, success, items, error in
//				if success, let sharedItem = items?.first as? URL {
//					// Rename the shared file
//					let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//					let destinationURL = documentsDirectoryURL.appendingPathComponent(filename)
//
//					do {
//						if FileManager.default.fileExists(atPath: destinationURL.path) {
//							try FileManager.default.removeItem(at: destinationURL)
//						}
//						try FileManager.default.moveItem(at: sharedItem, to: destinationURL)
//						print("Renamed file to \(filename)")
//					} catch {
//						print("Error renaming file: \(error)")
//					}
//				}
//			}
//		}

		return activityViewController
	}

	public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
#endif
