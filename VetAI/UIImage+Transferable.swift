import SwiftUI
import UniformTypeIdentifiers
#if canImport(UIKit)
import UIKit

// Allow UIImage to be shared via ShareLink by conforming to Transferable.
extension UIImage: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { image in
            image.pngData() ?? Data()
        }
    }
}
#endif
