import Foundation
import CoreMotion
import SwiftUI
internal import Combine
import CoreGraphics

class MotionManager: ObservableObject {

    private let motion = CMMotionManager()

    // Published property so SwiftUI updates CardViewRepresentable
    @Published var focalPointOffset: CGPoint = .zero

    private var initialPitch: Double?
    private var initialRoll: Double?

    private let maxRadiansX = 0.2
    private let maxRadiansY = 0.1
    private let maxFocalShift = 100.0

    func start() {
        motion.deviceMotionUpdateInterval = 0.1

        motion.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let attitude = data?.attitude else { return }

            if self.initialPitch == nil { self.initialPitch = attitude.pitch }
            if self.initialRoll == nil { self.initialRoll = attitude.roll }

            guard let basePitch = self.initialPitch,
                  let baseRoll = self.initialRoll else { return }

            let deltaPitch = attitude.pitch - basePitch
            let deltaRoll = attitude.roll - baseRoll

            let y = mapRange(deltaPitch,
                             -self.maxRadiansY, self.maxRadiansY,
                             -self.maxFocalShift, self.maxFocalShift)

            let x = mapRange(deltaRoll,
                             -self.maxRadiansX, self.maxRadiansX,
                             -self.maxFocalShift, self.maxFocalShift)

            self.focalPointOffset = CGPoint(x: x, y: y)
        }
    }

    func stop() {
        motion.stopDeviceMotionUpdates()
    }
}
