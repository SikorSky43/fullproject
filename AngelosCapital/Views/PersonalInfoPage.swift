import SwiftUI

struct PersonalInformationView: View {

    @State private var name: String = "AMINE IHIRI"
    @State private var dob: String = "3 February 2002"
    @State private var shareToggle: Bool = false
    @StateObject private var bioAuth = BiometricAuth.shared

    // Admin-set image (from your backend)
    let profileImageURL: String = "https://pbs.twimg.com/media/G6iTx5eXkAAqqYy?format=jpg"

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {

                // --------------------------------------------------
                // PROFILE PICTURE SECTION (FLOATING GLASS)
                // --------------------------------------------------
                VStack(spacing: 16) {

                    AsyncImage(url: URL(string: profileImageURL)) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())

                        default:
                            Circle()
                                .fill(Color.white.opacity(0.08))
                                .frame(width: 130, height: 130)
                        }
                    }

                    Button(action: {}) {
                        Text("Change")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.clear)
                                    .glassEffect(.regular.interactive(),
                                                 in: .rect(cornerRadius: 20))
                            )
                    }
                }
                .padding(.top, 30)

                // --------------------------------------------------
                // FLOATING GLASS TILES
                // --------------------------------------------------
                VStack(spacing: 14) {

                    glassTile {
                        tileRow(title: "Name", value: name)
                    }

                    glassTile {
                        tileRow(title: "Date of birth", value: dob)
                    }

                    glassTile {
                        HStack {
                            Text("Name and Photo Sharing")
                                .foregroundColor(.white)
                            Spacer()
                            Toggle("", isOn: $shareToggle)
                                .labelsHidden()
                        }
                        .padding(.vertical, 6)
                    }

                    // --------------------------------------------------
                    // 🔐 FACE ID TOGGLE (NEW)
                    // --------------------------------------------------
                    glassTile {
                        HStack {
                            Text("Enable Face ID Login")
                                .foregroundColor(.white)

                            Spacer()

                            Toggle("", isOn: $bioAuth.biometricEnabled)
                                .labelsHidden()
                                .disabled(!bioAuth.canUseBiometrics)
                        }
                        .padding(.vertical, 6)
                    }

                    glassTile {
                        arrowTile(title: "Age Range for Apps", value: "Ask First")
                    }

                    glassTile {
                        arrowTile(title: "Communication Preferences", value: "")
                    }
                }
                .padding(.horizontal, 20)

            }
            .padding(.bottom, 40)
        }
        .refreshable {
            RefreshService.shared.refreshAll()
        }
        .onAppear {
            RefreshService.shared.refreshAll()
        }

        .background(Color.black.ignoresSafeArea())
    }


    // ----------------------------------------------------------
    // GLASS TILE WRAPPER (LIQUID GLASS)
    // ----------------------------------------------------------
    @ViewBuilder
    func glassTile<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(18)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(.clear)
                    .glassEffect(.regular, in: .rect(cornerRadius: 22))
            )
    }

    // ----------------------------------------------------------
    // ROW COMPONENT
    // ----------------------------------------------------------
    func tileRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)

            Spacer()

            Text(value)
                .foregroundColor(.white.opacity(0.95))
        }
    }

    // ----------------------------------------------------------
    // ARROW TILE
    // ----------------------------------------------------------
    func arrowTile(title: String, value: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundColor(.white)

                if !value.isEmpty {
                    Text(value)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}
