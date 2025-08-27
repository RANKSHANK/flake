{
  config,
  util,
  ...
}: let
  inherit (config.lib.stylix) colors;
  light = util.ternary (config.stylix.polarity == "light");
  inherit (util) hex2Vec4;
in
  /*
  glsl
  */
  ''
    // Modified balatro shader from https://www.shadertoy.com/view/XXjGDt
    #version 300 es
    #define PIXEL_SIZE_FAC 700.0
    precision highp float;
    #define SPIN_EASE 0.5
    #define BKG_COLOR ${hex2Vec4 colors.base00 1.0}
    #define BKG_COLOR2 ${hex2Vec4 colors.base01 1.0}
    #define RESOLUTION vec3(1.0, 1.0, 1.)
    #define SPIN_AMOUNT 0.7
    #define CONTRAST 1.5
    #define TOLERANCE 0.0182
    #define STRENGTH ${toString (light 0.4 0.2)}
    #define SCAN_LIGHT 0.8
    #define SCAN_SPEED 18.0
    #define COLOR_1 ${hex2Vec4 (light colors.base00 colors.base03) 1.0}
    #define COLOR_2 ${hex2Vec4 colors.base02 1.0}
    #define COLOR_3 ${hex2Vec4 (light colors.base03 colors.base00) 1.0}

    uniform sampler2D tex;
    uniform float time;

    in vec2 v_texcoord;
    layout(location = 0) out vec4 fragColor;

    void main()
    {
      vec4 base_color = texture(tex, v_texcoord);
      float dist = min(distance(BKG_COLOR.rgb, base_color.rgb), distance(BKG_COLOR2.rgb, base_color.rgb));

      //Convert to UV coords (0-1) and floor for pixel effect
      float pixel_size = length(RESOLUTION.xy)/PIXEL_SIZE_FAC;
      vec2 uv = (floor(v_texcoord.xy*(1.0/pixel_size))*pixel_size - 0.5*RESOLUTION.xy)/length(RESOLUTION.xy) - vec2(0.0, 0.0);
      float uv_len = length(uv);

      //Adding in a center swirl, changes with time. Only applies meaningfully if the 'spin amount' is a non-zero number
      float speed = (time*SPIN_EASE*0.1) + 302.2;
      float new_pixel_angle = (atan(uv.y, uv.x)) + speed - SPIN_EASE*20.*(1.*SPIN_AMOUNT*uv_len + (1. - 1.*SPIN_AMOUNT));
      vec2 mid = (RESOLUTION.xy/length(RESOLUTION.xy))/2.;
      uv = (vec2((uv_len * cos(new_pixel_angle) + mid.x), (uv_len * sin(new_pixel_angle) + mid.y)) - mid);

      //Now add the paint effect to the swirled UV
      uv *= 30.;
      speed = time*(1.);
      vec2 uv2 = vec2(uv.x+uv.y);

      for(int i=0; i < 5; i++) {
          uv2 += uv + cos(length(uv));
          uv  += 0.5*vec2(cos(5.1123314 + 0.353*uv2.y + speed*0.131121),sin(uv2.x - 0.113*speed));
          uv  -= 1.0*cos(uv.x + uv.y) - 1.0*sin(uv.x*0.711 - uv.y);
      }

      //Make the paint amount range from 0 - 2
      float contrast_mod = (0.25*CONTRAST + 0.5*SPIN_AMOUNT + 1.2);
      float paint_res =min(2., max(0.,length(uv)*(0.035)*contrast_mod));
      float c1p = max(0.,1. - contrast_mod*abs(1.-paint_res));
      float c2p = max(0.,1. - contrast_mod*abs(paint_res));
      float c3p = 1. - min(1., c1p + c2p);

      vec4 ret_col = (0.3/CONTRAST)*COLOR_1 + (1. - 0./CONTRAST)*(COLOR_1*c1p + COLOR_2*c2p + vec4(c3p*COLOR_3.rgb, c3p*COLOR_1.a)) + 0.3*max(c1p*5. - 4., 0.) + 0.4*max(c2p*5. - 4., 0.);
      float heaviside = 1. - step(TOLERANCE, dist);
      float heaviside2 = step(3., float(int(gl_FragCoord.y - (speed * SCAN_SPEED)) & 0x7));
      ret_col = mix(ret_col, ret_col * SCAN_LIGHT, heaviside2);
      fragColor = mix(base_color, ret_col, heaviside * STRENGTH);
    }
  ''
