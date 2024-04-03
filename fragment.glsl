precision highp float;
precision highp int;
precision highp sampler2DArray;

uniform sampler2DArray field;
uniform vec2 camArraySize;
uniform float aperture;
uniform float focus;

in vec2 vSt;
in vec2 vUv;

void main() {
  vec4 color = vec4(0.0); // 黑色
  float colorCount = 0.0; // 计数器，用于记录采样的颜色数量

  // 如果当前片元纹理坐标超出[0,1]范围，则丢弃片元
  if (vUv.x < 0.0 || vUv.x > 1.0 || vUv.y < 0.0 || vUv.y > 1.0) {
    discard;
  }

  // 遍历纹理数组的每个横向纹理
  for (float i = 0.0; i < camArraySize.x; i++) {
    // 遍历纹理数组的每个纵向纹理
    for (float j = 0.0; j < camArraySize.y; j++) {
      // 计算水平偏移量
      float dx = i - (vSt.x * camArraySize.x - 0.5);
      // 计算垂直偏移量
      float dy = j - (vSt.y * camArraySize.y - 0.5);
      // 计算偏移量的平方和
      float sqDist = dx * dx + dy * dy;
      // 如果平方和小于光圈大小，则进行纹理采样
      if (sqDist < aperture) {
        // 计算纹理在数组中的索引偏移量
        float camOff = i + camArraySize.x * j;
        // 计算对焦偏移量
        vec2 focOff = vec2(dx, dy) * focus;
        // 采样纹理，并累加到 color 中
        color += texture(field, vec3(vUv + focOff, camOff));
        // 增加采样颜色的计数
        colorCount++;
      }
    }
  }
  // 将累加后的颜色除以采样数量，得到平均颜色，并设置为片元的最终输出颜色
  gl_FragColor = vec4(color.rgb / colorCount, 1.0);
}