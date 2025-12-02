//
//  SwiftUIView.swift
//  FLShared
//
//  Created by Francesco Leoni on 18/05/25.
//

#if !os(macOS)
import LinkPresentation

final class ShareableObject: NSObject, UIActivityItemSource {

	private let object: Any
	private let title: String?
	private let subtitle: String?
	private let image: UIImage?

	init(object: Any, title: String? = nil, subtitle: String? = nil, image: UIImage? = nil) {
		self.object = object

		if let title {
			self.title = title
		} else {
			self.title = nil
		}

		self.subtitle = subtitle
		self.image = image
		super.init()
	}

	func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
		return object
	}

	func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
		return title ?? ""
	}

	func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
		return object
	}

	func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
		var metadata: LPLinkMetadata?

		if let title {
			metadata = LPLinkMetadata()
			metadata?.title = title
		}

		if let subtitle = subtitle {
			if metadata == nil { metadata = LPLinkMetadata() }
			// You may need to escape some characters.
			metadata?.originalURL = URL(fileURLWithPath: subtitle)
		}

		if let image {
			metadata?.iconProvider = NSItemProvider(object: image)
		}

		return metadata
	}
}
#endif
