import CryptoKit
import Foundation
import SwiftUI
import XCTest
@testable import DesignSystemForIOS

@MainActor
final class DSVisualSnapshotTests: XCTestCase {
    private struct SnapshotCase {
        let id: String
        let size: CGSize
        let view: AnyView
    }

    func testVisualSnapshots() throws {
        let recordMode = ProcessInfo.processInfo.environment["DS_RECORD_SNAPSHOTS"] == "1"
        let baselineURL = Self.projectRootURL
            .appendingPathComponent("Tests/VisualRegression/Baselines/hash_manifest.json")

        let cases = makeSnapshotCases()
        var current: [String: String] = [:]
        for snapshotCase in cases {
            current[snapshotCase.id] = try renderDigest(for: snapshotCase)
        }

        if recordMode {
            try writeBaseline(current, to: baselineURL)
            return
        }

        let baseline = try loadBaseline(from: baselineURL)
        XCTAssertEqual(
            baseline,
            current,
            "Visual snapshot mismatch. If change is expected, run DS_RECORD_SNAPSHOTS=1 swift test and review baselines."
        )
    }
}

private extension DSVisualSnapshotTests {
    static var projectRootURL: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    private func makeSnapshotCases() -> [SnapshotCase] {
        [
            SnapshotCase(
                id: "surface.light.non_glass",
                size: CGSize(width: 220, height: 120),
                view: AnyView(
                    DSSurface(style: .surface) {
                        Color.clear
                    }
                    .frame(width: 220, height: 120)
                    .environment(\.colorScheme, .light)
                    .dsVisualStylePolicy(.init(themeMode: .light, visualStyle: .nonGlass))
                )
            ),
            SnapshotCase(
                id: "surface.dark.glass",
                size: CGSize(width: 220, height: 120),
                view: AnyView(
                    DSSurface(style: .surface) {
                        Color.clear
                    }
                    .frame(width: 220, height: 120)
                    .environment(\.colorScheme, .dark)
                    .dsSurfaceCapabilitySnapshot(
                        .init(
                            supportsGlassMaterial: true,
                            accessibility: .init(
                                reduceTransparencyEnabled: false,
                                increasedContrastEnabled: false
                            )
                        )
                    )
                    .dsVisualStylePolicy(.init(themeMode: .dark, visualStyle: .glass))
                )
            ),
            SnapshotCase(
                id: "button.light.primary",
                size: CGSize(width: 220, height: 64),
                view: AnyView(
                    DSButton(
                        title: "Primary",
                        variant: .primary,
                        size: .medium
                    ) {}
                    .frame(width: 220, height: 64)
                    .environment(\.colorScheme, .light)
                    .dsVisualStylePolicy(.init(themeMode: .light, visualStyle: .nonGlass))
                )
            ),
            SnapshotCase(
                id: "button.dark.secondary.glass",
                size: CGSize(width: 220, height: 64),
                view: AnyView(
                    DSButton(
                        title: "Secondary",
                        variant: .secondary,
                        size: .medium
                    ) {}
                    .frame(width: 220, height: 64)
                    .environment(\.colorScheme, .dark)
                    .dsSurfaceCapabilitySnapshot(
                        .init(
                            supportsGlassMaterial: true,
                            accessibility: .init(
                                reduceTransparencyEnabled: false,
                                increasedContrastEnabled: false
                            )
                        )
                    )
                    .dsVisualStylePolicy(.init(themeMode: .dark, visualStyle: .glass))
                )
            ),
            SnapshotCase(
                id: "list_row.light.non_glass",
                size: CGSize(width: 280, height: 72),
                view: AnyView(
                    DSListRow(
                        title: "Morning",
                        subtitle: "07:00",
                        accessory: .disclosure
                    )
                    .frame(width: 280, height: 72)
                    .environment(\.colorScheme, .light)
                    .dsVisualStylePolicy(.init(themeMode: .light, visualStyle: .nonGlass))
                )
            ),
            SnapshotCase(
                id: "toast.dark.glass",
                size: CGSize(width: 280, height: 72),
                view: AnyView(
                    DSToastBanner(
                        message: "Saved",
                        kind: .success
                    )
                    .frame(width: 280, height: 72)
                    .environment(\.colorScheme, .dark)
                    .dsSurfaceCapabilitySnapshot(
                        .init(
                            supportsGlassMaterial: true,
                            accessibility: .init(
                                reduceTransparencyEnabled: false,
                                increasedContrastEnabled: false
                            )
                        )
                    )
                    .dsVisualStylePolicy(.init(themeMode: .dark, visualStyle: .glass))
                )
            )
        ]
    }

    private func renderDigest(for snapshotCase: SnapshotCase) throws -> String {
        let renderer = ImageRenderer(content: snapshotCase.view)
        renderer.scale = 1
        renderer.proposedSize = ProposedViewSize(snapshotCase.size)
        renderer.isOpaque = false

        guard let cgImage = renderer.cgImage else {
            throw SnapshotError.renderFailed(snapshotCase.id)
        }
        guard let dataProvider = cgImage.dataProvider,
              let cfData = dataProvider.data else {
            throw SnapshotError.bitmapDataMissing(snapshotCase.id)
        }

        let bitmap = Data(
            bytes: CFDataGetBytePtr(cfData),
            count: CFDataGetLength(cfData)
        )
        var payload = Data()
        payload.append(Data("w\(cgImage.width)h\(cgImage.height)bpp\(cgImage.bitsPerPixel)".utf8))
        payload.append(bitmap)
        let hash = SHA256.hash(data: payload)
        return hash.map { String(format: "%02x", $0) }.joined()
    }

    private func loadBaseline(from url: URL) throws -> [String: String] {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([String: String].self, from: data)
    }

    private func writeBaseline(
        _ baseline: [String: String],
        to url: URL
    ) throws {
        let sorted = baseline.sorted { $0.key < $1.key }
        let dictionary = Dictionary(uniqueKeysWithValues: sorted)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(dictionary)

        let directoryURL = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )
        try data.write(to: url)
    }

    enum SnapshotError: Error {
        case renderFailed(String)
        case bitmapDataMissing(String)
    }
}
