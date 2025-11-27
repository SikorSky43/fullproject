import SwiftUI

struct AccountHealthView: View {
    
    // --- Bind these to your real DB values ---
    var accountHealth: String = "B"     // A, B, C, D, F
    var comments: [String] = [
        "Try to reduce your outstanding balance.",
        "Avoid multiple transactions in a short period.",
        "Keep your card utilization under 30%."
    ]
    
    // Mock values (connect later)
    var selectedAmount: Double = 28.79
    var interest: Double = 74.43
    
    // ======================================================
    //      GRADIENT COLORS BASED ON ACCOUNT HEALTH
    // ======================================================
    var ringGradient: [Color] {
        switch accountHealth.uppercased() {
        case "A":
            return [Color.green.opacity(0.4), Color.green]
        case "B":
            return [Color.green.opacity(0.2), Color.teal]
        case "C":
            return [Color.yellow, Color.orange]
        case "D":
            return [Color.orange, Color.red]
        case "F":
            return [Color.red.opacity(0.6), Color.red]
        default:
            return [Color.gray, Color.gray.opacity(0.4)]
        }
    }
    
    // Fill percentage of ring depending on grade
    var fillPercent: CGFloat {
        switch accountHealth.uppercased() {
        case "A": return 1.0
        case "B": return 0.75
        case "C": return 0.50
        case "D": return 0.30
        case "F": return 0.15
        default: return 0.40
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                
                // TITLE
                Text("Account Health")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                // SUBTITLE
                Text("Overall financial standing based on your activity.")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                // ===============================
                //         DYNAMIC RING
                // ===============================
                ZStack {
                    
                    // Outer dim background ring
                    Circle()
                        .stroke(Color.white.opacity(0.05), lineWidth: 26)
                        .frame(width: 300, height: 300)
                    
                    // Colored ring based on DB grade
                    Circle()
                        .trim(from: 0.0, to: fillPercent)
                        .stroke(
                            LinearGradient(
                                colors: ringGradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 26, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 300, height: 300)
                        .animation(.easeOut(duration: 0.8), value: accountHealth)
                    
                    // Center information
                    VStack(spacing: 6) {
                        Text(accountHealth)
                            .font(.system(size: 56, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(descriptionForGrade(accountHealth))
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 8)
                
                // ======================================================
                //                IMPROVEMENT SUGGESTIONS
                // ======================================================
                VStack(alignment: .leading, spacing: 12) {
                    Text("Suggestions to Improve")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    ForEach(comments, id: \.self) { comment in
                        HStack(alignment: .top) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 16))
                                .padding(.top, 2)
                            
                            Text(comment)
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer(minLength: 80)
            }
        }
        .refreshable {
            RefreshService.shared.refreshAll()
        }
        .onAppear {
            RefreshService.shared.refreshAll()
        }

        .background(Color.black.ignoresSafeArea())
    }
    
    
    // ======================================================
    //            Short text describing a grade
    // ======================================================
    func descriptionForGrade(_ grade: String) -> String {
        switch grade.uppercased() {
        case "A": return "Excellent Financial Standing"
        case "B": return "Very Good Condition"
        case "C": return "Average Health"
        case "D": return "Needs Attention"
        case "F": return "Critical Condition"
        default:  return "Unknown Status"
        }
    }
}
