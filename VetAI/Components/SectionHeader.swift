import SwiftUI

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(Typography.section)
            .foregroundStyle(Palette.cyanDark)
            .padding(.bottom, 4)
    }
}
