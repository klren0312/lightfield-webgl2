# WebGL2 Light field renderer

## [View the demo on Github Pages](https://hypothete.github.io/lightfield-webgl2/)

Uses [THREE.js](https://threejs.org/) for rendering and motion controls. Click and drag to orbit around the light field. Scroll wheel zooms in and out.

Images are from the [Stanford Light Field Archive](http://lightfield.stanford.edu/lfs.html) , scaled down for reduced bandwidth.


1. `float zRatio = posToCam.z / nDir.z;`
   
   这行代码首先计算了从顶点位置到相机位置的向量 `posToCam` 的 z 分量（即深度分量）。这个深度分量表示顶点在三维空间中相对于相机的深度位置。然后，将这个深度值除以法线方向 `nDir` 的 z 分量。这里的 `nDir` 是从顶点位置指向相机的向量，经过归一化处理，表示为单位向量，即方向向量。

   通过这种除法操作，我们得到了一个深度比率 `zRatio`，它表示顶点在相机视角下的相对深度。如果顶点更靠近相机，`zRatio` 会更大，反之，如果顶点更远离相机，`zRatio` 会更小。这个比率可以用来调整顶点在聚焦平面上的投影位置，从而模拟出深度模糊的效果。

2. `vec3 uvPoint = zRatio * nDir;`

   在得到了深度比率 `zRatio` 之后，这行代码使用这个比率来计算顶点在聚焦平面上的投影点。由于 `nDir` 是一个单位向量，所以 `zRatio * nDir` 实际上不会改变向量的方向，只是改变了它的长度。这样，我们就得到了一个新的向量 `uvPoint`，它表示从相机位置出发，沿着法线方向，按照顶点的相对深度进行缩放后的位置。

   接下来，这个 `uvPoint` 向量会被用来计算顶点在纹理坐标系中的位置。通过将这个位置向量映射到 0 到 1 的范围内，我们可以得到一个适应于屏幕空间的纹理坐标，这个坐标将用于片元着色器中的纹理采样，从而实现深度相关的渲染效果，如景深效果。

总结来说，这两行代码通过使用相似三角形原理和深度比率，将顶点的三维空间位置转换为聚焦平面上的二维纹理坐标，从而在渲染过程中模拟出深度感知的效果。


想象一个简单的3D场景，其中有一个相机（Camera）和一个顶点（Vertex）。顶点位于3D空间中的某个位置，相机则位于另一个位置。我们的目标是确定顶点在2D聚焦平面（通常对应于屏幕或图像平面）上的投影位置。

1. **计算深度比率 `zRatio`**:
   - 首先，我们计算顶点到相机的向量 `posToCam`。
   - 然后，我们取这个向量在z轴上的分量 `posToCam.z`，这代表了顶点在z轴（深度轴）上的位置。
   - 接下来，我们将这个深度值除以法线方向 `nDir` 在z轴上的分量 `nDir.z`。由于 `nDir` 是单位向量，这个操作实际上是在计算顶点到相机的相对深度。
   - 得到的 `zRatio` 表示顶点在聚焦平面上的深度位置，相对于相机的焦距。

2. **计算聚焦平面上的点 `uvPoint`**:
   - 现在我们有了 `zRatio`，我们用它来缩放整个法线方向 `nDir` 向量。
   - 由于 `nDir` 是单位向量，`zRatio * nDir` 实际上是在沿着法线方向移动 `zRatio` 单位长度。
   - 这个新向量 `uvPoint` 表示顶点在聚焦平面上的投影位置，沿着法线方向从相机出发。

3. **映射到纹理坐标 `vUv`**:
   - 为了将这个3D位置转换为2D纹理坐标，我们需要将其映射到0到1的范围内。
   - 我们取 `uvPoint` 向量的xy分量（因为屏幕坐标是2D的，所以忽略z分量）。
   - 通常，我们会将这个位置偏移，使得近平面（靠近相机的平面）的顶点映射到纹理坐标的中心，而远平面的顶点映射到边缘。这就是为什么有时候我们会看到 `vUv.x = 1.0 - vUv.x;` 这样的操作，它是为了将坐标映射到正确的方向。

希望这个文字描述能帮助你更好地理解这个过程。如果你需要图像来辅助理解，我建议你可以在网络上搜索相关的3D图形学教程，那里通常会有详细的图解。