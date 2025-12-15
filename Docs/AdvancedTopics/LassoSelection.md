# Lasso Selection

## Overview

Lasso Selection is an alternative selection mode in NodeLink that allows users to select nodes, containers, and links using a freeform (lasso-style) path instead of a rectangular marquee. This feature enables more flexible and precise selection in dense or irregular node layouts.

The lasso selection integrates seamlessly with the existing selection system, selection tools, and rubber band visualization.

![Lasso selection Overview 1](images/Lasso_1.png)  
![Lasso selection Overview 2](images/Lasso_2.png)  
![Lasso selection Overview 3](images/Lasso_3.png)  
![Lasso selection Overview 4](images/Lasso_4.png)  

---

## Motivation

Rectangular (marquee) selection is not always ideal when:
- Nodes are arranged in non-rectangular patterns
- The scene is dense and overlapping
- Users need fine-grained control over which objects are selected

Lasso Selection solves these problems by allowing users to draw an arbitrary shape around objects, selecting only those fully or partially enclosed by the lasso path.

---

## Selection Modes

NodeLink supports multiple selection modes managed by `SceneSession`:

- **Rectangle Selection** (default)
- **Lasso Selection**

The active selection mode determines how pointer drag interactions are interpreted during selection.

---

## High-Level Flow

1. User activates **Lasso Selection mode**
2. Pointer drag creates a freehand path
3. Path points are collected in real time
4. Path is optionally auto-closed when endpoints are close
5. Objects inside the lasso polygon are detected
6. Selection model is updated
7. Selection tools and rubber band visuals are refreshed

---

## Lasso Selection Algorithm

The lasso selection feature is implemented using a free-form polygon selection algorithm combined with a point-in-polygon containment test to accurately determine which scene items fall inside the user-defined lasso area.

### Lasso Path Construction

While the user is drawing the lasso, mouse positions are sampled continuously and stored as an ordered list of 2D points.
To improve visual smoothness and reduce noise caused by high-frequency mouse movement, the raw input points are rendered using quadratic Bézier curve interpolation, resulting in a smooth and visually consistent lasso outline without altering the actual selection geometry.

Once the user completes the lasso gesture, the path is automatically closed, forming a valid polygon.

### Selection Algorithm

After the lasso polygon is finalized, each selectable item in the scene is tested against the lasso area using a Point-in-Polygon (PIP) algorithm.
For nodes and containers, the algorithm typically evaluates one or more representative points (such as the node’s center point or bounding box corners) to determine whether the item lies inside the lasso polygon.

The implementation relies on a well-known and robust approach such as the ray-casting algorithm, which determines containment by counting edge intersections between a horizontal ray and the polygon edges.

### Accuracy and Performance Considerations

#### Accuracy:
The lasso selection provides pixel-level precision, allowing users to select complex and irregular groups of nodes that cannot be efficiently captured using rectangular (marquee) selection.

#### Performance:
The algorithm operates in linear time relative to the number of polygon edges and selectable items, which is suitable for real-time interaction.
Selection evaluation is only performed after the lasso gesture is completed, ensuring that scene interaction remains responsive during drawing.

### Design Rationale

The lasso-based approach was chosen to:
- Support non-rectangular, free-form selection shapes
- Improve usability in dense node layouts
- Provide predictable and visually intuitive selection behavior

This algorithm integrates seamlessly with the existing selection model and complements traditional rectangle-based selection without introducing breaking changes.  

---

## Lasso Path Handling

### Path Construction

The lasso path is built incrementally from mouse/touch move events:

- Each movement adds a new point to `pathPoints`
- The path is rendered dynamically for visual feedback
- A minimum number of points is required to form a valid lasso

### Shape Auto-Closing

To improve usability, the lasso automatically closes when the last point is close enough to the first point:

```qml
function closeShapeIfNeeded() {
    lassoSelection.isShapeClosed = false;

    if (lassoSelection.pathPoints.length < 3)
        return;

    var first = lassoSelection.pathPoints[0];
    var last = lassoSelection.pathPoints[lassoSelection.pathPoints.length - 1];

    var dx = first.x - last.x;
    var dy = first.y - last.y;
    var dist = Math.sqrt(dx * dx + dy * dy);

    var threshold = 25;

    if (dist < threshold) {
        lassoSelection.pathPoints[lassoSelection.pathPoints.length - 1] =
            Qt.point(first.x, first.y);
        lassoSelection.isShapeClosed = true;
    }

    freehandCanvas.requestPaint();
}
```
This avoids forcing users to manually close the lasso precisely.

---

## Object Detection

Once the lasso is closed (or selection ends):

- The lasso path is treated as a polygon
- Each selectable object is tested against this polygon
- Nodes and containers are tested using their bounding rectangles
- Links are tested using their input/output port positions

Only objects inside the lasso area are added to the SelectionModel.

---

## Integration with SelectionModel

Lasso selection does not introduce a new selection system.
Instead, it reuses the existing SelectionModel:
- Supports multi-selection
- Works with Shift modifier
- Triggers the same signals as rectangle selection
- Automatically updates dependent views

This ensures full compatibility with:
- ObjectSelectionView
- SelectionToolsRect
- Rubber band visualization
- Drag & move behavior

---

## Visual Feedback

### Lasso Overlay
- Rendered using a Canvas
- Displays the freehand path while drawing
- Highlights closed shape when ready

### Rubber Band Rectangle
After selection:
- The bounding rectangle of selected objects is calculated
 Used for:
- Dragging multiple objects
- Displaying selection outline
- Anchoring SelectionToolsRect

---

## Selection Tools Behavior

The SelectionToolsRect (delete, color, duplicate, etc.):
- Appears above selected objects
- Updates position dynamically via calculateDimensions()
Correctly follows:
- Single-node selection
- Multi-node selection
- Dragging operations
- Zoom changes

A fix was applied to ensure the tools update correctly for single selection, not only multi-selection, by reacting to selection changes consistently.  

---

## Performance Considerations
- Path points are stored in a simple array
- No expensive calculations during pointer movement
- Object intersection checks happen only when selection ends
- Bounding rectangle calculations are reused for visuals and movement

This keeps lasso selection responsive even in large scenes.

---

## Best Practices
- Use lasso selection for dense or irregular layouts
- Combine with Shift for additive selection
- Avoid extremely long paths to keep interaction smooth
- Prefer rectangle selection for large, structured selections

---

## Result

With Lasso Selection, NodeLink now provides:
- More flexible selection workflows
- Better control in complex scenes
- Seamless integration with existing tools
- A consistent user experience across selection modes

This feature significantly improves usability without adding complexity to the core selection architecture.  