import Cocoa
import SceneKit
import NavLib

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var window: NSWindow!
    @IBOutlet var sceneView: SCNView!

    private let session = NavLibSession()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let sceneView = self.sceneView!
        let geometry = SCNBox(width: 10, height: 20, length: 25, chamferRadius: 2)
        geometry.firstMaterial?.diffuse.contents = NSColor.red
        let boxNode = SCNNode(geometry: geometry)

        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.showsStatistics = true
        scene.rootNode.addChildNode(boxNode)

        do {
            try session.start(stateProvider: self, applicationName: "NavLibDemo")
        } catch {
            print("NavLib initialization failed: \(error)")
        }
    }
}

extension AppDelegate: NavLibStateProvider {
    var modelBoundingBox: any BoundingBox {
        Bounds(sceneView.scene!.rootNode.boundingBox)
    }

    var cameraTransform: any Transform {
        get {
            sceneView.pointOfView!.presentation.transform
        }
        set {
            guard let pov = sceneView.pointOfView else { return }
            SCNTransaction.begin()
            SCNTransaction.disableActions = true // Disable animations
            pov.transform = newValue.scnMatrix
            SCNTransaction.commit()
        }
    }
}

