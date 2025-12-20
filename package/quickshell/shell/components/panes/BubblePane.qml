import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.vars


Item {
  id: root

  required property vector2d topLeft
  required property vector2d bottomRight
  required property int verticalPoints
  required property int horizontalPoints

  property double minSpeed: 1.0
  property double maxSpeed: 3.0
  property int swingDist: 16

  property alias strokeColor: outline.strokeColor
  property alias fillColor: outline.fillColor
  property alias strokeWidth: outline.strokeWidth

  readonly property Component bounds: PathLine {
    property vector2d pos
    property int min
    property int max
    property int dir
    property double speed

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
      capStyle: ShapePath.FlatCap
      strokeColor: Theme.base02
      fillColor: Theme.base01
      strokeWidth: 0
    }

    FrameAnimation {
      id: anim
      running: true
      onTriggered: () => {
        const dt = frameTime;
        for (let i = 0; i < root.horizontalPoints; i++) {
          const cur = outline.pathElements[i];
          if (cur.dir == 1) {
            cur.pos.y -= cur.speed * dt;
            if(cur.pos.y <= cur.min) {
              cur.dir *= -1;
              cur.pos.y = cur.min;
            }
          } else {
            cur.pos.y += cur.speed * dt;
            if(cur.pos.y >= cur.max) {
              cur.dir *= -1;
              cur.pos.y = cur.max;
            }
          }
        }
        for (let i = horizontalPoints; i < root.horizontalPoints + root.verticalPoints; i++) {
          const cur = outline.pathElements[i];
          if (cur.dir == 1) {
            cur.pos.x -= cur.speed * dt;
            if(cur.pos.x <= cur.min) {
              cur.dir *= -1;
              cur.pos.x = cur.min;
            }
          } else {
            cur.pos.x += cur.speed * dt;
            if(cur.pos.x >= cur.max) {
              cur.dir *= -1;
              cur.pos.x = cur.max;
            }
          }
        }
        for (let i = horizontalPoints + verticalPoints; i < 2 * root.horizontalPoints + root.verticalPoints; i++) {
          const cur = outline.pathElements[i];
          if (cur.dir == 1) {
            cur.pos.y -= cur.speed * dt;
            if(cur.pos.y <= cur.min) {
              cur.dir *= -1;
              cur.pos.y = cur.min;
            }
          } else {
            cur.pos.y += cur.speed * dt;
            if(cur.pos.y >= cur.max) {
              cur.dir *= -1;
              cur.pos.y = cur.max;
            }
          }
        }
        for (let i = 2 * horizontalPoints + verticalPoints; i < 2 * (root.horizontalPoints + root.verticalPoints); i++) {
          const cur = outline.pathElements[i];
          if (cur.dir == 1) {
            cur.pos.x -= cur.speed * dt;
            if(cur.pos.x <= cur.min) {
              cur.dir *= -1;
              cur.pos.x = cur.min;
            }
          } else {
            cur.pos.x += cur.speed * dt;
            if(cur.pos.x >= cur.max) {
              cur.dir *= -1;
              cur.pos.x = cur.max;
            }
          }
        }
      }
    }

  }

  Component.onCompleted: () => {
    const hDist = Math.abs(topLeft.x - bottomRight.x) / horizontalPoints
    const vDist = Math.abs(topLeft.y - bottomRight.y) / verticalPoints
    const halfSwing = swingDist / 2;
    const hMax = bottomRight.x + swingDist;
    const hMin = topLeft.x - swingDist;
    const vMax = bottomRight.y + swingDist;
    const vMin = topLeft.y - swingDist;
    let dir = 1;
    // probably better as a lambda
    // TOP:LEFT -> TOP:RIGHT
    for (let i = topLeft.x; i < bottomRight.x; i += hDist) {
      outline.pathElements.push(bounds.createObject(root ,{
        pos: Qt.vector2d(i, topLeft.y - halfSwing),
        min: vMin,
        max: topLeft.y,
        dir: dir,
        speed: (Math.random() * (maxSpeed - minSpeed)) + minSpeed,
      }));
      dir *= -1;
    };
    // TOP:RIGHT -> BOTTOM:RIGHT
    for (let i = topLeft.y; i < bottomRight.y; i += vDist) {
      outline.pathElements.push(bounds.createObject(root ,{
        pos: Qt.vector2d(bottomRight.x + halfSwing, i),
        min: bottomRight.x,
        max: hMax,
        dir: dir,
        speed: (Math.random() * (maxSpeed - minSpeed)) + minSpeed,
      }));
      dir *= -1;
    };
    // BOTTOM:RIGHT -> BOTTOM:LEFT
    for (let i = bottomRight.x; i > topLeft.x; i -= hDist) {
      outline.pathElements.push(bounds.createObject(root ,{
        pos: Qt.vector2d(i, bottomRight.y + halfSwing),
        min: bottomRight.y,
        max: vMax,
        dir: dir,
        speed: (Math.random() * (maxSpeed - minSpeed)) + minSpeed,
      }));
      dir *= -1;
    };
    // BOTTOM:LEFT -> TOP:LEFT
    for (let i = bottomRight.y; i > topLeft.y; i -= vDist) {
      outline.pathElements.push(bounds.createObject(root ,{
        pos: Qt.vector2d(topLeft.x - halfSwing, i),
        min: hMin,
        max: topLeft.x,
        dir: dir,
        speed: (Math.random() * (maxSpeed - minSpeed)) + minSpeed,
      }));
      dir *= -1;
    };
    outline.startX = outline.pathElements[0].x;
    outline.startY = outline.pathElements[0].y;
  }

}
