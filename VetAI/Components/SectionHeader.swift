import SwiftUI

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(Typography.section)
            .foregroundColor(Palette.cyanDark)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
