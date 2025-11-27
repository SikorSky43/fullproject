import SwiftUI

struct TopToolbar: ToolbarContent {
    @Binding var showSendMoneyPopup: Bool   // <-- NEW
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
                    .foregroundColor(.white)
            }
        }

        // RIGHT → Card Details, Search, Deposit
        ToolbarItemGroup(placement: .navigationBarTrailing) {

            // OPEN CARD DETAILS
            Button {
                withAnimation(.easeInOut(duration: 0.28))
                { showCardDetails = true
                }
            } label: {
                Image(systemName: "creditcard")
                    .font(.system(size: iconSize))
                    .foregroundColor(.white)
            }

            // Search (not used)
            Button {} label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: iconSize))
                    .foregroundColor(.white)
            }

            // OPEN DEPOSIT POPUP
            Button {
                withAnimation(.spring()) {
                        showSendMoneyPopup = true   // ← FIXED!!!
                }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: iconSize))
                    .foregroundColor(.white)
            }
        }
    }
}
