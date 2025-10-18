import NavLib
import SceneKit

// MARK: - Conversion between SceneKit and NavLib types

extension SCNVector3: NavLib.Vector {
    public init(x: Double, y: Double, z: Double) {
        self.init(x, y, z)
    }
}

extension Transform {
    init(scnMatrix m: SCNMatrix4) {
        self.init([m.m11, m.m12, m.m13, m.m14,  m.m21, m.m22, m.m23, m.m24,  m.m31, m.m32, m.m33, m.m34,  m.m41, m.m42, m.m43, m.m44])
    }

    var scnMatrix: SCNMatrix4 {
        let v = values
        return SCNMatrix4(
            m11: v[0], m12: v[1], m13: v[2], m14: v[3],
            m21: v[4], m22: v[5], m23: v[6], m24: v[7],
            m31: v[8], m32: v[9], m33: v[10], m34: v[11],
            m41: v[12], m42: v[13], m43: v[14], m44: v[15]
        )
    }
}
