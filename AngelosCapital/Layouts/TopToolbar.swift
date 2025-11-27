import SwiftUI

struct TopToolbar: ToolbarContent {
    @Binding var showSendMoneyPopup: Bool
    @Binding var showCardDetails: Bool
    @Binding var showDepositPopup: Bool
    let onLogout: () -> Void

    private let iconSize: CGFloat = 18

    var body: some ToolbarContent {

        // LEFT → Logout
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                onLogout()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: iconSize))
                    .foregroundColor(Color.primary)      // ADAPTIVE
            }
        }

        // RIGHT → Card Details, Search, Deposit
        ToolbarItemGroup(placement: .navigationBarTrailing) {

            // OPEN CARD DETAILS
            Button {
                withAnimation(.easeInOut(duration: 0.28)) {
                    showCardDetails = true
                }
            } label: {
                Image(systemName: "creditcard")
                    .font(.system(size: iconSize))
                    .foregroundColor(Color.primary)      // ADAPTIVE
            }

            // Search (not used)
            Button {} label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: iconSize))
                    .foregroundColor(Color.primary)       // ADAPTIVE
            }

            // OPEN SEND / DEPOSIT POPUP
            Button {
                withAnimation(.spring()) {
                    showSendMoneyPopup = true
                }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: iconSize))
                    .foregroundColor(Color.primary)        // ADAPTIVE
            }
        }
    }
}
