import NavLib
import SceneKit

// MARK: - Conversion between SceneKit and NavLib types

extension SCNVector3: NavLib.Vector {}

extension Transform {
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

extension SCNMatrix4: @retroactive Transform {
    public var values: [Double] {
        [m11, m12, m13, m14,  m21, m22, m23, m24,  m31, m32, m33, m34,  m41, m42, m43, m44]
    }
}

struct Bounds: BoundingBox {
    let min: SCNVector3
    let max: SCNVector3

    init(_ box: (min: SCNVector3, max: SCNVector3)) {
        min = box.min
        max = box.max
    }
}
