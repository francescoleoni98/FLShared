//
//  AppStoreReview.swift
//  FLShared
//  Written by Francesco Leoni <leoni.francesco98@gmail.com>, April 2025.
//

import Foundation
import StoreKit

public final class AppStoreReview {

	private static let userDefaults = UserDefaults.standard

	private static let minimumActionCounts = [10, 30, 50, 80, 110, 140, 180, 230, 290, 360, 420, 480, 530, 580, 630, 660, 700, 750, 800, 850, 900, 950, 1000]
	private static var currentVersion = ""

	private static let lastVersionPromptedForReview = "lastVersionPromptedForReview"
	private static let reviewValidActionCount = "reviewValidActionCount"

	/// Requests a review if the the minimum action count is one of the thresholds and restart from the first threshold if the app version changes.
	@MainActor
	public static func requestReviewAndRestartThresholdsIfAppropriate() {
		guard currentVersionIsDifferent,
					currentCountIsOverThreshold else { return }

		requestReview()
	}

	/// Shows apple in-app review pop-up
	public static func requestReview() {
#if os(iOS) || os(visionOS)
		if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
#if os(iOS)
			UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif

			userDefaults.set(currentVersion, forKey: lastVersionPromptedForReview)
			SKStoreReviewController.requestReview(in: scene)
		}
#else
		userDefaults.set(currentVersion, forKey: lastVersionPromptedForReview)
		SKStoreReviewController.requestReview()
#endif
	}
	
	private static var currentVersionIsDifferent: Bool {
		guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			print("Expected to find a bundle version in the info dictionary.")
			return false
		}
		
		self.currentVersion = currentVersion
		
		let lastVersionPromptedForReview = userDefaults.string(forKey: lastVersionPromptedForReview)

		return currentVersion != lastVersionPromptedForReview
	}
	
	private static var currentCountIsOverThreshold: Bool {
		var actionCount = userDefaults.integer(forKey: reviewValidActionCount)
		actionCount += 1
		userDefaults.set(actionCount, forKey: reviewValidActionCount)

		print("Valid action executed \(actionCount) times.")
		
		return minimumActionCounts.contains(actionCount)
	}
}
