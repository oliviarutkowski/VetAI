import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.button)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .foregroundColor(.white)
            .background(
                Palette.primary.opacity(configuration.isPressed ? 0.9 : 1)
            )
            .cornerRadius(12)
    }
}
