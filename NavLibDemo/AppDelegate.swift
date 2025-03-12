import Cocoa
import SceneKit
import NavLib
import NavLibSwift

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var window: NSWindow!
    @IBOutlet var sceneView: SCNView!

    private let session = NavLibSession()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let geometry = SCNBox(width: 10, height: 20, length: 25, chamferRadius: 2)
        geometry.firstMaterial?.diffuse.contents = NSColor.red
        let boxNode = SCNNode(geometry: geometry)

        let scene = SCNScene()
        sceneView.scene = scene
        scene.rootNode.addChildNode(boxNode)

        sceneView.showsStatistics = true

        do {
            try session.start(applicationName: "NavLibDemo")
        } catch {
            print("NavLib initialization failed: \(error)")
        }

        session[getter: .modelExtents] = {
            // NavLib asks us for the model bounding box
            let bounds = scene.rootNode.boundingBox
            return .init(min: .init(bounds.min), max: .init(bounds.max))
        }

        session[getter: .cameraTransform] = { [weak self] in
            // NavLib asks us for the current camera transform
            guard let sceneView = self?.sceneView,
                  let transform = sceneView.pointOfView?.presentation.transform
            else {
                return .init()
            }
            return .init(scnMatrix: transform)
        }

        session[setter: .cameraTransform] = { [weak self] transform in
            // NavLib tells us to change the camera transform
            guard let self, let pov = sceneView.pointOfView else { return }
            SCNTransaction.begin()
            SCNTransaction.disableActions = true
            pov.transform = transform.scnMatrix
            SCNTransaction.commit()
        }
    }
}


// MARK: - Conversion between SceneKit and NavLib types

extension navlib.matrix_t {
    init(scnMatrix m: SCNMatrix4) {
        self = .init(m00: m.m11, m01: m.m12, m02: m.m13, m03: m.m14,
                     m10: m.m21, m11: m.m22, m12: m.m23, m13: m.m24,
                     m20: m.m31, m21: m.m32, m22: m.m33, m23: m.m34,
                     m30: m.m41, m31: m.m42, m32: m.m43, m33: m.m44)
    }

    var scnMatrix: SCNMatrix4 {
        SCNMatrix4(m11: m00, m12: m01, m13: m02, m14: m03,
                   m21: m10, m22: m11, m23: m12, m24: m13,
                   m31: m20, m32: m21, m33: m22, m34: m23,
                   m41: m30, m42: m31, m43: m32, m44: m33)
    }
}

extension navlib.point_t {
    init(_ v: SCNVector3) {
        self.init(x: v.x, y: v.y, z: v.z)
    }
}
