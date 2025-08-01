{...}: ''
  // Original shader collected from: https://www.shadertoy.com/view/WsVSzV
  // Licensed under Shadertoy's default since the original creator didn't provide any license. (CC BY NC SA 3.0)
  // Slight modifications were made to give a green-ish effect.

  // This shader was modified by April Hall (arithefirst)
  // Sourced from https://github.com/m-ahdal/ghostty-shaders/blob/main/retro-terminal.glsl
  // Changes made:
  // - Removed tint
  // - Made the boundaries match ghostty's background color

  float warp = 0.25; // simulate curvature of CRT monitor

  void mainImage(out vec4 fragColor, in vec2 fragCoord)
  {
      // squared distance from center
      vec2 uv = fragCoord / iResolution.xy;
      vec2 dc = abs(0.5 - uv);
      dc *= dc;

      // warp the fragment coordinates
      uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.3 * warp)); uv.x += 0.5;
      uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.4 * warp)); uv.y += 0.5;

      // sample the texture
      vec3 color = texture(iChannel0, uv).rgb;

      // mix the sampled color with the scanline intensity
      fragColor = vec4(color, 1.0);
  }
''
