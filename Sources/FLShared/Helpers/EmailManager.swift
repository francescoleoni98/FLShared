//
//  EmailManager.swift
//  FLShared
//  Written by Francesco Leoni <leoni.francesco98@gmail.com>, April 2025.
//

import SwiftUI

#if canImport(MessageUI)
import MessageUI
#endif

public class EmailManager {

	public struct MailProvider {

		public var name: String
		public var url: URL

		init?(name: String, url: URL?) {
			guard let url else {
				return nil
			}

			self.name = name
			self.url = url
		}
	}

	public static func availableMailProviders(to: String, subject: String, body: String) -> [MailProvider] {
		let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

		let gmailUrl = MailProvider(name: "Gmail",
																url: URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"))
		let outlookUrl = MailProvider(name: "Outlook",
																	url: URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"))
		let yahooMail = MailProvider(name: "Yahoo Mail",
																 url: URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"))
		let sparkUrl = MailProvider(name: "Spark",
																url: URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"))
		let defaultUrl = MailProvider(name: "Apple Mail",
																	url: URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)"))

#if canImport(MessageUI)
		let allProviders = [gmailUrl, outlookUrl, yahooMail, sparkUrl]
		var availableProviders = MFMailComposeViewController.canSendMail() ? [defaultUrl].compactMap { $0 } : []
		availableProviders.append(contentsOf: allProviders.compactMap { $0 }.filter { UIApplication.shared.canOpenURL($0.url) })
		return availableProviders
#else
		return [defaultUrl].compactMap { $0 }
#endif
	}

	public static func sendEmail(subject: String, body: String) {
		let providers = availableMailProviders(to: "braindump.help@gmail.com",
																					 subject: subject,
																					 body: body)

		if let url = providers.first {
#if os(iOS) || os(visionOS)
			if UIApplication.shared.canOpenURL(url.url) {
				UIApplication.shared.open(url.url)
			}
#else
			NSWorkspace.shared.open(url.url)
#endif
		}
	}
}
