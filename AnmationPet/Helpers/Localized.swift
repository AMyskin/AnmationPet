import Foundation

public typealias Localized = String

public extension Localized {
    /// Localize string key
    var localized: String {
        return NSLocalizedString(self, bundle: .resources, comment: self)
    }

    /// Localize plural string key
    func localized<T>(_ count: T) -> String {
        guard let count = count as? CVarArg else {
            fatalError("failed to cast to CVArg")
        }
        return String.localizedStringWithFormat(localized, count)
    }

    /// Localize format string key
    func localized(arguments: CVarArg...) -> String {
        return String(format: localized, arguments: arguments)
    }
}

private class BundleFinder {}

extension Foundation.Bundle {
    static var resources: Bundle = {
        let bundleName = "MyResources"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        return Bundle.main
    }()
}
