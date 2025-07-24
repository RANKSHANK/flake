{
  config,
  lib,
  ...
}: let
  inherit (config.lib.stylix) colors;
  inherit (lib) hex2Vec4;
  #extension GL_EXT_gpu_shader4: enable
in ''
  #version 300 es
  #define PIXEL_SIZE_FAC 700.0
  precision highp float;
  #define SPIN_EASE 0.5
  #define bkg_color ${hex2Vec4 colors.base00 1.0}
  #define bkg_color2 ${hex2Vec4 colors.base01 1.0}
  #define resolution vec3(1.0, 1.0, 1.)
  #define spin_amount 0.7
  #define contrast 1.5
  #define tolerance 0.018
  #define color_1 ${hex2Vec4 colors.base05 1.0}
  #define color_2 ${hex2Vec4 colors.base06 1.0}
  #define color_3 ${hex2Vec4 colors.base00 1.0}

  uniform sampler2D tex;
  uniform float time;

  in vec2 v_texcoord;
  layout(location = 0) out vec4 fragColor;

  void main()
  {
      vec4 base_color = texture2D(tex, v_texcoord);
      float dist = min(distance(base_color.rgb, bkg_color.rgb), distance(base_color.rgb, bkg_color2.rgb));
      if (dist < tolerance){
          //Convert to UV coords (0-1) and floor for pixel effect
          float pixel_size = length(resolution.xy)/PIXEL_SIZE_FAC;
          vec2 uv = (floor(v_texcoord.xy*(1.0/pixel_size))*pixel_size - 0.5*resolution.xy)/length(resolution.xy) - vec2(0.0, 0.0);
          float uv_len = length(uv);

          //Adding in a center swirl, changes with time. Only applies meaningfully if the 'spin amount' is a non-zero number
          float speed = (time*SPIN_EASE*0.1) + 302.2;
          float new_pixel_angle = (atan(uv.y, uv.x)) + speed - SPIN_EASE*20.*(1.*spin_amount*uv_len + (1. - 1.*spin_amount));
          vec2 mid = (resolution.xy/length(resolution.xy))/2.;
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
          float contrast_mod = (0.25*contrast + 0.5*spin_amount + 1.2);
          float paint_res =min(2., max(0.,length(uv)*(0.035)*contrast_mod));
          float c1p = max(0.,1. - contrast_mod*abs(1.-paint_res));
          float c2p = max(0.,1. - contrast_mod*abs(paint_res));
          float c3p = 1. - min(1., c1p + c2p);

          vec4 ret_col = (0.3/contrast)*color_1 + (1. - 0.3/contrast)*(color_1*c1p + color_2*c2p + vec4(c3p*color_3.rgb, c3p*color_1.a)) + 0.3*max(c1p*5. - 4., 0.) + 0.4*max(c2p*5. - 4., 0.);
          fragColor = mix(base_color, ret_col, 0.1 * (1. - dist / tolerance));
      } else {

          fragColor = base_color;
      }
  }
''
