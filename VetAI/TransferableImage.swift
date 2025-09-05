#if canImport(UIKit)
import SwiftUI
import UIKit
import UniformTypeIdentifiers

/// Wrapper allowing ``UIImage`` instances to be used with ``ShareLink``.
struct TransferableImage: Transferable {
    let image: UIImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            item.image.pngData() ?? Data()
        }
    }
}
#endif
