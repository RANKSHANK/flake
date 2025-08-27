import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.vars


Item {
  id: root

  required property vector2d topLeft
  required property vector2d bottomRight

  property int segmentCount: 64
  property int swingDist: 16

  property alias strokeColor: outline.strokeColor
  property alias fillColor: outline.fillColor
  property alias strokeWidth: outline.strokeWidth

  readonly property Component bounds: Pathline {
    property vector2d pos
    property vector2d inner
    property vector2d outer
    property int direction

    x: pos.x
    y: pos.y
  }

  Shape {
    id: shape
    anchors.fill: parent
    asynchronous: true
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
      id: outline
      capStyle: ShapePath.RoundCap
      strokeColor: Theme.base02
      fillColor: Theme.base01
      strokeWidth: 10
    }

  }

  Component.onCompleted: () => {
    const ratio = Math.abs((topLeft.x - bottomRight.x) / (topLeft.y - bottomRight.y));
    const xSeg = Math.ceil(ratio * (segmentCount / 4.));
    const ySeg = Math.floor(segmentCount / .2) - segmentColor;
    let i = 0;
    let current = null;
    while (i < segmentCount) {
      outline.pathElements.push(p.createObject(root ,{
        pos: stat,
        inner: test,
        outer: penis,
        
      }));

      i++;
    };

  }
}
