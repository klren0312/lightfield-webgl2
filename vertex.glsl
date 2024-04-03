// 定义一个输出变量 vSt，用于传递顶点的纹理坐标
out vec2 vSt;
// 定义一个输出变量 vUv，用于传递经过计算的纹理坐标
out vec2 vUv;

void main() {
  // 计算顶点到相机的位置向量
  vec3 posToCam = cameraPosition - position;
  // 计算法线方向
  vec3 nDir = normalize(posToCam);
  // given similar triangles we can project the focusing plane point
  // 根据相似三角形原理，计算深度比率 zRatio，即顶点在聚焦平面上的投影深度
  float zRatio = posToCam.z / nDir.z;
  // 用深度比率 zRatio 乘以法线方向 nDir，得到聚焦平面上的点。
  vec3 uvPoint = zRatio * nDir;
  // offset the uv into 0-1.0 coords
  // 将聚焦平面上的点转换为0-1.0的纹理坐标系，并赋值给 vUv。
  vUv = uvPoint.xy + 0.5;
  // 这里对 vUv.x 坐标进行取反操作，这通常是为了适配不同的坐标系或者纹理坐标的约定。具体原因可能需要根据具体的渲染管线或纹理坐标的约定来确定。
  vUv.x = 1.0 - vUv.x; // why is this necessary?
  // 直接将输入的纹理坐标 uv 传递给输出变量 vSt
  vSt = uv;
  // 同样对 vSt.x 坐标进行取反操作，原因同上
  vSt.x = 1.0 - vSt.x;
  // 计算顶点的最终位置，通过将顶点位置 position 与模型视图矩阵 modelViewMatrix 和投影矩阵 projectionMatrix 相乘，
  // 并将结果赋值给 gl_Position，这是顶点着色器的输出，用于确定顶点在屏幕上的位置。
  gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}
